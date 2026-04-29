# vitopack — návod od nuly do CRAN

Tento dokument tě provede: 1. instalací nástrojů, 2. vygenerováním
dokumentace a buildu, 3. spuštěním testů a `R CMD check`, 4. publikací
na GitHub a nasazením pkgdown stránky, 5. odesláním balíčku na CRAN.

> **Poznámka:** balíček byl vygenerován mimo R (v Cowork mode). Než ho
> poprvé buildneš, musíš spustit `devtools::document()` — tím roxygen2
> přepíše/dovytvoří `man/*.Rd` z anotací uvnitř `R/*.R`.

------------------------------------------------------------------------

## 1. Předpoklady

V R konzoli (Windows: RGui nebo RStudio):

``` r
install.packages(c("devtools", "roxygen2", "testthat", "knitr",
                   "rmarkdown", "pkgdown", "covr", "usethis", "rhub"))
```

Ujisti se, že máš: - **R 4.1+** (kvůli nativní pipe `|>`). - **Rtools**
(Windows) — <https://cran.r-project.org/bin/windows/Rtools/> -
**MikTeX** nebo **TinyTeX** pro PDF manuál:
`r install.packages("tinytex"); tinytex::install_tinytex()`

## 2. Otevři projekt v RStudiu

V RStudiu: **File → New Project → Existing Directory →**
`Desktop/vitopack/vitopack`

Nebo z konzole:

``` r
setwd("C:/Users/OndřejVít/Desktop/vitopack/vitopack")
```

## 3. Vygeneruj dokumentaci a NAMESPACE

``` r
devtools::document()
```

Tím se z `roxygen2` komentářů v `R/*.R` vytvoří soubory v `man/` a
doplní/aktualizuje `NAMESPACE`.

## 4. Spusť testy

``` r
devtools::test()
```

Pokrytí:

``` r
covr::report()
```

## 5. R CMD check (povinné před CRAN)

``` r
devtools::check()
# nebo s manuálem a externími kontrolami
devtools::check(manual = TRUE, remote = TRUE)
```

Cíl: **0 errors, 0 warnings, 0 notes**.

## 6. PDF manuál (referenční manuál)

Čistý PDF se všemi exportovanými funkcemi:

``` r
devtools::build_manual()
# výstup: ../vitopack_0.1.0.pdf
```

Nebo přes terminál:

``` bash
R CMD Rd2pdf .
```

## 7. Build zdrojového balíčku

``` r
devtools::build()
# výstup: ../vitopack_0.1.0.tar.gz
```

Pro instalaci lokálně:

``` r
devtools::install()
```

## 8. GitHub repozitář a Pages stránka

1.  Vytvoř repo na GitHubu (např. `donvito/vitopack`). Pokud používáš
    jiný název nebo organizaci, **uprav `URL` a `BugReports` v souboru
    `DESCRIPTION` a `_pkgdown.yml`** — momentálně tam je
    `donvito/vitopack`.

2.  Inicializuj Git a pushni:

    ``` bash
    cd C:\Users\OndřejVít\Desktop\vitopack\vitopack
    git init -b main
    git add .
    git commit -m "Initial vitopack 0.1.0"
    git remote add origin https://github.com/donvito/vitopack.git
    git push -u origin main
    ```

3.  V repozitáři otevři **Settings → Pages** a nastav:

    - Source: **Deploy from a branch**
    - Branch: **`gh-pages`** / `(root)`

4.  Po prvním pushi se automaticky spustí GitHub Actions:

    - **R-CMD-check** — multi-OS check.
    - **pkgdown** — vygeneruje a pushne stránku do `gh-pages` větve.
    - **test-coverage** — Codecov report.

    Stránka pak bude na **<https://donvito.github.io/vitopack/>**.

5.  (Volitelné) lokálně si stránku zkus:

    ``` r
    pkgdown::build_site()
    ```

## 9. Pre-CRAN kontroly napříč platformami

``` r
devtools::check_win_devel()       # win-builder (R-devel)
devtools::check_win_release()     # win-builder (R-release)
rhub::rhub_setup()                # první nastavení
rhub::rhub_check()                # check na různých Linux/Win/Mac obrazech
```

Vyřeš všechny WARNING/NOTE než půjdeš dál.

## 10. Odeslání na CRAN

1.  Aktualizuj `cran-comments.md` reálnými výsledky checků.

2.  V `DESCRIPTION` ověř:

    - Title bez koncového `.`,
    - Description ve smysluplných větách,
    - Verze ve formátu `0.1.0`,
    - Maintainer e-mail aktivní (CRAN posílá potvrzovací mail).

3.  Spusť:

    ``` r
    devtools::release()
    ```

    Skript projde checklistem, vygeneruje `tar.gz`, nahraje ho přes
    <https://xmpalantir.wu.ac.at/cransubmit/> a pošle e-mail z tvé
    adresy `ondrej.vit@com-pass.cz` k potvrzení.

4.  CRAN tým odpoví e-mailem (typicky 1–7 dnů). Pokud chce úpravy,
    uprav, zvedni verzi (např. `0.1.1`), zaktualizuj `NEWS.md` a
    `cran-comments.md` a pošli znovu.

## 11. Po přijetí

- Otaguj release na GitHubu:

  ``` bash
  git tag v0.1.0 && git push --tags
  ```

- Vytvoř GitHub release — pkgdown workflow ho zachytí a aktualizuje
  stránku.

- Pro další verzi:

  ``` r
  usethis::use_version("patch")  # 0.1.0 → 0.1.1
  ```

## Časté problémy a opravy

| Symptom při `R CMD check`                   | Oprava                                                                                                          |
|---------------------------------------------|-----------------------------------------------------------------------------------------------------------------|
| `no visible binding for global variable`    | Přidej do `R/vitopack-package.R` do `utils::globalVariables(...)`.                                              |
| `Undocumented arguments in...`              | Doplň `@param` do roxygen komentáře v příslušné `R/*.R`.                                                        |
| `\dontrun{}` examples should not be skipped | Přepiš na `if (interactive())` nebo `\donttest{}`.                                                              |
| `License stub mismatch`                     | `LICENSE` stub musí mít přesně `YEAR:` a `COPYRIGHT HOLDER:` řádky.                                             |
| Encoding warning u CZ znaků                 | DESCRIPTION už má `Encoding: UTF-8` — zkontroluj, že ho má i `RStudio Tools → Project Options → Code → Saving`. |

## Struktura balíčku (rychlý přehled)

    vitopack/
    ├── DESCRIPTION            # metadata
    ├── NAMESPACE              # auto-gen z roxygen
    ├── LICENSE / LICENSE.md   # MIT
    ├── NEWS.md                # changelog
    ├── README.md
    ├── _pkgdown.yml           # konfigurace webu
    ├── cran-comments.md       # pro CRAN reviewer
    ├── R/                     # zdrojový kód s roxygen2 komentáři
    │   ├── vitopack-package.R
    │   ├── columns.R
    │   ├── birth-date.R
    │   ├── colors.R
    │   ├── io.R
    │   ├── triangles.R
    │   └── chain-ladder.R
    ├── man/                   # auto-gen .Rd (regeneruje document())
    ├── tests/testthat/        # testy
    ├── vignettes/             # úvodní článek
    └── .github/workflows/     # CI: R-CMD-check, pkgdown, coverage
