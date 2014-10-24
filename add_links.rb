#!/bin/ruby

# Given a file called "input.txt", read it, creates a file called "output.txt"
# The file is formatted so that any person listed in 5winners.txt has their
# entry in the file changed from First Last to [[First Last]]
# This is useful for quickly editing Wikipedia files to create a link
# Note: This will NOT handle disambiguation very well, i.e. names which are common
# and may have other Wikipedia entries, e.g. Charles Coon who is a Bridge player
# but there are already 2 Charles Coon entries
CSV_DELIMITER = ","
# 

data = File.read("input.txt")

# Originally this file was called 5winners.txt, hence the variable name
win5 = File.read("conversion_list.txt")

win5.each_line do |w5|
  w5.chomp!
  w2 = "[[" + w5 + "]]"
  w4 = "[[[[" + w5 + "]]]]"
  # My name to [[My Name]]
  data.gsub!(w5, w2)
  # Catch already done
  # [[[[My Name]]]] to [[My Name]]
  data.gsub!(w4, w2)

  w2a = "[[[[" + w5 + "]]"
  w2b = "[[" + w5
  # [[[[My Name]] to [[My Name]]
  data.gsub!(w2a, w2b)

  # [[My Name]]]] to [[My Name]]
  w2a = "[[" + w5 + "]]]]"
  w2b = w5 + "]]"
  data.gsub!(w2a, w2b)

end

ambig_data = File.read("ambiguous_list.txt")
ambig_data.each_line do |csv_row|
	fields = csv_row.chomp.split(CSV_DELIMITER).map(&:strip)
  from = fields[0]
  to = fields[1]

  w1 = "[[" + from + "]]"
  w2 = "[[" + to + "|" + from + "]]"
  # My name,My name (bridge) to [[My name (bridge)|My name]]
  data.gsub!(w1, w2)
end

file_name = "output.txt"
File.open(file_name, "w") do |fd|
  fd.puts data
end
