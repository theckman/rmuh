require 'rspec'
require File.join(File.expand_path('../..', __FILE__), 'lib/rmuh/rpt')

describe RMuh::RPT do
  context '::V_MAJ' do
    it 'should have a major version that is an integer' do
      RMuh::RPT::V_MAJ.is_a?(Integer).should be_true
    end

    it 'should have a major version that is a positive number' do
      (RMuh::RPT::V_MAJ > -1).should be_true
    end
  end

  context '::V_MIN' do
    it 'should have a minor version that is an integer' do
      RMuh::RPT::V_MIN.is_a?(Integer).should be_true
    end

    it 'should have a minor version that is a positive integer' do
      (RMuh::RPT::V_MIN > -1).should be_true
    end
  end

  context '::V_REV' do
    it 'should have a revision number that is an integer' do
      RMuh::RPT::V_REV.is_a?(Integer).should be_true
    end

    it 'should have a revision number that is a positive integer' do
      (RMuh::RPT::V_REV > -1).should be_true
    end
  end

  context '::VERSION' do
    it 'should have a version that is a string' do
      RMuh::RPT::VERSION.should be_an_instance_of String
    end

    it 'should match the following format N.N.N' do
      /\A(?:\d+?\.){2}\d+?/.match(RMuh::RPT::VERSION).should_not be_nil
    end
  end
end
