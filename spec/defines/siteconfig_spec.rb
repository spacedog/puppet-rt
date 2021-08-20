require 'spec_helper'
describe 'rt::siteconfig', type: :define do
  let(:title) { 'Test' }
  let(:facts) do
    {
      fqdn: 'test.example.com',
      hostname: 'test',
      ipaddress: '192.168.0.1',
      operatingsystem: 'CentOS',
      osfamily: 'RedHat'
    }
  end
  let :default_params do
    {
      'ensure' => 'present',
    }
  end
  # we do not have defaults for some parameters so the define should fail

  context 'with defaults for all parameters' do
    let(:params) { {} }

    it 'fails on empty value' do
      expect { is_expected.to compile }.to raise_error(RSpec::Expectations::ExpectationNotMetError, %r{Value must be defined})
    end
  end

  context 'with basic params' do
    context 'should have a properly value defined for hash ' do
      let(:params) do
        default_params.merge({ 'value' => {
                               'param1' => 'test value1',
                                'param2' => 'test value2',
                             } })
      end

      it do
        is_expected.to contain_file('/etc/rt/RT_SiteConfig.d/Test.pm').with(
          {
            'ensure'  => 'present',
            'mode'    => '0640',
            'owner'   => 'apache',
            'group'   => 'apache',
            'content' => "# File is generated by puppet
use utf8;
Set(%Test,
  'param1' => 'test value1',
  'param2' => 'test value2',
);
1;
"
          },
        )
      end
    end
    context 'should have a properly value defined for array ' do
      let(:params) do
        default_params.merge({ 'value' => [
                               'param1',
                               'param2',
                             ] })
      end

      it do
        is_expected.to contain_file('/etc/rt/RT_SiteConfig.d/Test.pm').with(
          {
            'ensure'  => 'present',
            'mode'    => '0640',
            'owner'   => 'apache',
            'group'   => 'apache',
            'content' => "# File is generated by puppet
use utf8;
Set(@Test,
  'param1',
  'param2',
);
1;
"
          },
        )
      end
    end
    context 'should have a properly value defined for String ' do
      let(:params) do
        default_params.merge({
                               'value' => 'Test value'
                             })
      end

      it do
        is_expected.to contain_file('/etc/rt/RT_SiteConfig.d/Test.pm').with(
          {
            'ensure'  => 'present',
            'mode'    => '0640',
            'owner'   => 'apache',
            'group'   => 'apache',
            'content' => "# File is generated by puppet
use utf8;
Set($Test, 'Test value');
1;
"
          },
        )
      end
    end
    context 'should do syntax check' do
      let(:params) do
        default_params.merge({
                               'value' => 'Test value'
                             })
      end

      it { is_expected.to contain_exec('Test syntax check') }
    end
  end
end

# vim: ts=2 sw=2 sts=2 et :
