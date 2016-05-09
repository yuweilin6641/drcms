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
	
	//enter key
	$('#goodsSN').keypress(function(e) {
		var key = window.event ? e.keyCode : e.which;
		if (key == 13) $('#showData').click();
	});
	
	
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
	
	
	$("#showData").click(function() {
		if ($('#goodsSN').val() == "" ) alert("no S/N input");
		else {
		$.ajax({
			url: "/drcms/warranty/detail",
			type: "GET",
			dataType: "json",
			data:{"sn" : $('#goodsSN').val()},
			success: function(JData) {
				//clear table...
				$("#mainTableHead  tr").remove();
				$("#mainTableBody  tr").remove();
			
				//get table tbody data...
				$("#mainTableHead").append('<TR><TH colspan=2 width=50%>' + JData['goodsSN'] + '</TH></TR>');
				$("#mainTableBody").append('<TR><Td>客戶名稱:</Td><Td>' + JData['customerName'] + '</Td></TR>');
				$("#mainTableBody").append('<TR><Td>保固類別:</Td><Td>'+ JData['warrantyType']['id'] + '</Td></TR>');
				$("#mainTableBody").append('<TR><Td>起始日:</Td><Td>' + JData['warrantyDate'] + '</Td></TR>');
				$("#mainTableBody").append('<TR><Td>到期日:</Td><Td>' + JData['warrantyExpire'] + '</Td></TR>');
				$("#mainTableBody").append('<TR><Td>Service Grade:</Td><Td>' + JData['warrantyType']['serviceGrade'] + '</Td></TR>');
				$("#mainTableBody").append('<TR><Td>Service Response Time:</Td><Td>' + JData['warrantyType']['serviceResponseTime'] + '</Td></TR>');
				$("#mainTableBody").append('<TR><Td>Warranty Desc:</Td><Td>'+ JData['warrantyType']['description'] + '</Td></TR>');
			},
		   
			error: function(JData) {
				$("#mainTableHead  tr").remove();
				$("#mainTableBody  tr").remove();
				var thStr ="<tr>";
				thStr += "<th>no data</th>";
				thStr +="</tr>";
				$("#mainTableHead").append(thStr);
			}
		});
		};
	});
});

//jqGridTable code...
function showTable(){
	
	//processUrl();
	
	$("#jqGridTable").jqGrid({			
	   	url:'warranty/list' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width(),
		height: '100%',
		loadonce:false,
	   	colNames:['SN','客戶名稱','緯穎SO單', '保固類別','起始日', '到期日' , 'Service Gradee'],
	   	colModel:[
	   		{name:'goodsSN',index:'goodsSN', width:40, align:"center",sortable:false},
	   		{name:'customerName',index:'customerName', width:30,sortable:false},
	   		{name:'sapSalesOrder',index:'sapSalesOrder', width:30,sortable:false},
	   		{name:'warrantyType.id',index:'warrantyType.id', width:20,sortable:false},
	   		{name:'warrantyDate',index:'warrantyDate', width:30,sortable:false},
	   		{name:'warrantyExpire',index:'warrantyExpire', width:30,sortable:false},
	   		{name:'warrantyType.serviceGrade',index:'serviceGrade', width:30,sortable:false}	
	   	],
	   	rowNum:15,
	   	pager: '#jqGridPager',
	   	sortname: 'goodsSN',
	    viewrecords: true,
	    sortorder: "desc",
	    onPaging: function(pgButton){ 
			$("#jqGridTable").setGridParam({url:'warranty/list' + processUrl()});
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
	
	
	$("#jqGridTable").setGridParam({url:'warranty/list' + url}).trigger("reloadGrid");
}

//process url value...
function processUrl(){
	var tempUrl = $("#tempUrl").val();
	
	url = '?sn='+$("#goodsSN").val();
	url += '&snType='+$("#snType").val();
	url += '&wiwynnSO='+$("#wiwynnSO").val();
	
	$("#tempUrl").val(url);
	
	if(tempUrl != url){
		url+="&queryChange=true";
	}else{
		url+="&queryChange=false";
	}
			
	return url;
}



</script>

<h1 class="contentTitle">保固資料查詢</h1>
<div align="center">
	<div class="pageFirstDiv" style="width:80%">
		<table>
			<tr>
                <td class="contentTD">
				<p>序號：</p>
				<input type="text" id="goodsSN" >
				</td>
				<td class="contentTD">
				<p>緯穎SO：</p>
				<input type="text" id="wiwynnSO" >
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
				<input id="fileupload" type="file" name="files[]" data-url="/drcms/warranty/uploadFile">
				</td>
                <td class="lastTD">
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




