<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type='text/javascript' src='/drcms/js/dwr/eval.js'></script>
<script type='text/javascript' src='/drcms/js/dwr/util.js'></script>
<script type='text/javascript' src='/drcms/js/jquery/json2.js'></script>

<script type="text/javascript">
//page java sciprt
var currentUser = '<%= session.getAttribute("LOGIN_ACCOUNT") %>';
//For left click item list...
$(window).load(function(){
	
$(function(){
    $.contextMenu({
        selector: '.issueDataActionList', 
		trigger: 'left',
        callback: function(key, options) { 
			if(key=='showDetail'){
				dIndex = $(this).attr("value");
				location.href='/drcms/issue/detail?id='+dIndex;
			}
        },
        items: {
			"showDetail": {name: "查看明細"}
        }
    });
});



});



$(document).ready(function(){
	$.ajax({
		url: "/drcms/issue/getAssignees",
		type: "GET",
		dataType: "json",
		success: function(res) {
			dwr.util.addOptions( "assignee",res,'account','account');
			dwr.util.setValue('assignee', currentUser);
			$("#queryAjaxBtn").click();
		},
		error: function() {
			alert("error");
		}
	});
	
	

//list all issue data...
$("#queryAjaxBtn").click(function() {
	$(".CSSTableGenerator").removeClass();
	$("#mainTable").attr("id","jqGridTable");
	showTable();
});


//add issue data button click...
$("#issueDataAddAjaxAddBtn").click(function(event) {
    event.preventDefault();
    window.location = "/drcms/issue/add";
});

});


</script>



<h1 class="contentTitle">客服單資料維護</h1>
<div align="center">
	<div class="pageFirstDiv" >
		<table>
			<tr>
                <td class="contentTD">
				<p>客戶名稱：</p>
				<input type="text" id="customerName">
				</td>
				<td class="contentTD">
				<p>Status：</p>
				<select id=issueStatus>
					<option value=""> </option>
					<option value="OPEN">待處理</option>
					<option value="IN_PROGRESS">處理中</option>
					<option value="RESOLVED">已解決</option>
					<option value="CLOSED">已結案</option>
				</select>
				</td>
				<td class="contentTD">
				<p>Assignee：</p>
				<select id="assignee" name="assignee">
					<option value="">全部</option>
				</select>
				</td>
                <td  class="lastTD">
					<input class="JQbtn" type="button" value="查詢" id="queryAjaxBtn" >
					<input class="JQbtn" type="button" value="新增" id="issueDataAddAjaxAddBtn" >
					<input type="hidden" id="tempUrl"  >
				</td>
            </tr>
         </table>
	</div>
	
	<div class="CSSTableGenerator">
		<table id="mainTable">
            <thead id="mainTableHead">
            <TR><th>None</th></TR>
            </thead>
            <tbody id="mainTableBody">
            <tr style="text-align:center;"><td>No Data...</td></tr>
            </tbody>           
			
         </table>
	</div>
	<div id="jqGridPager"></div>
	
</div>

<script type="text/javascript">
	//jQuery(document).ready(function(){
		
	//process url value...
	function processUrl(){
		var tempUrl = $("#tempUrl").val();
	
		url = '?customerName='+$("#customerName").val()+
		'&issueStatus='+$("#issueStatus").val()+
		'&assignee='+$("#assignee").val();
	
		$("#tempUrl").val(url);
	
		if(tempUrl != url){
			url+="&queryChange=true";
		}else{
			url+="&queryChange=false";
		}
			
		return url;
	}	
	function showTable(){
		
		$("#jqGridTable").jqGrid({
		   	url:'issue/list' + processUrl(),
			datatype: "json",
			width:$(window).width()-$(window).width()*0.05,		
			height: '100%',
			loadonce:false,
			//shrinkToFit: true,
		   	colNames:['編號','客戶名稱','問題描述','處理人員','回報人員', '處理狀態', '解決狀態', '建立時間', '處理期限' ,'動作'],
		   	colModel:[
		   		{name:'id',index:'id', width:15, align:"center",sortable:false, formatter:formatIssueId},
		   		{name:'customer.customerName',index:'customerName', width:90,sortable:false},
		   		{name:'summary',index:'summary', width:90,sortable:false},
		   		{name:'assignee',index:'assignee', width:90,sortable:false},
		   		{name:'reporter',index:'reporter', width:90,sortable:false},
		   		{name:'issueStatus.id',index:'issueStatus.id', width:90,sortable:false},
		   		{name:'resolution',index:'resolution', width:90,sortable:false, formatter:formatResolution},
		   		{name:'created',index:'created', width:90,sortable:false, formatter:formatCreateDate},
		   		{name:'dueDate',index:'due', width:90,sortable:false, formatter:formatDueDate},

		   		{name:'action', index:'action', width:20, align:"center", formatter:actionItem}		   		
		   	],
		   	rowNum:15,
		   	//rowList:[10,20,30],
		   	pager: '#jqGridPager',
		   	sortname: 'id',
		    viewrecords: true,
		    sortorder: "desc",
		    onPaging: function(pgButton){ 
				$("#jqGridTable").setGridParam({url:'issue/list' + processUrl()});
			},
		});
		$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
		$("#jqGridTable").setGridParam({url:'issue/list' + processUrl()}).trigger("reloadGrid");
	}
	
	function formatIssueId (cellvalue, options, rowObject){
		return "<a href='/drcms/issue/detail?id="+options.rowId+"'>"+options.rowId+"</a>";
	}
	
	function formatResolution (cellvalue, options, rowObject){
		if(rowObject.issueResolution == null){
			return "UnResolved";
			
		}
		else{
			return rowObject.issueResolution.resolutionName;
		}
	}
	
	function formatCreateDate (cellvalue, options, rowObject){
		if(rowObject.createDate!=null){
			var currentTime = new Date(rowObject.createDate);
			var month = currentTime.getMonth() + 1;
			var day = currentTime.getDate();
			var year = currentTime.getFullYear();
			return year +'-'+month+'-'+day;
		}
		else{
			return "";
		}
	}

	
	function formatDueDate (cellvalue, options, rowObject){
		if(rowObject.dueDate!=null){
			var currentTime = new Date(rowObject.dueDate);
			var month = currentTime.getMonth() + 1;
			var day = currentTime.getDate();
			var year = currentTime.getFullYear();
			return year +'-'+month+'-'+day;
		}
		else{
			return "";
		}
		
	}
	
	function actionItem (cellvalue, options, rowObject){
		return "<img src='/drcms/images/action.png' class='actionImg issueDataActionList' value="+options.rowId+" ></img>";
	}
		
	function turnCsrType (cellvalue, options, rowObject){
		return issueTypeArr[rowObject.issueType];
	}
		
	function turnCsrStatus (cellvalue, options, rowObject){
		return issueStatusArr[rowObject.issueStatus];
	}
</script>
	
	



