define rjil::system::define_metrics(
  $instance,
  $persist,
  $persistok,
  $disks = [],
  $disk_percent_warn = undef,
  $disk_percent_fail = undef,
  $memory_warn = undef,
  $cpu_warn = undef,
) {

  #Generate a file
  file { "/etc/collectd/conf.d/20-thresholds_$name.conf":
    content => template("rjil/collectd/thresholds-$name.conf.erb"),
    notify  => Service['collectd'],
  }
}
