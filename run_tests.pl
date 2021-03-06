eval '(exit $?0)' && eval 'exec perl -w -S $0 ${1+"$@"}'
    & eval 'exec perl -w -S $0 $argv:q'
    if 0;

# ******************************************************************
#      Author: Chad Elliott
#        Date: 6/20/2005
# Description: Run MPC related tests.
# ******************************************************************

# ******************************************************************
# Pragma Section
# ******************************************************************

use strict;
use Cwd;
use Config;
use FindBin;
use FileHandle;
use File::Copy;
use File::Path;
use File::Spec;
use File::Basename;
use File::Find;
use POSIX qw(strftime);

my $basePath = $FindBin::Bin;
unshift(@INC, $basePath . '/modules');

require OptionProcessor;

# ******************************************************************
# Data Section
# ******************************************************************

my $MWC;
my $MPC;
my @types;
my $one_built = 0;
my $cr_expect;
my $br_error;
my $nodiff;
my $nobuild;
my $diff;
my $test_scr  = 'run_test.pl';
my $patch     = which('patch');
my $gmake     = which('gmake') || which('make');
my $passed    = 'succeeded';
my $failed    = '****failed****';
my $quiet;
my $coverage;

my %devenv_ver = ('vc7'  => '13.00',
                  'vc71' => '13.10',
                  'vc8'  => '14.00',
                  'vc9'  => '15.00',
                  'vc10' => '16.00',
                 );

# ******************************************************************
# Subroutine Section
# ******************************************************************

sub which {
  my $prog = shift;

  if (defined $ENV{'PATH'}) {
    my $part   = '';
    my $envSep = ($^O eq 'VMS' ? ':' : $Config{'path_sep'});
    foreach $part (split(/$envSep/, $ENV{'PATH'})) {
      $part .= "/$prog";
      if (-x "$part$Config{'exe_ext'}") {
        return '"' . File::Spec->canonpath($part) . '"';
      }
    }
  }

  return undef;
}


sub touch {
  my @files = @_;
  my $fh    = new FileHandle();
  foreach my $file (@files) {
    if (open($fh, ">>$file")) {
      close($fh);
    }
  }
}


sub diff_files {
  my($left, $right, $i, $lline, $rline) = @_;

  if (!$nodiff) {
    if (defined $diff) {
      my $txt = 'diff.' . $$ . '.txt';
      my $dh  = new FileHandle();
      system("$diff $left $right > $txt");
      if (open($dh, $txt)) {
        while(<$dh>) {
          print SAVEERR $_;
        }
        close($dh);
      }
      unlink($txt);
    }
    else {
      $lline .= "\n" if ($lline !~ /\n$/);
      $rline .= "\n" if ($rline !~ /\n$/);
      print SAVEERR "Line $i of $left differs\n",
                    "from $right\n",
                    "< $lline",
                    "> $rline";
    }
  }
}

sub compare {
  my($left, $right, $show) = @_;
  my $lh = new FileHandle();
  my $rh = new FileHandle();
  my $different = 1;
  my $now = strftime '%a %b %d %Y', localtime;

  if (open($lh, $left)) {
    my @lines;
    while(<$lh>) {
      push(@lines, $_);
    }
    close($lh);
    if (open($rh, $right)) {
      my $cwdre = getcwd();
      $cwdre =~ s![\\\/]![\\\\\\/]!g;
      my $mpcre = $ENV{MPC_ROOT};
      $mpcre =~ s![\\\/]![\\\\\\/]!g;

      my $i = 0;
      $different = 0;
      while(<$rh>) {
        my $line = $_;
        next if ($line =~ /^\s*$/);

        while(defined $lines[$i] && $lines[$i] =~ /^\s*$/) {
          ++$i;
        }

        ## Don't compare things that are likely to change.  This
        ## currently includes MPC command line, CVS Id tags, GUID's, timestamps,
        ## and html references.  Due to expansion of environment
        ## variables containing full paths, we're skipping lines that
        ## contain the current working directory.
        if ($line !~ /mwc\.pl/ && $line !~ /\$Id[:\$]/ &&
            $line !~ /[\da-f]+\-[\da-f]+\-/i && $line !~ /a\s+href=/i &&
            $line !~ /\b$now \d{2}:\d{2}:\d{2}\b/ &&
            $line !~ /^ProjectDir=/ && ($line !~ /$cwdre/ || $cr_expect)) {
          if (!defined $lines[$i]) {
            diff_files($left, $right, $i, $lines[$i], $line) if ($show);
            $different = 1;
            last;
          }
          elsif ($lines[$i] ne $line) {
            if (($lines[$i] !~ /ACE_HAS_MFC=1/ || $cr_expect)
                && $line !~ /$mpcre/) {
              diff_files($left, $right, $i, $lines[$i], $line) if ($show);
              $different = 1;
              last;
            }
          }
        }
        ++$i;
      }
      close($rh);

      if (!$different || !defined $diff) {
        while (defined $lines[$i]) {
          if ($lines[$i] !~ /^\s+$/) {
            diff_files($left, $right, $i, $lines[$i], "\n") if ($show);
            $different = 1;
            last;
          }
          ++$i;
        }
      }
    }
  }

  return $different;
}


