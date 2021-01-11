#!/usr/bin/env ruby
require_relative '../lib/check.rb'

check=CheckError.new(ARGV.first)
check.check_trailing_spaces

if check.errors.empty? && check.checker.error_msg.empty?
    puts 'No offenses'.colorize(:green) + ' detected'
else
    check.errors.uniq.each do |er|
        puts "#{check.checker.file_path.colorize(:blue)} : #{er.colorize(:red)}"
    end
end

puts check.checker.error_msg if check.checker.file_lines.empty?