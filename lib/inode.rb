require "colorize"
module DropboxShell
  class INode
    attr_reader :name, :type
    def initialize(name, type)
      @name = name
      @type = type
    end

    def dir?
      type == :dir
    end

    def file?
      type == :file
    end

    def to_s
      if dir?
        "#{name}/"
      else
        name.to_s
      end
    end

    def <=>(anOther)
      name <=> anOther.name
    end
  end
end
