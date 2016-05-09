<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style type='text/css'>
.tableShowStyle {
background-image:url('/drcms/images/arrow-up.png');
background-repeat: no-repeat;
text-shadow: 1px 1px #3ADA67;
}
.tableHideStyle {
background-image:url('/drcms/images/arrow-down.png');
background-repeat: no-repeat;
text-shadow: 1px 1px #C5C4C4;
}
legend {
margin:0 0 0px 0;
padding:0 0 15px 15px;
}
</style>

<script src="/drcms/js/upload/jquery.ui.widget.js"></script>
<script src="/drcms/js/upload/jquery.iframe-transport.js"></script>
<script src="/drcms/js/upload/jquery.fileupload.js"></script>

<script type="text/javascript">
var onsiteOrderId = <%=request.getParameter("id") %>;
var issueId = null;
var currentUser = '<%= session.getAttribute("LOGIN_ACCOUNT") %>';

function formatJsonDate (jsonDate){
	if(jsonDate!=null){
		var currentTime = new Date(jsonDate);
		var month = currentTime.getMonth() + 1;
		var day = currentTime.getDate();
		var year = currentTime.getFullYear();
		return year +'-'+month+'-'+day;
	}
	else{
		return "";
	}
}

function checkAssignee(res){
	if(currentUser!=res.reporter){
		if(res.approvedStatus!=null){
			$('#assignAddAjaxBtn').remove();
		}
		
		if(res.resolutionStatus!='OPEN'){
			$('#assignAddAjaxBtn').remove();
		}
		if(currentUser!=res.taskOwner){
			$('#assignAddAjaxBtn').remove();
		}
	}
} 

