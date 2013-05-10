class Watcher
  attr_accessor :params
  attr_reader :git

  # params - Run options
  #          :project      - becomes repos/project.git
  #          :project_path - path to watched folder
  #          :git_dir      - override default repos
  #          :sleep        - Timeout in seconds
  def initialize(params)
    self.params = params.reverse_merge :git_dir => ROOT("repos/#{params[:project]}.git"), :sleep => 300
  end

  def init_repo
    git_dir = params[:git_dir].to_s
    @git = Git.init params[:project_path].to_s, :repository => git_dir, :index => git_dir + '/index'
    #ap @git

    #git.add
    #git.status
    #puts git.status.pretty
  end

  def commit_initial
    puts 'Initial commit'
    git.commit 'Initial commit', :add_all => true, :allow_empty => true
  end

  def commit_changed
    git.add

    #changed = git.status.added.keys + git.status.changed.keys + git.status.deleted.keys
    changed = git.status.changed.keys.map {|s| "*#{s}"}
    changed += git.status.added.keys.map {|s| "+#{s}"}
    changed += git.status.deleted.keys.map {|s| "-#{s}"}
    #ap changed

    if changed.empty?
      #puts "no changes"
    else
      msg = "#{Time.now} #{changed.join(' ')}"
      puts msg
      git.commit msg, :add_all => true, :allow_empty => false
    end

  rescue
    commit_initial
  end

  def run
    loop do
      commit_changed

      sleep params[:sleep]
    end
  end

end
