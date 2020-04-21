require 'spec_helper'

describe('rt::config') do
  let(:facts) do
    {
      :fqdn            => 'test.example.com',
      :hostname        => 'test',
      :ipaddress       => '192.168.0.1',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat'
    }
  end
  context 'with defaults for all parameters' do
    let (:params) {{}}

    it do
      expect { should compile }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  context 'with default parameters from init' do
  let (:params) do
    {
      'ensure'            => 'present',
      'user'              => 'root',
      'group'             => 'root',
      'web_user'          => 'apache',
      'web_group'         => 'apache',
      'config_dir'        => '/etc/rt',
      'config_site'       => '/etc/rt/RT_SiteConfig.pm',
      'config_d'          => '/etc/rt/RT_SiteConfig.d',
      'config_content'    => :undef,
      'siteconfig'        => {},
      'defaultsiteconfig' => {
        'rtname'  => 'example.com',
        'WebPath' => '/rt',
      }
    }
  end

  it { should contain_class('rt::config') }
  it do
    should contain_file('/etc/rt').with(
      {
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      }
    )
  end
  it do
    should contain_file('/etc/rt/RT_SiteConfig.pm').with(
      {
        'ensure' => 'present',
        'owner'  => 'apache',
        'group'  => 'apache',
        'mode'   => '0640',
        'content' => "# This file is managed by puppet
use utf8;
Set($rtname, 'example.com');
Set($WebPath, '/rt');
1;
"
      }
    )
  end
  it do
    should contain_exec('Site config syntax check')
  end
  end
end
