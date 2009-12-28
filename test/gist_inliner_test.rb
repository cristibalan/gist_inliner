require File.expand_path(File.dirname(__FILE__) + '/test_helper')

describe 'GistInliner' do
  it "should collect gists and not get distracted by nongists" do
    [
      ['<script src="http://gist.github.com/264628.js"></script>', 
          ["http://gist.github.com/264628.js"]],
      ['<script id="gist" src="http://gist.github.com/264628.js"></script>', 
          ["http://gist.github.com/264628.js"]],
      ['<script src="http://gist.github.com/264628.js?file=example.rb" type="text/javascript"></script>', 
          ["http://gist.github.com/264628.js?file=example.rb"]],
      ['<script>alert("http://gist.github.com/264628.js")</script>', 
          []],
      ['<script title="http://gist.github.com/264628.js"></script>', 
          []],
      ['<script id="gist" src="http://gist.github.com/264628.js"></script><br/><script id="gist" src="http://gist.github.com/264628.js"></script>', 
          ["http://gist.github.com/264628.js", "http://gist.github.com/264628.js"]],
      ["<script id='gist' src='http://gist.github.com/264628.js'></script><br/>\n\n<script id='gist' src='http://gist.github.com/264628.js'></script>", 
          ["http://gist.github.com/264628.js", "http://gist.github.com/264628.js"]],
    ].each do |html, gists|
      GistInliner.new(wrap(html)).collect.should == gists
    end
  end

  it "should parse a gist correctly" do
    GistInliner.new("").parse_gist(fixture('264628.js')).should == fixture('264628.html')
    GistInliner.new("").parse_gist(fixture('264628examplerb.js')).should == fixture('264628examplerb.html')
  end

  it "should inline gists" do
    gi = GistInliner.new(wrap("<script src='http://gist.github.com/264628.js'></script>\n<br/>\n<script src='http://gist.github.com/264628.js?file=example.rb'></script>"))

    gi.expects(:fetch_gist).with('http://gist.github.com/264628.js').returns(fixture('264628.js'))
    gi.expects(:fetch_gist).with('http://gist.github.com/264628.js?file=example.rb').returns(fixture('264628examplerb.js'))

    gi.inline.should == fixture('inline.html')
  end
end
