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
	
	$('#fileupload').fileupload({
	    dataType: 'json',
	    done: function (e, data) {
//	    	alert("done");
	    	$("#queryBtn").click();
	    },
	    
	    fail: function (e, data) {
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

	//clear button
	$("#clearBtn").click(function() {
		location.reload();
	});
	
	//list sales data...
	$("#queryBtn").click(function() {
		$(".CSSTableGenerator").removeClass();
		$("#mainTable").attr("id","jqGridTable");
		showTable();
	});
	
	//inital table when enter page
	$("#queryBtn").click();
});


//jqGridTable code...
function showTable(){
	
	//processUrl();
	
	$("#jqGridTable").jqGrid({			
	   	url:'parts/list' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width(),
		height: '100%',
		loadonce:false,
	   	colNames:['Part Number','Part Type','Revision','Description', 'Model Name' , 'Project Code'],
	   	colModel:[
	   		{name:'id',index:'id', width:20, align:"center",sortable:false},
	   		{name:'partType',index:'partType', width:30,sortable:false},
	   		{name:'revision',index:'revision', width:10,sortable:false},
	   		{name:'description',index:'description', width:70,sortable:false},
	   		{name:'modelName',index:'modelName', width:20,sortable:false},
	   		{name:'projectCode',index:'projectCode', width:20,sortable:false}	
	   	],
	   	rowNum:15,
	   	pager: '#jqGridPager',
	   	sortname: 'id',
	    viewrecords: true,
	    sortorder: "desc",
	    onPaging: function(pgButton){ 
			$("#jqGridTable").setGridParam({url:'parts/list' + processUrl()});
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
	
	
	$("#jqGridTable").setGridParam({url:'parts/list' + url}).trigger("reloadGrid");
}

//process url value...
function processUrl(){
	var tempUrl = $("#tempUrl").val();
	
	url = '?partNumber='+$("#partNumber").val() +
			'&description='+$("#description").val();
	
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

<h1 class="contentTitle">料件資料查詢</h1>
<div align="center">
	<div class="pageFirstDiv" >
		<table id="queryTable">
			<tr>
				<td class="contentTD">
				<p>料號：</p>
				<input type="text" id="partNumber">
				</td>
                <td class="contentTD">
				<p>料件名稱：</p>
				<input type="text" id="description">
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

