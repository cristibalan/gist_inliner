require 'rubygems'
require 'test/spec'
require 'mocha'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gist_inliner'

DIRNAME = File.expand_path(File.dirname(__FILE__))

def wrap(html)
  "<html><body>#{html}</body></html>\n"
end

def fixture(path)
  File.read(File.join(DIRNAME, "fixtures/#{path}"))
end
