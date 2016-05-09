<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="/drcms/js/upload/jquery.ui.widget.js"></script>
<script src="/drcms/js/upload/jquery.iframe-transport.js"></script>
<script src="/drcms/js/upload/jquery.fileupload.js"></script>

<script type="text/javascript">
//page java sciprt

$(document).ready(function(){


	
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
	    	$("#queryBtn").click();
	    },
	    
	    fail: function (data) {
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

//jqGridTable code...
function showTable(){
	
	//processUrl();
	
	$("#jqGridTable").jqGrid({			
	   	url:'failParts/list' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width(),
		height: '100%',
		loadonce:false,
	   	colNames:['fail_parts_SN','replace_parts_SN','machine_SN','Date'],
	   	colModel:[
	   		{name:'id',index:'id', width:40, align:"center",sortable:false},
	   		{name:'replacePartsSN',index:'replacePartsSN', width:30,sortable:false},
	   		{name:'machineSN',index:'machineSN', width:20,sortable:false},
	   		{name:'createDate',index:'createDate', width:30,sortable:false, formatter:timetostampFn}	
	   	],
	   	rowNum:15,
	   	pager: '#jqGridPager',
	   	sortname: 'id',
	    viewrecords: true,
	    sortorder: "desc",
	    onPaging: function(pgButton){ 
			$("#jqGridTable").setGridParam({url:'failParts/list' + processUrl()});
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
	
	
	$("#jqGridTable").setGridParam({url:'failParts/list' + url}).trigger("reloadGrid");
}

//process url value...
function processUrl(){
	var tempUrl = $("#tempUrl").val();
	
	url = '?failPartsSN='+$("#failPartsSN").val()+
	'&replacePartsSN='+$("#replacePartsSN").val()+
	'&machineSN='+$("#machineSN").val();
	
	$("#tempUrl").val(url);
	
	if(tempUrl != url){
		url+="&queryChange=true";
	}else{
		url+="&queryChange=false";
	}
			
	return url;
}

function timetostampFn(cellvalue, options, rowObject){
	return timestampToDateWithoutTime(rowObject.createDate);
}

</script>

<h1 class="contentTitle">損壞零件資料上傳</h1>
<div align="center">
	<div class="pageFirstDiv" style="width:70%">
		<table>
			<tr>
                <td class="contentTD">
				<p>Fail Parts序號：</p>
				<input type="text" id="failPartsSN" >
				</td>
				<td class="contentTD">
				<p>Replace Parts序號：</p>
				<input type="text" id="replacePartsSN" >
				</td>
				<td class="contentTD">
				<p>機器序號：</p>
				<input type="text" id="machineSN" >
				</td>
                <td class="lastTD">
                	<input id="fileupload" type="file" name="files[]" data-url="/drcms/failParts/uploadFile">
					<input class="JQbtn" type="button" value="查詢" id="queryBtn">
					<input class="JQbtn" type="button" value="清除" id="clearBtn">
					<input type="hidden" id="tempUrl"  >
				</td>
            </tr>
         </table>
	</div>
	
	<div class="CSSTableGenerator" style="width:70%">
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




