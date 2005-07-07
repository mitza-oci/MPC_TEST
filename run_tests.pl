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
use FileHandle;
use File::Copy;
use File::Path;
use File::Spec;
use File::Basename;

my($basePath) = getExecutePath($0);
unshift(@INC, $basePath . '/modules');

require OptionProcessor;

# ******************************************************************
# Data Section
# ******************************************************************

my($MWC)       = undef;
my(@types)     = ();
my($one_built) = 0;
my($cr_expect) = undef;
my($br_error)  = undef;
my($nodiff)    = undef;
my($test_scr)  = 'run_test.pl';
my($diff)      = which('diff');
my($patch)     = which('patch');
my($passed)    = 'succeeded';
my($failed)    = '**failed**';

# ******************************************************************
# Subroutine Section
# ******************************************************************

sub which {
  my($prog) = shift;
  my($exec) = $prog;

  if (defined $ENV{'PATH'}) {
    my($part)   = '';
    my($envSep) = $Config{'path_sep'};
    foreach $part (split(/$envSep/, $ENV{'PATH'})) {
      $part .= "/$prog";
      if (-x "$part$Config{'exe_ext'}") {
        return File::Spec->canonpath($part);
      }
    }
  }

  return undef;
}


sub getExecutePath {
  my($prog) = shift;
  my($loc)  = '';

  if ($prog ne basename($prog)) {
    if ($prog =~ /^[\/\\]/ ||
        $prog =~ /^[A-Za-z]:[\/\\]?/) {
      $loc = dirname($prog);
    }
    else {
      $loc = getcwd() . '/' . dirname($prog);
    }
  }
  else {
    $loc = dirname(which($prog));
  }

  if ($loc eq '.') {
    $loc = getcwd();
  }

  if ($loc ne '') {
    $loc .= '/';
  }

  return $loc;
}


sub compare {
  my($left)      = shift;
  my($right)     = shift;
  my($lh)        = new FileHandle();
  my($rh)        = new FileHandle();
  my($different) = 1;

  if (open($lh, $left)) {
    my(@lines) = ();
    while(<$lh>) {
      push(@lines, $_);
    }
    close($lh);
    if (open($rh, $right)) {
      my($i) = 0;
      $different = 0;
      while(<$rh>) {
        my($line) = $_;
        next if ($line =~ /^\s*$/);

        while($lines[$i] =~ /^\s*$/) {
          ++$i;
        }

        if ($line !~ /mwc\.pl/ && $line !~ /\$Id[:\$]/ &&
            $line !~ /[\da-f]+\-[\da-f]+\-/i && $line !~ /a\s+href=/i) {
          if ($lines[$i] ne $line) {
            if (!$nodiff) {
              if (defined $diff) {
                my($txt) = 'diff.txt';
                my($dh)  = new FileHandle();
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
                print SAVEERR "Line $i of $left differs\n",
                              "from $right\n",
                              "< $lines[$i]",
                              "> $line";
              }
            }
            $different = 1;
            last;
          }
        }
        ++$i;
      }
      close($rh);
    }
  }

  return $different;
}


sub printBuildMessage {
  my($type) = shift;
  print SAVEOUT "+++ Building for the $type type: ";
}


sub checkBuildStatus {
  my($cmd)    = shift;
  my($status) = 0;

  if (system($cmd) / 256 == 0) {
    $status = 1;
    $one_built++;
    print SAVEOUT "$passed.\n";
  }
  else {
    print SAVEOUT "$failed.\n";
  }

  return $status;
}


