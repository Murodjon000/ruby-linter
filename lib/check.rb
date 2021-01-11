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

    def check_indentation
        mesg='IndentationWidth: Use 2 spaces for indentation.'
        val=0
        indent_val=0

        @checker.file_lines.each_with_index do |val,idx|
            strip_line=val.strip.split(' ')
            exp_val=val * 2
            res_word=%w[class def if elsif until module unless begin case]
            
            next unless !val.strip.empty? || !val.first.eql?('#')

            indent_val+=1 if res_word.include?(strip_line.first) || strip_line.include?('do')
            indent_val-=1 if val.strip == 'end'

            next if val.strip.empty?

            indent_error(val,idx,exp_val,mesg)
            val=indent_val
        end
    end

    private

    def indent_error(val,idx,exp_val,mesg)
        strip_line=val.strip.split(' ')
        emp=val.match(/^\s*\s*/)
        end_check=emp[0].size.eql?(exp_val.zero ? 0 : exp_val-2)

        if val.strip.eql?('end') || val.strip.eql?('elsif') || val.strip.eql?('when')
            log_error("line:#{idx+1} #{mesg}") unless end_check
        elsif !emp[0].size.eql?(exp_val)
            log_error("line:#{idx+1} #{mesg}")

        end
    end

    def log_error(error_msg)
        @errors << error_msg
    end
end