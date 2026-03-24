# frozen_string_literal: true

RSpec.describe SalesTax::InputParser do
  subject(:parser) { described_class.new }

  describe '#parse' do
    it 'parses a single line into an Item' do
      items = parser.parse('1 music CD at 14.99')

      expect(items.length).to eq(1)
      expect(items.first.quantity).to eq(1)
      expect(items.first.name).to eq('music CD')
      expect(items.first.price).to eq(14.99)
    end

    it 'parses multiple lines into Items' do
      input = <<~INPUT
        2 book at 12.49
        1 music CD at 14.99
        1 chocolate bar at 0.85
      INPUT

      items = parser.parse(input)

      expect(items.length).to eq(3)
      expect(items[0].name).to eq('book')
      expect(items[1].name).to eq('music CD')
      expect(items[2].name).to eq('chocolate bar')
    end

    it 'handles names with multiple words' do
      items = parser.parse('1 imported bottle of perfume at 47.50')

      expect(items.first.name).to eq('imported bottle of perfume')
    end

    it 'parses quantity greater than 1' do
      items = parser.parse('3 imported boxes of chocolates at 11.25')

      expect(items.first.quantity).to eq(3)
      expect(items.first.name).to eq('imported boxes of chocolates')
      expect(items.first.price).to eq(11.25)
    end

    it 'ignores blank lines' do
      input = "1 book at 12.49\n\n1 music CD at 14.99\n"

      items = parser.parse(input)

      expect(items.length).to eq(2)
    end

    it 'raises an error for invalid input' do
      expect { parser.parse('not a valid line') }
        .to raise_error(ArgumentError, /Invalid input format/)
    end
  end
end
