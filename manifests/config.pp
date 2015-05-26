# == Class varnish::config
#
# This class is called from varnish
#
class varnish::config {

  file { $varnish::params::sysconfig:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($varnish::params::sysconfig_template),
  }

  if $varnish::params::systemd {
    file { '/etc/systemd/system/multi-user.target.wants/varnish.service':
      ensure => link,
      target => $varnish::params::sysconfig,
    }

    exec { '/bin/systemctl daemon-reload':
      refreshonly => true,
      subscribe   => File[$varnish::params::sysconfig, '/etc/systemd/system/multi-user.target.wants/varnish.service'],
    }
  }
}
