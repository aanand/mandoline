require "mandoline/version"
require "mandoline/logger"
require "mandoline/runner"
require "optparse"

module Mandoline
  def self.run(*args)
    options = {}

    parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{File.basename($0)} [OPTIONS] [PATHS]"

      opts.on "-t TAGS", "--tags TAGS", "Comma-separated list of tags to delete, e.g. wip,pending,v1", Array do |v|
        options[:tags] = v
      end
    end

    begin
      parser.parse!(args)
      raise OptionParser::MissingArgument, "--tags" unless options[:tags]
      raise OptionParser::MissingArgument, "At least one path must be specified" if args.empty?
    rescue OptionParser::ParseError => e
      puts e.message
      puts
      puts parser
      exit -1
    end

    options[:logger] = Mandoline::Logger.new(STDERR)

    paths = if args.length == 1 && File.directory?(args.first)
              Dir.glob("#{args.first}/**/*.feature")
            else
              args
            end

    Runner.new(options).run(paths)
  end
end
