## Test environments

* local Windows 11, R 4.4.3 -- 0 errors | 0 warnings | 2 notes
* GitHub Actions:
  - macOS-latest (R-release)         -- 0/0/0
  - windows-latest (R-release)       -- 0/0/0
  - ubuntu-latest (R-devel)          -- 0/0/0
  - ubuntu-latest (R-release)        -- 0/0/0
  - ubuntu-latest (R-oldrel-1)       -- 0/0/0
* win-builder (R-devel)              -- pending (will update on resubmission if needed)

## R CMD check results

0 errors | 0 warnings | 2 notes

The notes are:

1. `New submission` -- expected for an initial CRAN release.
2. `unable to verify current time` -- a Windows-only artefact of the
   local check (NTP query is blocked); does not appear on the CRAN
   reference machines.

## Reverse dependencies

This is a new submission, so there are no reverse dependencies.

## Notes for CRAN reviewers

* All 32 exported functions are documented and unit-tested via
  `testthat` (78 tests, all passing on every CI platform listed above).
* `load_xlsb_sheets()` provides optional support for `.xlsb` workbooks
  via the `readxlsb` package. Because `readxlsb` was archived from CRAN
  in September 2024, it is **not** declared in `Suggests` -- the function
  resolves it dynamically via `requireNamespace()` and errors out cleanly
  with installation guidance if the user has not installed it manually
  from GitHub. This avoids forcing CRAN to deal with an archived
  dependency while keeping the helper available to users who want it.
* Examples that depend on optional packages (`plotly`, `readxl`,
  `readxlsb`) are wrapped in `\dontrun{}` and the functions check for
  those packages with `requireNamespace()` before using them.
* No external services or files are accessed during examples or tests.
* The package wraps internal Com-PASS Advisory s.r.o. tooling for
  non-life actuarial work (chain-ladder triangles, exposure column
  construction, Czech birth-number parsing, plot palettes).
