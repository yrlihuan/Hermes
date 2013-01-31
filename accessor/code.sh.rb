#
# filename: accessor/code.sh.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "json"

require File.expand_path("../base.rb", __FILE__)

module Accessor
  class CodeSh < Base
    def query(params={})
      dir = data_dir

      data = {}
      Dir.entries(dir).each do |f|
        next if f.start_with? '.'

        text = File.open(File.join(dir, f)).read
        obj = JSON.load(text)
        code = f.gsub("json", "ss")
        data[code] = obj
      end

      data
    end

    def update(identifier, params={})
      data = params[:data]
      path = File.join(data_dir, "#{identifier}.json")

      f = File.open(path, 'w')
      f.write(JSON.dump(data))
      f.close
    end

    def append(identifier, params={})
    end
  end
end

if $PROGRAM_NAME == __FILE__
  gen = Accessor::CodeSh.new
  data = gen.query
  puts data.count
  puts data['600036.ss']
end

