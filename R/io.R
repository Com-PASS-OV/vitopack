#' Load every sheet of an Excel `.xlsx` workbook into a named list
#'
#' Wrapper around [readxl::excel_sheets()] and [readxl::read_xlsx()]. Returns
#' a list whose names are the sheet names and whose elements are the parsed
#' tibbles.
#'
#' @param path Path to the workbook.
#' @param range Optional cell range passed to [readxl::read_xlsx()] (e.g.
#'   `"A1:D20"`).
#'
#' @return A named list of data frames — one entry per sheet.
#' @export
#'
#' @examples
#' \dontrun{
#'   sheets <- load_excel_sheets("path/to/file.xlsx")
#'   sheets <- load_excel_sheets("path/to/file.xlsx", range = "A1:F100")
#' }
load_excel_sheets <- function(path, range = NULL) {
  if (!requireNamespace("readxl", quietly = TRUE)) {
    stop("Package 'readxl' is required for load_excel_sheets(). ",
         "Install it with install.packages(\"readxl\").",
         call. = FALSE)
  }
  sheets_name <- readxl::excel_sheets(path = path)
  df <- list()
  for (segmented_variable in sheets_name) {
    df[[segmented_variable]] <- readxl::read_xlsx(
      path  = path,
      sheet = segmented_variable,
      range = range
    )
  }
  return(df)
}


#' Load every sheet of a binary Excel `.xlsb` workbook into a named list
#'
#' Wrapper around the `readxlsb` package. Returns a list whose names are the
#' sheet names and whose elements are the parsed data frames.
#'
#' @param path Path to the workbook.
#' @param range Optional cell range passed to `readxlsb::read_xlsb()`.
#'
#' @return A named list of data frames — one entry per sheet.
#' @export
#'
#' @examples
#' \dontrun{
#'   sheets <- load_xlsb_sheets("path/to/file.xlsb")
#' }
load_xlsb_sheets <- function(path, range = NULL) {
  if (!requireNamespace("readxlsb", quietly = TRUE)) {
    stop("Package 'readxlsb' is required for load_xlsb_sheets(). ",
         "Install it with install.packages(\"readxlsb\").",
         call. = FALSE)
  }
  # readxlsb does not export a sheet-listing helper, so we parse sheet
  # names ourselves from xl/workbook.xml (.xlsb is a ZIP container).
  td <- tempfile("vitopack_xlsb_")
  dir.create(td)
  on.exit(unlink(td, recursive = TRUE), add = TRUE)

  utils::unzip(path, files = "xl/workbook.xml", exdir = td)
  wb_path <- file.path(td, "xl", "workbook.xml")
  if (!file.exists(wb_path)) {
    stop("Could not extract 'xl/workbook.xml' from ", path,
         "; is it a valid .xlsb workbook?", call. = FALSE)
  }
  wb_xml <- paste(readLines(wb_path, warn = FALSE, encoding = "UTF-8"),
                  collapse = " ")
  matches <- regmatches(wb_xml,
                        gregexpr('<sheet [^>]*name="[^"]+"', wb_xml))[[1]]
  sheets_name <- sub('.*name="([^"]+)".*', "\\1", matches)
  if (!length(sheets_name)) {
    stop("No sheets found in ", path, ".", call. = FALSE)
  }

  df <- list()
  for (segmented_variable in sheets_name) {
    df[[segmented_variable]] <- readxlsb::read_xlsb(
      path  = path,
      sheet = segmented_variable,
      range = range
    )
  }
  return(df)
}


#' Format a number with a thin space as the thousands separator
#'
#' Convenience wrapper around [base::format()] with sensible Czech-friendly
#' defaults (thin space as group separator, `.` as decimal mark, no
#' scientific notation).
#'
#' @param number Numeric vector.
#'
#' @return A character vector of formatted numbers.
#' @export
#'
#' @examples
#' numeric_format(c(1234567, 89.5))
numeric_format <- function(number) {
  format(number, big.mark = " ", decimal.mark = ".", scientific = FALSE)
}
