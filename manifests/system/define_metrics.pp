define rjil::system::define_metrics(
  $instance,
  $warningmin,
  $failuremin,
  $persist    = true,
  $persistok  = true,
  $disks = ['root'],
  $disk_percent_warn = '10',
  $disk_percent_fail = '5',
) {

  #Generate a file
  file { "/etc/collectd/conf.d/20-thresholds-$name.conf":
      content => template("rjil/collectd/thresholds-$name.conf.erb"),
      notify => Service['collectd'],
   }
  rjil::jiocloud::consul::service { "metric_thresholds_$name":
    interval     => '120s',
    tags          => ['metrics'],
    check_command => "/usr/lib/jiocloud/metrics/check_thresholds_$name.sh",
  }
  file { '/usr/lib/jiocloud/metrics':
    ensure => directory,
  }
  file { "/usr/lib/jiocloud/metrics/check_thresholds_$name.sh":
    mode    => '0755',
    content => template('rjil/tests/check_thresholds.sh.erb')
  }
}
