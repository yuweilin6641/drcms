<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="/drcms/js/upload/jquery.ui.widget.js"></script>
<script src="/drcms/js/upload/jquery.iframe-transport.js"></script>
<script src="/drcms/js/upload/jquery.fileupload.js"></script>

<script type="text/javascript">
//page java sciprt

$(document).ready(function(){
	
	$('#fileupload').fileupload({
	    dataType: 'json',
	    done: function (e, data) {
//	    	alert("done");
	    	$("#queryBtn").click();
	    },
	    
	    fail: function (e, data) {
	    	//alert("fail");
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
});

//jqGridTable code...
function showTable(){
	
	//processUrl();
	
	$("#jqGridTable").jqGrid({			
	   	url:'shipment/list' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width(),
		height: '100%',
		loadonce:false,
	   	colNames:['零件/機器序號','機器序號','Parts No','工廠SO單','運送日期'],
	   	colModel:[
	   		{name:'goodsSN',index:'goodsSN', width:40, align:"center",sortable:false},
	   		{name:'parentSN',index:'parentSN', width:30,sortable:false},
	   		{name:'partsNo',index:'partsNo', width:20,sortable:false},
	   		{name:'factorySO',index:'factorySO', width:20,sortable:false},
	   		{name:'shipmentDate',index:'shipmentDate', width:30,sortable:false, formatter:timetostampFn}
	   	],
	   	rowNum:15,
	   	pager: '#jqGridPager',
	   	sortname: 'goodsSN',
	    viewrecords: true,
	    sortorder: "desc",
	    onPaging: function(pgButton){ 
			$("#jqGridTable").setGridParam({url:'shipment/list' + processUrl()});
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
	
	
	$("#jqGridTable").setGridParam({url:'shipment/list' + url}).trigger("reloadGrid");
}

function timetostampFn(cellvalue, options, rowObject){
	return timestampToDateWithoutTime(rowObject.shipmentDate);
}

//process url value...
function processUrl(){
	var tempUrl = $("#tempUrl").val();
	url = '?goodsSN='+$("#goodsSN").val();
	url += '&parentSN='+$("#parentSN").val();
	url += '&snType='+$("#snType").val();
	url += '&factorySO='+$("#factorySO").val();
	
	$("#tempUrl").val(url);
	
	if(tempUrl != url){
		url+="&queryChange=true";
	}else{
		url+="&queryChange=false";
	}
	return url;
}



</script>

<h1 class="contentTitle">機器/零組件出廠資料查詢</h1>
<div align="center">
	<div class="pageFirstDiv" style="width:80%">
		<table>
			<tr>
                <td class="contentTD">
				<p>序號：</p>
				<input type="text" id="goodsSN" >
				<p>(請輸入完整序號)：</p>
				</td>
				<td class="contentTD">
				<p>機器序號：</p>
				<input type="text" id="parentSN" >
				<p>(請輸入完整序號)：</p>
				</td>
				<td class="contentTD">
				<p>工廠SO：</p>
				<input type="text" id="factorySO" >
				<p>(請輸入完整工廠SO)：</p>
				</td>
				<td class="contentTD">
				<p>序號類別：</p>
				<select id="snType">
					<option value="machine">機器</option>
					<option value="parts">零組件</option>
				</select>				
				</td>
				<td class="contentTD">
				<p>序號檔案：</p>
				<input id="fileupload" type="file" name="files[]" data-url="/drcms/shipment/uploadFile">
                <p><a href="example-import/shipment.csv" download>batch query sample file</a></p>
				</td>
                <td class="lastTD" style="width:130px">
					<input class="JQbtn" type="button" value="查詢" id="queryBtn">
					<input class="JQbtn" type="button" value="清除" id="clearBtn">
					<input type="hidden" id="tempUrl"  >
				</td>
            </tr>
         </table>
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




