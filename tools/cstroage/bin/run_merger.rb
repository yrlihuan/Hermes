#!/usr/bin/env ruby

def usage
  """
usage:
  ruby run_merger.rb <date> <output csv> <output dat>
  example:
    ruby run_merger.rb 20130425 ../../../data/level2_merged/20130425.csv ../../../data/level2_merged/20130425.dat
  """
end

if $PROGRAM_NAME == __FILE__
  date = ARGV[0]
  out_csv = ARGV[1]
  out_dat = ARGV[2]

  if !date || date.length != 8 || !out_csv || !out_dat
    puts usage
    exit 1
  end

  curdir = File.dirname(__FILE__)
  datadir = File.join(curdir, "../../../data")

  csv_files = {}
  Dir.glob("#{datadir}/level2/*/#{date}.csv").each do |f|
    f = File.expand_path(f)
    unless /level2\/([0-9]*)\// =~ f
      puts "warning: folder pattern not recognized! #{f}"
      exit 1
    end

    code = $1
    csv_files[code] = f
  end

  # create config file
  tempCfg = "/tmp/merger_#{date}.cfg"
  fout = File.open(tempCfg, 'w')
  csv_files.each do |code,path|
    fout.write("#{code},#{path}\n")
  end
  fout.close()

  # check if there is data_merger executable under bin folder
  # if doesn't exist, run make under cpp folder
  unless File.exist? "#{curdir}/data_merger"
    `cd #{curdir}/../cpp && make`
  end

  # create output folder, if needed
  out_csv = File.expand_path out_csv
  out_dat = File.expand_path out_dat
  [out_csv, out_dat].each do |f|
    d = File.dirname f
    `mkdir -p #{d}` unless File.exist? d
  end

  # run data_merger
  puts "run data_merger"
  output = `#{curdir}/data_merger #{tempCfg} "#{out_csv}" "#{out_dat}" 2>&1`

  puts output

  # remove temp file
  puts "done!"
  #`rm #{tempCfg}`
end
