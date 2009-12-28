require 'net/http'

class GistInliner
  GIST_REGEX = /<script[^>]*src=["']([^>"']*gist\.github\.com\/\d+[^>"']*)["'][^>]*><\/script>/

  def initialize(html)
    @html = html.to_s
  end

  def inline
    @html.gsub(GIST_REGEX) do |script|
      parse_gist(fetch_gist($1))
    end
  end

  def collect
    @html.scan(GIST_REGEX).flatten
  end

  def fetch_gist(uri)
    ::Net::HTTP.get(URI.parse(uri))
  end

  def parse_gist(js)
    output = []
    js.each do |line|
      if line.chomp =~/^document\.write\('(.*)'\);?/
        output << $1.gsub(/\\(["'\/])/, '\1').gsub('\n', "\n").gsub('\\\\', '\\')
      end
    end
    output.join("\n")
  end
end

class GistInliner
  class RackMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      body = body.inject("") { |html, part| html += part }

      body = GistInliner.new(body).inline

      [status, headers, body]
    end
  end
end
