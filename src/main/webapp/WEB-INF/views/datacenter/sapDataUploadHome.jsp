<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="/drcms/js/upload/jquery.ui.widget.js"></script>
<script src="/drcms/js/upload/jquery.iframe-transport.js"></script>
<script src="/drcms/js/upload/jquery.fileupload.js"></script>

<script type="text/javascript">
//page java sciprt

$(document).ready(function(){
	//for enter key
	$('#queryTable').keypress(function(e) {
		var key = window.event ? e.keyCode : e.which;
		if (key == 13) $('#queryBtn').click();
	});
	
	//list sales data...
	$("#queryBtn").click(function() {
		$(".CSSTableGenerator").removeClass();
		$("#mainTable").attr("id","jqGridTable");
		showTable();
	});
	

	$('#fileupload').fileupload({
	    dataType: 'json',
	    done: function (e, data) {
	    	alert(data.result[0]);
	    	$("#queryBtn").click();
	    },
	    
	    fail: function (e, data) {
	    	$("#queryBtn").click();
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


//jqGridTable code...
function showTable(){
	//processUrl();
	$("#jqGridTable").jqGrid({			
	   	url:'sapDataUpload/list' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width()/2,
		height: '100%',
		loadonce:false,
	   	colNames:['SAP Sales Order','客戶名稱','銷售日期'],
	   	colModel:[
	   		{name:'id',index:'id', width:20, sortable:false},
	   		{name:'customer.customerName',index:'customer', width:30,sortable:false},
	   		{name:'salesDate',index:'salesDate', width:20,sortable:false}
	   	],
	   	rowNum:15,
	   	pager: '#jqGridPager',
	   	sortname: 'id',
	    viewrecords: true,
	    sortorder: "desc",
	    onPaging: function(pgButton){ 
			$("#jqGridTable").setGridParam({url:'sapDataUpload/list' + processUrl()});
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
	
	$("#jqGridTable").setGridParam({url:'sapDataUpload/list' + url}).trigger("reloadGrid");
}

//process url value...
function processUrl(){
	var tempUrl = $("#tempUrl").val();
	
	url = '?salesOrder='+$("#salesOrder").val() + 
			'&customerId='+$("#customerId").val() +
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


$(window).load(function() {
	$("#queryBtn").click();
});

</script>

<h1 class="contentTitle">SAP資料上傳</h1>
<div align="center">
	<div class="pageFirstDiv" >
		<table id="queryTable">
			<tr>
                <td class="contentTD">
                <p>SAP Sales Order No：</p>
                <input type="text" id="salesOrder">
                </td>
                <td class="contentTD">
                <p>SAP Customer：</p>
                <input type="text" id="customerId">
                </td>
				<td class="contentTD" style="width:20%;" >
				<p>銷售日期：</p>
				<input type="text" id="fromDate" style="width:45%;" >~<input type="text" id="toDate" style="width:45%;">
				</td>
                <td class="lastTD">
					<input class="JQbtn" type="button" value="查詢" id="queryBtn" >
					<input id="fileupload" type="file" name="files[]" data-url="/drcms/sapDataUpload/uploadFile">
					<input type="hidden" id="tempUrl"  >
					<label class="JQbtn"
					 onclick="location.href='/drcms/example-import/sap-example.csv'">範例檔下載</label>
				</td>
            </tr>
         </table>
	</div>
		
	<div class="CSSTableGenerator">
		<table id="mainTable"></table>
         <div id="jqGridPager"></div>
	</div>
</div>

