require 'spec_helper'
module Formaggio
  describe NewRelicManager do
    before(:each) do
      expect(File.exists? NewRelicManager.newrelic_file).to be_true
      NewRelicManager.backup_original
    end

    after(:each) do
      NewRelicManager.reset_original
      expect(File.exists? NewRelicManager.newrelic_file).to be_true
      expect(File.exists? "#{NewRelicManager.newrelic_file}.bak").to be_false
    end

    describe "newrelic file" do
      it "should always exist" do
        newrelic_file = NewRelicManager.newrelic_file
        expect(File.exists? newrelic_file).to be_true
      end

      it "should be valid yaml after rewrite" do
        NewRelicManager.rewrite_with_settings
        yaml = YAML.load_file(NewRelicManager.newrelic_file)
        yaml.class.should eq Hash
        yaml["common"]["license_key"].should eq "dummykey"
        yaml["common"]["app_name"].should eq "NyulibrariesDummyApplication"
      end
    end

    describe "newrelic backup file" do
      it "should only exist after backup" do
        NewRelicManager.backup_original
        expect(File.exists? "#{NewRelicManager.newrelic_file}.bak").to be_true
      end
    end
  end
end
