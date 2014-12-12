require "fileutils"
require "pathname"
module DFS
  UP_DIR_REGEX = /^\.\.\/?/
  class Shell
    attr_reader :uname, :root

    def initialize(start_path, uname)
      @uname = uname
      @root  = File.expand_path(start_path)
      FileUtils.cd(@root)
      @vpwd  = "/"
    end

    def ls

    end

    def up_dir
      @vpwd = @vpwd.split('/')[0...-1].join('/')
    end

    def cd(path = "")
      case path
        when '' then @vpwd = '/'
        when UP_DIR_REGEX
          up_dir
          new_path = path.sub(UP_DIR_REGEX, '')
          cd(new_path) unless new_path == ''
        else
          if @vpwd == '/'
            @vpwd = path
          else
            @vpwd = "#{@vpwd}/#{path}"
          end
      end
    end

    def pwd
      if @vpwd == "/"
        @vpwd
      else
        "#{@vpwd}/"
      end
    end
  end
end