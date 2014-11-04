#!/bin/ruby

# Given a file, remove the headers
#
# Script to grab data from Wikipedia.
# Used it to grab WBF IDs

file_name = ARGV[0]

#puts "F=#{file_name}"
contents = open(file_name, "rb") {|io| io.read }

output_file_name = file_name + ".bridge"

File.open(output_file_name, "w") do |out_file|
  write_line = 0
  contents.each_line do |line|
#    puts "wl=#{write_line} Line = #{line}"
    if (line.include? "==Bridge acco") then
      write_line = 1
    end

    if (line.include? "</textarea><div class='editOptions") then
      write_line = 0
    end

    if (write_line == 1) then
      line.gsub!("&lt;", "<")
    	out_file.write line
    end
  end
end
