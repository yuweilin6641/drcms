<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
.ui-dialog{font-size:14px;}
</style>

<script type="text/javascript">
//page java sciprt
var salesTypeArr=["直銷","經銷"];
var salesDtlsJson = "";
var pickDtlsJson = "";

//For left click item list...
$(window).load(function(){
	$('#queryAjaxBtn').click();
});



$(document).ready(function(){

//list all customer data...
$("#queryAjaxBtn").click(function(event) {
	event.preventDefault();
	$(".CSSTableGenerator").removeClass();
	$("#mainTable").attr("id","jqGridTable");
	showTable();
		
});

//clear button
$("#clearBtn").click(function() {
	location.reload();
});

//for enter key
$('#queryTable').keypress(function(e) {
	var key = window.event ? e.keyCode : e.which;
	if (key == 13) $('#queryAjaxBtn').click();
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
	   	url:'/drcms/wiwynnSales/list' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width(),
		height: '100%',
		loadonce:false,

	   	colNames:['SAP ORDER', '銷售日期', 'sales Org', 'SO Type', 'sold to', 'ship to','bill to','Po No','warranty Type','warranty Date'],
	   	colModel:[ //name for json data
	   	    {name:'id.sapSalesOrder',index:'id.sapSalesOrder', width:90,sortable:false},
	   	    {name:'id.salesDate',index:'id.salesDate', width:50,sortable:false, formatter:timetostampFn},
	   	    {name:'salesOrg',index:'salesOrg', width:50,sortable:false},
	   	    {name:'salesType',index:'salesType', width:50,sortable:false},
	   	    {name:'customer.customerName',index:'customer', width:90,sortable:false},
	   		{name:'shipCustomer.customerName',index:'shipCustomer', width:90,sortable:false},
	   		{name:'billCustomer.customerName',index:'billCustomer', width:90,sortable:false},
	   	    {name:'poNO',index:'poNO', width:50,sortable:false},
	   	    {name:'warrantyType',index:'warrantyType', width:50,sortable:false},
	   	    {name:'warrantyDate',index:'warrantyDate', width:50,sortable:false, formatter:timetostampFn2}	   		
	   	],
	   	rowNum:15,
	   	pager: '#jqGridPager',
	   	sortname: 'id',
	    viewrecords: true,
	    sortorder: "desc",
	    onPaging: function(pgButton){ 
			$("#jqGridTable").setGridParam({url:'wiwynnSales/list' + processUrl()});
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
	

	$("#jqGridTable").setGridParam({url:'wiwynnSales/list' + processUrl() }).trigger("reloadGrid");

}


//process url value...
function processUrl(){
	var tempUrl = $("#tempUrl").val();
	
	url = '?sap='+$("#sapQuery").val()+
		'&customerName='+$("#customerNameQuery").val()+
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

function turnSalesType(cellvalue, options, rowObject){
	return salesTypeArr[rowObject.salesType];
}

function timetostampFn(cellvalue, options, rowObject){
	return timestampToDateWithoutTime(rowObject.id.salesDate);
}

function timetostampFn2(cellvalue, options, rowObject){
	return timestampToDateWithoutTime(rowObject.warrantyDate);
}

function warrantyTypeItem (cellvalue, options, rowObject){
	return rowObject.warrantyType.id;
}

function dtlActionItem (cellvalue, options, rowObject){
	return "<img class='actionImg salesDtlDataActionList' value="+rowObject.id+" ></img>";
}

function partsFormatter(obj) { return obj.id+ "｜" + obj.description; }
</script>

<h1 class="contentTitle">銷售資料維護</h1>
<div align="center">
	<div class="pageFirstDiv" >
		<table id="queryTable" >
			<tr>
                <td class="contentTD">
				<p>SAP_SO：</p>
				<input type="text" id="sapQuery" >
				</td>
				<td class="contentTD">
				<p>客戶名稱：</p>
				<input type="text" id="customerNameQuery" >
				</td>
				
				<td class="contentTD" style="width:20%;" >
				<p>銷售日期：</p>
				
				<input type="text" id="fromDate" style="width:45%;" >~<input type="text" id="toDate" style="width:45%;">
				</td>
				
                <td class="lastTD">
					<input class="JQbtn" type="button" value="查詢" id="queryAjaxBtn" >
					<input class="JQbtn" type="button" value="清除" id="clearBtn" >
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