$(window).load(function() {
	$('#fileupload').fileupload({
	    dataType: 'json',
	    url: "/drcms/onSite/uploadFile?issueId="+issueId,
	    done: function (e, data) {
	    	$("#selectedAttach").append($('<td/>').html("<a href=\"/drcms/fileController/get/"+data.result.id+"\">"+data.result.fileName+"</a>"));
	    	$("#attachFileAddDialog").dialog("close");
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

$(document).ready(function(){
	$.ajax({
		url: "/drcms/onSite/get/"+ onsiteOrderId,
		type: "GET",
		dataType: "json",
		success: function(res) {
			dwr.util.setValues(objectEval(JSON.stringify(res)));
			
			issueId = res.issueId;

			$('#onsiteDate').text(formatJsonDate(res.onsiteDate));
			$('#dueDate').text(formatJsonDate(res.dueDate));
			

			checkAssignee(res);
					
			if(res.resolutionStatus!='OPEN'){
				$('#attachFileAddAjaxBtn').remove();
				$('#statusAjaxBtn').remove();
				$('#approvedAjaxBtn').remove();
				$('#rejectAjaxBtn').remove();
			}
			if(currentUser!=res.taskOwner){
				$('#attachFileAddAjaxBtn').remove();
				$('#statusAjaxBtn').remove();
				$('#approvedAjaxBtn').remove();
				$('#rejectAjaxBtn').remove();
			}
			else if(res.approvedStatus==null && currentUser==res.taskOwner){
				$('#attachFileAddAjaxBtn').remove();
				$('#statusAjaxBtn').remove();
			}
			else{
				if(res.approvedStatus==null){
					$('#attachFileAddAjaxBtn').remove();
					$('#statusAjaxBtn').remove();
				}
				else {
					$('#approvedAjaxBtn').remove();
					$('#rejectAjaxBtn').remove();
				}
			}
			

			$.each(res.attachments, function (index, file) {
	            $("#selectedAttach").append($('<td/>').html("<a href=\"/drcms/fileController/get/"+file.id+"\">"+file.fileName+"</a>"));
	        }); 
			
		},
		error: function() {
			alert("error");
		}
	});


//Dialog
//for Assign add in CustomerService
$("#changeAssigneeDialog").dialog({
    autoOpen: false,
    modal: true,
	width: '520', height: '450',
    buttons: {
        "Assign": function() {
            $.ajax({
            	url: "/drcms/onSite/changeAssignee" ,
                type: "POST",
    			dataType: "json",
    			data: $("#changeAssigneeDialog > form").serialize(),
                "success": function(res) {
                	$("#changeAssigneeDialog").dialog("close");
                	window.location.href = '/drcms/onSite/detail?id=' + onsiteOrderId;
                },
                error: function() {
        			alert("error");
        		}
            });
            
        },
		"Cancel": function() {
            $(this).dialog("close");
        }
    }
});

$("#assignAddAjaxBtn").click(function(event) {
    event.preventDefault();
    $("#changeAssigneeDialog").dialog("open");
    $.ajax({
		url: "/drcms/onSite/getAssignees",
		type: "GET",
		dataType: "json",
		success: function(res) {
			dwr.util.removeAllOptions("assigneeOption");
			dwr.util.addOptions( "assigneeOption",res,'account','account');
			$('#changeAssigneeDialog #issueId').val(issueId);
		},
		error: function() {
			alert("error");
		}
	});
});

$("#approvedAjaxBtn").click(function(event) {
    event.preventDefault();
    $.ajax({
		url: "/drcms/onSite/changeApprovedStatus/"+ onsiteOrderId,
		type: "GET",
		dataType: "json",
		data:{"status" : 'APPROVED'},
		success: function(res) {
			window.location.href = '/drcms/onSite/detail?id=' + onsiteOrderId;
		},
		error: function() {
			alert("error");
		}
	});
});

$("#rejectAjaxBtn").click(function(event) {
    event.preventDefault();
    $.ajax({
		url: "/drcms/onSite/changeApprovedStatus/"+ onsiteOrderId,
		type: "GET",
		dataType: "json",
		data:{"status" : 'REJECT'},
		success: function(res) {
			window.location.href = '/drcms/onSite/detail?id=' + onsiteOrderId;
		},
		error: function() {
			alert("error");
		}
	});
});

$("#statusAjaxBtn").click(function(event) {
    event.preventDefault();
    $("#resolveIssueAddDialog").dialog("open");
    
});


//for Attachment add in CustomerService
$("#attachFileAddDialog").dialog({
    autoOpen: false,
    modal: true,
	width: '600', height: '470'
});

$("#attachFileAddAjaxBtn").click(function(event) {
    event.preventDefault();

    $("#attachFileAddDialog").dialog("open");
});


//for Resolve Issue add in CustomerService
$("#resolveIssueAddDialog").dialog({
    autoOpen: false,
    modal: true,
	width: '800', height: '570',
    buttons: {
    	"Save": function() {
            $.ajax({
                url: "/drcms/onSite/onsiteResponse",
                type: "POST",
    			dataType: "json",
    			data: $("#resolveIssueAddDialog > form").serialize(),
                success: function(res) {
                    $("#resolveIssueAddDialog").dialog("close");
                    window.location.href = '/drcms/onSite/detail?id=' + onsiteOrderId;
                }
            });
        },
		"Cancel": function() {
            $(this).dialog("close");
        }
    }
    

});


//For legend UI...
$("legend").toggleClass("tableShowStyle");

//For Hide and Show action...
$("legend").click(function(){
	var tableObj = $(this).next("table");
	var fff = $(this).parent();
	tableObj.toggle("slow",			
		function(){				
			if (tableObj.is(':visible')) {
				fff.css("border-bottom-width","1px");
				fff.css("border-right-width","1px");
				fff.css("border-left-width","1px");
				fff.children('legend').attr("class", "tableShowStyle");
				
			}else{
				fff.children('legend').attr("class", "tableHideStyle");
				fff.css("border-bottom-width","0px");
				fff.css("border-right-width","0px");
				fff.css("border-left-width","0px");
			}
		}
	); 
});

});


</script>


<h1 class="contentTitle" style="margin-bottom: 5px;">外出單  <label id="id"></label>: <label id="summary"></label></h1>
<div align="center">
	
	<div class="CSSTableGenerator" >
		<table id="mainTable">
            <thead id="mainTableHead" >
            <tr>
                <th colspan="2" style="text-align:left;padding: 0px 0px 0px 0px;">
					<input name="" type="button" class="JQbtn" value="同意" id="approvedAjaxBtn">
					<input name="" type="button" class="JQbtn" value="拒絕" id="rejectAjaxBtn">
					<input name="" type="button" class="JQbtn" value="附件" id="attachFileAddAjaxBtn">
					<input name="" type="button" class="JQbtn" value="處理結果" id="statusAjaxBtn">
				</th>
			</tr>
            </thead>
            <tr>
                <td width="50%">
					<fieldset>
						<legend><span>資訊</span></legend>
						<table id="mainTable">
							<tr><td align="left">客戶名稱：</td><td><label id="customer.customerName"></label></td></tr>
							<tr><td align="left">聯絡人：</td><td><label id="contactName"></label></td></tr>
							<tr><td align="left">聯絡電話：</td><td><label id="contactPhone"></label></td></tr>
							<tr><td align="left">聯絡手機：</td><td><label id="contactCell"></label></td></tr>
							<tr><td align="left">地址：</td><td><label id="address"></label></td></tr>
							<tr><td align="left">處理狀態：</td><td><label id="resolutionStatus"></label></td></tr>
							<tr><td align="left">核准狀態：</td><td><label id="approvedStatus"></label></td></tr>
							<tr><td align="left">機器序號：</td><td><label id="goodsSn"></label></td></tr>
						</table>
					</fieldset>
					
					<fieldset>
						<legend><span>問題描述</span></legend>
						<table id="mainTable">
							<tr><td align="left"><textarea name="description" id="description" cols="50" rows="3" readonly></textarea></td></tr>
						</table>
					</fieldset>
					<fieldset>
						<legend><span>現場建議處理步驟</span></legend>
						<table id="mainTable">
							<tr><td align="left"><textarea name="onsiteCommand" id="onsiteCommand" cols="50" rows="3" readonly></textarea></td></tr>
						</table>
					</fieldset>
				</td>
                <td  style="vertical-align:text-top;" >
					<fieldset>
						<legend><span>People</span></legend>
						<table id="mainTable">
							<tr><td align="left">處理人員：</td><td><label id="assignee"></label>&nbsp;&nbsp;&nbsp;&nbsp;<input name="" type="button" class="JQbtn" value="變更處理人員" id="assignAddAjaxBtn"></td></tr>
							<tr><td align="left">回報人員：</td><td><label id="reporter"></label></td></tr>
						</table>
					</fieldset>
					
					<fieldset>
						<legend><span>Date</span></legend>
						<table id="mainTable">
							<tr><td align="left">到現場時間：</td><td><label id="onsiteDate"></label></td></tr>
							<tr><td align="left">處理期限：</td><td><label id="dueDate"></label></td></tr>
						</table>
					</fieldset>
					
					<fieldset>
						<legend id="attachmentLegend"><span>附件</span></legend>
						<table id="mainTable">
								<tr id="selectedAttach">
				        		</tr>
						</table>
					</fieldset>
				</td>
            </tr>
         </table>
	</div>
</div>


<!-- Dialog Content -->
<div id="changeAssigneeDialog" title="更換處理人員" >
<form>
	<fieldset>
		<table align="center" >
			<tr><td align="left">處理人員：</td>
				<td><select id="assigneeOption" name="assignee"></select>
				<input name="issueId" id="issueId" type="hidden">
				<input name="onsiteOrderId" id="onsiteOrderId" type="hidden" value="<%=request.getParameter("id") %>">
			</td></tr>
			<tr><td align="left">更換理由：</td><td><textarea rows="10" cols="30"></textarea></td></tr>
		</table>    
	</fieldset>
</form>
</div>

<div id="attachFileAddDialog" title="附件上傳" >
<form>
	<fieldset>
		<table align="center" >
			<tr><td align="left">附件：</td><td><input id="fileupload" type="file" name="files[]">
			</td></tr>
		</table>    
	</fieldset>
</form>
</div>

<div id="resolveIssueAddDialog" title="處理方式描述" >
<form>
	<fieldset>
		<table align="center">
			<tr><td align="left">處理結果：</td>
				<td>
					<select name="resolutionStatus">
						<option value="FIXED">問題已解決</option>
						<option value="NOT_FIXED">仍有問題</option>
					</select>
				</td>
			</tr>
			<tr><td align="left">花費時間：</td>
				<td>
					<input name="workPeriod" id="workPeriod" type="text" >(eg. 2w, 1d, 23h)
					<input name="id" type="hidden" value="<%=request.getParameter("id") %>">
				</td>
			</tr>
			<tr>
				<td align="left">處理方式描述.：(請描述料件更換方式)</td>
				<td>
					<textarea name="onsiteResponse" id="onsiteResponse" rows="10" cols="30"></textarea>
				</td>
			</tr>
		</table>
	</fieldset>
</form>
</div>
