require 'colorize'

class FileReader
  attr_reader :error_msg, :file_path, :file_lines, :file_lines_count

  def initialize(file_path)
    @error_msg = ''
    @file_path = file_path
    begin
      @file_lines = File.readlines(@file_path)
      @file_lines_count = @file_lines.size
    rescue StandardError => e
      @file_lines = []
      @error_msg = "Check file name or path one more time\n".colorize(:red) + e.to_s.colorize(:light_red)
    end
  end
end
