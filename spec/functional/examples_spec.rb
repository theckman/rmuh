# -*- coding: UTF-8 -*-
# These are just specs to make sure the example files run with an exit
# code of zero.
#

require 'spec_helper'
require 'open3'

DIR = File.expand_path('../../../examples', __FILE__)

describe 'example files' do
  %w( basic_parsing.rb basic_serverstats.rb serverstats_advanced.rb
      serverstats_cache.rb uolog_parsing.rb uorpt_parsing.rb ).each do |e|
    context File.join(DIR, e) do
      it 'should run and return a zero exit code' do
        _, _, s = Open3.capture3(
          "bundle exec ruby #{File.join(DIR, e)}"
        )
        expect(s.success?).to be_truthy
      end
    end
  end
end
