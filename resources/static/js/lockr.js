$(document).ready(function() {
    $('.entrytable').dataTable({
        "bJQueryUI": true,
        "bPaginate": false,
        "aoColumns": [
          { "sWidth": "200px" },
          { "sWidth": "200px" },
          { "sWidth": "200px" }
        ]
    });
} );