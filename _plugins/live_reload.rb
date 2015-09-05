require 'guard'
require 'guard/plugin'
require 'guard/livereload/reactor'
require 'guard/livereload/websocket'

module Jekyll
  module Commands
    class Build < Command

      class << self

        def watch(site, options)
          require 'jekyll-watch'
          Jekyll::Watcher.watch(options)
          Jekyll::LiveReload.watch(site, options)
        end

      end
    end
  end
end

module Jekyll
  module LiveReload
    extend self

    attr_accessor :reactor, :options

    def watch(site, options)
      listener = build_listener(site, options)
      listener.start
      start

      unless options['serving']
        trap("INT") do
          listener.stop
          stop
          puts "     Halting live-reload."
          exit 0
        end

        loop { sleep 1000 }
      end
    rescue ThreadError => e
      # You pressed Ctrl-C, oh my!
    end

    def build_listener(site, options)
      require 'listen'
      Listen.to(
        options['source'],
        &(listen_handler(site))
      )
    end

    def start
      @reactor = ::Guard::LiveReload::Reactor.new({
        host:           '0.0.0.0',
        port:           '35729',
        apply_css_live: true,
        override_url:   false,
        grace_period:   0
      })
    end

    def stop
      reactor.stop
    end

    def listen_handler(site)
      proc { |modified, added, removed|
        modified.select! do |x|
          x.match(/^#{site.config['destination']}/)
        end
        modified.map! do |x|
          x.sub(site.config['destination'], '')
        end
        reactor.reload_browser(modified) unless modified.empty?
      }
    end

    class Generator < Jekyll::Generator

      def generate(site)
        site.pages.each do |page|
          unless page.ext == '.coffee'
            page.content << "<script>host = location.host.split(':')[0]; if (host == 'localhost' || host == 'lvh.me') { document.write('<script src=\"http://' + (host || 'localhost').split(':')[0] + ':35729/livereload.js?snipver=1\"></' + 'script>')}</script>"
          end
        end
      end

    end

  end
end
