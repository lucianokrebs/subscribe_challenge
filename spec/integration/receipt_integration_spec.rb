# frozen_string_literal: true

RSpec.describe 'Receipt integration' do
  let(:parser) { SalesTax::InputParser.new }
  let(:tax_calculator) { SalesTax::TaxCalculator.new }

  def receipt_for(input)
    items = parser.parse(input)
    SalesTax::Receipt.new(items: items, tax_calculator: tax_calculator).to_s
  end

  it 'produces correct output for basket 1' do
    input = <<~INPUT
      2 book at 12.49
      1 music CD at 14.99
      1 chocolate bar at 0.85
    INPUT

    expect(receipt_for(input)).to eq(
      "2 book: 24.98\n" \
      "1 music CD: 16.49\n" \
      "1 chocolate bar: 0.85\n" \
      "Sales Taxes: 1.50\n" \
      "Total: 42.32"
    )
  end

  it 'produces correct output for basket 2' do
    input = <<~INPUT
      1 imported box of chocolates at 10.00
      1 imported bottle of perfume at 47.50
    INPUT

    expect(receipt_for(input)).to eq(
      "1 imported box of chocolates: 10.50\n" \
      "1 imported bottle of perfume: 54.65\n" \
      "Sales Taxes: 7.65\n" \
      "Total: 65.15"
    )
  end

  it 'produces correct output for basket 3' do
    input = <<~INPUT
      1 imported bottle of perfume at 27.99
      1 bottle of perfume at 18.99
      1 packet of headache pills at 9.75
      3 imported boxes of chocolates at 11.25
    INPUT

    expect(receipt_for(input)).to eq(
      "1 imported bottle of perfume: 32.19\n" \
      "1 bottle of perfume: 20.89\n" \
      "1 packet of headache pills: 9.75\n" \
      "3 imported boxes of chocolates: 35.55\n" \
      "Sales Taxes: 7.90\n" \
      "Total: 98.38"
    )
  end
end
