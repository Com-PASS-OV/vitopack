# Load every sheet of a binary Excel `.xlsb` workbook into a named list

Wrapper around the `readxlsb` package. Returns a list whose names are
the sheet names and whose elements are the parsed data frames.

## Usage

``` r
load_xlsb_sheets(path, range = NULL)
```

## Arguments

- path:

  Path to the workbook.

- range:

  Optional cell range passed to `readxlsb::read_xlsb()`.

## Value

A named list of data frames – one entry per sheet.

## Note

`readxlsb` was archived from CRAN in 2024-09-25. To use this function
you have to install it from GitHub manually:
`remotes::install_github("velofrog/readxlsb")`.

## Examples

``` r
if (FALSE) { # \dontrun{
  # Requires: remotes::install_github("velofrog/readxlsb")
  sheets <- load_xlsb_sheets("path/to/file.xlsb")
} # }
```
