<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
.ui-dialog{font-size:14px;}
</style>

<script type="text/javascript">
//page java sciprt
var salesDtlsJson = "";
var pickDtlsJson = "";

//For left click item list...
$(window).load(function(){
	
$(function(){
    $.contextMenu({
        selector: '.salesDataActionList', 
		trigger: 'left', 
        callback: function(key, options) { //function
			if(key=='editMst'){	
				$.ajax({
					url: "/drcms/warrantyModify/getMachineDetail/"+$(this).attr("value"),
					type: "GET",
					dataType: "json",
					success: function(res) {
						dwr.util.setValues(objectEval(JSON.stringify(res)));
					},
					error: function() {
						alert('error');
					}
				}).done(function( data ) {
					$("#salesDataModifyMstDialog").dialog("open");
				});
			}
        },
        items: {
			"editMst": {name: "修改機器保固"}
        }
    });
});

//first load (debug)
$('#queryAjaxBtn').click();
});//]]> 

$(document).ready(function(){
	
//initial page
$.ajax({
	url: "/drcms/warrantyModify/initialPageJson",
	type: "GET",
	dataType: "json",
	success: function(res) {
		dwr.util.addOptions( "warrantyType.id",res.warrantyTypes,'id','id');
	}
});

//list all customer data...
$("#queryAjaxBtn").click(function(event) {
	event.preventDefault();
	$(".CSSTableGenerator").removeClass();
	$("#mainTable").attr("id","jqGridTable");
	showTable();
		
});


//custom validation for option select...
$.validator.addMethod("valueNotEquals", function(value, element, arg){
	return arg != value;
}, "Value must not equal arg.");

$('#modifyForm').validate({
	rules: {
		'sapSalesOrder': { valueNotEquals: "-1" },
		'warrantyType': { valueNotEquals: "-1" },
		'salesManSelect': { valueNotEquals: "-1" }
	},
	messages: {
		'sapSalesOrder': { valueNotEquals: "請選擇一個!!!" },
		'warrantyType': { valueNotEquals: "請選擇一個!!!" },
		'salesManSelect': { valueNotEquals: "請選擇一個!!!" }
	}  
});

//for salesMst Data edit dialog
$("#salesDataModifyMstDialog").dialog({
    autoOpen: false,
    modal: true,
	width: 550, height: 250,
    buttons: {

    	"Save": function() {
    		if($("#modifyForm").valid()){
	        	$.ajax({
	
	        		url: "/drcms/warrantyModify/editSubmitByMachine",
	        		type: "POST",
	        		data: $("#salesDataModifyMstDialog > form").serialize(),
	
	        		success: function(res) {
	        			$('#jqGridTable').trigger( 'reloadGrid' );
	        			//$("#queryAjaxBtn").click(); //refresh
	        		},
	        		error: function() {
	        			alert("ERROR!!!");
	        		}
	
	        	}).done(function( data ) {
					$("#salesDataModifyMstDialog").dialog("close");
				});
    		}
        },
		"Cancel": function() {
            $(this).dialog("close");
        }
    }
});

});


//jqGridTable code...
function showTable(){
	cindex = 0;
	dindex = 0;
	
	//sales mst table
	$("#jqGridTable").jqGrid({
	   	url:'/drcms/warrantyModify/listByMachine' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width(),
		height: '100%',
		loadonce:false,

	   	colNames:['機器序號', 'wiwynn SO','factory SO','客戶', '保固類型', '保固日期', '動作'],
	   	colModel:[ //name for json data
	   	    {name:'goodsSN',index:'goodsSN', width:50,sortable:false},
	   		{name:'wiwynnSO',index:'wiwynnSO', width:50,sortable:false},
	   		{name:'factorySO',index:'factorySO', width:50,sortable:false},
	   		{name:'customerName',index:'customerName', width:50,sortable:false},
	   		{name : 'warrantyType',index : 'warrantyType',sortable:false,width : 50, sortable:false},
   	    	{name : 'warrantyDate',index : 'warrantyDate',sortable:false,width : 50}, 
	   		{name:'action', index:'action', width:20, align:"center", sortable:false, formatter:actionItem}		   		
	   	],
	   	rowNum:15,
	   	pager: '#jqGridPager',
	   	sortname: 'id',
	    viewrecords: true,
	    sortorder: "desc",
	    onPaging: function(pgButton){ 
			$("#jqGridTable").setGridParam({url:'/drcms/warrantyModify/listByMachine' + processUrl()});
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
	

	$("#jqGridTable").setGridParam({url:'/drcms/warrantyModify/listByMachine' + url }).trigger("reloadGrid");
	
}


//process url value...
function processUrl(){
	var tempUrl = $("#tempUrl").val();
	
	url = '?goodsSN='+$("#goodsQuery").val()+
		'&wiwynnSO='+$("#wiwynnSOQuery").val()+
		'&factorySO='+$("#factorySOQuery").val();
	
	$("#tempUrl").val(url);
	
	if(tempUrl != url){
		url+="&queryChange=true";
	}else{
		url+="&queryChange=false";
	}
			
	return url;
}

function timetostampFn(cellvalue, options, rowObject){
	return timestampToDateWithoutTime(rowObject.salesDate);
}

function actionItem (cellvalue, options, rowObject){
	return "<img src='/drcms/images/action.png' class='actionImg salesDataActionList' value="+rowObject.id+" ></img>";
}

function warrantyTypeItem (cellvalue, options, rowObject){
	return rowObject.warrantyType.id;
}

function partsFormatter(obj) { return obj.id+ "｜" + obj.description; }
</script>

<h1 class="contentTitle">依機器調整保固</h1>
<div align="center">
	<div class="pageFirstDiv" >
		<table>
			<tr>
                <td class="contentTD">
				<p>機器序號：</p>
				<input type="text" id="goodsQuery" >
				</td>
				<td class="contentTD">
				<p>wiwynn SO：</p>
				<input type="text" id="wiwynnSOQuery" >
				</td>
				<td class="contentTD">
				<p>factory SO：</p>
				<input type="text" id="factorySOQuery" >
				</td>
                <td class="lastTD">
					<input class="JQbtn" type="button" value="查詢" id="queryAjaxBtn" >
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

<!-- Dialog Content -->

<div id="salesDataModifyMstDialog" title="修改銷售資料">
	<form method="post" id="modifyForm">
		<fieldset>
			<table>
				<tr>
					<td style="width: 30%">goods SN :</td>
					<td><input type="hidden" id="idStr" name="idStr">
					<input type="text" id="id.goodsSn" name="id.goodsSn" readonly="true" class="textbox" size="40"></td>
				</tr>
				<tr>
					<td>預設保固類型 :</td>
					<td><select name="warrantyType.id" id="warrantyType.id" style="width: 120px">
					</select></td>
				</tr>
				<tr>
					<td>預設保固起始日期 :</td>
					<td><input type="text" name="warrantyDate" id="warrantyDate"
						class="pickDate required"></td>
				</tr>
			</table>
		</fieldset>
	</form>
</div>
