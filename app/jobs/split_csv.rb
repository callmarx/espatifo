module SplitCsv
  def self.split_csv(original, file_count)
    header_lines = 1
    lines = `cat #{original} | wc -l`.to_i - header_lines
    lines_per_file = 10000
    header = `head -n #{header_lines} #{original}`

    start = 0
    generated_files = []
    file_count.times do |i|
      finish = start + lines_per_file
      file = "#{original}-#{i}.csv"

      File.open(file,'w'){|f| f.write header }
      `tail -n #{lines - start} #{original} | head -n #{lines_per_file} >> #{file}`

      start = finish
      generated_files << file
    end

    generated_files
  end
end
