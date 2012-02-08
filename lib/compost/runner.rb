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

        i = 0
        any_tags_found = false

        while i < lines.length
          line = lines[i]
          tag_found = false


          if tags_section = line[/^(\s+@\w+)+/]
            found_tags = tags_section.scan(/@(\w+)/).flatten

            if (@tags & found_tags).any?
              tag_found = true
              any_tags_found = true
              indent = line[/^\s+/]

              lines.delete_at(i)
              lines.delete_at(i) while lines[i] =~ /^#{indent}\s+/
            end
          end

          i += 1 unless tag_found
        end

        if any_tags_found
          File.open(path, "w") do |f|
            lines.each do |line|
              f.write(line)
            end
          end
        end
      end
    end

    def entire_file_tagged?(lines)
      @tags.any? { |tag| lines.any? { |line| line =~ /^@#{tag}/ } }
    end
  end
end