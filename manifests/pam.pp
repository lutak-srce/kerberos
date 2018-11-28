#
# = Class: kerberos::pam
#
class kerberos::pam (
  $package = $::kerberos::params::package_pam,
) inherits kerberos::params {

  package { 'pam_kerberos':
    name => $package,
  }

}
