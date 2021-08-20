require 'spec_helper'

describe('rt::install') do
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
    let(:params) { {} }

    it do
      expect { is_expected.to compile }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  context 'with default parameters from init' do
    let(:params) do
      {
        'ensure'         => 'present',
        'package'        => 'rt',
        'package_ensure' => 'installed',
      }
    end

    it { is_expected.to contain_package('rt').with_ensure('installed') }
  end
end
