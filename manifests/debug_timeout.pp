#
# Class rjil::debug_timeout
#
class rjil::debug_timeout(
  $debug_files,
) {
  ini_setting { 'debug_timeout':
    path    => '/etc/debug_timeout.ini',
    section => main,
    setting => files,
    value   => $debug_files
  }
}

