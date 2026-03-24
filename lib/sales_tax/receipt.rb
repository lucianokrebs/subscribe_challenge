# frozen_string_literal: true

module SalesTax
  class Receipt
    def initialize(items:, tax_calculator: TaxCalculator.new)
      @items = items
      @tax_calculator = tax_calculator
    end

    def to_s
      lines = @items.map { |item| format_line(item) }
      lines << "Sales Taxes: #{format_price(total_taxes)}"
      lines << "Total: #{format_price(total)}"
      lines.join("\n")
    end

    private

    def tax_for(item)
      @tax_calculator.tax_for(item)
    end

    def line_total(item)
      (item.price + tax_for(item)) * item.quantity
    end

    def total_taxes
      @items.sum { |item| tax_for(item) * item.quantity }
    end

    def total
      @items.sum { |item| line_total(item) }
    end

    def format_line(item)
      "#{item.quantity} #{item.name}: #{format_price(line_total(item))}"
    end

    def format_price(amount)
      format('%.2f', amount)
    end
  end
end
