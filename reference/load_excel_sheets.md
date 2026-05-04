# Load every sheet of an Excel `.xlsx` workbook into a named list

Wrapper around
[`readxl::excel_sheets()`](https://readxl.tidyverse.org/reference/excel_sheets.html)
and
[`readxl::read_xlsx()`](https://readxl.tidyverse.org/reference/read_excel.html).
Returns a list whose names are the sheet names and whose elements are
the parsed tibbles.

## Usage

``` r
load_excel_sheets(path, range = NULL)
```

## Arguments

- path:

  Path to the workbook.

- range:

  Optional cell range passed to
  [`readxl::read_xlsx()`](https://readxl.tidyverse.org/reference/read_excel.html)
  (e.g. `"A1:D20"`).

## Value

A named list of data frames – one entry per sheet.

## Examples

``` r
if (FALSE) { # \dontrun{
  sheets <- load_excel_sheets("path/to/file.xlsx")
  sheets <- load_excel_sheets("path/to/file.xlsx", range = "A1:F100")
} # }
```
