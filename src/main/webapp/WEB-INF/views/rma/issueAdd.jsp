<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	

<script src="/drcms/js/upload/jquery.ui.widget.js"></script>
<script src="/drcms/js/upload/jquery.iframe-transport.js"></script>
<script src="/drcms/js/upload/jquery.fileupload.js"></script>

<h1 class="contentTitle">Create RMA</h1>
<div align="center">
	<div>
<form method="post" id="mainForm">
	<table id="mainTable" style="width: 50%; text-align: left;">
	<tr><td align="left">*Desc.：</td><td><input name="summary" type="text" size="50" class="required" ></td></tr>
	<tr><td align="left">Customer：</td><td><select id="customerNameOption" name="customer"></select></td></tr>
	<tr><td align="left">Data Center：</td><td><input name="dataCenter" type="text" ></td></tr>
	<tr><td align="left">Contact Name：</td><td><input name="contactName" type="text" ></td></tr>
	<tr><td align="left">Contact Phone：</td><td><input name="contactPhone" type="text" ></td></tr>
	<tr><td align="left">Contact Cell：</td><td><input name="contactCell" type="text" ></td></tr>
	<tr><td align="left">Address：</td><td><input name="address" type="text" size="100"></td></tr>
	<tr><td align="left">State：</td><td><input name="state" type="text" size="100"></td></tr>
	<tr><td align="left">Country：</td><td><input name="country" type="text" size="100"></td></tr>
	<tr><td align="left">Zip Code：</td><td><input name="zipCode" type="text" size="100"></td></tr>
	<tr><td align="left">Attachment：</td><td><div id="selectedAttach"></div><input id="fileupload" type="file" name="files[]" data-url="/drcms/rma/uploadFile"></td></tr>
	<tr><td align="left">Add Fail Parts：</td><td><input id="FailPartsBtn" type="button" name="FailPartsBtn" value="Add"></td></tr>
	<tr><td colspan="2">
		<table id="failPartsTable" style="width: 80%; text-align: left;">
			<thead><tr><th>Material Type</th><th>Patrs No</th><th>Parts SN</th><th>System SN</th><th>Fail Cause</th></tr></thead>
			<tbody></tbody>
		</table></td>
	</tr>
	
	<tr>
					<td colspan=2 align=right>
					<input class="JQbtn" type="button" value="Add" id="issueDataAddAjaxAddBtn" onclick=""> 
					<input class="JQbtn" type="button" value="cancel" id="issueAddCancel" onclick="location.href= ('/drcms/rma');">
					</td>
				</tr>
	</table>    
</form>
	</div>

<div id="insertFailPartsDialog" title="新增新料件" style="display:none;" >
<form>
	<fieldset>
	<table>
		<tr><td align="left">Parts Type：</td><td><select name="dialogPartsType" id="dialogPartsType">
		</select></td></tr>
		<tr><td align="left">Parts No：</td><td><input type="text" id="dialogPartsNo"></td></tr>
		<tr><td align="left">Parts S/N：</td><td><input type="text" id="dialogPartsSN"></td></tr>
		<tr><td align="left">System S/N：</td><td><input type="text" id="dialogMachineSN"></td></tr>
		<tr><td align="left">Fail Cause：</td><td><input type="text" id="dialogFailCause"></td></tr>
	</table>
	</fieldset>
</form>
<div id='msgDiv' style="display: none; "><font color=red>此料件下無法新增料件</font></div>
</div>


</div>
<script>
$(document).ready(function() { 
	$('#mainForm').validate();

	//for initial some object
	$.ajax({
		url: "/drcms/rma/initialCustomer",
		type: "GET",
		dataType: "json",
		success: function(res) {
			dwr.util.addOptions( "customerNameOption", res, 'id', 'customerName');
		}
	});
	
	//for Work Log add in CustomerService
	$("#insertFailPartsDialog").dialog({
	    autoOpen: false,
	    modal: true,
		width: '620', height: '450',
	    buttons: {
	        "Save": function() {
	        	var dialogPartsType = $('#dialogPartsType').val();
	        	var dialogPartsNo = $('#dialogPartsNo').val();
	        	var dialogPartsSN = $('#dialogPartsSN').val();
	        	var dialogMachineSN = $('#dialogMachineSN').val();
	        	var dialogFailCause = $('#dialogFailCause').val();
	        	rowData = '';
	        	rowData = rowData + '<tr>';
	        	rowData = rowData + '<td>'+dialogPartsType+'<input type=\'hidden\' id=\'dialogPartsType\' name=\'dialogPartsType\' value=\''+dialogPartsType+'\'></td>';
	    		rowData = rowData + '<td>'+dialogPartsNo+'<input type=\'hidden\' id=\'dialogPartsNo\' name=\'dialogPartsNo\' value=\''+dialogPartsNo+'\'></td>';
	    		rowData = rowData + '<td>'+dialogPartsSN+'<input type=\'hidden\' id=\'dialogPartsSN\' name=\'dialogPartsSN\' value=\''+dialogPartsSN+'\'></td>';
	    		rowData = rowData + '<td>'+dialogMachineSN+'<input type=\'hidden\' id=\'dialogMachineSN\' name=\'dialogMachineSN\' value=\''+dialogMachineSN+'\'></td>';
	    		rowData = rowData + '<td>'+dialogFailCause+'<input type=\'hidden\' id=\'dialogFailCause\' name=\'dialogFailCause\' value=\''+dialogFailCause+'\'></td>';
	    		rowData = rowData + '</tr>';
	    		$("#failPartsTable > tbody").prepend(rowData);
	    		$(this).dialog("close");
	        },
			"Cancel": function() {
	            $(this).dialog("close");
	        }
	    }
	});

	$("#FailPartsBtn").click(function(event) {
	    event.preventDefault();
	    $("#insertFailPartsDialog").dialog("open");
	});
	
	$( "#issueDataAddAjaxAddBtn" ).click(function() {
		if($("#mainForm").valid()){
		$.ajax({
			url: "/drcms/rma/addSubmit",
			type: "POST",
			dataType: "json",
			data : $("#mainForm").serialize(),
			success: function(res) {
				window.location.href = '/drcms/rma/detail?id='+ res.id;
			},
		   
			error: function() {
				alert('error');
			}
		});
		}
	});

	$('#fileupload').fileupload({
	    dataType: 'json',
	    
	    done: function (e, data) {
	            $("#selectedAttach").append(
	                            $('<tr/>')
	                            .append($('<td/>').text(data.result.fileName))
	                            .append($('<td/>').html("<input type=\"checkbox\" id=\"attachmentId\" name=\"attachmentId\" value=\""+data.result.id+"\" checked>"))
	                            )//end $("#selectedAttach").append()
	    },
	    
	    progressall: function (e, data) {
	            var progress = parseInt(data.loaded / data.total * 100, 10);
	            $('#progress .bar').css(
	                'width',
	                progress + '%'
	            );
	               },
	               
	            dropZone: $('#dropzone')
	});

	



});

//JS datePicker
$(function() {
	$( "#dueDate" ).datepicker({
		changeYear: true,
		changeMonth: true,
		dateFormat:"yy-mm-dd",
		showAnim:"blind",
		showButtonPanel: true,       
		onClose: function( selectedDate ) {
			$( "#toDate" ).datepicker("option", "minDate", new Date(selectedDate));          
		}
	});

	});
</script>
