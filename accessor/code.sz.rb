#
# filename: accessor/code.sz.rb
# author: yrlihuan@gmail.com
#

require File.expand_path("../code.sh.rb", __FILE__)

module Accessor
  class CodeSz < CodeSh
    def query(params={})
      dir = data_dir

      data = {}
      Dir.entries(dir).each do |f|
        next if f.start_with? '.'

        text = File.open(File.join(dir, f)).read
        obj = JSON.load(text)
        code = f.gsub("json", "sz")
        data[code] = obj
      end

      data
    end
  end
end

if $PROGRAM_NAME == __FILE__
  gen = Accessor::CodeSz.new
  data = gen.query
  puts data.count
  puts data['000001.sz']
end

