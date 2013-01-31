#
# filename: accessor/base.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require File.expand_path("../../lib/string_ext.rb", __FILE__)

module Accessor
  class Base
    def initialize
    end

    def query(params={})
    end

    def update(identifier, params={})
    end

    def append(identifier, params={})
    end

    def filename
      clsname = self.class.to_s.split("::")[-1]
      clsname.underscore.gsub('_', '.')
    end

    def data_dir
      File.expand_path("../../data/#{filename}", __FILE__)
    end
  end
end

