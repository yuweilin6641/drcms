<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="/drcms/js/upload/jquery.ui.widget.js"></script>
<script src="/drcms/js/upload/jquery.iframe-transport.js"></script>
<script src="/drcms/js/upload/jquery.fileupload.js"></script>

<script type="text/javascript">
//page java sciprt

$(document).ready(function(){

	$( "#reportSubmitBtn" ).click(function() {
		if($("#mainForm").valid()){
			$("#mainForm").submit();
		}
	});
	
	//query button
	$("#queryBtn").click(function() {
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

	
	$('#fileupload').fileupload({
	    dataType: 'text',
	    done: function (data) {
//	    	alert("done");
	    	$("#queryBtn").click();
	    },
	    
	    fail: function (data) {
	    	alert("fail");
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
	
	//processUrl();
	
	$("#jqGridTable").jqGrid({			
	   	url:'facebookPartsConsumed/list' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width(),
		height: '100%',
		loadonce:false,
	   	colNames:['Asset SN','vender parts desc','goods SN', 'Parts Type', 'Timestamp', 'data center', 'PartsNo'],
	   	colModel:[
	   		{name:'id.assetSN',index:'id.assetSN', width:30, align:"center",sortable:false},
	   		{name:'venderPartsDesc',index:'venderPartsDesc', width:50,sortable:false},
	   		{name:'id.goodsSN',index:'id.goodsSN', width:30,sortable:false},
	   		{name:'partsType',index:'partsType', width:20,sortable:false},
	   		{name:'id.createDate',index:'id.createDate', width:30,sortable:false, formatter:timetostampFn},
	   		{name:'dataCenter',index:'dataCenter', width:30,sortable:false},
	   		{name:'partsNo',index:'partsNo', width:30,sortable:false}
	   	],
	   	rowNum:15,
	   	pager: '#jqGridPager',
	   	sortname: 'id.assetSN',
	    viewrecords: true,
	    sortorder: "desc",
	    onPaging: function(pgButton){ 
			$("#jqGridTable").setGridParam({url:'facebookPartsConsumed/list' + processUrl()});
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
	
	
	$("#jqGridTable").setGridParam({url:'facebookPartsConsumed/list' + url}).trigger("reloadGrid");
}

//process url value...
function processUrl(){
	var tempUrl = $("#tempUrl").val();
	
	url = '?fromDate='+$("#fromDate").val()+
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
	return timestampToDateWithoutTime(rowObject.id.createDate);
}

</script>

<h1 class="contentTitle">零件使用資料上傳</h1>
<div align="center">
	<div class="pageFirstDiv" style="width:80%">
	  <form id="mainForm" method="post" action="/drcms/facebookPartsConsumed/exportExcel">
		<table>
			<tr>
                <!-- <td class="contentTD"> -->
				<td class="contentTD">
					<input id="fileupload" type="file" name="files[]" data-url="/drcms/facebookPartsConsumed/uploadFile">
					<input class="JQbtn formButton" type="button" value="Export Excel" id="reportSubmitBtn">
				</td>
				<td class="contentTD" style="width:35%;" >
				<p>零件使用日期：</p>
				<input type="text" id="fromDate" style="width:45%;" >~<input type="text" id="toDate" style="width:45%;">
				</td>
				<td class="lastTD">
					<input class="JQbtn" type="button" value="查詢" id="queryBtn">
					<input class="JQbtn" type="button" value="清除" id="clearBtn">
					<input type="hidden" id="tempUrl"  >
				</td>
                
            </tr>
         </table>
       </form>
	</div>
	
	<div class="CSSTableGenerator" style="width:80%">
		<table id="mainTable">
            <thead id="mainTableHead">
            <tr>
                <th>None</th>
			 </tr>
            </thead>
            <tbody id="mainTableBody">
            <tr style="text-align:center;"><td>No Data...</td></tr>
            </tbody>           
			
         </table>
         <div id="jqGridPager"></div>
	</div>
	
	
</div>

<!-- Dialog Content -->




