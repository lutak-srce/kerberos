#
# = Define: kerberos::realm
#
# This definition creates a new realm in krb5.conf
#
# == Parameters:
#
#   [*user*]            - Name of the user that will have following privileges.
#
define kerberos::realm (
  $realm,
  $kdc,
  $admin_server         = 'UNSET',
  $auth_to_local        = 'DEFAULT',
  $file_krb5_conf       = $::kerberos::file_krb5_conf,
  $erb_krb5_conf_realm  = $::kerberos::erb_krb5_conf_realm,
  $erb_krb5_conf_drealm = $::kerberos::erb_krb5_conf_drealm,
) {

  include ::kerberos

  concat::fragment { "${file_krb5_conf}_realms_${realm}":
    target  => $file_krb5_conf,
    content => template($erb_krb5_conf_realm),
    order   => '200',
  }

  concat::fragment { "${file_krb5_conf}_domainrealms_${realm}":
    target  => $file_krb5_conf,
    content => template($erb_krb5_conf_drealm),
    order   => '400',
  }

}
