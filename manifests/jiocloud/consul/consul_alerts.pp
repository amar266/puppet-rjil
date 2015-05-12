#
# Class: rjil::consul_alerts
#  This class to manage consul-alerts
#
#

class rjil::jiocloud::consul::consul_alerts (
  $health_check           = 'false',
  $check_thresold         = '30',
  $slack_notifier_enabled = 'true',
  $slack_enabled          = 'true',
  $slack_cluster_name     = 'consul-alerts',
  $slack_url              = 'https://hooks.slack.com/services',
  $slack_username         = 'WatchBot',
  $slack_channel          = 'consul-alerts',
  $bin_dir                = '/usr/local/sbin',
  $download_url           = 'https://bintray.com/artifact/download/darkcrux/generic/consul-alerts-latest-linux-amd64.tar',
) {

  staging::file { 'consul-alerts.tar':
    source => $download_url,
    target   => '/tmp/consul-alerts.tar',
  } ->
  exec { "tar -xf /tmp/consul-alerts.tar":
    cwd     => "$bin_dir",
    creates => "$bin_dir/consul-alerts",
    path    => ["/usr/bin", "/usr/sbin", "/bin"]
  } ->
  file { "$bin_dir/consul-alerts":
    owner => 'root',
    group => 0,
    mode  => '0555',
  }

  $healthcheck = {
    'consul-alerts/config/checks/enabled'        => { value => $health_check, },
    'consul-alerts/config/checks/check_thresold' => { value => $check_thresold, },
  }

  $slack_notifier = {
    'consul-alerts/config/notifiers/slack/enabled'      => { value => $slack_notifier_enabled, },
    'consul-alerts/config/notifiers/slack/cluster_name' => { value => $slack_cluster_name, },
    'consul-alerts/config/notifiers/slack/url'          => { value => $slack_url, },
    'consul-alerts/config/notifiers/slack/username'     => { value => $slack_username, },
    'consul-alerts/config/notifiers/slack/channel'      => { value => $slack_channel, },
  }

  create_resources(consul_kv, $healthcheck)

  if $slack_notifier_enabled {
    create_resources(consul_kv, $slack_notifier)
  }

  file { '/etc/init/consul-alerts.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    require => File["$bin_dir/consul-alerts"],
    content => template('rjil/consul-alerts.erb'),
    notify  => Service[consul-alerts]
  }

  service {'consul-alerts':
    ensure  => 'running',
    require => File['/etc/init/consul-alerts.conf'],
  }

}
