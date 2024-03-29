# Filter out lowly expressed transcripts and test if the number of rows in getDegTx output matches expected transcript count
rse_tx_low <- covComb_tx_deg[rowMeans(assays(covComb_tx_deg)$tpm) < 1, ]
test_that("length for number of rows is the same a length sig_transcripts", {
    expect_equal(length(rownames(getDegTx(covComb_tx_deg))), length(select_transcripts("cell_component")))
})

# Test if number of columns in getDegTx output matches number of columns in original dataset
test_that("length for number of columns is the same a length sig_transcripts", {
    expect_equal(length(colnames(getDegTx(covComb_tx_deg))), length(colnames(covComb_tx_deg)))
})

# Test if getDegTx returns an object of the same class as its input
test_that("output is an RSE", {
    expect_equal(class(getDegTx(covComb_tx_deg)), class(covComb_tx_deg))
})

# Test for a warning when getDegTx is used on a dataset with lowly expressed transcripts
test_that("test warning output for lowly expressed transcripts", {
    expect_warning(getDegTx(rse_tx_low), "The transcripts selected are lowly expressed in your dataset. This can impact downstream analysis.")
})

# Test for rownames starting with "ENST"
test_that("getDegTx correctly processes covComb_tx_deg", {
  # If covComb_tx_deg is correctly structured and all rownames start with "ENST", expect no error
  expect_silent(getDegTx(covComb_tx_deg))
})

# Test where at least one sig_transcript is in covComb_tx_deg rownames
test_that("At least one sig_transcript is in covComb_tx_deg rownames", {
  sig_transcripts <- select_transcripts("cell_component")
  expect_silent({
    # Check if any of the sig_transcripts are in covComb_tx_deg rownames
    getDegTx(covComb_tx_deg, sig_transcripts = sig_transcripts)
  })
})

# Test whether getDegTx gives the same results with original and altered row names
test_that("getDegTx works with original and altered row names", {
  set.seed(123)
  # Apply getDegTx to covComb_tx_deg
  original_results <- getDegTx(covComb_tx_deg,sig_transcripts =select_transcripts("cell_component"))
  
  # Alter the row names of covComb_tx_deg and apply getDegTx
  altered_covComb_tx_deg <- covComb_tx_deg
  rownames(altered_covComb_tx_deg) <- gsub("\\..*", "", rownames(covComb_tx_deg))
  altered_results <- getDegTx(altered_covComb_tx_deg,sig_transcripts =select_transcripts("cell_component"))
  rownames(altered_results) <- rownames(original_results)
  # Test if two objects identical
  expect_identical(original_results, altered_results)
})

# Test for assayname not in assayNames
test_that("getDegTx throws an error when assayname is not in assayNames", {
  expect_error(getDegTx(covComb_tx_deg, assayname = "not_in_assayNames"), "'not_in_assayNames' is not in assayNames\\(rse_tx\\).")
})

# Test for input is an rse object
test_that("getDegTx throws an error when input is not a RangedSummarizedExperiment object", {
  qsv <- list(x = matrix(seq_len(9), ncol = 3))
  expect_error(getDegTx(qsv, assayname = "tpm"), "'rse_tx' must be a RangedSummarizedExperiment object.")
})

