License: Freeware
Version: >>ERROR: no value for rpm_version<<
Release: >>ERROR: no value for rpm_releasenumber<<
Source: i.tar.gz
Name: i
Group: >>ERROR: no value for rpm_group<<
Summary: >>ERROR: no value for rpm_summary<<
BuildRoot: %{_tmppath}/%{name}-%{version}-root
Prefix: /usr
AutoReqProv: no




%description
>>ERROR: no value for rpm_description<<

%files -f %{_tmppath}/i.flist
%defattr(-,root,root)
%doc
%config

%post


%preun


%postun


%prep
%setup -n i->>ERROR: no value for rpm_version<<

%build

rm -rf $RPM_BUILD_ROOT

mwc.pl -type gnuace -base install -value_project libpaths+=/tmp/mpcrpm/inst/lib -value_project includes+=/tmp/mpcrpm/inst/include  i.mwc
make 

%install
if [ "$RPM_BUILD_ROOT" = "/" ]; then
  echo "Build root of / is a bad idea.  Bailing."
  exit 1
fi
rm -rf $RPM_BUILD_ROOT
export staging_dir=$RPM_BUILD_ROOT/install/usr
mkdir -p $staging_dir
export pkg_dir=$RPM_BUILD_ROOT/i_dir
mkdir -p $RPM_BUILD_ROOT/i_dir
make INSTALL_PREFIX=${staging_dir} install
if [ -d ${staging_dir}/share/man ]; then
  files=$(find ${staging_dir}/share/man -name '*.bz2')
  if [[ "${files}" ]]; then echo "${files}" | xargs bunzip2 -q; fi
  files=$(find ${staging_dir}/share/man -name '*.[0-9]')
  if [[ "${files}" ]]; then echo "${files}" | xargs gzip -9; fi
fi
cp -a $RPM_BUILD_ROOT/install/* ${pkg_dir}
find ${pkg_dir} ! -type d | sed s^${pkg_dir}^^ | sed /^\s*$/d > %{_tmppath}/i.flist
find ${pkg_dir} -type d | sed s^${pkg_dir}^^ | sed '\&^/usr$&d;\&^/usr/share/man&d;\&^/usr/games$&d;\&^/lib$&d;\&^/etc$&d;\&^/boot$&d;\&^/usr/bin$&d;\&^/usr/lib$&d;\&^/usr/share$&d;\&^/var$&d;\&^/var/lib$&d;\&^/var/spool$&d;\&^/var/cache$&d;\&^/var/lock$&d;\&^/tmp/apkg&d' | sed /^\s*$/d | sed 's&^&%dir &' >> %{_tmppath}/i.flist
cp -a $RPM_BUILD_ROOT/*_dir/* $RPM_BUILD_ROOT
rm -rf $RPM_BUILD_ROOT/*_dir
rm -rf $RPM_BUILD_ROOT/install

%clean
make realclean
find . -name 'GNUmakefile*' -o -name '.depend.*' | xargs rm -f

%changelog
* Tue Dec 21 2010 14:10:11 This file was generated by MPC.
  $Id$
  Any changes made directly to this file will
  be lost the next time it is generated.
  MPC Command:
  /tao_builds/mitza/1.5a/ACE_wrappers/bin/mwc.pl -include config -type rpmspec t/c/d/d.mwc
