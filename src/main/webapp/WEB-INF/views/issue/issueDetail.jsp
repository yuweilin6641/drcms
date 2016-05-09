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
var issueId = <%=request.getParameter("id") %>;
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

$(window).load(function() {
	
	$.ajax({
		url: "/drcms/issue/get/"+ issueId,
		type: "GET",
		dataType: "json",
		success: function(res) {
			
			$.each(res.onsiteOrders, function (index, onsiteOrder) {
				if(onsiteOrder.approvedStatus==null && res.assignee==currentUser && res.currentTask=='onSiteConfirm'){
					window.location.href = '/drcms/onSite/detail?id=' + onsiteOrder.id;
				}
				else if(onsiteOrder.resolutionStatus=='OPEN' && res.assignee==currentUser && res.currentTask=='responseOnSiteTask'){
					window.location.href = '/drcms/onSite/detail?id=' + onsiteOrder.id;
				}
			});
			
			dwr.util.setValues(objectEval(JSON.stringify(res)));

			

			

			
			$('#createDate').text(formatJsonDate(res.createDate));
			$('#dueDate').text(formatJsonDate(res.dueDate));
			$('#updateDate').text(formatJsonDate(res.updateDate));
			
			var nowDate = new Date().getTime();
			if(nowDate>res.dueDate){
				$('#dueDate').css('color','red');
			}
			
			if(currentUser!=res.reporter){
				$('#changeAssigneeBtn').remove();
			}

			if(res.issueStatus.id=='RESOLVED'){
				$('#assignAddAjaxBtn').remove();
				$('#statusAjaxBtn').remove();
				$('#createOnSiteOrderAjaxBtn').remove();
				$('#changeAssigneeBtn').remove();
				$('#workLogAddAjaxBtn').remove();
				$('#attachFileAddAjaxBtn').remove();
				$('#createOnSiteOrderAjaxBtn').remove();
			}
			else if(currentUser!=res.assignee){
				$('#assignAddAjaxBtn').remove();
				$('#statusAjaxBtn').remove();
				$('#createOnSiteOrderAjaxBtn').remove();
			}
			else{
				if(res.currentTask!='initiatorDiagnostic'){
					$('#assignAddAjaxBtn').remove();
				}
				
				if(res.currentTask!='onDutyTask'){
					$('#createOnSiteOrderAjaxBtn').remove();
				}
				else{
					$('#assignAddAjaxBtn').remove();
				}
				
				if(res.currentTask=='onSiteConfirm' || res.currentTask=='responseOnSiteTask'){
					$('#changeAssigneeBtn').remove();
				}
				
				if(res.issueStatus.id=='OPEN'){
					$('#statusAjaxBtn').val("開始處理");
				}
				else if(res.issueStatus.id=='IN_PROGRESS'){
					$('#statusAjaxBtn').val("已解決");
				}
			}
			
			
			
			
			$.each(res.issueAttachments, function (index, file) {
	            $("#selectedAttach").append($('<td/>').html("<a href=\"/drcms/fileController/get/"+file.id+"\">"+file.fileName+"</a>"));
	        }); 
			
			$.each(res.issueWorklogs, function (index, worklog) {
				$("#worklogField > table").append($('<tr/>')
		       			 .append($('<td/>').text(worklog.userAccount))
		       			 .append($('<td/>').text(worklog.workPeriod))
		       			 .append($('<td/>').text(worklog.commentInfo))
		       			 .append($('<td/>').text(formatJsonDate(worklog.workDate)))
		       			 );
			});

			$.each(res.onsiteOrders, function (index, onsiteOrder) {
				var htmlPrint = "";
				if(onsiteOrder.approvedStatus==null){
					htmlPrint = " &nbsp;<span style='color:red'>待審核!!!</span>";
					
				}
				$("#onsiteField > table").append($('<tr/>')
						 .append($('<td/>').html("<a href=\"/drcms/onSite/detail?id="+onsiteOrder.id+"\">"+onsiteOrder.id+"</a>"+ htmlPrint))
		       			 .append($('<td/>').text(onsiteOrder.assignee))
		       			 .append($('<td/>').text(onsiteOrder.onsiteCommand))
		       			 .append($('<td/>').text(formatJsonDate(onsiteOrder.onsiteDate)))
		       			 );
			});
			
			$("#attachmentLegend").toggleClass("tableHideStyle");
			
		},
		error: function() {
			alert("error");
		}
	});
});

