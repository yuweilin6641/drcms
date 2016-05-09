<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	

<script src="/drcms/js/upload/jquery.ui.widget.js"></script>
<script src="/drcms/js/upload/jquery.iframe-transport.js"></script>
<script src="/drcms/js/upload/jquery.fileupload.js"></script>

<script type="text/javascript">
<% String tmp[] = request.getParameterValues("rmaId");
   String val = "";
   if(tmp==null || tmp.length==0){
	   val = "[]";
   }
   else{
	   for(int i=0; i<tmp.length; i++){
		   val = val + "," + tmp[i] + "";
	   }
	   val = "[" + val.substring(1) + "]";
   }

%>
var rmaIds = <%=val %>;
</script>
<h1 class="contentTitle">Create Return</h1>
<div align="center">
	<div>
<form method="post" id="mainForm">
	<table id="mainTable" style="width: 50%; text-align: left;">
	<tr><td colspan="2">Send By</td></tr>
	<tr><td align="left">Customer:</td><td><input name="customer" type="text" size="50" class="required" ></td></tr>
	<tr><td align="left">Address:</td><td><input name="contacAddress" type="text" size="50" class="required"></td></tr>
	<tr><td align="left">Contact Name:</td><td><input name="contacAddress" type="text" size="50" class="required"></td></tr>
	<tr><td align="left">Phone:</td><td><input name="contacAddress" type="text" size="50" class="required"></td></tr>
	<tr><td align="left">zip code:</td><td><input name="contacAddress" type="text" size="50" class="required"></td></tr>
	</table>
	<table id="mainTable" style="width: 50%; text-align: left;">
	<tr><td colspan="2">Send By</td></tr>
	<tr><td align="left">Customer:</td><td><input name="wiwynnCustomer" type="text" size="50" class="required" ></td></tr>
	<tr><td align="left">Address:</td><td><input name="wiwynnContacAddress" type="text" size="50" class="required"></td></tr>
	<tr><td align="left">Contact Name:</td><td><input name="wiwynnContacAddress" type="text" size="50" class="required"></td></tr>
	<tr><td align="left">Phone:</td><td><input name="wiwynnContacAddress" type="text" size="50" class="required"></td></tr>
	<tr><td align="left">zip code:</td><td><input name="wiwynnContacAddress" type="text" size="50" class="required"></td></tr>
	</table>
	<table id="mainTable" style="width: 50%; text-align: left;">
	<tr><td align="left">Total number <br>of package:</td><td><input name="totalNumber" type="text" size="50"></td></tr>
	<tr><td align="left">Total Weight:</td><td><input name="totalWeight" type="text" size="50"></td></tr>
	<tr><td align="left">*Forwarder:</td><td><input name="forwarder" type="text" size="50" class="required"></td></tr>
	<tr><td align="left">*trackign no.:</td><td><input name="trackingNo" type="text" size="50" class="required"></td></tr>
	<tr><td align="left">*pickup date</td><td><input name="pickupDate" type="text" size="50" class="required"></td></tr>
	</table>
	<table id="mainTable" style="width: 50%; text-align: left;">
	<tr><td colspan="2">
		<table id="failPartsTable" style="width: 80%; text-align: left;">
			<thead><tr><th>Material Type</th><th>Patrs No</th><th>Parts SN</th><th>System SN</th><th>Fail Cause</th></tr></thead>
			<tbody></tbody>
		</table></td>
	</tr>
	</table>
	<table style="width: 50%; text-align: left;">
	<tr>
					<td align=center>
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
		<tr><td align="left">Parts Type:</td><td><select name="dialogPartsType" id="dialogPartsType">
		</select></td></tr>
		<tr><td align="left">Parts No:</td><td><input type="text" id="dialogPartsNo"></td></tr>
		<tr><td align="left">Parts S/N:</td><td><input type="text" id="dialogPartsSN"></td></tr>
		<tr><td align="left">System S/N:</td><td><input type="text" id="dialogMachineSN"></td></tr>
		<tr><td align="left">Fail Cause:</td><td><input type="text" id="dialogFailCause"></td></tr>
	</table>
	</fieldset>
</form>
<div id='msgDiv' style="display: none; "><font color=red>此料件下無法新增料件</font></div>
</div>


</div>
<script>
$(document).ready(function() { 
	$('#mainForm').validate();
	
	$.ajax({
		type:"POST",
        url:"/drcms/return/initialAddReturn",
        data: {"rmaIds" : rmaIds, "aaa":"aaaa1"},
		dataType: "json",
		success: function(res) {
            $.each(res, function(i, item) {
            	rowData = '';
             	rowData = rowData + '<tr>';
             	rowData = rowData + '<td>'+item.failPartsSN+'<input type=\'hidden\' id=\'dialogPartsType\' name=\'dialogPartsType\' value=\''+item.failPartsSN+'\'></td>';
         		rowData = rowData + '<td>'+item.failPartsSN+'<input type=\'hidden\' id=\'dialogPartsNo\' name=\'dialogPartsNo\' value=\''+item.failPartsSN+'\'></td>';
         		rowData = rowData + '<td>'+item.failPartsSN+'<input type=\'hidden\' id=\'dialogPartsSN\' name=\'dialogPartsSN\' value=\''+item.failPartsSN+'\'></td>';
         		rowData = rowData + '<td>'+item.failPartsSN+'<input type=\'hidden\' id=\'dialogMachineSN\' name=\'dialogMachineSN\' value=\''+item.failPartsSN+'\'></td>';
         		rowData = rowData + '<td>'+item.failPartsSN+'<input type=\'hidden\' id=\'dialogFailCause\' name=\'dialogFailCause\' value=\''+item.failPartsSN+'\'></td>';
         		rowData = rowData + '</tr>';
         		$("#failPartsTable > tbody").prepend(rowData);
            });
			
		},
		error: function() {
			alert("error");
		}
	});
	
	$("#FailPartsBtn").click(function(event) {
	    event.preventDefault();
	    $("#insertFailPartsDialog").dialog("open");
	});
	
	$( "#issueDataAddAjaxAddBtn" ).click(function() {
		if($("#mainForm").valid()){
		$.ajax({
			url: "/drcms/return/addSubmit",
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