sub printBuildMessage {
  my $type = shift;
  print SAVEERR "+++ Building for the $type type: ";
}


sub checkBuildStatus {
  my $cmd    = shift;
  my $status = 0;

  if (system($cmd) / 256 == 0) {
    $status = 1;
    $one_built++;
    print SAVEERR "$passed.\n";
  }
  else {
    print SAVEERR "$failed.\n";
  }

  return $status;
}


sub validateHTML {
  my($cmd, $dir) = @_;
  my $status = 0;
  my $fh = new FileHandle();

  if (opendir($fh, $dir)) {
    foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
      my $full = "$dir/$file";
      if (-d $full) {
        $status += validateHTML($cmd, $full);
      }
      elsif ($file =~ /\.html$/) {
        my $ph = new FileHandle();

        if (open($ph, "$cmd $full |")) {
          my $first = 1;
          while(<$ph>) {
            if ($first) {
              print $full, ":\n";
              $first = undef;
            }
            print;
            if (/error:/i) {
              ++$status;
            }
          }
          close($ph);
        }
        else {
          ++$status;
        }
      }
    }
    closedir($fh);
  }
  else {
    ++$status;
  }

  return $status;
}


sub buildit {
  my($type, $path, $entry) = @_;
  my $status = 0;
  my $orig = getcwd();
  my $ob = $one_built;
  my $cross;

  ## Update the PWD environment variable for gnuace
  chdir($path);
  $ENV{PWD} = $path;

  if ($type eq 'html') {
    my $cmd = which('tidy');
    if (defined $cmd) {
      print SAVEERR "+++ Validation for the $type type: ";
      if (validateHTML("$cmd -q -e", '.')) {
        print SAVEERR "$failed.\n";
      }
      else {
        print SAVEERR "$passed.\n";
      }
    }
  }
  elsif ($^O eq 'MSWin32') {
    if ($type eq 'bmake') {
      my $cmd = which('bcc32');
      if (!defined $cmd) {
        $cmd = which('bccx');
        $ENV{CBX} = 1;
      }
      if (defined $cmd) {
        $cmd = which('make');
        $ENV{RELEASE} = 1;
        if (defined $cmd) {
          printBuildMessage($type);
          my $save;
          if (defined $entry) {
            my $dir = dirname($entry);
            my $base = basename($entry);
            if ($dir ne '.') {
              $save = getcwd();
              chdir($dir);
            }
            $cmd .= ' -f ' . $base;
          }
          $status = checkBuildStatus($cmd);
          chdir($save) if (defined $save);
        }
      }
    }
    elsif ($type eq 'nmake') {
      my $cmd = which('nmake');
      if (defined $cmd) {
        printBuildMessage($type);
        my $save;
        if (defined $entry) {
          my $dir = dirname($entry);
          my $base = basename($entry);
          if ($dir ne '.') {
            $save = getcwd();
            chdir($dir);
          }
          $cmd .= ' -f ' . $base;
        }
        $status = checkBuildStatus($cmd);
        chdir($save) if (defined $save);
      }
    }
    elsif ($type eq 'em3') {
      my $cmd = which('evc');
      if (defined $cmd && defined $ENV{TARGETCPU}) {
        printBuildMessage($type);
        $entry = basename($path) . '.vcw' if (!defined $entry);
        $status = checkBuildStatus("$cmd " .
                                   "$entry /make \"all - win32 " .
                                   "(WCE $ENV{TARGETCPU}) Release\"");
        $cross = 1;
      }
    }
    elsif ($type eq 'vc6') {
      my $cmd = which('msdev');
      if (defined $cmd) {
        printBuildMessage($type);
        $entry = basename($path) . '.dsw' if (!defined $entry);
        $status = checkBuildStatus("$cmd " .
                                   "$entry /make \"all - win32 release\"");
      }
    }
    elsif ($type eq 'vc7' || $type eq 'vc71' || $type eq 'vc8' ||
           $type eq 'vc9' || $type eq 'vc10') {
      my $cmd = which('devenv');
      if (defined $cmd) {
        my $fh = new FileHandle();
        my $cl = which('cl');
        if (defined $cl) {
          if (open($fh, "$cl /? 2>&1 |")) {
            while(<$fh>) {
              if (/Version\s+(\d+\.\d+)/) {
                if ($1 ne $devenv_ver{$type}) {
                  $cmd = undef;
                }
              }
            }
            close($fh);
          }
        }
        else {
          $cmd = undef;
        }
        if (defined $cmd) {
          printBuildMessage($type);
          $entry = basename($path) . '.sln' if (!defined $entry);
          $status = checkBuildStatus("$cmd " .
                                     "$entry /build release");
        }
      }
    }
  }
  elsif ($type eq 'automake') {
    my $cmd = which('automake');
    if (defined $cmd) {
      my $fh = new FileHandle();
      if (open($fh, "$cmd --version 2>&1 |")) {
        while(<$fh>) {
          if (/^automake\s+\(.*\)\s+(\d+.\d+)/) {
            if ($1 < 1.9) {
              $cmd = undef;
            }
          }
        }
        close($fh);
      }
    }
    if (defined $cmd) {
      printBuildMessage($type);
      $ENV{LD_LIBRARY_PATH}   = getcwd() . '/lib';
      $ENV{SHLIB_PATH}        = $ENV{LD_LIBRARY_PATH};
      $ENV{LIBPATH}           = $ENV{LD_LIBRARY_PATH};
      $ENV{DYLD_LIBRARY_PATH} = $ENV{LD_LIBRARY_PATH};

      ## Create the necessary files and directories for automake
      mkdir('m4');
      touch('NEWS', 'README', 'AUTHORS', 'ChangeLog', 'install-sh',
            'missing', 'compile');
      open(FH, ">depcomp");
      print FH "eval \$\@\n";
      close(FH);

      ## Run the automake setup and configure
      my $dir;
      my $cmd = 'aclocal && libtoolize && autoconf && automake';
      if (defined $entry) {
        my $base;
        if ($entry =~ /`/) {
          $base = $entry;
        }
        else {
          $dir = dirname($entry);
          $base = basename($entry);
        }
        $cmd .= ' -a ';
        $cmd .= $base if ($base ne 'Makefile');
      }
      if (!defined $dir || $dir eq '.') {
        system("$cmd && ./configure");
      }
      else {
        system("cd $dir; ($cmd && ./configure)");
      }

      ## Find the automake generated makefile
      my $mfile;
      if (!-r 'Makefile.am') {
        if (opendir(DH, defined $dir ? $dir : '.')) {
          foreach my $file (sort(readdir(DH))) {
            if ($file =~ /^(Makefile.+)\.am$/) {
              $mfile = $1;
              last;
            }
          }
          closedir(DH);
        }
      }

      $status = checkBuildStatus((defined $dir ? "cd $dir; " :'') . 'make' .
                                 (defined $mfile ?
                                   " -f $mfile" .
                                   ($mfile =~ /^Makefile[^\.]/ ?
                                      " AM_MAKEFLAGS='-f $mfile'" : '') :
                                   ''));
    }
  }
  elsif ($type eq 'make' && $^O eq 'linux') {
    my $cmd = 'make';
    printBuildMessage($type);
    $ENV{LD_LIBRARY_PATH} = getcwd() . '/lib';
    if (defined $entry) {
      my $dir = dirname($entry);
      my $base = basename($entry);
      $cmd = "cd $dir; $cmd" if ($dir ne '.');
      $cmd .= ' -f ' . $base;
    }
    $status = checkBuildStatus($cmd);
  }
  elsif ($type eq 'gnuace') {
    my $cmd = $gmake;
    printBuildMessage($type);
    if (defined $entry) {
      my $dir = dirname($entry);
      my $base = basename($entry);
      $cmd = "cd $dir; $cmd" if ($dir ne '.');
      $cmd .= ' -f ' . $base;
    }
    $status = checkBuildStatus($cmd);
  }

  ## If $one_built has changed then we built the test.
  ## We can run the test (if there is a test script and we're not
  ## cross-compiling).
  if ($status && !$cross && $ob != $one_built && -r $test_scr) {
    $status = system("$^X $test_scr");
  }

  chdir($orig);
  return $status;
}


sub compare_output {
  my($test, $expect) = @_;
  my $fh = new FileHandle();
  my $status = 0;

  if (opendir($fh, $expect)) {
    foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
      ## The order of the project dependencies are non-deterministic
      ## within the GNUmakefile workspace (the file system has much
      ## to do with it).  So, we are not going to compare them.  As long
      ## as everything builds correctly we won't have a problem.
      $file =~ s/\.dir$// if ($^O eq 'VMS');
      if ($file ne '.svn' && $file ne 'CVS' && $file ne 'GNUmakefile') {
        my $tf = "$test/$file";
        my $ef = "$expect/$file";
        if (-d $ef) {
          $status += compare_output($tf, $ef);
        }
        else {
          if (!-r $tf) {
            $status++;
            print SAVEERR "ERROR: Unable to read file: $tf\n";
          }
          elsif (!-r $ef) {
            $status++;
            print SAVEERR "ERROR: Unable to read file: $ef\n";
          }
          elsif (compare($ef, $tf, 1) != 0) {
            $status++;
          }
        }
      }
    }
    closedir($fh);
  }
  else {
    if (!$quiet) {
      print SAVEERR "[No expected results] ";
    }
  }

  return $status;
}


sub list_files {
  my $dir   = shift;
  my $fh = new FileHandle();
  my @files;

  if (opendir($fh, $dir)) {
    foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
      $file =~ s/\.dir$// if ($^O eq 'VMS');
      my $full = "$dir/$file";
      if (-d $full) {
        push(@files, list_files($full));
      }
      push(@files, $full);
    }
    closedir($fh);
  }
  return @files;
}


sub remove_files {
  my($dir, $exist) = @_;
  my $fh = new FileHandle();

  if (opendir($fh, $dir)) {
    foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
      $file =~ s/\.dir$// if ($^O eq 'VMS');
      my $full = "$dir/$file";
      if (-d $full) {
        remove_files($full, $exist);
        if (!exists $$exist{$full}) {
          rmdir($full);
        }
      }
      else {
        if (!exists $$exist{$full}) {
          unlink($full);
        }
      }
    }
    closedir($fh);
  }
}


sub move_expected {
  my($from, $to, $exist) = @_;
  my $fh = new FileHandle();

  if (opendir($fh, $from)) {
    foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
      $file =~ s/\.dir$// if ($^O eq 'VMS');
      if ($file ne '.svn' && $file ne 'CVS') {
        my $ffull = "$from/$file";
        my $tfull = "$to/$file";
        if (-d $ffull) {
          move_expected($ffull, $tfull, $exist);

          ## If a directory was made during project creation, we need to
          ## make sure we attempt to remove it after we're done.
          if (!exists $$exist{$ffull}) {
            rmdir($ffull);
          }
        }
        else {
          if (!exists $$exist{$ffull}) {
            mkpath(dirname($tfull));

            ## configure.ac is not something that gets compared.
            ## See the comment about GNUmakefile in compare_output().
            if ($file ne 'configure.ac' && $file ne '.custom_build_rule' &&
                $file ne '.empty_html_file' &&
                (!-r $tfull ||
                 ($file ne 'GNUmakefile' && compare($ffull, $tfull) != 0))) {
              move($ffull, $tfull);
            }
            else {
              unlink($ffull);
            }
          }
        }
      }
    }
    closedir($fh);
  }
}


sub apply_patches {
  my($path, $reverse) = @_;
  my $fh = new FileHandle();

  if (defined $patch && opendir($fh, $path)) {
    foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
      $file =~ s/\.dir$// if ($^O eq 'VMS');
      my $full = "$path/$file";
      if (-d $full) {
        apply_patches($full, $reverse);
      }
      elsif ($file =~ /\.patch$/) {
        my $orig = getcwd();
        chdir($path);
        system("$patch -p0 " . ($reverse ? '-R ' : '') . "< $file");
        chdir($orig);
      }
    }
    closedir($fh);
  }
}


sub clean_dir {
  my $file = shift;
  if (-d $file) {
    my $fh = new FileHandle();
    if (opendir($fh, $file)) {
      foreach my $name (grep(!/^\.\.?$/, readdir($fh))) {
        my $full = "$file/$name";
        clean_dir($full);
        rmdir($full);
      }
      closedir($fh);
    }
  }
  else {
    unlink($file);
  }
}

sub to_be_cleaned {
  (/^\.depend\..*\z/s ||
   /^Makefile.*\z/s ||
   /^GNUmakefile.*\z/s ||
   /^.*\.sln\z/s ||
   /^.*\.vcproj\z/s ||
   /^.*\.vcxproj\z/s ||
   /^.*\.vcxproj\.filters\z/s ||
   /^.*\.ds.?\z/s ||
   /^.*\.ncb\z/s ||
   /^.*\.suo\z/s ||
   /^.*\.sdf\z/s ||
   /^.*\.bor\z/s ||
   /^.*\.opt\z/s ||
   /^.*\.plg\z/s ||
   /^.*\.pdb\z/s ||
   /^.*\.lib\z/s ||
   /^.*\.dll\z/s ||
   /^\.shobj\z/s ||
   /^.*\.ins\z/s ||
   /^.*\.mak\z/s ||
   /^.*\.dep\z/s ||
   /^Debug\z/s ||
   /^Release\z/s ||
   /^Static_Debug\z/s ||
   /^Static_Release\z/s ||
   /^.*\.vcw\z/s ||
   /^.*\.vcp\z/s ||
   /^.*\.o\z/s ||
   /^.*\.bmak\z/s ||
   /^.*\.bpgr\z/s ||
   /^.*\.cbx\z/s ||
   /^.*_workspace\.html\z/s ||
   /^.*\.csproj\z/s ||
   /^.*\.bld\z/s ||
   /^.*\.bmake\z/s ||
   /^.*\.nmake\z/s ||
   /^.*\.icc\z/s ||
   /^.*\.vpj\z/s ||
   /^.*\.tds\z/s ||
   /^configure\.ac\.Makefiles\z/s ||
   /^.*\.icp\z/s ||
   /^.*\.vpw\z/s ||
   /^.*\.vbproj\z/s ||
   /^.*\.RES\z/s ||
   /^.*\.aps\z/s ||
   /^.*\.idb\z/s ||
   /^.*\.sbr\z/s ||
   /^.*\.exp\z/s ||
   /^.*\.vcl\z/s ||
   /^.*\.vco\z/s ||
   /^.*\.vcb\z/s ||
   /^configure\.ac\z/s ||
   /^.*\.obj\z/s ||
   /^autom4te\.cache\z/s ||
   /^AUTHORS\z/s ||
   /^ChangeLog\z/s ||
   /^NEWS\z/s ||
   /^README\z/s ||
   /^aclocal\.m4\z/s ||
   /^config\..*\z/s ||
   /^configure\z/s ||
   /^libtool\z/s ||
   /^m4\z/s ||
   /^\.deps\z/s ||
   /^COPYING\z/s ||
   /^depcomp\z/s ||
   /^INSTALL\z/s ||
   /^install-sh\z/s ||
   /^ltmain\.sh\z/s ||
   /^missing\z/s ||
   /^mkinstalldirs\z/s ||
   /^\.libs\z/s ||
   /^.*\.lo\z/s ||
   /^.*\.la\z/s ||
   /^.*\.loT\z/s ||
   /^.*\.user\z/s ||
   /^core\z/s ||
   /^core\..*\z/s ||
   /^.*\.bdsgroup\z/s ||
   /^.*\.bdsproj\z/s ||
   /^.*\.gch\z/s) &&
  ($File::Find::prune = 1) &&
  clean_dir($_);
}


sub run_test {
  my($path, $mwc, $cfg, $expect, $type, $pass) = @_;
  my $orig = getcwd();
  my $status = 0;
  my %existing;

  if ($pass == 0) {
    my @files = list_files($path);
    @existing{@files} = ();
  }

  my $defsigint = $SIG{INT};
  $SIG{INT} = sub { chdir($orig);
                    remove_files($path, \%existing);
                    exit(1);
                  };

  chdir($path);
  my $add = '';
  my $fh  = new FileHandle('additional_options.txt');
  if (defined $fh) {
    $add = <$fh>;
    $add =~ s/\s+$//;
    close($fh);
  }
  $ENV{TEST_ROOT} = getcwd();

  if (-e "./config/MPC.cfg" || -e "./config/MPC_PHONY.cfg") {
    $ENV{TEST_MPC_CONFIG} = getcwd() . "/config";
  }
  else {
    $ENV{TEST_MPC_CONFIG} = "$orig/config";
  }
    
  $fh = new FileHandle('environment.txt');
  my %saveenv;
  if (defined $fh) {
     while(<$fh>) {
      if ($_ =~ /(\w+)\s*=\s*(.*)$/) {
        my $name = $1;
        my $val  = $2;
        $val =~ s/^\s+//;
        $val =~ s/\s+$//;

        ## Even in Perl on Windows, if the environment variable is
        ## empty, it will not show up as a set variable.
        $val = '""' if ($^O eq 'MSWin32' && $val eq '');

        if (!defined $ENV{$name} || $ENV{$name} ne $val) {
          $saveenv{$name} = $ENV{$name};
          $ENV{$name} = $val;
        }
      }
    }
    close($fh);
  }
  my $popt = '';
  $fh = new FileHandle('perl_options.txt');
  if (defined $fh) {
    $popt = <$fh>;
    $popt =~ s/\s+$//;
    close($fh);
  }

  my $CMD = -e 'MPC_ONLY' ? $MPC : $MWC;
  my $ret = system("$^X $popt " .
                   ($coverage ? "-MDevel::Cover=-db,$orig/cover_db " : '') .
                   "$CMD -include $cfg -include $orig/config -type $type $add $mwc");
  chdir($orig);

  ## A signal killed mwc.pl
  if ($ret > 0 && $ret < 256) {
    &{$SIG{INT}}();
  }
  else {
    $ret /= 256;
  }

  if ($ret != 0) {
    $status++;
  }
  else {
    if (!$cr_expect) {
      $status += compare_output($path, "$expect/$type");
      if ($pass < 1) {
        apply_patches($path);
        my $entry;
        $fh = new FileHandle("$path/build_entry.txt");
        if (defined $fh) {
          while(<$fh>) {
            if (/(.*):\s*(.*)/) {
              if ($type eq $1) {
                $entry = $2;
                last;
              }
            }
          }
          close($fh);
        }
        ## If there was no entry, then build it.
        ## If there was an entry, but it was empty the user does
        ## not want to attempt to build for this type.
        if (!$nobuild &&
            (!defined $entry || $entry ne '') &&
            buildit($type, $path, $entry)) {
          apply_patches($path, 1);
          $status += run_test($path, $mwc, $cfg, $expect, $type, $pass + 1);
        }
      }
    }
  }

  if ($pass == 0) {
    if ($cr_expect) {
      move_expected($path, "$expect/$type", \%existing);
    }
    elsif ($status == 0 || !$br_error) {
      remove_files($path, \%existing);
    }
  }

  $SIG{INT} = $defsigint if (defined $defsigint);

  for my $name (keys %saveenv) {
    if (defined $saveenv{$name}) {
      $ENV{$name} = $saveenv{$name};
    }
    else {
      delete $ENV{$name};
    }
  }

  return $status;
}


sub determine_setup {
  if (defined $ENV{ACE_ROOT}) {
    $MWC = "$ENV{ACE_ROOT}/bin/mwc.pl";
    $MPC = "$ENV{ACE_ROOT}/bin/mpc.pl";
    delete $ENV{MPC_GNUACE_NAMED_TARGETS};
  }
  elsif (defined $ENV{MPC_ROOT}) {
    $MWC = "$ENV{MPC_ROOT}/mwc.pl";
    $MPC = "$ENV{MPC_ROOT}/mpc.pl";
  }

  # Configure cdt6 to work as if it's on linux, even if running on Win32
  $ENV{MPC_CDT_PLATFORMS} = 'linux';
  $ENV{MPC_CDT_HOST_WIN32} = 0;

  if (defined $MWC) {
    my $fh = new FileHandle();
    if (open($fh, "$^X " .
                  ($coverage ? "-MDevel::Cover=-db,cover_db " : '') .
                  "$MWC -help 2>&1 |")) {
      my $look_for_end = 0;
      while(<$fh>) {
        my $typestr;
        if (/\[-type <(.*)/) {
          $typestr = $1;
          $look_for_end = 1;
        }
        elsif ($look_for_end) {
          $typestr = $_;
          if (/(.*)\>\]/) {
            $look_for_end = 0;
            $typestr = $1;
          }
        }
        if (defined $typestr) {
          foreach my $type (split(/\s*\|\s*/, $typestr)) {
            $type =~ s/\s//g;
            push(@types, $type);
          }
        }
      }
      close($fh);

      ## To complete the coverage of the Options.pm module, we will run
      ## the two options that cause a print-out and exit.
      if ($coverage) {
        if (open($fh, "$^X -MDevel::Cover=-db,cover_db " .
                      "$MWC -complete 2>&1 |")) {
          while(<$fh>) {
          }
          close($fh);
        }
        if (open($fh, "$^X -MDevel::Cover=-db,cover_db " .
                      "$MWC -version 2>&1 |")) {
          while(<$fh>) {
          }
          close($fh);
        }
      }
    }
  }
}

# ******************************************************************
# Main Section
# ******************************************************************

my @dirs;
my @tonly;
my $output;
my %options = ('expected'  => \$cr_expect,
               'break'     => \$br_error,
               'coverage'  => \$coverage,
               'nobuild'   => \$nobuild,
               'nodiff'    => \$nodiff,
               'output=s'  => \$output,
               'test=s'    => \@dirs,
               'type=s'    => \@tonly,
               'diffcmd=s' => \$diff,
               'quiet'     => \$quiet,
              );
my %desc    = ('expected' => 'Create expected results for all of the ' .
                             'tests',
               'break'    => 'Break on the first test failure',
               'coverage' => 'Enable coverage statistics collection.  This ' .
                             'option implies --nobuild',
               'diffcmd'  => 'Provide the full path to an alternate ' .
                             'diff command',
               'nobuild'  => 'Do not build any of the tests',
               'nodiff'   => 'Do not show file differences',
               'output'   => 'Send output to the specified file',
               'test'     => 'Run the specified test or tests',
               'type'     => 'Use only the specified type or types',
               'quiet'    => 'Only print the test name and errors',
              );

my $status  = 0;
my $options = new OptionProcessor($0, \%options, \%desc);
$options->process();

## If we're not redirecting the output to a file and we have a
## diffiles.pl diff command, then use it.
if (!defined $diff) {
  if (!defined $output && defined $ENV{DIFFILES_CMD}) {
    $diff = $ENV{DIFFILES_CMD};
  }
  else {
    $diff = which('diff');
  }
}

## We're doing coverage testing, there is no need for building
$nobuild = 1 if ($coverage);

if ($cr_expect && "@types" =~ /gnuace/ && !defined $ENV{ACE_ROOT}) {
  print STDERR "ERROR: You can not generate expected results without ",
               "the ACE_ROOT\n       environment variable set.\n";
  exit(1);
}

determine_setup();

if (!defined $MWC) {
  print STDERR "ERROR: Unable to locate mwc.pl.\n";
  $status++;
}
else {
  if (!defined $types[0]) {
    print STDERR "ERROR: Unable to determine project types.\n";
    $status++;
  }
  else {
    my $expectdir = 'expected';
    my $testdir   = 'tests';
    my $logdir    = 'logs';
    my @lt        = localtime(time());
    my $logfile   = sprintf("$logdir/%04d%02d%02d-%02d%02d%02d.log",
                            $lt[5] + 1900, $lt[4] + 1, $lt[3],
                            $lt[2], $lt[1], $lt[0]);
    my $fh        = new FileHandle();

    open(SAVEOUT, ">&STDOUT");
    open(SAVEERR, (defined $output ? ">$output" : ">&STDERR"));

    ## Avoid a perl warning
    print SAVEOUT '';

    mkdir($logdir, 0777);
    open(STDOUT, ">$logfile");
    open(STDERR, ">&STDOUT");

    $ENV{MPC_ALWAYS_SORT} = 1;

    if (opendir($fh, $testdir)) {
      my %dirs;
      my %tonly;
      my $finished;
      my $columns = (defined $ENV{COLUMNS} ? $ENV{COLUMNS} : 80);
      @dirs{@dirs} = ();
      @tonly{@tonly} = ();
      foreach my $dir (sort(grep(!/^\.\.?$/, readdir($fh)))) {
        $dir =~ s/\.dir$// if ($^O eq 'VMS');
        if ($dir ne '.svn' && $dir ne 'CVS' &&
            (!defined $dirs[0] || exists $dirs{$dir})) {
          my $full = "$testdir/$dir";
          if (-d $full) {
            my $amount = $columns - 4 - length($dir);
            if ($amount < 0) {
              $amount = 1;
            }
            else {
              $amount = int($amount / 2);
            }

            my $test_heading = '' . ('=' x $amount) . " $dir " . ('=' x $amount) . (((length $dir) % 2) ? '=' : '') . "\n";
            print SAVEERR $test_heading;
            print STDOUT $test_heading;
            my $mwc = '';
            if (-r "$full/$dir.mwc") {
              $mwc = "$dir.mwc";
            }
            $one_built = 0;

            foreach my $type (@types) {
              if (!defined $tonly[0] || exists $tonly{$type}) {
                File::Find::find({wanted => \&to_be_cleaned}, $full);

                $amount = $columns - 4 - length($type);
                if ($amount < 0) {
                  $amount = 1;
                }
                else {
                  $amount = int($amount / 2);
                }
                my $type_heading = (' ' x ($amount / 2)) . ('=' x ($amount / 2)) . " $type " . ('=' x ($amount / 2)) 
                    . (((length $type) % 2) ? '=' : '') . (' ' x ($amount / 2)) . "\n";
                print STDOUT $type_heading;

                my $ret = run_test($full, $mwc, 'config',
                                   "$expectdir/$dir", $type, 0);
                $status += $ret;
                if ($ret) {
                  print SAVEERR "MPC generation for $type $failed.\n";
                  if ($br_error) {
                    $finished = 1;
                    last;
                  }
                }
                else {
                  if (!$quiet) {
                    print SAVEERR "MPC generation for $type $passed.\n";
                  }
                }
              }
            }
            if (!$nobuild && !$one_built && !$cr_expect) {
              print SAVEERR "WARNING: This project did not ",
                            "build on at least one platform.\n";
            }
          }
          if ($finished) {
            last;
          }
        }
      }
      closedir($fh);
    }
    else {
      print SAVEERR "ERROR: Unable to open the test directory.\n";
    }

    open(STDOUT, ">&SAVEOUT");
    if (defined $output) {
      close(SAVEERR);
    }
    else {
      open(STDERR, ">&SAVEERR");
    }
  }
}

exit($status);
