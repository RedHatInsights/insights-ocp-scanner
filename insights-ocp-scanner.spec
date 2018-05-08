%global project       RedhatInsights
%global repo          insights-ocp-scanner
%global commit        v0.0.1
%global shortcommit   %(c=%{commit}; echo ${c:0:7})

Name:           insights-ocp-scanner
Version:        0.0.1
Release:        2%{?dist}
Summary:        Tool for extracting and serving content of container images
License:        ASL 2.0
URL:            https://github.com/redhatinsights/insights-ocp-scanner
Source0:        https://github.com/%{project}/%{repo}/archive/%{commit}/%{repo}-%{version}.tar.gz
Source1:        client-egg.tar.gz
BuildRequires:  golang >= 1.7
Requires:       insights-client >= 3.0.3

%description
Insights scan scanner for Openshift Container Platform.

%prep
%setup -qn %{name}-%{version}
%setup -T -D -a 1

%build
mkdir -p ./_build/src/github.com/RedHatInsights
ln -s $(pwd) ./_build/src/github.com/RedHatInsights/insights-ocp-scanner
export GOPATH=$(pwd)/_build:$(pwd)/Godeps/_workspace:%{gopath}
go build -o insights-ocp-scanner -ldflags "-B 0x$(head -c20 /dev/urandom|od -An -tx1|tr -d ' \n')" -v -x "$@" $(pwd)/_build/src/github.com/RedHatInsights/insights-ocp-scanner/insights-scanner.go

%install
install -d %{buildroot}%{_bindir}
mkdir -p %{buildroot}/etc/insights-ocp-scanner
install -p -m 0755 ./insights-ocp-scanner %{buildroot}%{_bindir}/insights-ocp-scanner
install -m644 ./client-egg/rpm.egg  %{buildroot}/etc/insights-ocp-scanner
install -m644 ./client-egg/rpm.egg.asc  %{buildroot}/etc/insights-ocp-scanner

%files
#%doc LICENSE README.md
%{_bindir}/insights-ocp-scanner
/etc/insights-ocp-scanner/rpm.egg
/etc/insights-ocp-scanner/rpm.egg.asc

%changelog

* Tue May 07 2018 Lindani Phiri <lphiri@redhat.com> - 0.0.1-2
- Update insights client dependency

* Wed May 02 2018 Lindani Phiri <lphiri@redhat.com> - 0.0.1-1
- Initial Release

* Wed Apr 25 2018 Lindani Phiri <lphiri@redhat.com> - 0.0.1-0.alpha1
- Initial Build (Alpha)
