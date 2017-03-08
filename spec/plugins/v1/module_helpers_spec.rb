require 'spec_helper'
require 'retrospec/plugins/v1/plugin'

describe Retrospec::Plugins::V1::ModuleHelpers do

  let(:helper_class) do
    Retrospec::Plugins::V1::Plugin.new
  end

  let(:context) do
    Retrospec::Plugins::V1::ContextObject.new
  end

  it 'sync_file should be false' do
    expect(helper_class.sync_file?('/tmp')).to be false
  end

  it 'sync_file should be true' do
    expect(helper_class.sync_file?('/tmp/file_template.retrospec.erb.sync')).to be true
  end

  it 'sync_file should be false with sync in name' do
    expect(helper_class.sync_file?('/tmp/modulesync.retrospec.erb')).to be false
  end

  it 'retrospec_file should be false' do
    expect(helper_class.retrospec_file?('/tmp')).to be false
  end

  it 'retrospec_file should be true' do
    expect(helper_class.retrospec_file?('/tmp/file_template.retrospec.erb.sync')).to be true
  end

  it 'retrospec_file should be false with retrospec in name' do
    expect(helper_class.retrospec_file?('/tmp/modulesync_retrospec.erb')).to be false
  end

  describe 'sync files' do
    before(:each) do
      allow(helper_class).to receive(:create_content).and_return(true)

    end
    it 'create file with sync true' do
      expect(helper_class.safe_create_file('/tmp/file123', 'blah', true))
    end
    it 'create file with sync false' do
      expect(helper_class.safe_create_file('/tmp/file123', 'blah', false))
    end

    it 'can sync non template file' do
      file = File.join(fixtures_dir, 'sync_files', 'module_files', 'Gemfile.sync')
      expect(helper_class).to receive(:safe_copy_file).with(file, '/tmp/module_name/Gemfile', true)
      helper_class.safe_create_module_files(File.join(fixtures_dir, 'sync_files'), '/tmp/module_name', context)
    end

    it 'can sync template file' do
      file = File.join(fixtures_dir, 'sync_files', 'module_files', 'Rakefile.sync.retrospec.erb')
      # expect(helper_class).to receive(:create_content).with(:dir, "/tmp/module_name")
      # expect(helper_class).to receive(:create_content).with(:cp, "/tmp/module_name/Gemfile", "/Users/cosman/github/retrospec/spec/fixtures/sync_files/module_files/Gemfile.sync")
      # expect(helper_class).to receive(:create_content).with(:file, '/tmp/module_name/Rakefile', anything)
      expect(helper_class).to receive(:safe_create_file).with('/tmp/module_name/Rakefile', anything, true)
      helper_class.safe_create_module_files(File.join(fixtures_dir, 'sync_files'), '/tmp/module_name', context)
    end
  end

end