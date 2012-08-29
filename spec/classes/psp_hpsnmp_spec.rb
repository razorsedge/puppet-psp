require 'spec_helper'

describe 'psp::hpsnmp', :type => 'class' do

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
        let(:params) {{ :cmalocalhostrwcommstr => 'aString' }}
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'foo'
        }
        end
        it { should_not contain_group('hpsmh') }
        it { should_not contain_user('hpsmh') }
        it { should_not contain_package('hp-snmp-agents') }
        it { should_not contain_file('snmpd.conf-HP') }
        it { should_not contain_exec('copy_snmpd.conf-HP') }
        it { should_not contain_exec('hpsnmpconfig') }
        it { should_not contain_file('cma.conf') }
        it { should_not contain_service('hp-snmp-agents') }
      end
    end
  end

  context 'on a supported operatingsystem, HP platform, default parameters' do
    (['RedHat']).each do |os|
      context "for operatingsystem #{os} operatingsystemrelease 6.0" do
        let(:pre_condition) { ['class { "psp": }', 'class {"psp::snmp":}', 'class {"psp::hphealth":}'].join("\n") }
        let(:params) {{ :cmalocalhostrwcommstr => 'aString' }}
        let :facts do {
          :operatingsystem        => os,
          :operatingsystemrelease => '6.0',
          :lsbmajdistrelease      => '6',
          :manufacturer           => 'HP'
        }
        end
        it { should include_class('psp') }
        it { should include_class('psp::snmp') }
        it { should include_class('psp::hpsnmp') }
        it { should contain_group('hpsmh').with_ensure('present').with_gid('490') }
        it { should contain_user('hpsmh').with_ensure('present').with_uid('490') }
        it { should contain_package('hp-snmp-agents').with_ensure('present') }
        it { should contain_file('snmpd.conf-HP').with_ensure('present') }
        it { should contain_exec('copy_snmpd.conf-HP') }
        it { should contain_exec('hpsnmpconfig') }
        it { should contain_file('cma.conf').with_ensure('present') }
        it { should contain_service('hp-snmp-agents').with(
          :ensure => 'running',
          :enable => true
        )}
      end
    end
  end

  context 'on a supported operatingsystem, HP platform, custom parameters' do
    (['RedHat']).each do |os|
      context "for operatingsystem #{os} operatingsystemrelease 6.0" do
        let(:pre_condition) { ['class { "psp": }', 'class {"psp::snmp":}', 'class {"psp::hphealth":}'].join("\n") }
        let :params do {
          :cmalocalhostrwcommstr => 'aString',
          :autoupgrade           => true,
          :service_ensure        => 'stopped'
        }
        end
        let :facts do {
          :operatingsystem        => os,
          :operatingsystemrelease => '6.0',
          :lsbmajdistrelease      => '6',
          :manufacturer           => 'HP'
        }
        end
        it { should include_class('psp') }
        it { should include_class('psp::snmp') }
        it { should include_class('psp::hpsnmp') }
        it { should contain_group('hpsmh').with_ensure('present').with_gid('490') }
        it { should contain_user('hpsmh').with_ensure('present').with_uid('490') }
        it { should contain_package('hp-snmp-agents').with_ensure('latest') }
        it { should contain_file('snmpd.conf-HP').with_ensure('present') }
        it { should contain_exec('copy_snmpd.conf-HP') }
        it { should contain_exec('hpsnmpconfig') }
        it { should contain_file('cma.conf').with_ensure('present') }
        it { should contain_service('hp-snmp-agents').with_ensure('stopped') }
      end
    end
  end

end
