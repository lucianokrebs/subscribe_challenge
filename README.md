# Sales Tax Calculator

A command-line application that calculates sales tax and generates receipts for shopping baskets.

## Requirements

- Ruby 4.0.2
- Bundler

## Setup

```bash
bundle install
```

## Usage

Pass a basket file as an argument:

```bash
ruby main.rb input/basket1.txt
```

Or pipe input via STDIN:

```bash
echo "2 book at 12.49" | ruby main.rb
```

Multiple baskets can be provided in a single file, separated by blank lines:

```bash
ruby main.rb input/all_baskets.txt
```

## Running Tests

```bash
bundle exec rspec
```

## Design Overview

The application is organized into four classes under the `SalesTax` module, each with a single
responsibility:

- **Item** -- Immutable value object holding quantity, name, and price. Exposes `imported?` and
  `exempt?` predicates for tax classification.
- **TaxCalculator** -- Computes the per-unit tax for an item based on the applicable rates and
  the rounding rule.
- **InputParser** -- Parses raw text lines (e.g., `"2 book at 12.49"`) into `Item` objects.
- **Receipt** -- Receives items and a `TaxCalculator` via composition, formats the receipt output
  with line totals, sales taxes, and grand total.

`main.rb` is a thin entry point that wires the four classes together.

## Tax Rules

| Rule | Rate | Applies to | Exemptions |
|------|------|-----------|------------|
| Basic sales tax | 10% | All goods | Books, food, medical products |
| Import duty | 5% | All imported goods | None |

**Rounding**: `(price * rate * 20).ceil / 20.0` -- rounds the tax up to the nearest 0.05.

## Assumptions

- **Combined rounding**: The rounding rule is applied once to the combined tax rate per item,
  not separately per tax type. Both approaches produce identical results for all provided test
  data. The combined approach was chosen for simplicity.

  The two approaches can diverge with other prices. For example, an imported non-exempt item
  at 10.15:

  ```
  Combined (15%):  10.15 * 0.15 = 1.5225  → round up → 1.55
  Separate:
    Basic (10%):   10.15 * 0.10 = 1.015   → round up → 1.05
    Import (5%):   10.15 * 0.05 = 0.5075  → round up → 0.55
                                    Total:              1.60
  ```

- **Exempt category detection**: Exemption is determined by keyword matching on item names
  (e.g., "book", "chocolate", "pill"). This is a simplification suitable for the given test
  data -- a production system would use a product catalog or category mapping.
