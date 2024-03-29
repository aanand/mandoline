module Mandoline
  class Runner
    def initialize(options)
      @tags   = options[:tags]
      @logger = options[:logger]
    end

    def run(paths)
      paths.each do |path|
        process_file(path)
      end
    end

    def process_file(path)
      lines = File.readlines(path)

      if entire_file_tagged?(lines)
        delete_file(path)
      else
        delete_scenarios_from_file(path, lines)
      end
    end

    def delete_file(path)
      File.delete(path)
      @logger.file_deleted(path) if @logger
    end

    def delete_scenarios_from_file(path, lines)
      scenario_names = delete_tagged_scenarios(lines)

      if scenario_names.any?
        File.open(path, "w") do |f|
          lines.each do |line|
            f.write(line)
          end
        end

        @logger.scenarios_deleted(path, scenario_names) if @logger
      end
    end

    def delete_tagged_scenarios(lines)
      index = 0
      scenario_names = []

      while index < lines.length
        line = lines[index]

        if line_tagged?(line)
          scenario_names << delete_scenario(lines, index)
        else
          index += 1
        end
      end

      scenario_names
    end

    def line_tagged?(line)
      if tags_section = line[/^(\s+@\w+)+/]
        found_tags = tags_section.scan(/@(\w+)/).flatten
        (@tags & found_tags).any?
      else
        false
      end
    end

    def entire_file_tagged?(lines)
      first_non_empty_line = lines.find { |line| !line.strip.empty? }
      @tags.any? { |tag| first_non_empty_line =~ /^@#{tag}/ }
    end

    def delete_scenario(lines, index)
      lines.delete_at(index) # delete tag line

      scenario_name = lines[index][/Scenario: (.*)/, 1]

      indent = lines[index][/^\s+/]

      lines.delete_at(index)                                       # delete scenario line
      lines.delete_at(index) while lines[index] =~ /^#{indent}\s+/ # delete nested lines
      lines.delete_at(index) while lines[index] =~ /^\s+$/         # delete trailing blank lines

      scenario_name
    end
  end
end