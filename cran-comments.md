## Test environments
* local R installation, R 4.4.1
* ubuntu 22.04 (on R-hub), R-devel
* windows (on R-hub), R-devel
* macos (on R-hub), R-devel

## Resubmission
> Please use only undirected quotation marks in the description text.
> e.g. `python` --> 'python'
> Also, they are probably not needed as only pacakge and software names
> should be wrapped in single quotes.

Fixed it.

> \dontrun{} should only be used if the example really cannot be executed
> (e.g. because of missing additional software, missing API keys, ...) by
> the user. That's why wrapping examples in \dontrun{} adds the comment
> ("# Not run:") as a warning for the user. Does not seem necessary.
> Please replace \dontrun with \donttest.
> Please unwrap the examples if they are executable in < 5 sec, or replace
> dontrun{} with \donttest{}.
> Please put functions which download data in \donttest{}.

The functions test takes more than 5 seconds in a virtual environment (rhub), so it is marked as do not run.
One function requires a specific file (DESCRIPTION file) to exist in the specified directory for execution and is basically a do not run because it cannot be executed.

> Please note that your functions should not write by default or in your
> examples/vignettes/tests in the user's home filespace (including the
> package directory and getwd()). This is not allowed by CRAN policies.
> Please omit any default path in writing functions. In your
> examples/vignettes/tests you can write to tempdir().

Fixed it. The function no longer specifies a default path.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

* The following words are suspected to be misspelled, but they are not.

```
Possibly misspelled words in DESCRIPTION:
  README (3:16, 7:23)
  md (7:30)
```
