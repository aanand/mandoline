module Mandoline
  class Logger
    def initialize(io)
      @io = io
    end

    def file_deleted(path)
      @io.puts("Deleted #{path}")
    end

    def scenarios_deleted(path, names)
      @io.puts("Deleted scenarios from #{path}:")

      names.each do |name|
        @io.puts("  #{name}")
      end
    end
  end
end