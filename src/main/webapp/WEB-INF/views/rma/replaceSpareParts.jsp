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
		       			 .append($('<td/>').text(failParts.machineSN))
		       			 .append($('<td/>').html('<input type=\"text\" id=\"rmaFailParts_partsNo_'+index+ '\" name=\"rmaFailParts_partsNo\">'))
		       			 .append($('<td/>').html('<input type=\"text\" id=\"rmaFailParts_partsSN_'+index+ '\" name=\"rmaFailParts_partsSN\">'))
		       			 .append($('<td/>').html('<input type=\"button\" value=\"Choose Replacement\" onclick=\"inputReplacement(\''+index+'\')\"> '))
		       			 );
	        }); 
			
			$.each(res.rmaWorklogs, function (index, worklog) {
				$("#worklogField > table").append($('<tr/>')
		       			 .append($('<td/>').text(worklog.userAccount))
		       			 .append($('<td/>').text(worklog.workPeriod))
		       			 .append($('<td/>').text(worklog.commentInfo))
		       			 .append($('<td/>').text(formatJsonDate(worklog.workDate)))
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
            	url: "/drcms/rma/assignNext" ,
                type: "POST",
    			dataType: "json",
    			data: $("#assignAddDialog > form").serialize(),
                "success": function(res) {
                	$("#assignAddDialog").dialog("close");
                	window.location.href = '/drcms/rma/detail?id=' + issueId;
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
		url: "/drcms/rma/getAssignees",
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
            	url: "/drcms/rma/changeAssignee" ,
                type: "POST",
    			dataType: "json",
    			data: $("#changeAssigneeDialog > form").serialize(),
                "success": function(res) {
                	$("#changeAssigneeDialog").dialog("close");
                	window.location.href = '/drcms/rma/detail?id=' + issueId;
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
		url: "/drcms/rma/getAssignees",
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
                url: "/drcms/rma/addWorklog",
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

$("#sparePartsAjaxBtn").click(function(event) {
    event.preventDefault();
    window.location.href = '/drcms/rma/replaceSpareParts?id=' + issueId;
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
                url: "/drcms/rma/resolvedIssue",
                type: "POST",
    			dataType: "json",
    			data: $("#resolveIssueAddDialog > form").serialize(),
                success: function(res) {
                	window.location.href = '/drcms/rma/detail?id=' + issueId;
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
            	url: "/drcms/rma/addOnsiteOrder" ,
                type: "POST",
    			dataType: "json",
    			data: $("#createOnSiteOrderDialog > form").serialize(),
                "success": function(res) {
                	$("#createOnSiteOrderDialog").dialog("close");
                	window.location.href = '/drcms/rma/detail?id=' + issueId;
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
		url: "/drcms/rma/getAssignees",
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

//initial page
$.ajax({
	url: "/drcms/configurationMaintain/initialPageJson",
	type: "GET",
	dataType: "json",
	success: function(res) {
		dwr.util.addOptions("goodsTypesOption",res.goodsTypes,'id','goodsTypeName');
	}
});

//option lock in add node dialog
var nobj = [];
var goodsRes = null;
$("#goodsTypesOption").change(function() {
	if($( "#goodsTypesOption" ).val()!=-1){

		$.ajax({
    		url: "/drcms/configurationMaintain/getFreeGoodsListbyTypeId/" + $( "#goodsTypesOption" ).val(),
    		type: "GET",
    		success: function(res) {
    			goodsRes = res;
    			dwr.util.removeAllOptions("parts");
    			dwr.util.removeAllOptions("partsSN");

    			var nres = [];
    			nobj = [];
    			for(var i=0;i<res.length;i++){
    				if($.inArray(res[i].parts.id, nres) == -1){
    					nres.push(res[i].parts.id);
    					nobj.push(res[i].parts);
    				}
    			}
    			
    			dwr.util.addOptions("parts", nobj, "id", "description");
    			$("#insertNodeDialog #parts").change();
    		},
    		error: function() {
    			alert("ERROR!!!");
    		}
    	});
	}else{
		$("#insertNodeDialog #parts").prop('disabled', true);
		$("#insertNodeDialog #id").prop('disabled', true);
		dwr.util.removeAllOptions("parts");
	}


});


$("#insertNodeDialog #parts").change(function() {
	if($("#insertNodeDialog #parts").val()!=-1){
		dwr.util.removeAllOptions("partsSN");
		var goods = [];
		for(var i = 0;i<goodsRes.length;i++){
			if(goodsRes[i].parts.id == $(this).val())goods.push(goodsRes[i]);
		}
		dwr.util.addOptions("partsSN", goods, "id", "id");
		$("#insertNodeDialog #id").prop('disabled', false);
	}else{
		$("#insertNodeDialog #id").prop('disabled', true);
	}
});

 $("#insertNodeDialog").dialog({
    autoOpen: false,
    modal: true,
	width: 400, height: 250,
    buttons: {

        "Choose": function() {
        	$('#rmaFailParts_partsNo_'+repairIndex).val($("#insertNodeDialog #parts").val());
        	$('#rmaFailParts_partsSN_'+repairIndex).val($("#insertNodeDialog #partsSN").val());
        	$(this).dialog("close");
        },
		"Cancel": function() {
            $(this).dialog("close");
        }
    }
});


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
									<th>id</th>
									<th>parts</th>
									<th>sn</th>
									<th>Replace parts</th>
									<th>Replace SN</th>
									<th>Action</th>
				        		</tr>
				     </thead>
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


<div id="insertNodeDialog" title="新增新料件" style="display:none;" >
<form>
	<fieldset>
	<table>
		<tr><td align="left">Type：</td><td><select id="goodsTypesOption" name="goodsTypesOption">
		</select></td></tr>
		<tr><td align="left">Parts Name：</td><td><select name="parts" id="parts" >
		</select></td></tr>
		<tr><td align="left">S/N：</td><td><select name="partsSN" id="partsSN" >
		</select></td></tr>
		<tr><td><input type="hidden" id="parentSn" name="parentSn"></td></tr>
	</table>
	</fieldset>
</form>
<div id='msgDiv' style="display: none; "><font color=red>此料件下無法新增料件</font></div>
</div>

<div id="attachFileAddDialog" title="附件上傳" >
<form>
	<fieldset>
		<table align="center" >
			<tr><td align="left">附件：</td><td><input id="fileupload" type="file" name="files[]" data-url="/drcms/rma/uploadFile?issueId=<%=request.getParameter("id") %>"></td></tr>
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
