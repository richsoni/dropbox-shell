#! /usr/bin/env ruby
require "dropbox_sdk"
require "#{File.expand_path(".")}/lib/dropboxConnection"
require "#{File.expand_path(".")}/lib/dfsShell"
require "pry"
connection = DropboxShell::Connection.new
shell      = DFS::Shell.new("~/Dropbox", connection.uname)
res        = nil

Pry.config.commands.command "uname", "current user logged in" do |*args|
  res shell.uname
  puts res
end

Pry.config.commands.command "cd", "cd into new vfs scope" do |*args|
  #todo fix updir non existant like ../bullshit from /Documents/current
  if connection.inode_exists?("#{shell.pwd}/#{args[0]}") || shell.is_up_dir?(args[0])
    shell.cd(args[0])
    res = shell.pwd
    puts res
  else
    res = "#{args[0]} does not exist"
    puts res
  end
end

Pry.config.commands.command "pwd", "return pwd" do |*args|
  res = shell.pwd
  puts res
end

Pry.config.commands.command "genlink", "show public link for a file" do |*args|
  if !args[0]
    res = "path required"
    puts res
  else
    res = connection.link(shell.buildPath(args[0]))
    puts res
  end
end

Pry.config.commands.command "open", "exec mac os x open command on a media file or a url" do |*args|
  if !args[0]
    res = "path required"
    puts res
  else
    url = connection.link(shell.buildPath(args[0]))
    shell.open(url)
  end
end

Pry.config.commands.command "mv", "move a file from one dropbox folder to another" do |*args|
  if !args[0]
    res = "src required"
    puts res
  elsif !args[1]
    res = "dest required"
    puts res
  else
    connection.mv(args[0], args[1])
  end
end


Pry.config.commands.command "ls", "ls the current scope" do |*args|
  args[0] = shell.pwd unless args[0]
  cloud_inodes = connection.inodes_at_path(args[0])
  local_inodes = shell.inodes_at_path(args[0])
  res = cloud_inodes.sort.map {|inode|
    puts inode.to_s
    inode.to_s
  }
end

Pry.config.commands.command "mkdir", "make a directory at path" do |*args|
  if !args[0]
    res = "path required"
    puts res
  else
    connection.mkdir(args[0])
  end
end

# has to be the last line yo
Pry.start(self, {
  :prompt => [proc { "#{shell.uname}@dbsh(#{shell.pwd})$ " },
                            proc { "MORE INPUT REQUIRED!* " }],
  :command_completions => proc {|a| []
    connection.cached_inodes.sort.map {|inode|
      inode.to_s }
  }})
