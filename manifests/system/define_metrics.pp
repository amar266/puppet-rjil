define rjil::system::define_metrics(
  $instance,
  $persist    = true,
  $persistok  = true,
  $disks = ['root'],
  $disk_percent_warn = '10',
  $disk_percent_fail = '5',
  $memory_warn = '100000000',
  $cpu_warn = '10',
) {

  #Generate a file
  file { "/etc/collectd/conf.d/20-thresholds_$name.conf":
      content => template("rjil/collectd/thresholds-$name.conf.erb"),
      notify => Service['collectd'],
  }
}
