#' @import htmltools
#' @import DT

#' @rdname loadings2table
#' @title Factor loading table
#' @description
#' Render the table with factor loadings as html-widget.
#' @param M numeric matrix, dimnames must be present
#' @param hints named character vector with item content
#' @param Vexpl numeric vector with proportion of explained variance
#' @param FA \code{fa} or \code{fa.ci} object from \code{psych} package
#' @param L \code{loadings} object from \code{psych} package
#' @param ... the arguments passed to \code{loadings2table.matrix}:
#' hints or Vexpl
#'
#' @export
loadings2table.matrix <-
  function(M,
           hints = character(0),
           Vexpl = numeric(0)) {
    if(length(rownames(M)) == 0 ||
       length(colnames(M)) == 0)
      stop('The table must have dimnames')

    container <- withTags(
      div(
        class = 'loading-table-wrapper',
        table(
          tableHeader(c('ind', '', '','item', colnames(M))),
          if (length(Vexpl) > 0)
            tfoot(
              tr(td(colspan = 4, em('Expl.var. (%)')),
                 lapply(sprintf('%0.1f', 100 * Vexpl),
                        function(x) td(em(x)))
              )
            )
        )
      )
    )

    # Export button configuration
    buttons <- list(
      list(extend = 'copy',
           footer = TRUE,
           exportOptions = list(
             columns = ':visible'
           )),
      list(extend = 'excel',
           footer = TRUE,
           exportOptions = list(
             columns = ':visible'
           )),
      list(extend = 'csv',
           footer = TRUE,
           exportOptions = list(
             columns = ':visible'
           )),
      list(extend = 'pdf',
           footer = TRUE,
           exportOptions = list(
             columns = ':visible'
           )))

    rn <- rownames(M)
    if (length(hints) == 0)
      hints <- rep('', length(rn))

    which_f <- apply(abs(M), 1, which.max)
    max_l <- apply(abs(M), 1, max)
    init_order <- order(which_f, max_l,
                        method = 'radix',
                        decreasing = c(FALSE, TRUE))

    Ldf <- data.frame(ind = 1:length(rn),        # visible
                      init_order = 1:length(rn), # invisible
                      hint = hints[init_order],  # invisible
                      item = rn[init_order],     # visible
                      M[init_order, ],           # visible
                      row.names = NULL,
                      stringsAsFactors = FALSE)

    DT <- datatable(Ldf,
                    rownames = FALSE,
                    style = 'bootstrap4',
                    escape = FALSE,
                    container = container,
                    extensions = c('Buttons', 'RowReorder'),
                    options = list(
                      pageLength = 50,
                      order = list(0, 'asc'),
                      rowReorder = list(
                        dataSrc = 0
                      ),
                      dom = paste0("<'row'<'col-sm-12 col-md-5'f>",
                                   "<'col-sm-12 col-md-3'<'reorder-but'>>",
                                   "<'col-sm-12 col-md-4'<'cutoff-inp'>>>",
                                   "<'row'<'col-sm-12'tr>>",
                                   "<'row'<'col-sm-12 col-md-6'BC>>"),
                      columnDefs = list(
                        list(
                          className = 'dt-left',
                          targets = 0:3
                        ),
                        list(
                          render = JS('renderLoading'),
                          searchable = FALSE,
                          className = 'dt-right',
                          targets = 4:(ncol(Ldf) - 1)),
                        list( # Hints and initial order
                          visible = FALSE,
                          searchable = FALSE,
                          targets = 1:2
                        )
                      ),
                      buttons = buttons
                    ))

    DT$dependencies <- c(DT$dependencies, html_dependency_L2T())
    return(DT)
  }

#' @rdname loadings2table
#' @export
loadings2table <- function(x, ...) {
  UseMethod('loadings2table', x)
}

#' @rdname loadings2table
#' @export
loadings2table.fa <-
  function(FA, ...) {
    L <- loadings(FA)
    Vexpl <- FA$Vaccounted['Proportion Var', ]
    loadings2table.loadings(L, Vexpl = Vexpl, ...)
  }

#' @rdname loadings2table
#' @export
loadings2table.fa.ci <- loadings2table.fa

#' @rdname loadings2table
#' @export
loadings2table.loadings <- function(L, ...) {
  class(L) <- 'matrix'
  loadings2table.matrix(L, ...)
}
