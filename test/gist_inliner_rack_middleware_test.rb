require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require 'rack/mock'

describe 'GistInliner::RackMiddleware' do
  it "should inline gists" do
    @test_body = "<html><body><script src='http://gist.github.com/264628.js'></script>\n<br/>\n<script src='http://gist.github.com/264628.js?file=example.rb'></script></body></html>\n"
    @test_headers = {'Content-Type' => 'text/html'}
    @app = lambda { |env| [200, @test_headers, [@test_body]] }
    @request = Rack::MockRequest.env_for("/")

    GistInliner.any_instance.expects(:fetch_gist).with('http://gist.github.com/264628.js').returns(fixture('264628.js'))
    GistInliner.any_instance.expects(:fetch_gist).with('http://gist.github.com/264628.js?file=example.rb').returns(fixture('264628examplerb.js'))
    GistInliner::RackMiddleware.new(@app).call(@request)[2].should == fixture('inline.html')
  end
end