$(document).ready(function(){

	$('#fileupload').fileupload({
	    dataType: 'json',
	    
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

//Dialog
//for Assign add in CustomerService
$("#assignAddDialog").dialog({
    autoOpen: false,
    modal: true,
	width: '520', height: '450',
    buttons: {
        "Assign": function() {
            $.ajax({
            	url: "/drcms/issue/assignNext" ,
                type: "POST",
    			dataType: "json",
    			data: $("#assignAddDialog > form").serialize(),
                "success": function(res) {
                	$("#assignAddDialog").dialog("close");
                	window.location.href = '/drcms/issue/detail?id=' + issueId;
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
    $("#assignAddDialog").dialog("open");
    $.ajax({
		url: "/drcms/issue/getAssignees",
		type: "GET",
		dataType: "json",
		success: function(res) {
			dwr.util.removeAllOptions("assigneeOption");
			dwr.util.addOptions( "assigneeOption",res,'account','account');
		},
		error: function() {
			alert("error");
		}
	});
});

$("#changeAssigneeDialog").dialog({
    autoOpen: false,
    modal: true,
	width: '520', height: '450',
    buttons: {
        "Assign": function() {
            $.ajax({
            	url: "/drcms/issue/changeAssignee" ,
                type: "POST",
    			dataType: "json",
    			data: $("#changeAssigneeDialog > form").serialize(),
                "success": function(res) {
                	$("#changeAssigneeDialog").dialog("close");
                	window.location.href = '/drcms/issue/detail?id=' + issueId;
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


$("#changeAssigneeBtn").click(function(event) {
    event.preventDefault();
    $("#changeAssigneeDialog").dialog("open");
    $.ajax({
		url: "/drcms/issue/getAssignees",
		type: "GET",
		dataType: "json",
		success: function(res) {
			dwr.util.removeAllOptions("changeAssigneeOption");
			dwr.util.addOptions( "changeAssigneeOption",res,'account','account');
		},
		error: function() {
			alert("error");
		}
	});
});

//for Work Log add in CustomerService
$("#workLogAddDialog").dialog({
    autoOpen: false,
    modal: true,
	width: '620', height: '450',
    buttons: {
        "Save": function() {
            $.ajax({
                url: "/drcms/issue/addWorklog",
                type: "POST",
    			dataType: "json",
    			data: $("#workLogAddDialog > form").serialize(),
                success: function(res) {
                	$("#worklogField > table").append($('<tr/>')
                			 .append($('<td/>').text(res.userAccount))
                			 .append($('<td/>').text(res.workPeriod))
                			 .append($('<td/>').text(res.commentInfo))
                			 .append($('<td/>').text(formatJsonDate(res.workDate)))
                			 );
                    $("#workLogAddDialog").dialog("close");
                }
            });
        },
		"Cancel": function() {
            $(this).dialog("close");
        }
    }
});

$("#workLogAddAjaxBtn").click(function(event) {
    event.preventDefault();
    $("#workLogAddDialog").dialog("open");
});

$("#statusAjaxBtn").click(function(event) {
    event.preventDefault();
    var buttonValue = $('#statusAjaxBtn').val();
    if(buttonValue=='開始處理'){
    	$.ajax({
    		url: "/drcms/issue/changeStatus/"+ issueId,
    		type: "GET",
    		dataType: "json",
    		data:{"buttonValue" : 'Start Progress'},
    		success: function(res) {
    			window.location.href = '/drcms/issue/detail?id=' + issueId;
    		},
    		error: function() {
    			alert("error");
    		}
    	});
    }
    else if (buttonValue=='已解決'){
    	$("#resolveIssueAddDialog").dialog("open");
    }
    
    
    
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
	width: '650', height: '570',
    buttons: {
        "Resolve": function() {
            $.ajax({
                url: "/drcms/issue/resolvedIssue",
                type: "POST",
    			dataType: "json",
    			data: $("#resolveIssueAddDialog > form").serialize(),
                success: function(res) {
                	window.location.href = '/drcms/issue/detail?id=' + issueId;
                }
            });
        },
		"Cancel": function() {
            $(this).dialog("close");
        }
    }
});

//for Create On Site Order add in CustomerService
$("#createOnSiteOrderDialog").dialog({
    autoOpen: false,
    modal: true,
	width: '650', height: '680',
    buttons: {
    	"Save": function() {
    		if($("#createOnSiteOrderDialog > form").valid()){
            $.ajax({
            	url: "/drcms/issue/addOnsiteOrder" ,
                type: "POST",
    			dataType: "json",
    			data: $("#createOnSiteOrderDialog > form").serialize(),
                "success": function(res) {
                	$("#createOnSiteOrderDialog").dialog("close");
                	window.location.href = '/drcms/issue/detail?id=' + issueId;
                },
                error: function() {
        			alert("error");
        		}
            });
    		}
            
        },
		"Cancel": function() {
            $(this).dialog("close");
        }
    }
});

$("#createOnSiteOrderAjaxBtn").click(function(event) {
    event.preventDefault();
    $("#createOnSiteOrderDialog > form").validate();
    $.ajax({
		url: "/drcms/issue/getAssignees",
		type: "GET",
		dataType: "json",
		success: function(res) {
			dwr.util.removeAllOptions("onSiteAssigneeOption");
			dwr.util.addOptions( "onSiteAssigneeOption",res,'account','account');
		},
		error: function() {
			alert("error");
		}
	});
    
    $('#createOnSiteOrderDialog #onSiteContactName').val($('#contactName').text());
    $('#createOnSiteOrderDialog #onSiteContactPhone').val($('#contactPhone').text());
    $('#createOnSiteOrderDialog #onSiteContactCell').val($('#contactCell').text());
    $('#createOnSiteOrderDialog #onSiteDueDate').val($('#dueDate').text());
    $('#createOnSiteOrderDialog #onSiteAddress').val($('#address').text());
    $('#createOnSiteOrderDialog #onSiteWarrantyType').val($('#warrantyType').text());
    $('#createOnSiteOrderDialog #onSiteGoodsSn').val($('#goodsSn').text());
    
    $('#createOnSiteOrderDialog #onSiteSummary').val($('#summary').text());
    $('#createOnSiteOrderDialog #onSiteReporter').val($('#reporter').text());
    $('#createOnSiteOrderDialog #onSiteDescription').val($('#description').val());
    
    $('#onSiteOnSiteDate').datetimepicker({ dateFormat:"yy-mm-dd" });
	
    $("#createOnSiteOrderDialog").dialog("open");
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


<h1 class="contentTitle" style="margin-bottom: 5px;">客服單  <label id="id"></label>: <label id="summary"></label></h1>
<div align="center">
	
	<div class="CSSTableGenerator" >
		<table id="mainTable">
            <thead id="mainTableHead" >
            <tr>
                <th colspan="2" style="text-align:left;padding: 0px 0px 0px 0px;">
					<input name="" type="button" class="JQbtn" value="轉工程師處理" id="assignAddAjaxBtn">
					<input name="" type="button" class="JQbtn" value="工作紀錄" id="workLogAddAjaxBtn">
					<input name="" type="button" class="JQbtn" value="附件" id="attachFileAddAjaxBtn">
					<input name="" type="button" class="JQbtn" value="開始處理" id="statusAjaxBtn">
					<input name="" type="button" class="JQbtn" value="建立外出單" id="createOnSiteOrderAjaxBtn">
				</th>
			</tr>
            </thead>
            <tr>
                <td width="50%">
					<fieldset>
						<legend><span>Detail</span></legend>
						<table id="mainTable">
							<tr><td align="left">客戶名稱：</td><td><label id="customer.customerName"></label></td></tr>
							<tr><td align="left">Priority：</td><td><label id="issuePriority.name"></label></tr>
							<tr><td align="left">狀態：</td><td><label id="issueStatus.statusName"></label></td></tr>
							<tr><td align="left">問題類別：</td><td><label id="issueType.subDesc"></label></td></tr>
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
						<legend><span>環境描述</span></legend>
						<table id="mainTable">
							<tr><td align="left"><textarea name="environment" id="environment" cols="50" rows="3" readonly></textarea></td></tr>
						</table>
					</fieldset>
					
					<fieldset>
						<legend id="attachmentLegend"><span>附件</span></legend>
						<table id="mainTable">
								<tr id="selectedAttach">
				        		</tr>
						</table>
					</fieldset>
					
					<fieldset id="worklogField">
						<legend><span>工作紀錄</span></legend>
						<table id="mainTable">
						    <thead>
								<tr>
									<th>User</th>
									<th>time spent</th>
									<th>Comments</th>
									<th>date</th>
				        		</tr>
				     </thead>
						</table>
					</fieldset>
				</td>
                <td  style="vertical-align:text-top;" >
					<fieldset id="onsiteField">
						<legend><span>外出單</span></legend>
						<table id="mainTable">
						    <thead>
								<tr>
									<th>id</th>
									<th>指派人</th>
									<th>處理方式</th>
									<th>date</th>
				        		</tr>
				     </thead>
						</table>
					</fieldset>
					<fieldset>
						<legend><span>People</span></legend>
						<table id="mainTable">
							<tr><td align="left">處理人員：</td><td><label id="assignee"></label>&nbsp;&nbsp;&nbsp;&nbsp;<input name="" type="button" class="JQbtn" value="變更" id="changeAssigneeBtn"></td></tr>
							<tr><td align="left">回報人員：</td><td><label id="reporter"></label></td></tr>
						</table>
					</fieldset>
					
					<fieldset>
						<legend><span>Date</span></legend>
						<table id="mainTable">
							<tr><td align="left">建立時間：</td><td><label id="createDate"></label></td></tr>
							<tr><td align="left">處理期限：</td><td><label id="dueDate"></label></td></tr>
							<tr><td align="left">更新時間：</td><td><label id="updateDate"></label></td></tr>
						</table>
					</fieldset>
					<fieldset>
						<legend><span>聯絡方式</span></legend>
						<table id="mainTable">
							<tr><td align="left">來電人員：</td><td><label id="callerName"></label></td></tr>
							<tr><td align="left">來電電話：</td><td><label id="callerPhone"></label></td></tr>
							<tr><td align="left">聯絡人員：</td><td><label id="contactName"></label></td></tr>
							<tr><td align="left">聯絡電話：</td><td><label id="contactPhone"></label></td></tr>
							<tr><td align="left">聯絡手機：</td><td><label id="contactCell"></label></td></tr>
							<tr><td align="left">地址：</td><td><label id="address"></label></td></tr>
						</table>
					</fieldset>
					
				</td>
            </tr>
         </table>
	</div>
</div>


<!-- Dialog Content -->
<div id="assignAddDialog" title="更換處理人員" >
<form>
	<fieldset>
		<table align="center" >
			<tr><td align="left">處理人員：</td>
				<td><select id="assigneeOption" name="assignee"></select>
				<input name="issueId" id="issueId" type="hidden" value="<%=request.getParameter("id") %>">
			</td></tr>
			<tr><td align="left">建議：</td><td><textarea rows="10" cols="30" id="comment" name="comment"></textarea></td></tr>
		</table>    
	</fieldset>
</form>
</div>

<div id="changeAssigneeDialog" title="更換處理人員" >
<form>
	<fieldset>
		<table align="center" >
			<tr><td align="left">處理人員：</td>
				<td><select id="changeAssigneeOption" name="assignee"></select>
				<input name="issueId" id="issueId" type="hidden" value="<%=request.getParameter("id") %>">
			</td></tr>
			<tr><td align="left">建議：</td><td><textarea rows="10" cols="30"></textarea></td></tr>
		</table>    
	</fieldset>
</form>
</div>

<div id="workLogAddDialog" title="工作紀錄" >
<form>
	<fieldset>
		<table align="center">
			<tr><td align="left">花費時間：</td><td><input name="workPeriod" id="workPeriod" type="text" >(eg. 2w, 1d, 23h)</td></tr>
			<tr>
				<td align="left">工作描述：</td>
				<td>
					<textarea name="commentInfo" id="commentInfo" rows="10" cols="30"></textarea>
					<input name="issueId" id="issueId" type="hidden" value="<%=request.getParameter("id") %>">
					<input name="userAccount" id="userAccount" type="hidden" value="<%= session.getAttribute("LOGIN_ACCOUNT") %>">
				</td>
			</tr>
			
		</table>    
	</fieldset>
</form>
</div>

<div id="attachFileAddDialog" title="附件上傳" >
<form>
	<fieldset>
		<table align="center" >
			<tr><td align="left">附件：</td><td><input id="fileupload" type="file" name="files[]" data-url="/drcms/issue/uploadFile?issueId=<%=request.getParameter("id") %>"></td></tr>
		</table>    
	</fieldset>
</form>
</div>

<div id="resolveIssueAddDialog" title="問題處理方式記錄" >
<form>
	<fieldset>
		<table align="center">
			<tr><td align="left">花費時間：</td>
				<td>
					<input name="workPeriod" id="workPeriod" type="text" >(eg. 2w, 1d, 23h)
					<input name="issueId" type="hidden" value="<%=request.getParameter("id") %>">
				</td>
			</tr>
			<tr>
				<td align="left">處理方式描述.：</td>
				<td>
					<textarea name="commentInfo" id="commentInfo" rows="10" cols="30"></textarea>
				</td>
			</tr>
		</table>
	</fieldset>
</form>
</div>

<div id="createOnSiteOrderDialog" title="建立到場服務單" >
<form>
	<fieldset>
	<table align="center" >
	
	<tr><td align="left" width="40%">指派人員：</td>
		<td width="60%"><select id="onSiteAssigneeOption" name="assignee"></select>
		<input name="issueId" id="issueId" type="hidden" value="<%=request.getParameter("id") %>">
		<input name="summary" id="onSiteSummary" type="hidden">
		<input name="reporter" id="onSiteReporter" type="hidden">
		<input name="description" id="onSiteDescription" type="hidden">
		<input name="customerId" id="customer.id" type="hidden">
	</td></tr>
	<tr><td align="left" width="40%">*聯絡人姓名：</td><td><input name="contactName" id="onSiteContactName" type="text" class="required"></td></tr>
	<tr><td align="left" width="40%">*聯絡人電話：</td><td><input name="contactPhone" id="onSiteContactPhone" type="text" class="required"></td></tr>
	<tr><td align="left" width="40%">*聯絡人手機：</td><td><input name="contactCell" id="onSiteContactCell" type="text" class="required"></td></tr>
	<tr><td align="left" width="40%">*計畫處理方式：</td><td><textarea name="onsiteCommand" id="onsiteCommand" rows="6" cols="30" class="required"></textarea></td></tr>
	<tr><td align="left" width="40%">*到場維修時間：</td><td><input name="onSiteDate" id="onSiteOnSiteDate" type="text" class="required"></td></tr>		
	<tr><td align="left" width="40%">*維修地址：</td><td><input name="address" id="onSiteAddress" type="text" size="40" class="required"></td></tr>
	<tr><td align="left" width="40%">處理期限：</td><td><input name="dueDate" id="onSiteDueDate" type="text" ></td></tr>
	<tr><td align="left" width="40%">機器序號：</td><td><input name="goodsSn" id="onSiteGoodsSn" type="text" ></td></tr>
	<tr><td align="left" width="40%">保固類型：</td><td><input name="warrantyType" id="onSiteWarrantyType" type="text" ></td></tr>
	</table>
	</fieldset>
</form>
</div>
