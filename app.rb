#! /usr/bin/env ruby
require "dropbox_sdk"
require "#{File.expand_path(".")}/lib/dropboxConnection"
require "#{File.expand_path(".")}/lib/dfsShell"
require "pry"
connection = DropboxShell::Connection.new
shell      = DFS::Shell.new("~/Dropbox", connection.uname)

Pry.config.commands.command "uname", "current user logged in" do |*args|
  puts shell.uname
end

Pry.config.commands.command "cd", "cd into new vfs scope" do |*args|
  #todo fix updir non existant like ../bullshit from /Documents/current
  if connection.inode_exists?("#{shell.pwd}/#{args[0]}") || shell.is_up_dir?(args[0])
    shell.cd(args[0])
    puts shell.pwd
  else
    "#{args[0]} does not exist"
  end
end

Pry.config.commands.command "pwd", "return pwd" do |*args|
  puts shell.pwd
end

Pry.config.commands.command "genlink", "show public link for a file" do |*args|
  if !args[0]
    puts "path required"
  else
    puts connection.link(shell.buildPath(args[0]))
  end
end

Pry.config.commands.command "open", "exec mac os x open command on a media file or a url" do |*args|
  if !args[0]
    puts "path required"
  else
    url = connection.link(shell.buildPath(args[0]))
    shell.open(url)
  end
end



Pry.config.commands.command "ls", "ls the current scope" do |*args|
  args[0] = shell.pwd unless args[0]
  cloud_inodes = connection.inodes_at_path(args[0])
  local_inodes = shell.inodes_at_path(args[0])
  cloud_inodes.sort.map {|inode|
    puts inode.to_s
  }
end

# has to be the last line yo
Pry.start(self, {
  :prompt => [proc { "#{shell.uname}@dbsh(#{shell.pwd})$ " },
                            proc { "MORE INPUT REQUIRED!* " }],
  :command_completions => proc {|a| []
    # inodes = connection.inodes_at_path(shell.pwd)
    # inodes.sort.map {|inode|
    #   inode.to_s }
  }})
