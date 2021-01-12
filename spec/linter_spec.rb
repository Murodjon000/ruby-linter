require_relative '../lib/check.rb'
require 'rspec'

describe CheckError do 
    let(:checker) {CheckError.new('app.rb')}

    describe '#check_trailing_spaces' do 
        it 'should return trailing space error' do 
            checker.check_trailing_spaces
            expect(checker.errors[0]).to eql('line:3:22: Error: Trailing whitespace detected.')
        end
    end

    describe '#check_indentation' do 
        it 'should return indentation errors' do 
            checker.check_indentation
            expect(checker.errors[0]).to eql('line:4 IndentationWidth: Use 2 spaces for indentation.')
        end
    end

    describe '#tag_error' do 
        it 'should return tag errors' do 
            checker.tag_error
            expect(checker.errors[0]).to eql("line:3 Lint/Syntax: Unexpected/Missing token ']' Square Bracket")
        end
    end

    describe '#check_end_empty_line' do 
        it 'should return end errors' do 
            checker.empty_line_error
            expect(checker.errors[0]).to eql("line:11 Extra empty line detected at block body end")
        end
    end

    describe '#end_error' do 
        it 'should return end errors' do 
            checker.end_error
            expect(checker.errors[0]).to eql("Lint/Syntax: Missing 'end'")
        end
    end

    describe '#empty_line_error' do 
        it 'should return empty line errors' do 
            checker.empty_line_error
            expect(checker.errors[0]).to eql('line:11 Extra empty line detected at block body end')
        end
    end
end