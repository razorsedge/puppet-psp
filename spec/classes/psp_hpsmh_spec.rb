require 'spec_helper'

describe 'psp::hpsmh', :type => 'class' do

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
        it { should_not contain_group('hpsmh') }
        it { should_not contain_user('hpsmh') }
        it { should_not contain_package('cpqacuxe') }
        it { should_not contain_package('hpdiags') }
        it { should_not contain_package('hp-smh-templates') }
        it { should_not contain_file('/usr/lib/libz.so.1') }
        it { should_not contain_package('hpsmh') }
        it { should_not contain_file('hpsmhconfig') }
        it { should_not contain_service('hpsmhd') }
      end
    end
  end

  context 'on a supported operatingsystem, HP platform, default parameters' do
    (['RedHat']).each do |os|
      context "for operatingsystem #{os}" do
        let(:pre_condition) { ['class { "psp": }', 'class {"psp::hpsnmp":}', 'class {"psp::hphealth":}'].join("\n") }
        #let(:pre_condition) { ['class { "psp": }', 'class {"psp::hpsnmp":}'].join("\n") }
        let :facts do {
          :operatingsystem        => os,
          :operatingsystemrelease => '6.0',
          :lsbmajdistrelease      => '6',
          :manufacturer           => 'HP'
        }
        end
        it { should include_class('psp') }
        it { should include_class('psp::hpsnmp') }
        it { should contain_group('hpsmh').with_ensure('present').with_gid('490') }
        it { should contain_user('hpsmh').with_ensure('present').with_uid('490') }
        it { should contain_package('cpqacuxe').with_ensure('present') }
        it { should contain_package('hpdiags').with_ensure('present') }
        it { should contain_package('hp-smh-templates').with_ensure('present') }
        it { should contain_file('/usr/lib/libz.so.1').with_ensure('') }
        it { should contain_package('hpsmh').with_ensure('present') }
#        it { should contain_file('hpsmhconfig').with_ensure('present').with_content(/^\s*<allow-default-os-admin>true<\/allow-default-os-admin>$/) }
        it { should contain_file('hpsmhconfig').with(
          :ensure  => 'present',
          :content => /^\s*<allow-default-os-admin>true<\/allow-default-os-admin>$/
        )}
        it { should contain_service('hpsmhd').with(
          :ensure => 'running',
          :enable => true
        )}
#        it 'should populate smhpd.xml with default values' do
#          content = get_param('file', '/opt/hp/hpsmh/conf/smhpd.xml', 'content')
#          content.should =~ /<allow-default-os-admin>true<\/allow-default-os-admin>/
#        end
      end
    end
  end

#  context 'on a supported operatingsystem, HP platform, custom parameters' do
#    (['RedHat']).each do |os|
#      context "for operatingsystem #{os} operatingsystemrelease 6.0" do
#        let(:pre_condition) { 'class {"psp":}' }
#        let :params do {
#          :autoupgrade    => true,
#          :service_ensure => 'stopped'
#        }
#        end
#        let :facts do {
#          :operatingsystem        => os,
#          :operatingsystemrelease => '6.0',
#          :manufacturer           => 'HP'
#        }
#        end
#        it { should include_class('psp') }
#        it { should contain_package('hp-OpenIPMI').with(
#          :ensure => 'latest',
#          :name   => 'OpenIPMI'
#        )}
#        it { should contain_package('hponcfg').with_ensure('latest') }
#        it { should contain_package('hp-health').with_ensure('latest') }
#        it { should contain_package('hpacucli').with_ensure('latest') }
#        it { should contain_package('hp-ilo').with_ensure('absent') }
#        it { should contain_service('hp-ilo').with_ensure('') }
#        it { should contain_service('hp-health').with_ensure('stopped') }
#      end
#    end
#  end

end
