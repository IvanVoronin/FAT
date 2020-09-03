#' @export
html_dependency_L2T <- function() {
  list(
    bootstrap4 = htmlDependency(
      name = 'bootstrap',
      version = '4.5.2',
      package = 'FAT',
      src = c(
        file = 'bootstrap4',
        href = 'https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/'
      ),
      script = 'js/bootstrap.bundle.min.js',
      stylesheet = 'css/bootstrap.min.css'
    ),
    dataTables.bootstrap4 = htmlDependency(
      name = 'dataTables.bootstrap4',
      version = '1.10.21',
      package = 'FAT',
      src = c(
        file = 'dataTables.bootstrap4',
        href = 'https://cdn.datatables.net/1.10.21/'
      ),
      script = c('js/jquery.dataTables.min.js',
                 'js/dataTables.bootstrap4.min.js'),
      stylesheet = 'css/dataTables.bootstrap4.min.css'
    ),
    dataTables.buttons = htmlDependency(
      name = 'dataTables.buttons',
      version = '1.6.3',
      package = 'FAT',
      src = c(
        href = 'https://cdn.datatables.net/buttons/1.6.3/',
        file = 'dataTables.buttons'
      ),
      script = c(
        'js/dataTables.buttons.min.js',
        'js/buttons.bootstrap4.min.js'
      ),
      stylesheet = 'css/buttons.bootstrap4.min.css'
    ),
    buttons.html5 = htmlDependency(
      name = 'buttons.html5',
      version = '1.6.2',
      package = 'FAT',
      src = c(
        href = 'https://cdn.datatables.net/buttons/1.6.2/',
        file = 'buttons.html5'
      ),
      script = 'js/buttons.html5.min.js'
    ),
    dataTables.rowReorder = htmlDependency(
      name = 'dataTables.rowReorder',
      version = '1.2.7',
      package = 'FAT',
      src = c(
        href = 'https://cdn.datatables.net/rowreorder/1.2.7/',
        file = 'dataTables.rowReorder'
      ),
      script = 'js/dataTables.rowReorder.min.js',
      stylesheet = 'css/rowReorder.bootstrap4.min.css'
    ),
    dataTables.factorLoadings = htmlDependency(
      name = 'dataTables.factorLoadings',
      version = '1.0',
      package = 'FAT',
      src = c(
        file = 'dataTables.factorLoadings'
      ),
      script = 'dataTables.factorLoadings.js',
      stylesheet = 'dataTables.factorLoadings.css'
    )
  )
}
