#' Obtain expression matrix for degraded transcripts
#'
#' This function is used to obtain a [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#'  of transcripts and their expression values #' These transcripts are selected based on a prior study of RNA degradation in
#'   postmortem brain tissues. This object can later be used to obtain the principle components
#' necessary to remove the effect of degradation in differential expression.
#'
#' @param rse_tx A [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#' object containing the transcript data desired to be studied.
#' @param type A `character(1)` specifying the transcripts set type.
#' These were determined by Joshua M. Stolz et al, 2022. Here the names "cell_component", "top1500",
#' and "standard" refer to models that were determined to be effective in removing degradation effects.
#' The "standard" model involves taking the union of the top 1000 transcripts
#' associated with degradation from the interaction model and the main effect model.
#' The "top1500" model is the same as the "standard model except the
#' union of the top 1500 genes associated with degradation is selected.
#' The most effective of our models, "cell_component", involved deconvolution of
#' the degradation matrix to determine the proportion of cell types within our studied tissue.
#' These proportions were then added to our `model.matrix()` and the union of the top 1000 transcripts in the interaction model,
#' the main effect model, and the cell proportions model were used to generate this model of qSVs.
#'
#' @param assayname character string specifying the name of the assay desired in rse_tx
#' @param sig_transcripts A list of transcripts determined to have degradation signal in the qsva expanded paper.
#'
#' @return A
#'  [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#'  object.
#'
#' @export
#' @importFrom methods is
#' @import rlang
#'
#' @examples
#' getDegTx(covComb_tx_deg)
#' stopifnot(mean(rowMeans(assays(covComb_tx_deg)$tpm)) > 1)
getDegTx <- function(rse_tx, type = c("cell_component", "standard", "top1500"), sig_transcripts = select_transcripts(type), assayname = "tpm") {
  
  type = arg_match(type)
  
  # Validate rse_tx is a RangedSummarizedExperiment object
  if (!is(rse_tx, "RangedSummarizedExperiment")) {
    stop("'rse_tx' must be a RangedSummarizedExperiment object.", call. = FALSE)
  }
  
  # Check if assayname is in assayNames
  if (!assayname %in% assayNames(rse_tx)) {
    stop(sprintf("'%s' is not in assayNames(rse_tx).", assayname), call. = FALSE)
  }
  
  # Check for validity and matching of tx names
  sig_transcripts = check_tx_names(rownames(rse_tx), sig_transcripts, 'rownames(rse_tx)', 'sig_transcripts')
  
  # Subset rse_tx to include sig_transcripts
  rse_tx <- rse_tx[rownames(rse_tx) %in% sig_transcripts, , drop = FALSE]
  
  # Check if the row means is greater than 1
  if (mean(rowMeans(assays(rse_tx)[[assayname]])) < 1) {
    warning("The transcripts selected are lowly expressed in your dataset. This can impact downstream analysis.")
    }
  return(rse_tx)
}
