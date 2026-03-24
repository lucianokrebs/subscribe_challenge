# frozen_string_literal: true

RSpec.describe SalesTax::TaxCalculator do
  subject(:calculator) { described_class.new }

  def item(name:, price:)
    SalesTax::Item.new(quantity: 1, name: name, price: price)
  end

  describe '#tax_for' do
    context 'when item is exempt and domestic' do
      it 'returns zero tax for books' do
        expect(calculator.tax_for(item(name: 'book', price: 12.49))).to eq(0.0)
      end

      it 'returns zero tax for food' do
        expect(calculator.tax_for(item(name: 'chocolate bar', price: 0.85))).to eq(0.0)
      end

      it 'returns zero tax for medical products' do
        expect(calculator.tax_for(item(name: 'packet of headache pills', price: 9.75))).to eq(0.0)
      end
    end

    context 'when item is non-exempt and domestic' do
      it 'applies 10% basic tax' do
        expect(calculator.tax_for(item(name: 'music CD', price: 14.99))).to eq(1.50)
      end

      it 'applies 10% basic tax on perfume' do
        expect(calculator.tax_for(item(name: 'bottle of perfume', price: 18.99))).to eq(1.90)
      end
    end

    context 'when item is exempt and imported' do
      it 'applies only 5% import duty' do
        expect(calculator.tax_for(item(name: 'imported box of chocolates', price: 10.00))).to eq(0.50)
      end

      it 'rounds up import duty to nearest 0.05' do
        expect(calculator.tax_for(item(name: 'imported box of chocolates', price: 11.25))).to eq(0.60)
      end
    end

    context 'when item is non-exempt and imported' do
      it 'applies both 10% basic tax and 5% import duty' do
        expect(calculator.tax_for(item(name: 'imported bottle of perfume', price: 47.50))).to eq(7.15)
      end

      it 'rounds up combined tax to nearest 0.05' do
        expect(calculator.tax_for(item(name: 'imported bottle of perfume', price: 27.99))).to eq(4.20)
      end
    end
  end
end
