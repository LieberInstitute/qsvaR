# qsvaR 1.13.2

# qsvaR 1.7.0

BUG FIXES

* Fixed the error messages displayed by `getDegTx()`, `k_qsvs()`,`get_qsvs()`, `getPCs()`, `DEqual()` and `qSVA()` to handle different types of situations. 

* Improved unit tests for `getDegTx()`, `k_qsvs()`,`get_qsvs()`, `getPCs()`,`DEqual()` and `qSVA()`.

# qsvaR 1.6.0

BUG FIXES

* `getDegTx()` can handle ENSEMBL IDs as input. 
* `DEqual()` can handle ENSEMBL IDs as input. 
* Improved unit tests for `getDegTx()` and `DEqual()`.

# qsvaR 1.5.3

BUG FIXES

* Fixed the error messages displayed by `k_qsvs()` to handle different types
of situations. We implemented this update with @HediaTnani, @reneegf, and
@lahuuki.

# qsvaR 1.5.2

BUG FIXES

* Fixed a bug in `qSVA()` which was not passing `sig_transcripts` to 
`getDegTx()`. Related to https://github.com/LieberInstitute/qsvaR/issues/29.
* Fixed the documentation to highlight when users should use `set.seed()` to
ensure the reproducibility of their results. Related to
https://github.com/LieberInstitute/qsvaR/issues/28.

# qsvaR 1.5.1

SIGNIFICANT USER-VISIBLE CHANGES

* Hedia Tnani is now the maintainer of qsvaR.

# qsvaR 0.99.0

NEW FEATURES

* This is the initial version of the second iteration of the qSVA framework,
which was initially described by Jaffe et al, PNAS, 2017
<https://doi.org/10.1073/pnas.1617384114>.
