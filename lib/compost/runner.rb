module Compost
  class Runner
    def initialize(options)
      @tags   = options[:tags]
      @logger = options[:logger]
    end

    def run(paths)
      paths.each do |path|
        lines = File.readlines(path)

        if entire_file_tagged?(lines)
          File.delete(path)
          @logger.file_deleted(path) if @logger
        end

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
      @tags.any? { |tag| lines.any? { |line| line =~ /^@#{tag}/ } }
    end

    def delete_scenario(lines, index)
      indent = lines[index][/^\s+/]
      scenario_name = (lines[index+1] || "")[/Scenario: (.*)/, 1]

      lines.delete_at(index)
      lines.delete_at(index) while lines[index] =~ /^#{indent}\s+/

      scenario_name
    end
  end
end