sub buildit {
  my($type)   = shift;
  my($path)   = shift;
  my($status) = 0;
  my($orig)   = getcwd();
  my($ob)     = $one_built;

  chdir($path);

  if ($^O eq 'MSWin32') {
    if ($type eq 'bmake') {
      my($cmd) = which('bcc32');
      if (!defined $cmd) {
        $cmd = which('bccx');
        $ENV{CBX} = 1;
      }
      if (defined $cmd) {
        printBuildMessage($type);
        $cmd = which('make');
        $ENV{DEBUG} = 1;
        $ENV{PATH} .= ';' . File::Spec->canonpath(getcwd() . '/lib');
        if (defined $cmd) {
          $status = checkBuildStatus($cmd);
        }
      }
    }
    elsif ($type eq 'nmake') {
      my($cmd) = which('nmake');
      if (defined $cmd) {
        printBuildMessage($type);
        $status = checkBuildStatus($cmd);
      }
    }
    elsif ($type eq 'vc6') {
      my($cmd) = which('msdev');
      if (defined $cmd) {
        printBuildMessage($type);
        $status = checkBuildStatus("\"$cmd\" " . basename($path) .
                                   ".dsw /make \"all - win32 debug\"");
      }
    }
    elsif ($type eq 'vc7') {
      my($cmd) = which('devenv');
      if (defined $cmd) {
        my($fh) = new FileHandle();
        my($cl) = which('cl');
        if (defined $cl) {
          if (open($fh, "\"$cl\" /? 2>&1 |")) {
            while(<$fh>) {
              if (/Version\s+(\d+\.\d+)/) {
                if ($1 ne '13.00') {
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
          $status = checkBuildStatus("\"$cmd\" " . basename($path) .
                                     ".sln /build debug");
        }
      }
    }
    elsif ($type eq 'vc71') {
      my($cmd) = which('devenv');
      if (defined $cmd) {
        my($fh) = new FileHandle();
        my($cl) = which('cl');
        if (defined $cl) {
          if (open($fh, "\"$cl\" /? 2>&1 |")) {
            while(<$fh>) {
              if (/Version\s+(\d+\.\d+)/) {
                if ($1 ne '13.10') {
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
          $status = checkBuildStatus("\"$cmd\" " . basename($path) .
                                     ".sln /build debug");
        }
      }
    }
    elsif ($type eq 'vc8') {
      my($cmd) = which('devenv');
      if (defined $cmd) {
        my($fh) = new FileHandle();
        my($cl) = which('cl');
        if (defined $cl) {
          if (open($fh, "\"$cl\" /? 2>&1 |")) {
            while(<$fh>) {
              if (/Version\s+(\d+\.\d+)/) {
                if ($1 ne '14.00') {
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
          $status = checkBuildStatus("\"$cmd\" " . basename($path) .
                                     ".sln /build debug");
        }
      }
    }
  }
  elsif ($type eq 'automake') {
    my($cmd) = which('automake');
    if (defined $cmd) {
      my($fh) = new FileHandle();
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
      system("aclocal; libtoolize; autoconf; " .
             "touch NEWS README AUTHORS ChangeLog; mkdir -p m4; " .
             "automake -a; configure");
      $status = checkBuildStatus('make');
    }
  }
  elsif ($type eq 'make' && $^O eq 'linux') {
    printBuildMessage($type);
    $ENV{LD_LIBRARY_PATH} = getcwd() . '/lib';
    $status = checkBuildStatus('make');
  }
  elsif ($type eq 'gnuace') {
    printBuildMessage($type);
    $status = checkBuildStatus('gmake');
  }

  ## If $one_built has changed then we built the test.
  ## We can run the test (if there is a test script).
  if ($status && $ob != $one_built && -r $test_scr) {
    $status = system("$^X $test_scr");
  }

  chdir($orig);
  return $status;
}


sub compare_output {
  my($test)   = shift;
  my($expect) = shift;
  my($fh)     = new FileHandle();
  my($status) = 0;

  if (opendir($fh, $expect)) {
    foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
      if ($file ne 'CVS') {
        my($tf) = "$test/$file";
        my($ef) = "$expect/$file";
        if (-d $ef) {
          $status += compare_output($tf, $ef);
        }
        else {
          if (!-r $tf) {
            $status++;
            print SAVEERR "ERROR: Unable read file: $tf\n";
          }
          elsif (!-r $ef) {
            $status++;
            print SAVEERR "ERROR: Unable read file: $ef\n";
          }
          elsif (compare($tf, $ef) != 0) {
            $status++;
          }
        }
      }
    }
    closedir($fh);
  }
  else {
    print SAVEERR "ERROR: Unable read directory: $expect\n";
    $status++;
  }

  return $status;
}


sub list_files {
  my($dir)   = shift;
  my($fh)    = new FileHandle();
  my(@files) = ();

  if (opendir($fh, $dir)) {
    foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
      my($full) = "$dir/$file";
      if (-d $full) {
        push(@files, list_files($full));
      }
      else {
        push(@files, $full);
      }
    }
    closedir($fh);
  }
  return @files;
}


sub remove_files {
  my($dir)   = shift;
  my($exist) = shift;
  my($fh)    = new FileHandle();
  my(@files) = ();

  if (opendir($fh, $dir)) {
    foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
      my($full) = "$dir/$file";
      if (-d $full) {
        remove_files($full, $exist);
        rmdir($full);
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
  my($from)  = shift;
  my($to)    = shift;
  my($exist) = shift;
  my($fh)    = new FileHandle();
  my(@files) = ();

  if (opendir($fh, $from)) {
    foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
      if ($file ne 'CVS') {
        my($ffull) = "$from/$file";
        my($tfull) = "$to/$file";
        if (-d $ffull) {
          move_expected($ffull, $tfull, $exist);
        }
        else {
          if (!exists $$exist{$ffull}) {
            mkpath(dirname($tfull));
            move($ffull, $tfull);
          }
        }
      }
    }
    closedir($fh);
  }
}


sub apply_patches {
  my($path)    = shift;
  my($reverse) = shift;
  my($fh)      = new FileHandle();

  if (defined $patch && opendir($fh, $path)) {
    foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
      my($full) = "$path/$file";
      if (-d $full) {
        apply_patches($full, $reverse);
      }
      elsif ($file =~ /(.*)\.patch$/) {
        my($real) = $1;
        if (-r "$path/$real") {
          my($orig) = getcwd();
          chdir($path);
          system("$patch " . ($reverse ? '-R ' : '') . "< $file");
          chdir($orig);
        }
      }
    }
    closedir($fh);
  }
}


sub run_test {
  my($path)     = shift;
  my($mwc)      = shift;
  my($cfg)      = shift;
  my($expect)   = shift;
  my($type)     = shift;
  my($pass)     = shift;
  my($orig)     = getcwd();
  my($status)   = 0;
  my(%existing) = ();

  if ($pass == 0) {
    my(@files) = list_files($path);
    @existing{@files} = ();
  }

  chdir($path);
  my($ret) = system("$^X $MWC -include $cfg -type $type $mwc") / 256;
  chdir($orig);

  if ($ret != 0) {
    $status++;
  }
  else {
    if (!$cr_expect) {
      $status += compare_output($path, "$expect/$type");
      if ($pass < 1) {
        apply_patches($path);
        if (buildit($type, $path)) {
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

  return $status;
}


sub determine_setup {
  if (defined $ENV{ACE_ROOT}) {
    $MWC = "$ENV{ACE_ROOT}/bin/mwc.pl";
  }
  elsif (defined $ENV{MPC_ROOT}) {
    $MWC = "$ENV{MPC_ROOT}/mwc.pl"
  }
  if (defined $MWC) {
    my($fh) = new FileHandle();
    if (open($fh, "$^X $MWC -h 2>&1 |")) {
      my($look_for_end) = 0;
      while(<$fh>) {
        my($typestr) = undef;
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
            if ($type ne 'borland') {
              push(@types, $type);
            }
          }
        }
      }
      close($fh);
    }
  }
}

# ******************************************************************
# Main Section
# ******************************************************************

my(%options) = ('expected' => \$cr_expect,
                'break'    => \$br_error,
                'nodiff'   => \$nodiff,
               );
my(%desc)    = ('expected' => 'Create expected results for all of the ' .
                              'tests',
                'break'    => 'Break on the first test failure',
                'nodiff'   => 'Do not show file differences',
               );

my($status)  = 0;
my($options) = new OptionProcessor($0, \%options, \%desc);
$options->process();

if ($cr_expect && !defined $ENV{ACE_ROOT}) {
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
    my($expectdir) = 'expected';
    my($testdir)   = 'tests';
    my($logdir)    = 'logs';
    my(@lt)        = localtime(time());
    my($logfile)   = sprintf("$logdir/%04d%02d%02d-%02d%02d%02d.log",
                             $lt[5] + 1900, $lt[4] + 1, $lt[3],
                             $lt[2], $lt[1], $lt[0]);
    my($fh)        = new FileHandle();

    open(SAVEOUT, ">&STDOUT");
    open(SAVEERR, ">&STDERR");

    mkdir($logdir, 0777);
    open(STDOUT, ">$logfile");
    open(STDERR, ">&STDOUT");

    $ENV{MPC_ALWAYS_SORT} = 1;

    if (opendir($fh, $testdir)) {
      my($columns) = (defined $ENV{COLUMNS} ? $ENV{COLUMNS} : 80);
      foreach my $dir (sort(grep(!/^\.\.?$/, readdir($fh)))) {
        if ($dir ne 'CVS') {
          my($full) = "$testdir/$dir";
          if (-d $full) {
            my($amount) = $columns - 4 - length($dir);
            if ($amount < 0) {
              $amount = 1;
            }
            else {
              $amount = int($amount / 2);
            }

            print SAVEOUT '', ('=' x $amount), " $dir ", ('=' x $amount), "\n";
            my($mwc) = '';
            if (-r "$full/$dir.mwc") {
              $mwc = "$dir.mwc";
            }
            foreach my $type (@types) {
              my($ret) = run_test($full, $mwc, 'config',
                                  "$expectdir/$dir", $type, 0);
              $status += $ret;
              if ($ret) {
                print SAVEERR "MPC generation for $type $failed.\n";
                if ($br_error) {
                  last;
                }
              }
              else {
                print SAVEERR "MPC generation for $type $passed.\n";
              }
            }
            if (!$one_built && !$cr_expect) {
              print SAVEERR "WARNING: This project did not ",
                            "build on at least on platform.\n";
            }
          }
          if ($br_error) {
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
    open(STDERR, ">&SAVEERR");
  }
}

exit($status);
