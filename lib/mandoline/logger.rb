module Mandoline
  class Logger
    def initialize(io)
      @io = io
    end

    def file_deleted(path)
      @io.puts("Deleted #{red(path)}")
    end

    def scenarios_deleted(path, names)
      @io.puts("Deleted scenarios from #{path}:")

      names.each do |name|
        @io.puts("  #{red(name)}")
      end
    end

    def red(text)
      color(text, 31)
    end

    def color(text, code)
      "\033[1;#{code}m#{text}\033[0m"
    end
  end
end