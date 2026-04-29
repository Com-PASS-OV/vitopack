## Resubmission notes

This is a new submission.

## Test environments

* local Windows install, R 4.4.x
* GitHub Actions:
  - macOS-latest (release)
  - windows-latest (release)
  - ubuntu-latest (devel, release, oldrel-1)
* `devtools::check_win_devel()`
* `rhub::rhub_check()` — linux, windows, macos

## R CMD check results

0 errors | 0 warnings | 0 notes

(Re-run `devtools::check(remote = TRUE, manual = TRUE)` locally and paste
the actual output here before submitting.)

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

## Notes for CRAN reviewers

* The package wraps internal Com-PASS Advisory tooling. All exported
  functions are documented and tested via `testthat`.
* Some examples that depend on optional packages (`plotly`, `readxlsb`,
  `readxl`) are wrapped in `\dontrun{}` and the functions check for those
  packages with `requireNamespace()` before use.
* No external services or files are accessed during examples or tests.
