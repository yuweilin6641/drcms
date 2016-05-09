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
					url: "/drcms/factorySales/getFactorySalesInfo/"+$(this).attr("value"),
					type: "GET",
					dataType: "json",
					success: function(res) {
						dwr.util.setValues(objectEval(JSON.stringify(res)));
						salesDtlsJson = res.salesDtls;
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
			"editMst": {name: "mapping wiwynn so"}
        }
    });
});

//first load (debug)
$('#queryAjaxBtn').click();
});//]]> 

$(document).ready(function(){

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
		'relateSapSalesOrder': { valueNotEquals: "-1" }
	},
	messages: {
		'relateSapSalesOrder': { valueNotEquals: "請選擇一個!!!" }
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
	
	        		url: "/drcms/factorySales/editSubmit",
	        		type: "GET",
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

//JS datePicker
$(function() {
	$( "#fromDate" ).datepicker({
		changeYear: true,
		changeMonth: true,
		dateFormat:"yy-mm-dd",
		showAnim:"blind",
		showButtonPanel: true,       
		onClose: function( selectedDate ) {
			$( "#toDate" ).datepicker("option", "minDate", new Date(selectedDate));          
		}
	});
	
	$( "#toDate" ).datepicker({
		changeYear: true,
		changeMonth: true,
		dateFormat:"yy-mm-dd",
		showAnim:"blind",
		onClose: function( selectedDate ) {
			$( "#fromDate" ).datepicker( "option", "maxDate", new Date(selectedDate));
		}
	});
//datepicker today button...
$.datepicker._gotoToday = function(id) {
    var target = $(id);
    var inst = this._getInst(target[0]);
    if (this._get(inst, 'gotoCurrent') && inst.currentDay) {
            inst.selectedDay = inst.currentDay;
            inst.drawMonth = inst.selectedMonth = inst.currentMonth;
            inst.drawYear = inst.selectedYear = inst.currentYear;
    }
    else {
            var date = new Date();
            inst.selectedDay = date.getDate();
            inst.drawMonth = inst.selectedMonth = date.getMonth();
            inst.drawYear = inst.selectedYear = date.getFullYear();
            // the below two lines are new
            this._setDateDatepicker(target, date);
            this._selectDate(id, this._getDateDatepicker(target));
    }
    this._notifyChange(inst);
    this._adjustDate(target);
};
});


});


//jqGridTable code...
function showTable(){
	cindex = 0;
	dindex = 0;
	
	//sales mst table
	$("#jqGridTable").jqGrid({
	   	url:'/drcms/factorySales/list' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width(),
		height: '100%',
		loadonce:false,

	   	colNames:['Factory SO', '銷售日期', '客戶', 'PO','Reference Wiwynn SO', '動作'],
	   	colModel:[ //name for json data
	   	    {name:'id.sapSalesOrder',index:'id.sapSalesOrder', width:50,sortable:false},
	   	 	{name:'id.salesDate',index:'id.salesDate', width:50,sortable:false, formatter:timetostampFn},
	   		{name:'customer.customerName',index:'customer', width:50,sortable:false},
	   		{name:'poNo',index:'poNo', width:50,sortable:false},
	   		{name : 'relateSapSalesOrder',index : 'relateSapSalesOrder',sortable:false,width : 50, sortable:false},
	   		{name:'actison', index:'action', width:20, align:"center", sortable:false, formatter:actionItem}		   		
	   	],
	   	rowNum:15,
	   	pager: '#jqGridPager',
	   	sortname: 'id',
	    viewrecords: true,
	    sortorder: "desc",
	    onPaging: function(pgButton){ 
			$("#jqGridTable").setGridParam({url:'factorySales/list' + processUrl()});
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
	

	$("#jqGridTable").setGridParam({url:'/drcms/factorySales/list' + processUrl() }).trigger("reloadGrid");
	
}


//process url value...
function processUrl(){
	var tempUrl = $("#tempUrl").val();
	
	url = '?factorySO='+$("#factorySO").val()+
		'&wiwynnSO='+$("#wiwynnSO").val()+
		'&poNoe='+$("#poNo").val()+
		'&fromDate='+$("#fromDate").val()+
		'&toDate='+$("#toDate").val();
	
	$("#tempUrl").val(url);
	
	if(tempUrl != url){
		url+="&queryChange=true";
	}else{
		url+="&queryChange=false";
	}
			
	return url;
}

function timetostampFn(cellvalue, options, rowObject){
	return timestampToDateWithoutTime(rowObject.id.salesDate);
}

function actionItem (cellvalue, options, rowObject){
	return "<img src='/drcms/images/action.png' class='actionImg salesDataActionList' value="+rowObject.idStr+" ></img>";
}

function warrantyTypeItem (cellvalue, options, rowObject){
	return rowObject.warrantyType.id;
}

function partsFormatter(obj) { return obj.id+ "｜" + obj.description; }
</script>

<h1 class="contentTitle">工廠銷售單查詢</h1>
<div align="center">
	<div class="pageFirstDiv" >
		<table>
			<tr>
                <td class="contentTD">
				<p>Factory SO：</p>
				<input type="text" id="factorySO" >
				</td>
				<td class="contentTD">
				<p>Wiwynn SO：</p>
				<input type="text" id="wiwynnSO" >
				</td>
				<td class="contentTD">
				<p>po No：</p>
				<input type="text" id="poNo" >
				</td>
				<td class="contentTD" style="width:20%;" >
				<p>銷售日期：</p>
				<input type="text" id="fromDate" style="width:45%;" >~<input type="text" id="toDate" style="width:45%;">
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
					<td style="width: 35%">Factory SO :</td>
					<td><input type="hidden" id="idStr" name="idStr">
					<input type="text" id="id.sapSalesOrder" name="id.sapSalesOrder" readonly="true" class="textbox"></td>
				</tr>
				<tr>
					<td>Wiwynn SO:</td>
					<td><input type="text" name="relateSapSalesOrder" id="relateSapSalesOrder"></td>
				</tr>
			</table>
		</fieldset>
	</form>
</div>
