# Print colored text to the console (rainbow cycle)

Prints `print_text` to the console wrapped in an ANSI color code chosen
by `color_num`. The color index cycles modulo 8 so any positive integer
is valid.

## Usage

``` r
rainbow_cat(print_text, color_num)
```

## Arguments

- print_text:

  Character – the text to print.

- color_num:

  Integer – color index (cycled modulo 8).

## Value

Invisible `NULL`. Called for the side effect of printing.

## Examples

``` r
rainbow_cat("Hello in green", 3)
#>  Hello in green 
```
