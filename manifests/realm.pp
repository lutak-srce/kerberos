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
  $admin_server   = 'UNSET',
  $auth_to_local  = 'DEFAULT',
  $file_krb5_conf = $::kerberos::file_krb5_conf,
) {
  include ::kerberos

  concat::fragment { "${file_krb5_conf}_realms_${realm}":
    target  => $file_krb5_conf,
    content => template('kerberos/krb5.conf_realm.erb'),
    order   => '200',
  }

  concat::fragment { "${file_krb5_conf}_domainrealms_${realm}":
    target  => $file_krb5_conf,
    content => template('kerberos/krb5.conf_domainrealm.erb'),
    order   => '400',
  }

}
