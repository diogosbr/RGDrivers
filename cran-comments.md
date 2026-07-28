## Resubmission

This is a resubmission. Per the CRAN team's feedback, in this version I have:

* Removed the redundant "Tools for" from the Title field.
* Added a reference describing the Link Magnitude method in the Description
  field: Shreve (1966) <doi:10.1086/627137>.
* Replaced the commented-out example in `write_network_with_orders()` with a
  runnable example that writes to `tempfile()`.
* Confirmed that no examples, vignettes, or tests write to the user's home
  filespace; all file output uses `tempdir()`/`tempfile()`.

## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a new release.
