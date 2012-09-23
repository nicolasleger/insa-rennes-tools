# encoding: utf-8

# Usage `ruby parse_INSA_Rennes_directory [HTML_SOURCE_FILE=parse_INSA_Rennes_directory.html] [OUTPUT_CSV_FILE=parse_INSA_Rennes_directory.csv]`
# where HTML_SOURCE_FILE is the page source of the official student directory page.

require 'htmlentities'
coder = HTMLEntities.new

input_file = ARGV[0] || "#{File.basename(__FILE__, '.rb')}.html"
file = File.open(input_file, 'r+')
html = file.read

students_data = html.scan /<b> (?<lastname>.+?)&nbsp;(?<firstname>.+?)&nbsp;&nbsp;<\/b>.+?>(?<email>[^>]+@insa-rennes\.fr)<br>\s*(?<formation>.+?)\r?\n/m

students = []
students_data.each do |student|

=begin
  student = {
    lastname: student[0],
    firstname: student[1],
    email: student[2].downcase!,
    formation: student[3],
  }
=end

  student[2].downcase! # Makes the email address downcase
  student = student.map { |value| value = coder.decode(value) }

  students << student
end

output = (students.map { |student| student.join(',') }).join("\n") # CSV
puts output

puts "#{students.size} student(s) imported"

ouput_file = ARGV[1] || "#{File.basename(__FILE__, '.rb')}.csv"
File.open(ouput_file, 'w') do |f|
  f.write output
end
