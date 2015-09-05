require 'jekyll/tags/include'

module Jekyll
  module Tags
    class ConvertIncludeTag < IncludeTag
      def initialize(tag_name, file, tokens)
        super
        @file = file.strip
      end

      def render(context)
        site = context.registers[:site]
        file = render_variable(context) || @file
        dir = resolved_includes_dir(context)
        path = File.join(dir, file)

        includes_dir = File.join(context.registers[:site].source, '_includes')

        if File.symlink?(includes_dir)
          return "Includes directory '#{includes_dir}' cannot be a symlink"
        end

        if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
          return "Include file '#{@file}' contains invalid characters or sequences"
        end

        if context.registers[:page] and context.registers[:page].has_key? "path"
          site.regenerator.add_dependency(
            site.in_source_dir(context.registers[:page]["path"]),
            path
          )
        end

        Dir.chdir(includes_dir) do
          choices = Dir['**/*'].reject { |x| File.symlink?(x) }
          if choices.include?(@file)
            source = File.read(@file)
            converter = context.registers[:site].converters.find { |c| c.matches(File.extname(@file)[1..-1]) }
            partial = Liquid::Template.parse(converter.convert(source))
            context.stack do
              partial.render(context)
            end
          else
            "Included file '#{@file}' not found in _includes directory"
          end
        end
      end
    end

  end
end

Liquid::Template.register_tag('include', Jekyll::Tags::ConvertIncludeTag)
