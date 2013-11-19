$(document).ready(function() {
    $('.entrytable').dataTable({
        "bJQueryUI": true,
        "bPaginate": false,
        "aoColumns": [
          { "sWidth": "20%" },
          { "sWidth": "20%" },
          { "sWidth": "30%" },
          { "sWidth": "30%" }
        ]
    });
    
    $( "a.button" ).button();
    
    $( "a#addnew").click( function() {
        $( "#dialog-addnewsite" ).dialog( "open" );
    });
    
    $( '#resultbox').hide();
    $( '#errorbox').hide();
    
    $( "a#copypwd").click( function() {
      var data = $( this).parents("tr.data")[0].dataset;
      jQuery.ajax({
        url: '/password',
        data: {"id": data.id, "username": data.username},
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
      height: 450,
      width: 400,
      position: { my: "left top", at: "left bottom", of: "a#addnew" },
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
            $( '.entrytable').dataTable().fnAddData( [
	        	response.row[0],
	        	response.row[1],
	        	response.row[2],
	        	'<a id="copypwd" class="button">Copy</a> <a id="changepwd" class="button">Change</a> <a id="deletepwd" class="button">Delete</a>'] );
	      	$( "a.button" ).button();
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
        var data = $( this).parents("tr.data")[0].dataset;
        $("#dialog-changepwd #id").attr('value', data.id);
        $("#dialog-changepwd #id_label").html( data.id);
        $("#dialog-changepwd #username").attr('value', data.username);
        $("#dialog-changepwd #username_label").html( data.username);
        $("#dialog-changepwd #url").attr('value', data.url);
        $("#dialog-changepwd" ).dialog( "open" );
    });
    
    $( "#dialog-changepwd" ).dialog({
      autoOpen: false,
      height: 450,
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
        var data = $( this).parents("tr.data")[0].dataset;
        $("#dialog-deletepwd #id").attr('value', data.id);
        $("#dialog-deletepwd #id_label").html( data.id);
        $("#dialog-deletepwd #username").attr('value', data.username);
        $("#dialog-deletepwd #username_label").html( data.username);
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