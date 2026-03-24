# frozen_string_literal: true

module SalesTax
  class InputParser
    LINE_PATTERN = /^(\d+)\s+(.+)\s+at\s+(\d+\.\d{2})$/

    def parse(text)
      text.strip
          .lines
          .map(&:strip)
          .reject(&:empty?)
          .map { |line| parse_line(line) }
    end

    private

    def parse_line(line)
      match = LINE_PATTERN.match(line)
      raise ArgumentError, "Invalid input format: '#{line}'" unless match

      Item.new(
        quantity: match[1].to_i,
        name: match[2],
        price: match[3].to_f
      )
    end
  end
end
