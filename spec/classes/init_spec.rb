require 'spec_helper'

describe 'rt' do
  let(:facts) do
    {
      fqdn: 'test.example.com',
      hostname: 'test',
      ipaddress: '192.168.0.1',
      operatingsystem: 'CentOS',
      osfamily: 'RedHat'
    }
  end

  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('rt') }
    it { is_expected.to contain_anchor('rt::begin') }
    it { is_expected.to contain_class('rt::install').that_requires('Anchor[rt::begin]') }
    it { is_expected.to contain_class('rt::config').that_requires('Class[rt::install]') }
    it { is_expected.to contain_anchor('rt::end').that_requires('Class[rt::config]') }
  end
end
