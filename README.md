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

## Running Tests

```bash
bundle exec rspec
```

## Assumptions

- The rounding rule ("round up to the nearest 0.05") is applied once to the combined tax rate
  per item, not separately per tax type. Both approaches produce identical results for all
  provided test data. The combined approach was chosen for simplicity.

  The two approaches can diverge with other prices. For example, an imported non-exempt item
  at 10.15:

  ```
  Combined (15%):  10.15 * 0.15 = 1.5225  → round up → 1.55
  Separate:
    Basic (10%):   10.15 * 0.10 = 1.015   → round up → 1.05
    Import (5%):   10.15 * 0.05 = 0.5075  → round up → 0.55
                                    Total:              1.60
  ```
