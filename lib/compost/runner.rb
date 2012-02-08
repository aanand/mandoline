module Compost
  class Runner
    def initialize(options)
      @paths = options[:paths]
      @tags  = options[:tags]
    end

    def run
      @paths.each do |path|
        lines = File.readlines(path)
        File.delete(path) if entire_file_tagged?(lines)

        if delete_tagged_scenarios(lines)
          File.open(path, "w") do |f|
            lines.each do |line|
              f.write(line)
            end
          end
        end
      end
    end

    def delete_tagged_scenarios(lines)
      index = 0
      any_tags_found = false

      while index < lines.length
        line = lines[index]

        if line_tagged?(line)
          any_tags_found = true
          delete_line_and_nested_lines(lines, index)
        else
          index += 1
        end
      end

      any_tags_found
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

    def delete_line_and_nested_lines(lines, index)
      indent = lines[index][/^\s+/]

      lines.delete_at(index)
      lines.delete_at(index) while lines[index] =~ /^#{indent}\s+/
    end
  end
end