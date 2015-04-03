#
# Class: rjil::consul_alerts
#  This class to manage consul-alerts
#
#

class rjil::jiocloud::consul::consul_alerts (
  $health_check           = 'true',
  $check_thresold         = '30',
  $slack_notifier_enabled = 'true',
  $slack_enabled          = 'true',
  $slack_cluster_name     = 'consul-alerts',
  $slack_url              = 'https://hooks.slack.com/services/T0300/B046C4M6Z/bH4CQ8IZU8uu13uWeMgZ8Mww',
  $slack_username         = 'WatchBot',
  $slack_channel          = 'consul-alerts',
  $bin_dir                = '/usr/local/sbin',
  $download_url           = 'https://bintray.com/artifact/download/darkcrux/generic/consul-alerts-latest-linux-amd64.tar',
) {

  staging::file { 'consul-alerts.tar':
    source => $download_url
  } ->
  staging::extract { 'consul-alerts.tar':
    target  => $bin_dir,
    creates => "$bin_dir/consul",
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
