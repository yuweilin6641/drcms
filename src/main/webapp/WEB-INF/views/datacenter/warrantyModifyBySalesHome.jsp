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

//For left click item list...
$(window).load(function(){
	
$(function(){
    $.contextMenu({
        selector: '.salesDataActionList', 
		trigger: 'left', 
        callback: function(key, options) { //function
			if(key=='editMst'){	
				$.ajax({
					url: "/drcms/warrantyModify/getWiwynnSales/"+$(this).attr("value"),
					type: "GET",
					dataType: "json",
					success: function(res) {
						dwr.util.setValues(objectEval(JSON.stringify(res)));
						dwr.util.setValue('id.salesDate', formatJsonDate(res.id.salesDate));
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
			"editMst": {name: "修改銷售單保固"}
        }
    });
});

});//]]> 

$(document).ready(function(){
	
//initial page
$.ajax({
	url: "/drcms/warrantyModify/initialPageJson",
	type: "GET",
	dataType: "json",
	success: function(res) {
		dwr.util.addOptions( "warrantyType",res.warrantyTypes,'id','id');
	}
});

//list all customer data...
$("#queryBtn").click(function(event) {
	event.preventDefault();
	$(".CSSTableGenerator").removeClass();
	$("#mainTable").attr("id","jqGridTable");
	showTable();
});

//clear button
$("#clearBtn").click(function() {
	location.reload();
});

//inital table when enter page
$("#queryBtn").click();

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
	
	        		url: "/drcms/warrantyModify/editSubmitBySales",
	        		type: "POST",
	        		data: $("#salesDataModifyMstDialog > form").serialize(),
	
	        		success: function(res) {
	        			$('#jqGridTable').trigger( 'reloadGrid' );
	        			//$("#queryBtn").click(); //refresh
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
	   	url:'/drcms/warrantyModify/listBySales' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width(),
		height: '100%',
		loadonce:false,

	   	colNames:['SAP ORDER', '銷售日期', '客戶','保固類型', '保固日期', '動作'],
	   	colModel:[ //name for json data
	   	    {name:'id.sapSalesOrder',index:'id.sapSalesOrder', width:50,sortable:false},
	   	    {name:'id.salesDate',index:'id.salesDate', width:50,sortable:false, formatter:timetostampFn},
	   		{name:'customer.customerName',index:'customer', width:50,sortable:false},
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
			$("#jqGridTable").setGridParam({url:'/drcms/warrantyModify/listBySales' + processUrl()});
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
	

	$("#jqGridTable").setGridParam({url:'/drcms/warrantyModify/listBySales' + processUrl() }).trigger("reloadGrid");
	
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

<h1 class="contentTitle">依銷售單調整保固</h1>
<div align="center">
	<div class="pageFirstDiv" >
		<table>
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
					<input class="JQbtn" type="button" value="查詢" id="queryBtn" >
					<input class="JQbtn" type="button" value="清除" id="clearBtn">
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
					<td style="width: 30%">*SAP SO :</td>
					<td><input type="hidden" id="idStr" name="idStr">
					<input type="text" id="id.sapSalesOrder" name="id.sapSalesOrder" readonly="true" class="textbox"></td>
				</tr>
				<tr>
					<td>銷售日期 :</td>
					<td><input type="text" id="id.salesDate" name="id.salesDate"  readonly="true"
						class="required textbox"></td>
				</tr>
				<tr>
					<td>預設保固類型 :</td>
					<td><select name="warrantyType" id="warrantyType" style="width: 120px">
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
