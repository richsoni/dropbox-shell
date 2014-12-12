#! /usr/bin/env ruby
require "dropbox_sdk"
require "#{File.expand_path(".")}/lib/dropboxConnection"
require "#{File.expand_path(".")}/lib/dfsShell"
require "pry"
@connection = DropboxShell::Connection.new
@shell      = DFS::Shell.new("~/Dropbox", @connection.uname)

def uname
  @shell.uname
end

def pwd
  @shell.pwd
end

def ls(path = nil)
  path = @shell.pwd unless path
  inodes = @connection.inodes_at_path(path)
  inodes.sort.map {|inode|
    puts inode.to_s
  }
  true
end

def cd(path = "/")
  @shell.cd(path)
end

Pry.config.command_prefix='pry-'
Pry.start(self, :prompt => [proc { "#{@shell.uname}@dbsh(#{@shell.pwd})$ " },
                            proc { "MORE INPUT REQUIRED!* " }])
