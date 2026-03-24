# frozen_string_literal: true

RSpec.describe SalesTax::Receipt do
  let(:tax_calculator) { SalesTax::TaxCalculator.new }

  def item(quantity:, name:, price:)
    SalesTax::Item.new(quantity: quantity, name: name, price: price)
  end

  describe '#to_s' do
    it 'formats a single exempt item with zero tax' do
      items = [item(quantity: 1, name: 'chocolate bar', price: 0.85)]
      receipt = described_class.new(items: items, tax_calculator: tax_calculator)

      expect(receipt.to_s).to eq(
        "1 chocolate bar: 0.85\n" \
        "Sales Taxes: 0.00\n" \
        "Total: 0.85"
      )
    end

    it 'formats a single taxed item' do
      items = [item(quantity: 1, name: 'music CD', price: 14.99)]
      receipt = described_class.new(items: items, tax_calculator: tax_calculator)

      expect(receipt.to_s).to eq(
        "1 music CD: 16.49\n" \
        "Sales Taxes: 1.50\n" \
        "Total: 16.49"
      )
    end

    it 'multiplies price and tax by quantity' do
      items = [item(quantity: 2, name: 'book', price: 12.49)]
      receipt = described_class.new(items: items, tax_calculator: tax_calculator)

      expect(receipt.to_s).to eq(
        "2 book: 24.98\n" \
        "Sales Taxes: 0.00\n" \
        "Total: 24.98"
      )
    end

    it 'sums taxes and totals across multiple items' do
      items = [
        item(quantity: 1, name: 'imported bottle of perfume', price: 27.99),
        item(quantity: 1, name: 'bottle of perfume', price: 18.99),
        item(quantity: 1, name: 'packet of headache pills', price: 9.75),
        item(quantity: 3, name: 'imported boxes of chocolates', price: 11.25)
      ]
      receipt = described_class.new(items: items, tax_calculator: tax_calculator)

      expect(receipt.to_s).to eq(
        "1 imported bottle of perfume: 32.19\n" \
        "1 bottle of perfume: 20.89\n" \
        "1 packet of headache pills: 9.75\n" \
        "3 imported boxes of chocolates: 35.55\n" \
        "Sales Taxes: 7.90\n" \
        "Total: 98.38"
      )
    end
  end
end
