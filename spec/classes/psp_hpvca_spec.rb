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

  #redhatish = ['RedHat']
  redhatish = ['RedHat', 'CentOS', 'OracleLinux', 'OEL']

  context 'on a supported operatingsystem, non-HP platform' do
    redhatish.each do |os|
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
    redhatish.each do |os|
      context "for operatingsystem #{os}" do
        let(:pre_condition) { 'class {"psp":}' }
        let(:params) {{ :ensure => 'present' }}
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'HP'
        }
        end
#  let :pre_condition do
#    " define apt::source (
#$location = '',
#$release = $lsbdistcodename,
#$repos = 'main',
#$include_src = true,
#$required_packages = false,
#$key = false,
#$key_server = 'keyserver.ubuntu.com',
#$key_content = false,
#$key_source = false,
#$pin = false
#) {
#notify { 'mock apt::source $title':; }
#}
#"
#  end
        it { should include_class('psp') }
        it { should contain_package('hpvca').with_ensure('present') }
        it { should contain_service('hpvca').with_ensure('running') }
      end
    end
  end

end
