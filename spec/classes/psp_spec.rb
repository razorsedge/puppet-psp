require 'spec_helper'

describe 'psp', :type => 'class' do

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
  fedoraish = ['Fedora']

  context 'on a supported operatingsystem, non-HP platform' do
    redhatish.each do |os|
      context "for operatingsystem #{os}" do
        let(:params) {{}}
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'foo'
        }
        end
        it { should_not contain_yumrepo('HP-psp') }
      end
    end
  end

  context 'on a supported operatingsystem, HP platform, default parameters' do
    redhatish.each do |os|
      context "for operatingsystem #{os}" do
        let(:params) {{}}
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'HP'
        }
        end
        it { should contain_yumrepo('HP-psp').with(
          :descr    => 'HP Software Delivery Repository for Proliant Support Pack',
          :enabled  => '1',
          :gpgcheck => '1',
          :gpgkey   => 'http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/GPG-KEY-ProLiantSupportPack',
          #:baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/#{os}/$releasever/packages/$basearch/",
          #:baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/facts[:operatingsystem]/$releasever/packages/$basearch/",
          #:baseurl  => 'http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/RedHat/$releasever/packages/$basearch/',
          :priority => '50',
          :protect  => '0'
        )}
      end
    end
  end

end
