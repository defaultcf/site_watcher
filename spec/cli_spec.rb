RSpec.describe "site_watcher command", type: :aruba do
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
      expect(last_command_started).to have_output("List")
    end
  end

  context "check command" do
    it "output success" do
      run_command "site_watcher check"
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output("Check")
    end
  end

  context "remove command" do
    it "output success" do
      run_command "site_watcher remove test-site"
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output("Remove test-site")
    end
  end
end
