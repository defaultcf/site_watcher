require_relative "../lib/site_watcher/db"

RSpec.describe "site_watcher", type: :aruba, startup_wait_time: 1 do
  let(:db) { SiteWatcher::DB.new }
  let(:setup) { db.setup }

  context "add command" do
    it "output success" do
      run_command "site_watcher add test-site https://example.com h1"
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output("Example Domain")
    end
  end

  context "list command" do
    it "output success" do
      run_command "site_watcher list"
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/test-site/)
    end
  end

  context "check command" do
    it "output success" do
      run_command "site_watcher check test-site"
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output("Example Domain")
    end
  end

  context "remove command" do
    it "output success" do
     expect {
        run_command "site_watcher remove test-site"
     }.to change { db.sites_count }.by(-1)
      expect(last_command_started).to be_successfully_executed
    end
  end
end
