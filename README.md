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
