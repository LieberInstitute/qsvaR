#' A wrapper function used to perform qSVA in one step.
#'
#' @param rse_tx A [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class] object containing
#' the transcript data desired to be studied.
#' @param type a character string specifying which model you would
#'  like to use when selecting a degradation matrix.
#' @param sig_transcripts A list of transcripts that are associated with
#' degradation signal. Use `select_transcripts()` to select sets of transcripts
#' identified by the qSVA expanded paper. Specifying a `character()` input of
#' ENSEMBL transcript IDs (or whatever values you have at `rownames(rse_tx)`)
#' obtained outside of `select_transcripts()` overrides
#' the user friendly `type` argument. That is, this argument provides more fine
#' tuning options for advanced users.
#' @param mod Model Matrix with necessary variables the you would
#'  model for in differential expression
#' @param assayname character string specifying the name of
#'  the assay desired in rse_tx
#'
#' @return matrix with k principal components for each sample
#' @export
#'
#' @examples
#' ## First we need to define a statistical model. We'll use the example
#' ## covComb_tx_deg data. Note that the model you'll use in your own data
#' ## might look different from this model.
#' mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN,
#'     data = colData(covComb_tx_deg)
#' )
#'
#' ## To ensure that the results are reproducible, you will need to set a
#' ## random seed with the set.seed() function. Internally, we are using
#' ## sva::num.sv() which needs a random seed to ensure reproducibility of the
#' ## results.
#' set.seed(20230621)
#' qSVA(rse_tx = covComb_tx_deg, type = "cell_component", mod = mod, assayname = "tpm")
#'
qSVA <-
    function(rse_tx,
    type = c("cell_component", "standard", "top1500"),
    sig_transcripts = select_transcripts(type),
    mod,
    assayname) {
        ## We don't need to pass type to getDegTx() since it's not used internally
        ## once the sig_transcripts have been defined.
      
      type = arg_match(type)
      
      # Validate rse_tx is a RangedSummarizedExperiment object
      if (!is(rse_tx, "RangedSummarizedExperiment")) {
        stop("'rse_tx' must be a RangedSummarizedExperiment object.", call. = FALSE)
      }
      
      # Check if assayname is in assayNames
      if (!assayname %in% assayNames(rse_tx)) {
        stop(sprintf("'%s' is not in assayNames(rse_tx).", assayname), call. = FALSE)
      }
      
      # Get the qSVs
      DegTx <-
            getDegTx(rse_tx, sig_transcripts = sig_transcripts, assayname = assayname)
        PCs <- getPCs(DegTx, assayname)
        k <- k_qsvs(DegTx, mod = mod, assayname = assayname)
        qSV <- get_qsvs(PCs, k)
        return(qSV)
    }
