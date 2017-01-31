require 'spec_helper'
module Formaggio
  describe PumaConfig, "#initialize" do
    let(:dummy_path)    {File.expand_path("../../dummy", __FILE__)}
    let(:port)          {'9292'}
    let(:puma_options)  { {} }
    let(:puma_config)   { PumaConfig.new(port, puma_options) }

    context "when not using ssl" do
      it "returns correct settings based on config when not ssl" do
        puma_config.port.should eq(port)
        puma_config.bind.should eq("'tcp://127.0.0.1:#{port}'")
        puma_config.pid.should eq("#{dummy_path}/tmp/pids/puma-#{port}.pid")
        puma_config.log.should eq("#{dummy_path}/log/puma-test-#{port}.log")
        puma_config.scripts_path.should eq("#{dummy_path}/config/deploy/puma")
      end
    end

    context "when using ssl" do
      let(:puma_options)  { {ssl_enabled: true} }
      context "when using default options" do
        it "returns correct settings based on config when ssl" do
          puma_config.port.should eq(port)
          puma_config.host_ip.should eq("127.0.0.1")
          puma_config.keystore.should eq(ENV["KEYSTORE"])
          puma_config.keystore_pass.should eq(ENV["KEYSTORE_PASS"])
          puma_config.bind.should eq("'ssl://127.0.0.1:#{port}?keystore=&keystore-pass=&verify_mode=none'")
          puma_config.pid.should eq("#{dummy_path}/tmp/pids/puma-#{port}.pid")
          puma_config.log.should eq("#{dummy_path}/log/puma-test-#{port}.log")
          puma_config.scripts_path.should eq("#{dummy_path}/config/deploy/puma")
        end
      end
      context "when using custom options" do
        let(:host_ip)       { "127.0.0.10" }
        let(:keystore)      { "keystore" }
        let(:keystore_pass) { "pass" }
        let(:puma_options)  { { ssl_enabled: true,
                                host_ip: host_ip,
                                keystore: keystore,
                                keystore_pass: keystore_pass } }

        it "returns correct settings based on config when ssl" do
          puma_config.port.should eq(port)
          puma_config.host_ip.should eq(host_ip)
          puma_config.keystore.should eq(keystore)
          puma_config.keystore_pass.should eq(keystore_pass)
          puma_config.bind.should eq("'ssl://#{host_ip}:#{port}?keystore=#{keystore}&keystore-pass=#{keystore_pass}&verify_mode=none'")
          puma_config.pid.should eq("#{dummy_path}/tmp/pids/puma-#{port}.pid")
          puma_config.log.should eq("#{dummy_path}/log/puma-test-#{port}.log")
          puma_config.scripts_path.should eq("#{dummy_path}/config/deploy/puma")
        end
      end
    end
  end
end
