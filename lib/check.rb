require 'colorize'
require 'strscan'
require_relative './file_reader.rb'

class CheckError
    def initialize(file_path)
        @checker=FileReader.new(file_path)
        errors=[]
        @keywords=%w[begin case class def do if module unless]
    end
    
end