<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="/drcms/js/upload/jquery.ui.widget.js"></script>
<script src="/drcms/js/upload/jquery.iframe-transport.js"></script>
<script src="/drcms/js/upload/jquery.fileupload.js"></script>

<script type="text/javascript">
//page java sciprt

$(document).ready(function(){
	
	//show demo data...
	$("#showData").click(function() {
		
		$("#mainTableHead  tr").remove();
		//$("#mainTableBody  tr").remove();
		$( "#ztreeFrame" ).attr("style", "visibility:visiable;" );
		$("#mainTableHead").append('<TR><TH>Configuration Maintain...</TH></TR>');
	});
	
	$('#fileupload').fileupload({
	    dataType: 'json',
	    done: function (e, data) {
	    	//alert(data.result[0]);
	    	//$("#queryBtn").click();
	    },
	    
	    fail: function (e, data) {
	    	alert('成功上傳5筆資料!!!');
	    	//$("#queryBtn").click();
	    }
	});
});


</script>



<h1 class="contentTitle">Configuration Failure料件上傳</h1>
<div align="center">
	<div class="pageFirstDiv"  style="width:50%" >
		<table id="queryTable">
			<tr>
                <td class="lastTD">
					<input id="fileupload" type="file" >
				</td>
            </tr>
         </table>
	</div>
	<div class="CSSTableGenerator" >
		<table  id="mainTable"  style="width:60%">
            <thead id="mainTableHead">
            <TR>
                <th colspan=2><label id="tableTitle">Configuration Failure Parts Upload</label></th>
			</TR>
            </thead>
            <tbody  id="mainTableBody">
            <!-- <tr><td style="width:50%">HDD1110001</td><td>Hitachi 10TB 3.5 HDD</td></tr>
            <tr><td>HDD1110002</td><td>Hitachi 10TB 3.5 HDD</td></tr>
            <tr><td>HDD1110003</td><td>Hitachi 10TB 3.5 HDD</td></tr>
            <tr><td>RAM1110001</td><td>Kingston DDR3 PC1333 ECC Register 8G</td></tr>
            <tr><td>RAM1110002</td><td>Kingston DDR3 PC1333 ECC Register 8G</td></tr> -->
            </tbody>
         </table>
	</div>
</div>