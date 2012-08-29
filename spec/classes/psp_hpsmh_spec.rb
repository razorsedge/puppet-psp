require 'spec_helper'

describe 'psp::hpsmh', :type => 'class' do
  # Convenience helper for returning parameters for a type from the
  # catalogue.
  #
  # TODO: find a place for this, potentially rspec-puppet.
  def get_param(type, title, param)
    catalogue.resource(type, title).send(:parameters)[param.to_sym]
  end

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
      context "for operatingsystem #{os} operatingsystemrelease 6.0" do
        let(:pre_condition) { ['class { "psp": }', 'class {"psp::hpsnmp":}', 'class {"psp::hphealth":}'].join("\n") }
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
        it { should contain_file('hpsmhconfig').with_ensure('present') }
        it 'should populate File[hpsmhconfig] with default values' do
          content = get_param('file', 'hpsmhconfig', 'content')
          content.should =~ /<admin-group><\/admin-group>/
          content.should =~ /<operator-group><\/operator-group>/
          content.should =~ /<user-group><\/user-group>/
          content.should =~ /<allow-default-os-admin>true<\/allow-default-os-admin>/
          content.should =~ /<anonymous-access>false<\/anonymous-access>/
          content.should =~ /<localaccess-enabled>false<\/localaccess-enabled>/
          content.should =~ /<localaccess-type>Anonymous<\/localaccess-type>/
          content.should =~ /<trustmode>TrustByCert<\/trustmode>/
          content.should =~ /<xenamelist><\/xenamelist>/
          content.should =~ /<ip-binding>false<\/ip-binding>/
          content.should =~ /<ip-binding-list><\/ip-binding-list>/
          content.should =~ /<ip-restricted-logins>false<\/ip-restricted-logins>/
          content.should =~ /<ip-restricted-include><\/ip-restricted-include>/
          content.should =~ /<ip-restricted-exclude><\/ip-restricted-exclude>/
          content.should =~ /<autostart>false<\/autostart>/
          content.should =~ /<timeoutsmh>30<\/timeoutsmh>/
          content.should =~ /<port2301>true<\/port2301>/
          content.should =~ /<iconview>false<\/iconview>/
          content.should =~ /<box-order>status<\/box-order>/
          content.should =~ /<box-item-order>status<\/box-item-order>/
          content.should =~ /<session-timeout>15<\/session-timeout>/
          content.should =~ /<ui-timeout>20<\/ui-timeout>/
          content.should =~ /<httpd-error-log>false<\/httpd-error-log>/
          content.should =~ /<multihomed><\/multihomed>/
          content.should =~ /<rotate-logs-size>5<\/rotate-logs-size>/
        end
        it { should contain_service('hpsmhd').with(
          :ensure => 'running',
          :enable => true
        )}
      end
    end
  end

  context 'on a supported operatingsystem, HP platform, custom parameters' do
    (['RedHat']).each do |os|
      context "for operatingsystem #{os} operatingsystemrelease 6.0" do
        let(:pre_condition) { ['class { "psp": }', 'class {"psp::hpsnmp":}', 'class {"psp::hphealth":}'].join("\n") }
        let :params do {
          :autoupgrade    => true,
          :service_ensure => 'stopped',
          :libz_fix       => 'present'
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
        it { should include_class('psp::hpsnmp') }
        it { should contain_group('hpsmh').with_ensure('present').with_gid('490') }
        it { should contain_user('hpsmh').with_ensure('present').with_uid('490') }
        it { should contain_package('cpqacuxe').with_ensure('latest') }
        it { should contain_package('hpdiags').with_ensure('latest') }
        it { should contain_package('hp-smh-templates').with_ensure('latest') }
        it { should contain_file('/usr/lib/libz.so.1').with_ensure('present') }
        it { should contain_package('hpsmh').with_ensure('latest') }
        it { should contain_file('hpsmhconfig').with_ensure('present') }
        it 'should populate File[hpsmhconfig] with custom values' do
          params[:admin_group] = 'administrators'
          params[:operator_group] = 'operators'
          params[:user_group] = 'users'
          params[:allow_default_os_admin] = 'false'
          params[:anonymous_access] = 'true'
          params[:localaccess_enabled] = 'true'
          params[:localaccess_type] = 'Anonymous'
          params[:trustmode] = 'TrustByCert'
          params[:xenamelist] = 'somevalue'
          params[:ip_binding] = 'true'
          params[:ip_binding_list] = '1.2.3.4'
          params[:ip_restricted_logins] = 'true'
          params[:ip_restricted_include] = '2.3.4.5/24'
          params[:ip_restricted_exclude] = '6.7.8.9/24'
          params[:autostart] = 'true'
          params[:timeoutsmh] = '4000'
          params[:port2301] = 'false'
          params[:iconview] = 'true'
          params[:box_order] = 'status'
          params[:box_item_order] = 'status'
          params[:session_timeout] = '1000'
          params[:ui_timeout] = '5000'
          params[:httpd_error_log] = 'true'
          params[:multihomed] = 'true'
          params[:rotate_logs_size] = '2000'
          content = get_param('file', 'hpsmhconfig', 'content')
          content.should =~ /<admin-group>administrators<\/admin-group>/
          content.should =~ /<operator-group>operators<\/operator-group>/
          content.should =~ /<user-group>users<\/user-group>/
          content.should =~ /<allow-default-os-admin>false<\/allow-default-os-admin>/
          content.should =~ /<anonymous-access>true<\/anonymous-access>/
          content.should =~ /<localaccess-enabled>true<\/localaccess-enabled>/
          content.should =~ /<localaccess-type>Anonymous<\/localaccess-type>/
          content.should =~ /<trustmode>TrustByCert<\/trustmode>/
          content.should =~ /<xenamelist>somevalue<\/xenamelist>/
          content.should =~ /<ip-binding>true<\/ip-binding>/
          content.should =~ /<ip-binding-list>1.2.3.4<\/ip-binding-list>/
          content.should =~ /<ip-restricted-logins>true<\/ip-restricted-logins>/
          content.should =~ /<ip-restricted-include>2.3.4.5\/24<\/ip-restricted-include>/
          content.should =~ /<ip-restricted-exclude>6.7.8.9\/24<\/ip-restricted-exclude>/
          content.should =~ /<autostart>true<\/autostart>/
          content.should =~ /<timeoutsmh>4000<\/timeoutsmh>/
          content.should =~ /<port2301>false<\/port2301>/
          content.should =~ /<iconview>true<\/iconview>/
          content.should =~ /<box-order>status<\/box-order>/
          content.should =~ /<box-item-order>status<\/box-item-order>/
          content.should =~ /<session-timeout>1000<\/session-timeout>/
          content.should =~ /<ui-timeout>5000<\/ui-timeout>/
          content.should =~ /<httpd-error-log>true<\/httpd-error-log>/
          content.should =~ /<multihomed>true<\/multihomed>/
          content.should =~ /<rotate-logs-size>2000<\/rotate-logs-size>/
        end
        it { should contain_service('hpsmhd').with_ensure('stopped') }
      end
    end
  end

end
