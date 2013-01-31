#
# filename: fetcher/base.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require File.expand_path("../../lib/string_ext.rb", __FILE__)

module Fetcher
  class Base
    def initialize
      puts "start fetching data: #{filename}"
    end

    def filename
      clsname = self.class.to_s.split("::")[-1]
      clsname.underscore.gsub('_', '.')
    end

    def data_dir
      File.expand_path("../../data/#{filename}", __FILE__)
    end

    def accessor_cls
      clsname = self.class.to_s.split("::")[-1]
      instance_eval "Accessor::#{clsname}"
    end
  end
end
