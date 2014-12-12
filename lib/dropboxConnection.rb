require "#{File.expand_path(".")}/lib/tokenProxy"
require "#{File.expand_path(".")}/lib/inode"
require "pathname"

module DropboxShell
  class Connection
    attr_reader :uname
    def initialize
      try_connection
    end

    def inodes_at_path(path = "/")
      metadata = @client.metadata(path)
      inodes = metadata["contents"].map{ |d|
        path = d["path"]
        type = d["is_dir"] ? :dir : :file
        name = Pathname.new(d["path"]).basename
        INode.new(name, type)
      }
    end

    def inode_exists?(path)
      begin
        metadata = @client.metadata(path)
        true
      rescue
        false
      end
    end

    private
    def try_connection
      puts "Attempting To Connect To Dropbox..."
      @access_token = TokenProxy.fetch
      @client = DropboxClient.new(@access_token)
      if bootstrap_connection_data
        puts "Connected!!!"
      else
        TokenProxy.reset
        try_connection
      end
    end

    def bootstrap_connection_data
      begin
        info = @client.account_info()
        @uname = info["email"].split("@")[0]
        @pwd   = "/"
        return true
      rescue
        puts "!!!Error Connecting To Dropbox"
        puts "Retrying..."
        return false
      end
    end
  end
end

