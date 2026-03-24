# frozen_string_literal: true

require_relative 'lib/sales_tax'

input = ARGF.read
baskets = input.split(/\n\s*\n/)

parser = SalesTax::InputParser.new
tax_calculator = SalesTax::TaxCalculator.new

baskets.each_with_index do |basket_text, index|
  items = parser.parse(basket_text)
  receipt = SalesTax::Receipt.new(items: items, tax_calculator: tax_calculator)

  puts receipt
  puts if index < baskets.length - 1
end
