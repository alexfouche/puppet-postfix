class postfix::params {
  case $::osfamily {
    'RedHat': {
      $aliasesseltype = $::operatingsystemmajrelease ? {
        '4'     => 'etc_t',
        /5/     => 'postfix_etc_t',
        /6|7|8|9/   => 'etc_aliases_t',
        default => undef,
      }

      $seltype = $::operatingsystemmajrelease ? {
        '4'     => 'etc_t',
        /5|6|7|8|9/ => 'postfix_etc_t',
        default => undef,
      }

      $restart_cmd = $::operatingsystemmajrelease ? {
        '7'     => '/bin/systemctl reload postfix',
        '8'     => '/bin/systemctl reload postfix',
        '9'     => '/bin/systemctl reload postfix',
        default => '/etc/init.d/postfix reload',
      }

      $mailx_package = $::operatingsystemmajrelease ? {
        '9'     => 's-nail',
        default => 'mailx',
      }

      $cyrus_sasl_plain_package = 'cyrus-sasl-plain'

      $master_os_template = "${module_name}/master.cf.redhat.erb"
    }

    'Debian': {
      $aliasesseltype = undef
      $seltype = undef

      $restart_cmd = '/etc/init.d/postfix reload'

      $mailx_package = $::lsbdistcodename ? {
        /^(sarge|etch|lenny)$/ => 'mailx',
        default                => 'bsd-mailx',
      }

      $cyrus_sasl_plain_package = undef

      $master_os_template = "${module_name}/master.cf.debian.erb"
    }

    'Suse': {
      $seltype = undef

      $mailx_package = 'mailx'

      $cyrus_sasl_plain_package = undef

      if $::operatingsystemmajrelease == '11' {
        $restart_cmd = '/etc/init.d/postfix reload'
        $master_os_template = "${module_name}/master.cf.${::operatingsystem}${::operatingsystemrelease}.erb"
      } else {
        $restart_cmd = '/usr/bin/systemctl reload postfix'
        $master_os_template = "${module_name}/master.cf.sles.erb"
      }
    }

    default: {
      case $::operatingsystem {
        'Alpine': {
            $aliasesseltype = undef
            $seltype = undef

            $restart_cmd = '/etc/init.d/postfix reload'

            $mailx_package = 'mailx'

            $cyrus_sasl_plain_package = undef

            $master_os_template = "${module_name}/master.cf.debian.erb"
        }
        default: {
          fail "Unsupported OS family '${::osfamily}' and OS '${::operatingsystem}'"
        }
      }
    }
  }
}
