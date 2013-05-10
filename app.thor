#!/usr/bin/env ruby
require File.dirname(File.absolute_path(__FILE__)) + '/lib/config.rb'
require 'watcher'

class App < Thor
  desc "watch PROJECT PROJECT_PATH SLEEP", "backup to git repo"
  def watch(project, project_path, sleep = nil)
    params = { }
    params[:project] = project
    params[:project_path] = project_path
    params[:sleep] = sleep.to_i if sleep.present?
    ap params

    obj = Watcher.new(params)
    obj.init_repo
    obj.run
  end
end

if __FILE__ == $0
  App.start
end
