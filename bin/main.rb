#!/usr/bin/env ruby
require_relative '../lib/check'

check = CheckError.new('../app.rb')
check.check_indentation
check.check_trailing_spaces
check.tag_error
check.end_error
check.empty_line_error

if check.errors.empty? && check.checker.error_msg.empty?
  mesg = 'No offenses'.colorize(:green)
  puts mesg.concat('detected')
else
  check.errors.uniq.each do |er|
    puts "#{check.checker.file_path.colorize(:green)} : #{er.colorize(:red)}"
  end
end

puts check.checker.error_msg if check.checker.file_lines.empty?
