## Resubmission notes

This is a resubmission of vitopack 0.1.0 (now bumped to 0.1.1) addressing
the two items raised by Benjamin Altmann in the CRAN review e-mail of
2026-05-04:

1. **Reference to the methods.** Added a reference to the chain-ladder
   methodology in the `Description` field of `DESCRIPTION`:
   `Mack (1993) <doi:10.2143/AST.23.2.2005092>`.
2. **`if (interactive())` in examples.** Replaced
   `if (interactive()) plot_color_bars(12)` with the plain
   `plot_color_bars(12)` example in `man/plot_color_bars.Rd`. The function
   produces a base-graphics plot and works correctly in non-interactive
   sessions; the wrapper was unnecessary.

No other changes were made.

## Test environments

* local Windows 11, R 4.4.3 -- 0 errors | 0 warnings | 1 note (New submission)
* GitHub Actions:
  - macOS-latest (R-release)         -- 0/0/0
  - windows-latest (R-release)       -- 0/0/0
  - ubuntu-latest (R-devel)          -- 0/0/0
  - ubuntu-latest (R-release)        -- 0/0/0
  - ubuntu-latest (R-oldrel-1)       -- 0/0/0
* win-builder (R-devel) on initial 0.1.0 -- 1 NOTE (New submission)
* Pre-test for 0.1.0 on CRAN auto-checks (Windows + Debian) -- 1 NOTE each
  (New submission). The code-level checks were unchanged in 0.1.1.

## R CMD check results

0 errors | 0 warnings | 1 note

The only NOTE is `New submission`, which is expected for an initial CRAN
release.

## Reverse dependencies

This is still effectively a new submission (0.1.0 was not yet on CRAN), so
there are no reverse dependencies.

## Notes for CRAN reviewers

* All 32 exported functions are documented and unit-tested via
  `testthat` (78 tests, all passing on every CI platform listed above).
* `load_xlsb_sheets()` provides optional support for `.xlsb` workbooks
  via the `readxlsb` package. Because `readxlsb` was archived from CRAN
  in September 2024, it is **not** declared in `Suggests` -- the function
  resolves it dynamically and errors out cleanly with installation
  guidance if the user has not installed it manually from GitHub.
* Examples that depend on optional packages (`plotly`, `readxl`,
  `readxlsb`) are wrapped in `\dontrun{}` and the functions check for
  those packages with `requireNamespace()` before using them.
* No external services or files are accessed during examples or tests.
* The package wraps internal Com-PASS Advisory s.r.o. tooling for
  non-life actuarial work (chain-ladder triangles, exposure column
  construction, Czech birth-number parsing, plot palettes).
