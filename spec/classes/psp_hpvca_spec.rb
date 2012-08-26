require 'spec_helper'

describe 'psp::hpvca', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'foo'
    }
    end
    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /Unsupported osfamily: foo operatingsystem: foo, module psp only support operatingsystem/)
      }
    end
  end

  redhatish = ['RedHat', 'CentOS', 'OracleLinux', 'OEL']

  context 'on a supported operatingsystem, non-HP platform' do
    (['RedHat']).each do |os|
      context "for operatingsystem #{os}" do
        let(:params) {{}}
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'foo'
        }
        end
        it { should_not contain_package('hpvca') }
        it { should_not contain_service('hpvca') }
      end
    end
  end

  context 'on a supported operatingsystem, HP platform, default parameters' do
    (['RedHat']).each do |os|
      context "for operatingsystem #{os}" do
        let(:pre_condition) { 'class {"psp":}' }
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'HP'
        }
        end
        it { should include_class('psp') }
        it { should contain_package('hpvca').with_ensure('present') }
        it { should contain_service('hpvca').with_ensure('running') }
      end
    end
    (['CentOS', 'OracleLinux', 'OEL']).each do |os|
      context "for operatingsystem #{os}" do
        let(:pre_condition) { 'class {"psp":}' }
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'HP'
        }
        end
        it { should include_class('psp') }
        it { should contain_package('hpvca').with_ensure('absent') }
        it { should contain_service('hpvca').with_ensure('stopped') }
      end
    end
  end

  context 'on a supported operatingsystem, HP platform, custom parameters' do
    (['RedHat']).each do |os|
      context "for operatingsystem #{os}" do
        let(:pre_condition) { 'class {"psp":}' }
        let :params do {
          :autoupgrade    => true,
          :service_ensure => 'stopped'
        }
        end
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'HP'
        }
        end
        it { should include_class('psp') }
        it { should contain_package('hpvca').with_ensure('latest') }
        it { should contain_service('hpvca').with_ensure('stopped') }
      end
    end
  end

end
