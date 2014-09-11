require 'spec_helper'
module Nyulibraries
  module Formaggio
    describe PumaConfig, "#initialize" do
      def dummy_path
        @dummy_path ||= File.expand_path("../../../dummy", __FILE__)
      end

      it "returns correct settings based on config" do
        puma_config = PumaConfig.new('9292')
        puma_config.port.should eq('9292')
        puma_config.bind.should eq('tcp://127.0.0.1:9292')
        puma_config.pid.should eq("#{dummy_path}/tmp/pids/puma-9292.pid")
        puma_config.log.should eq("#{dummy_path}/log/puma-test-9292.log")
        puma_config.scripts_path.should eq("#{dummy_path}/config/deploy/puma")
      end
    end
  end
end
