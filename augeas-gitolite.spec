Name:		augeas-gitolite
Version:	1.0
Release:	1%{?dist}
Summary:        Provides a lens for managing gitolite.conf files with augeas	

Group:		System Environment/Libraries
License:	LGPL v2+
URL:		https://github.com/jjulien/augeas-gitolite
Source0:        %{name}-%{version}.tar.gz	
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

Requires:      augeas
BuildArch:     noarch

%define lenses /usr/share/augeas/lenses

%description
Provides a lens for managing gitolite.conf files with augeas

%prep
%setup -q -c

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%{lenses}/gitolite.aug
%{lenses}/tests/test_gitolite.aug


%changelog
* Sat Nov 9 2013 John Julien <john@julienfamily.com> - 1.0-1
- Initial specfile
