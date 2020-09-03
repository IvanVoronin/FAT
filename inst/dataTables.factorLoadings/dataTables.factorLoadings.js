// This is a small library that operates on the dataTables
// with factor loadings.
// The tables are supposed to be created by the loadings2DT function in R.
// Don't forget to use header.html as well.

// Ivan Voronin

// Render loadings by applying cutoff
function renderLoading(data, type, row, meta) {
  var cutoff = 0.3;
  var inp = $(meta.settings.nTableWrapper).find('.cutoff-inp > input');
  if (inp.length > 0) {
    cutoff = parseFloat(inp.val());
  }

  if (Math.abs(data) < cutoff) {
    return "";
  } else {
    return data.toFixed(3);
  }
}

// Reorder the rows
function reorder() {
  var this_dt = $(this).parents('.dataTables_wrapper').find('.dataTable').DataTable();
  $('.popover').popover('hide');
  this_dt.order([1, 'asc']).draw();
}

// Redraw the table to apply new cutoff
function redraw() {
  var this_dt = $(this).parents('.dataTables_wrapper').find('.dataTable').DataTable();
  this_dt.rows().invalidate('data').draw('page');
}

$(document).ready(function() {
  // I will need this later to change control DOMs without messing up with other tables
  var $dt_wrap = $('.loading-table-wrapper');

  // Reorder controls
  $('.reorder-but').css('display', 'flex')
                   .css('align-items', 'center')
                   .css('justify-content', 'center');
  var $reorder_but = $('<button>Reorder</button>').on('click', reorder)
                                                  .attr('type', 'button')
                                                  .attr('class', 'btn btn-secondary')
                                                  .attr('data-toggle', 'tooltip')
                                                  .attr('title', 'Impose the default item order');
  $('.reorder-but').append($reorder_but);

  // Cutoff controls
  var $cutoff_inp = $('<input>').attr('type', "number")
                                .attr('value', 0.3)
                                .attr('min', 0)
                                .attr('max', 1)
                                .attr('step', 0.05)
                                .css('margin-left', '0.5em')
                                .on('change', redraw)
                                .attr('data-toggle', 'tooltip')
                                .attr('title', 'Exclude loadings below cutoff value');
  $('.cutoff-inp').css('float', 'right')
                  .append('Cutoff: ')
                  .append($cutoff_inp);

  // Aligning filter and length controls
  $dt_wrap.find('.dataTables_filter').css('float', 'left')
                                     .css('text-align', 'left')
                                     .find('label')
                                     .css('display', 'flex')
                                     .css('margin-bottom', '0pt');

  // Changing 'Search' to 'Filter'
  var $search_lab = $dt_wrap.find('.dataTables_filter > label');
  $search_lab.contents().filter(function() { return this.nodeType === 3 })
                        .each(function() {
                            this.textContent = this.textContent.replace('Search', 'Filter');
                        });

  // Item hints AND buttons
  $dt_wrap.find('.dataTable').each(function() {
    var this_dt = $(this).DataTable();

    this_dt.rows().every(function() {
      if (this.data()[2] !== '') {
        $(this.node()).attr('data-toggle', 'popover')
                      .attr('data-content', this.data()[2]);
      }
    });
  });

  $dt_wrap.find('td').attr('data-toggle', 'tooltip')
                        .attr('data-container', 'body')
                        .attr('title', 'Drag the index of a row to rearrange the rows. Click on a row to see item contents.');

  $('[data-toggle="tooltip"]').tooltip({
    delay: {
      show: 2000,
      hide: 0
    }
  });
  $('[data-toggle="popover"]').popover({'placement': 'left'});

  $(document).dblclick(function() {
    $('.popover').popover('hide');
  });

  // Update index column on reorder
  $dt_wrap.find('.dataTable').DataTable().on(
    'order.dt', function(e, settings, ordArr) {
      $('.popover').popover('hide');
      var this_dt = new $.fn.dataTable.Api(settings);
      this_dt.rows().every(function(rowIdx, tableLoop, rowLoop) {
        var data = this.data();
        data[0] = rowLoop + 1;
        this.data(data);
      });
    });

  // Order by index column on user ordering
  $dt_wrap.find('.dataTable').DataTable().on(
    'pre-row-reorder', function(e, node, index) {
        $(this).DataTable().order([0, 'asc']);
      });
});
