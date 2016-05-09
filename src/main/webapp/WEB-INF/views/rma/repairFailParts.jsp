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
var repairIndex = '';

function snformatter(obj) { return obj.id+ "｜" + obj.parts.description; }
function pnformatter(obj) { return obj.id+ "｜" + obj.parts.description; }

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
		url: "/drcms/rma/get/"+ issueId,
		type: "GET",
		dataType: "json",
		success: function(res) {

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

			if(res.rmaStatus.id=='RESOLVED'){
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
				
				if(res.rmaStatus.id=='OPEN'){
					$('#statusAjaxBtn').val("開始處理");
				}
				else if(res.rmaStatus.id=='IN_PROGRESS'){
					$('#statusAjaxBtn').val("已解決");
				}
			}
			
			
			
			
			$.each(res.rmaAttachments, function (index, file) {
	            $("#selectedAttach").append($('<td/>').html("<a href=\"/drcms/fileController/get/"+file.id+"\">"+file.fileName+"</a>"));
	        }); 
			
			$.each(res.rmaFailParts, function (index, failParts) {
				$("#repairField > table").append($('<tr id=\"'+index+'\"/>')
		       			 .append($('<td/>').text(failParts.partsNo))
		       			 .append($('<td/>').text(failParts.failPartsSN))
		       			 .append($('<td/>').text(failParts.failPartsSN))
		       			 .append($('<td/>').html('<select id=\"wiwynnCommit_'+index+ '\" name=\"wiwynnCommit\"><option value=\"repair\">repair</option><option value=\"scarp\">scarp</option></select>'))
		       			 .append($('<td/>').html('<input type=\"text\" value=\"\" id=\"reason\"> '))
		       			 .append($('<td/>').html('<select id=\"repairStatus_'+index+ '\" name=\"repairStatus\"><option value=\"repairing\">repairing</option><option value=\"fixed\">fixed</option><option value=\"can not fixed\">can not fixed</option></select>'))
		       			 
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

$("#issueDataAddAjaxAddBtn").click(function(event) {
    event.preventDefault();
    var buttonValue = $('#statusAjaxBtn').val();
    if(buttonValue=='開始處理'){
    	$.ajax({
    		url: "/drcms/rma/changeStatus/"+ issueId,
    		type: "GET",
    		dataType: "json",
    		data:{"buttonValue" : 'Start Progress'},
    		success: function(res) {
    			window.location.href = '/drcms/rma/detail?id=' + issueId;
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

//For legend UI...
$("legend").toggleClass("tableShowStyle");

});

function inputReplacement(index){
	repairIndex = index;
	$("#insertNodeDialog").dialog("open");
	//dwr.util.removeAllOptions("goodsTypesOption");
	//$('#goodsTypesOption').change();
}



</script>


<h1 class="contentTitle" style="margin-bottom: 5px;">RMA  <label id="id"></label>: <label id="summary"></label></h1>
<div align="center">
	
	<div class="CSSTableGenerator" >
		<table id="mainTable">
            <tr>
                <td  style="vertical-align:text-top;" >
					<fieldset id="repairField">
						<legend><span>fail parts</span></legend>
						<table id="mainTable">
						    <thead>
								<tr>
									<th>Type</th>
									<th>parts</th>
									<th>sn</th>
									<th>status</th>
									<th>Wiwynn Commit</th>
									<th>Wiwynn Reason</th>
									<th>Repair Status</th>
				        		</tr>
				     </thead>
						</table>
					</fieldset>
							
				</td>
            </tr>
         </table>
         <table style="width: 50%; text-align: left;">
            <tr>
				<td align=center>
					<input class="JQbtn" type="button" value="Save" id="issueDataAddAjaxAddBtn" onclick=""> 
					<input class="JQbtn" type="button" value="cancel" id="issueAddCancel" onclick="location.href= ('/drcms/rma');">
				</td>
			</tr>
	</table>  
	</div>
</div>

