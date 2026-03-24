# frozen_string_literal: true

module SalesTax
  class TaxCalculator
    BASIC_TAX_RATE = 0.10
    IMPORT_DUTY_RATE = 0.05

    def tax_for(item)
      rate = applicable_rate(item)
      round_tax(item.price * rate)
    end

    private

    def applicable_rate(item)
      rate = 0.0
      rate += BASIC_TAX_RATE unless item.exempt?
      rate += IMPORT_DUTY_RATE if item.imported?
      rate
    end

    # Rounds up to the nearest 0.05
    def round_tax(amount)
      (amount * 20).ceil / 20.0
    end
  end
end
