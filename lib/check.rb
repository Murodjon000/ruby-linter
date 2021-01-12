require 'colorize'
require 'strscan'
require_relative './file_reader'

class CheckError
  attr_reader :checker, :errors

  def initialize(file_path)
    @checker = FileReader.new(file_path)
    @errors = []
    @keywords = %w[begin case class def do if module unless]
  end

  def check_trailing_spaces
    @checker.file_lines.each_with_index do |val, index|
      if val[-2] == ' ' && !val.strip.empty?
        @errors << "line:#{index + 1}:#{val.size - 1}: Error: Trailing whitespace detected."
      end
    end
  end

  def tag_error
    check_tag_error(/\(/, /\)/, '(', ')', 'Parenthesis')
    check_tag_error(/\[/, /\]/, '[', ']', 'Square Bracket')
    check_tag_error(/\{/, /\}/, '{', '}', 'Curly Bracket')
  end

  def end_error
    keyw_count = 0
    end_count = 0
    @checker.file_lines.each do |val|
      keyw_count += 1 if @keywords.include?(val.split(' ').first) || val.split(' ').include?('do')
      end_count += 1 if val.strip == 'end'
    end

    status = keyw_count <=> end_count
    log_error("Lint/Syntax: Missing 'end'") if status.eql?(1)
    log_error("Lint/Syntax: Unexpected 'end'") if status.eql?(-1)
  end

  def empty_line_error
    @checker.file_lines.each_with_index do |val, idx|
      check_class_empty_line(val, idx)
      check_def_empty_line(val, idx)
      check_end_empty_line(val, idx)
      check_do_empty_line(val, idx)
    end
  end

  # rubocop:disable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity

  def check_indentation
    mesg = 'IndentationWidth: Use 2 spaces for indentation.'
    cur_val = 0
    indent_val = 0

    @checker.file_lines.each_with_index do |val, idx|
      strip_line = val.strip.split(' ')
      exp_val = cur_val * 2
      res_word = %w[class def if elsif until module unless begin case]

      next unless !val.strip.empty? || !strip_line.first.eql?('#')

      indent_val += 1 if res_word.include?(strip_line.first) || strip_line.include?('do')
      indent_val -= 1 if val.strip == 'end'

      next if val.strip.empty?

      indent_error(val, idx, exp_val, mesg)
      cur_val = indent_val
    end
  end

  private

  def indent_error(val, idx, exp_val, mesg)
    strip_line = val.strip.split(' ')
    emp = val.match(/^\s*\s*/)
    end_chk = emp[0].size.eql?(exp_val.zero? ? 0 : exp_val - 2)

    if val.strip.eql?('end') || strip_line.first == 'elsif' || strip_line.first == 'when'
      log_error("line:#{idx + 1} #{mesg}") unless end_chk
    elsif !emp[0].size.eql?(exp_val)
      log_error("line:#{idx + 1} #{mesg}")
    end
  end

  # rubocop:enable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity

  def check_tag_error(*args)
    @checker.file_lines.each_with_index do |val, index|
      open_p = []
      close_p = []
      open_p << val.scan(args[0])
      close_p << val.scan(args[1])

      status = open_p.flatten.size <=> close_p.flatten.size

      log_error("line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[3]}' #{args[4]}") if status.eql?(1)
      log_error("line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[2]}' #{args[4]}") if status.eql?(-1)
    end
  end

  def check_class_empty_line(val, idx)
    mesg = 'Extra empty line detected at class body beginning'
    return unless val.strip.split(' ').first.eql?('class')

    log_error("line:#{idx + 2} #{mesg}") if @checker.file_lines[idx + 1].strip.empty?
  end

  def check_def_empty_line(val, idx)
    mesg1 = 'Extra empty line detected at method body beginning'
    mesg2 = 'Use empty lines between method definition'

    return unless val.strip.split(' ').first.eql?('def')

    log_error("line:#{idx + 2} #{mesg1}") if @checker.file_lines[idx + 1].strip.empty?
    log_error("line:#{idx + 1} #{mesg2}") if @checker.file_lines[idx - 1].strip.split(' ').first.eql?('end')
  end

  def check_end_empty_line(val, idx)
    mesg = 'Extra empty line detected at block body end'
    return unless val.strip.split(' ').first.eql?('end')

    log_error("line:#{idx} #{mesg}") if @checker.file_lines[idx - 1].strip.empty?
  end

  def check_do_empty_line(val, idx)
    mesg = 'Extra empty line detected at block body beginning'
    return unless val.strip.split(' ').include?('do')

    log_error("line:#{idx + 2} #{mesg}") if @checker.file_lines[idx + 1].strip.empty?
  end

  def log_error(error_mesg)
    @errors << error_mesg
  end
end
