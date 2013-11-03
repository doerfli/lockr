$(document).ready(function() {
    $('.entrytable').dataTable({
        "bJQueryUI": true,
        "bPaginate": false,
        "aoColumns": [
          { "sWidth": "25%" },
          { "sWidth": "25%" },
          { "sWidth": "50%" }
        ]
    });
    
    $( "a.button" ).button();
    
    $( "a#addnew").click( function() {
        $( "#dialog-addnewsite" ).dialog( "open" );
    });
    
    $( "#dialog-addnewsite" ).dialog({
      autoOpen: false,
      height: 400,
      width: 400,
      modal: true,
      buttons: {
        "Save": function() {
          $( "form#form-add").submit();
        },
        "Cancel": function() {
          $( this ).dialog( "close" );
        }
      },
      close: function() {
          // clean all fields
          $("dialog-addnewsite input").each().val( "" ).removeClass( "ui-state-error" );
      }
    });
} );