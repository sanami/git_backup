require 'spec_helper'
require 'watcher'

describe Watcher do
  let(:test_project_template) { TEST_DIR + 'test_project' }
  let(:test_project) { ROOT('tmp/test_project') }
  let(:test_git) { ROOT('tmp/test_project.git') }

  subject do
    Watcher.new :project => 'test', :project_path => test_project, :git_dir => test_git
  end

  before :each do
    test_project.rmtree if test_project.exist?
    test_git.rmtree if test_git.exist?

    FileUtils.cp_r test_project_template, ROOT('tmp')
  end

  it 'should create subject' do
    ap subject
    subject.should_not == nil
  end

  it 'should init_repo' do
    subject.init_repo
    subject.git.should_not == nil

    # git --git-dir=../test_project.git status
    # git --git-dir=../test_project.git log

    #puts subject.git.status.pretty
  end

  it 'should commit_initial' do
    subject.init_repo
    subject.commit_initial

    #ap subject.git.log.first
  end

  it 'should commit_changed initial' do
    subject.init_repo

    File.open(test_project + '1', 'a') {|f| f.puts "4" }

    subject.commit_changed
  end

  it 'should commit_changed changed' do
    subject.init_repo
    #subject.commit_initial
    subject.commit_changed

    File.open(test_project + '1', 'a') {|f| f.puts "4" }
    File.open(test_project + '4', 'w') {|f| f.puts "123456789" }

    subject.commit_changed
  end

end
