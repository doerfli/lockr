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
    
    $( '#resultbox').hide();
    $( '#errorbox').hide();
    
    $( "a#copypwd").click( function() {
      var id = $( this).siblings( ".id").get(0).value;
      var username = $( this).siblings( ".username").get(0).value;
      jQuery.ajax({
        url: '/password',
        method: 'GET',
        data: {"id": id , "username": username},
        contentType: 'application/json',
        dataType: 'json'
      }).done(function (response) {
        $( '#errorbox').hide();
        $( '#resultbox').show();
        $( '#resultmsg').html( response.message);
      }).fail(function () {
        $( '#resultbox').hide();
        $( '#errorbox').show();
        $( '#errormsg').html( "Something went wrong.");
      });
    });
    
    $( "#dialog-addnewsite" ).dialog({
      autoOpen: false,
      height: 400,
      width: 400,
      modal: true,
      buttons: {
        "Save": function() {
          jQuery.ajax({
            url: '/password',
            method: 'POST',
            data: JSON.stringify($('#form-add').serializeArray()),
            contentType: 'application/json',
            dataType: 'json'
          }).done(function (response) {
            $( "#form-add").find("input[type=text], input[type=password]").val("");
            $( "#dialog-addnewsite" ).dialog( "close" );
            $( '#errorbox').hide();
            $( '#resultbox').show();
            $( '#resultmsg').html( response.message);
          }).fail(function () {
            $( "#dialog-addnewsite" ).dialog( "close" );
            $( '#resultbox').hide();
            $( '#errorbox').show();
            $( '#errormsg').html( "Something went wrong.");
          });
        },
        "Cancel": function() {
          $( this ).dialog( "close" );
        }
      }
    });
    
    $( "a#changepwd").click( function() {
        var id = $( this).siblings( ".id").get(0).value;
        var username = $( this).siblings( ".username").get(0).value;
        $("#dialog-changepwd #id").attr('value', id);
        $("#dialog-changepwd #id_label").html( id);
        $("#dialog-changepwd #username").attr('value', username);
        $("#dialog-changepwd #username_label").html( username);
        $("#dialog-changepwd" ).dialog( "open" );
    });
    
    $( "#dialog-changepwd" ).dialog({
      autoOpen: false,
      height: 400,
      width: 400,
      modal: true,
      buttons: {
        "Change": function() {
          jQuery.ajax({
            url: '/password',
            method: 'PATCH',
            data: JSON.stringify($('#form-change').serializeArray()),
            contentType: 'application/json',
            dataType: 'json'
          }).done(function (response) {
            console.log( response);
            $( "#form-change").find("input[type=text], input[type=password]").val("");
            $( "#dialog-changepwd" ).dialog( "close" );
            $( '#errorbox').hide();
            $( '#resultbox').show();
            $( '#resultmsg').html( response.message);
          }).fail(function () {
            $( "#dialog-changepwd" ).dialog( "close" );
            $( '#resultbox').hide();
            $( '#errorbox').show();
            $( '#errormsg').html( "Something went wrong.");
          });
        },
        "Cancel": function() {
          $( this ).dialog( "close" );
        }
      }
    });
    
    $( "a#deletepwd").click( function() {
        var id = $( this).siblings( ".id").get(0).value;
        var username = $( this).siblings( ".username").get(0).value;
        $("#dialog-deletepwd #id").attr('value', id);
        $("#dialog-deletepwd #id_label").html( id);
        $("#dialog-deletepwd #username").attr('value', username);
        $("#dialog-deletepwd #username_label").html( username);
        $("#dialog-deletepwd" ).dialog( "open" );
    });
    
    $( "#dialog-deletepwd" ).dialog({
      autoOpen: false,
      height: 400,
      width: 400,
      modal: true,
      buttons: {
        "Delete": function() {
          jQuery.ajax({
            url: '/password',
            method: 'DELETE',
            data: JSON.stringify($('#form-delete').serializeArray()),
            contentType: 'application/json',
            dataType: 'json'
          }).done(function (response) {
            console.log( response);
            $( "#form-delete").find("input[type=text], input[type=password]").val("");
            $( "#dialog-deletepwd" ).dialog( "close" );
            $( '#errorbox').hide();
            $( '#resultbox').show();
            $( '#resultmsg').html( response.message);
          }).fail(function () {
            $( "#dialog-delete" ).dialog( "close" );
            $( '#resultbox').hide();
            $( '#errorbox').show();
            $( '#errormsg').html( "Something went wrong.");
          });
        },
        "Cancel": function() {
          $( this ).dialog( "close" );
        }
      }
    });
    
});