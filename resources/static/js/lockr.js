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
    
    $( "a#changepwd").click( function() {
        var id = $( this).siblings( ".id").get(0).value;
        var username = $( this).siblings( ".username").get(0).value;
        $("#dialog-changepwd #id").attr('value', id);
        $("#dialog-changepwd #id_label").html( id);
        $("#dialog-changepwd #username").attr('value', username);
        $("#dialog-changepwd #username_label").html( username);
        $( "#dialog-changepwd" ).dialog( "open" );
    });
    
    $( "#dialog-changepwd" ).dialog({
      autoOpen: false,
      height: 400,
      width: 400,
      modal: true,
      buttons: {
        "Save": function() {
          $( "form#form-change").submit();
        },
        "Cancel": function() {
          $( this ).dialog( "close" );
        }
      },
      close: function() {
          // clean all fields
          $("dialog-changepwd input").each().val( "" ).removeClass( "ui-state-error" );
      }
    });
    
});