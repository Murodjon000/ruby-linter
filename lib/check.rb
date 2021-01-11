require 'colorize'
require 'strscan'
require_relative './file_reader.rb'

class CheckError
    attr_reader :checker, :errors

    def initialize(file_path)
        @checker=FileReader.new(file_path)
        @errors=[]
        @keywords=%w[begin case class def do if module unless]
    end

    def check_trailing_spaces
        @checker.file_lines.each_with_index do |val,idx|
            if val[-2] == ' ' && !val.strip.empty?
                @errors << "line:#{idx + 1}:#{val.size-1}: Error: Trailing whitespace detected. "
                + " '#{val.gsub(/\s*$/, '_')}' "
            end
        end
    end

    def tag_error
        check_tag_error(/\(/, /\)/, '(', ')', 'Parenthesis')
        check_tag_error(/\[/, /\]/, '[', ']', 'Square Bracket')
        check_tag_error(/\{/, /\}/, '{', '}', 'Curly Bracket')
    end

    def end_error
        key_count=0
        end_count=0
        @checker.file_lines.each_with_index  do |val,idx|
            key_count+=1 if @keywords.include?(val.split(' ').first) || val.split(' ').include?('do')
            end_count+=1 if val.strip == 'end'
        end

        status=key_count <=> end_count
        log_error("Lint/Syntax:Missing 'end'") if status.eql?(1)
        log_error("Lint/Syntax:Unexpected 'end'") if status.eql?(-1)
    end

end