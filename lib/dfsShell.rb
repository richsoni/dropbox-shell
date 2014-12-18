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

    def open(path)
      `open #{path}`
    end

    def buildPath(path)
      "#{pwd}/#{path}"
    end

    def is_up_dir?(path)
      !!path.match(UP_DIR_REGEX)
    end

    def up_dir
      @vpwd = @vpwd.split('/')[0...-1].join('/')
    end

    def cd(path = "")
      case path
        when NIL then @vpwd = '/'
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

    def inodes_at_path(path = "")
      Dir.glob("*").map { |node|
        # Inode.new()
      }
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
