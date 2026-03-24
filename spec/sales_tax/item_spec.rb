# frozen_string_literal: true

RSpec.describe SalesTax::Item do
  describe '#imported?' do
    it 'returns true for imported items' do
      item = described_class.new(quantity: 1, name: 'imported bottle of perfume', price: 47.50)
      expect(item.imported?).to be true
    end

    it 'returns false for domestic items' do
      item = described_class.new(quantity: 1, name: 'bottle of perfume', price: 18.99)
      expect(item.imported?).to be false
    end
  end

  describe '#exempt?' do
    it 'returns true for books' do
      item = described_class.new(quantity: 1, name: 'book', price: 12.49)
      expect(item.exempt?).to be true
    end

    it 'returns true for food items' do
      item = described_class.new(quantity: 1, name: 'chocolate bar', price: 0.85)
      expect(item.exempt?).to be true
    end

    it 'returns true for medical products' do
      item = described_class.new(quantity: 1, name: 'packet of headache pills', price: 9.75)
      expect(item.exempt?).to be true
    end

    it 'returns false for non-exempt items' do
      item = described_class.new(quantity: 1, name: 'music CD', price: 14.99)
      expect(item.exempt?).to be false
    end
  end

  context 'when item is both imported and exempt' do
    it 'reports both correctly' do
      item = described_class.new(quantity: 1, name: 'imported box of chocolates', price: 10.00)
      expect(item.imported?).to be true
      expect(item.exempt?).to be true
    end
  end

  describe 'immutability' do
    it 'is frozen after creation' do
      item = described_class.new(quantity: 1, name: 'book', price: 12.49)
      expect(item).to be_frozen
    end
  end
end
