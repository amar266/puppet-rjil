require 'spec_helper'
require 'hiera-puppet-helper'

describe 'rjil::system::metrics' do
  let(:facts) { {:operatingsystem => 'Debian', :osfamily => 'Debian'}}

  context 'collectd configuration' do
    it 'should configure collectd' do
      should contain_class('collectd').with({
        'purge'        => true,
        'recurse'      => true,
        'purge_config' => true,
      })
      should contain_file('/var/lib/metrics').with_ensure('directory')
      should contain_file('/var/lib/metrics/collectd').with_ensure('directory')
      should contain_file('/var/lib/metrics/collectd/csv').with_ensure('directory')
      should contain_class('collectd::plugin::csv').with({
        'datadir'    => '/var/lib/metrics/collectd/csv',
        'storerates' => false,
      })
      should contain_class('collectd::plugin::memory')
      end
  end
end
