<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	

<script src="/drcms/js/upload/jquery.ui.widget.js"></script>
<script src="/drcms/js/upload/jquery.iframe-transport.js"></script>
<script src="/drcms/js/upload/jquery.fileupload.js"></script>

<h1 class="contentTitle">Create Issue</h1>
<div align="center">
	<div>
<form method="post" id="mainForm">
	<table id="mainTable" style="width: 50%; text-align: left;">
	<tr><td align="left">*概述：</td><td><input name="summary" type="text" size="50" class="required" ></td></tr>
	<tr><td align="left">*來電電話：</td><td><input name="callerPhone" type="text" class="required"></td></tr>
	<tr><td align="left">*來電姓名：</td><td><input name="callerName" type="text" class="required"></td></tr>
	<tr><td align="left">Priority：</td><td><select name="issuePriority"><option value="URGENT">Urgent</option><option value="NORMAL">Normal</option><option value="LOW">Low</option></select></td></tr>
	<tr><td align="left">Description：</td><td><textarea name="description" cols="50" rows="3" ></textarea></td></tr>
	<tr><td align="left">環境：</td><td><textarea name="environment" cols="50" rows="3" ></textarea></td></tr>
	<tr><td align="left">Component Type：</td><td><select name="componentType"><option value="component">component</option><option value="server">Server</option><option value="software">software</option></select></td></tr>
	<tr><td align="left">機器序號：</td><td><input name="goodsSn" type="text"></td></tr>
	<tr><td align="left">機器保固日期：</td><td><input name="warrantyDate" type="text" ></td></tr>
	<tr><td align="left">保固類型：</td><td><input name="warrantyType" type="text" ></td></tr>
	<tr><td align="left">維修地址：</td><td><input name="address" type="text" size="100"></td></tr>
	<tr><td align="left">預期處理日期：</td><td><input name="" type="text" >(2w, 3d, 1h)</td></tr>
	<tr><td align="left">*DueDate：</td><td><input id="dueDate" name="dueDate" type="text" class="required"></td></tr>
	<tr><td align="left">客戶名稱：</td><td><select id="customerNameOption" name="customer"></select></td></tr>
	<tr><td align="left">聯絡人姓名：</td><td><input name="contactName" type="text" ></td></tr>
	<tr><td align="left">聯絡人電話：</td><td><input name="contactPhone" type="text" ></td></tr>
	<tr><td align="left">聯絡人手機：</td><td><input name="contactCell" type="text" ></td></tr>
	<tr><td align="left">Attachment：</td><td><div id="selectedAttach"></div><input id="fileupload" type="file" name="files[]" data-url="/drcms/issue/uploadFile"></td></tr>
	<tr>
					<td colspan=2 align=right>
					<input class="JQbtn" type="button" value="Add" id="issueDataAddAjaxAddBtn" onclick=""> 
					<input class="JQbtn" type="button" value="cancel" id="issueAddCancel" onclick="location.href= ('/drcms/issue');">
					</td>
				</tr>
	</table>    
</form>
	</div>

</div>
<script>
$(document).ready(function() { 
	$('#mainForm').validate();

	//for initial some object
	$.ajax({
		url: "/drcms/issue/initialCustomer",
		type: "GET",
		dataType: "json",
		success: function(res) {
			dwr.util.addOptions( "customerNameOption", res, 'id', 'customerName');
		}
	});
	
$( "#issueDataAddAjaxAddBtn" ).click(function() {
	if($("#mainForm").valid()){
	$.ajax({
		url: "/drcms/issue/addSubmit",
		type: "POST",
		dataType: "json",
		data : $("#mainForm").serialize(),
		success: function(res) {
			window.location.href = '/drcms/issue/detail?id='+ res.id;
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
