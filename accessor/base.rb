#
# filename: accessor/base.rb
# author: yrlihuan@gmail.com
#

require "rubygems"
require "optparse"
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

  def self.stock_options(options, opts)
    opts.on("-a", "--all", "Get the full list of codes") do |v|
      options[:all] = true
    end

    opts.on("-s", "--stocks a,b,c", Array, "List of stocks to query") do |v|
      options[:stocks] = v
    end
  end

  def self.validate_stock_options(options, opts)
    if !options[:all] && !options[:stocks]
      puts opts
      exit
    end
  end

  def self.common_options(options, opts)
    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
  end
end


