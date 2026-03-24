# frozen_string_literal: true

module SalesTax
  class Item
    attr_reader :quantity, :name, :price

    EXEMPT_KEYWORDS = %w[book chocolate pill food].freeze

    def initialize(quantity:, name:, price:)
      @quantity = quantity
      @name = name.freeze
      @price = price
      freeze
    end

    def imported?
      name.include?('imported')
    end

    def exempt?
      EXEMPT_KEYWORDS.any? { |keyword| name.downcase.include?(keyword) }
    end
  end
end
