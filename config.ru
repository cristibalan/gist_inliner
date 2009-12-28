#\ -p 9999
require 'gist_inline'

use Rack::GistInline
run Proc.new { |env| [ 200, { 'Content-Type' => 'text/html' }, [ '<html><body><script src="http://gist.github.com/2059.js"></script></body></html>' ] ] }
