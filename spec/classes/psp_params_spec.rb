#!/usr/bin/env rspec

require 'spec_helper'

describe 'psp::params', :type => :class do
  # Blank facts for these tests
  let(:facts) do
    {}
  end

  # Lets check each known good operatingsystem
  describe "when used on supported operatingsystem" do
    operatingsystems = ['redhat', 'centos']
    operatingsystems.each do |os|
      describe os do
        let(:facts) do
          { :operatingsystem => os }
        end

        it "should not fail" do
          subject.should contain_class("psp::params")
        end

        pending 'each parameter must be set' do
          # TODO: Need to get inside the class scope to check these.
          # Perhaps I can create a stub class somehow and inherit
          # psp::params, defining parameters that map to each params
          # variable so I can get at them for testing.
        end
      end
    end
  end

  # Lets check some operatingsystems we know will fail
  describe "when used on unsupported operatingsystems" do
    operatingsystems = ['debian', 'ubuntu', 'solaris']
    operatingsystems.each do |os|
      describe os do
        it "should fail" do
          facts[:operatingsystem] = os
          expect { subject.should }.to raise_error(Puppet::Error)
        end
      end
    end
  end

end

