require "coffee-script"

# module Jekyll
#   module Converters
#     class CoffeeScript < Converter
#       safe true
#       priority :low

#       def matches(ext)
#         ext.downcase == ".coffee"
#       end

#       def output_ext(ext)
#         ".js"
#       end

#       def convert(content)
#         binding.pry
#         ::CoffeeScript.compile(content)
#       end
#     end
#   end
# end

module Jekyll
  module CoffeeScript

    class CoffeeScriptFile < Jekyll::StaticFile

      # Obtain destination path.
      #   +dest+ is the String path to the destination dir
      #
      # Returns destination file path.
      def destination(dest)
        File.join(dest, @dir, @name.sub(/(js.)?coffee$/, 'js'))
      end

      # Convert the less file into a css file.
      #   +dest+ is the String path to the destination dir
      #
      # Returns false if the file was not modified since last time (no-op).
      def write(dest)

        dest_path = destination(dest)

        add_dependencies(path)
        FileUtils.mkdir_p(File.dirname(dest_path))
        begin
          return unless modified?(dest_path)
          content = ::CoffeeScript.compile(read_content)
          File.open(dest_path, 'w') do |f|
            f.write(content)
          end
        rescue => e
          STDERR.puts "CoffeeScript Exception: #{e.message}"
        end

        true
      end

      def modified? dest
        return true unless File.exist?(dest) && File.exist?(path)
        File.mtime(dest) < File.mtime(path)
      end

      def add_dependencies path
        import_files.each do |file|
          @site.regenerator.add_dependency(path, file.path)
          file.add_dependencies(file.path)
        end
      end

      def import_files
        begin
          files = read_content.scan(/\@import.*"(.+)";/)
          files.map!(&:first)
          files.map! do |path|
            name = File.basename(path)
            destination = File.dirname(path).sub(@site.source, '')
            if path =~ /\.less$/
              CoffeeScriptFile.new(@site, File.join(*[@base, @dir].compact), destination, name)
            else
              StaticFile.new(@site, File.join(*[@base, @dir].compact), destination, name)
            end
          end
          files
        rescue Exception => e
        end
      end

      def read_content
        File.read(path)
      end

    end

    class CoffeeScriptGenerator < Jekyll::Generator
      safe true

      # Jekyll will have already added the *.coffee files as Jekyll::StaticFile
      # objects to the static_files array.  Here we replace those with a
      # CoffeeScriptFile object.
      def generate(site)
        site.static_files.clone.each do |sf|
          if sf.kind_of?(Jekyll::StaticFile) && sf.path =~ /\.coffee$/
            site.static_files.delete(sf)
            name = File.basename(sf.path)
            destination = File.dirname(sf.path).sub(site.source, '')
            site.static_files << CoffeeScriptFile.new(site, site.source, destination, name)
          end
        end
      end
    end

  end
end
