Dir.glob(File.expand_path("../**/*.rb", __FILE__)) do |f|
  require f[0...-3]
end
