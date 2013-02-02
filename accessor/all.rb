#
# filename: accessor/all.rb
# author: yrlihuan@gmail.com
#

require "rubygems"

selfname = File.basename(__FILE__)
Dir.entries(File.dirname(__FILE__)).each do |f|
  next if f.start_with? '.'
  next if f == selfname

  require File.expand_path(f, File.dirname(__FILE__))
end


