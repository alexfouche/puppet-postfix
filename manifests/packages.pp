class postfix::packages {
  include ::postfix::params

  package { 'postfix':
    ensure => $postfix::postfix_ensure,
  }

  if ($postfix::manage_mailx) {
    package { 'mailx':
      ensure => $postfix::mailx_ensure,
      name   => $postfix::params::mailx_package,
    }
  }

  if ($postfix::manage_cyrus_sasl_plain) {
    package { 'cyrus-sasl-plain':
      ensure => $postfix::cyrus_sasl_plain_ensure,
      name   => $postfix::params::cyrus_sasl_plain_package,
    }
  }

}
