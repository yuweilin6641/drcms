<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<script type="text/javascript">
//page java sciprt

$(document).ready(function(){

	//for enter key
	$('#queryTable').keypress(function(e) {
		var key = window.event ? e.keyCode : e.which;
		if (key == 13) $('#queryDataAjaxBtn').click();
	});
	
	//show query data...
	$("#queryDataAjaxBtn").click(function(event) {
		event.preventDefault();
	});
	
	
});


</script>



<h1 class="contentTitle">Configuration Failure 料件查詢</h1>
<div align="center">
	<div class="pageFirstDiv"  style="width:50%" >
		<table id="queryTable">
			<tr>
                <td class="contentTD">
				<p>序號：</p>
				<input type="text" id="GoodsSN" >
				</td>
                <td class="lastTD">
					<input class="JQbtn" type="button" value="查詢" id="showData">
				</td>
            </tr>
         </table>
	</div>
	<div class="CSSTableGenerator" >
		<table  id="mainTable"  style="width:60%">
            <thead id="mainTableHead">
            <TR>
                <th colspan=3><label id="tableTitle">Configuration Failure Parts List</label></th>
			</TR>
			<TR><th>SN</th><th>Description</th><th>Warranty Date</th></TR>
            </thead>
            <tbody  id="mainTableBody">
            <tr><td style="width:50%">HDD1110001</td><td>Hitachi 10TB 3.5 HDD</td><td>2013-12-31</td></tr>
            <tr><td>HDD1110002</td><td>Hitachi 10TB 3.5 HDD</td><td>2013-12-31</td></tr>
            <tr><td>HDD1110003</td><td>Hitachi 10TB 3.5 HDD</td><td>2014-12-31</td></tr>
            <tr><td>RAM1110001</td><td>Kingston DDR3 PC1333 ECC Register 8G</td><td>2013-12-31</td></tr>
            <tr><td>RAM1110002</td><td>Kingston DDR3 PC1333 ECC Register 8G</td><td>2014-12-31</td></tr>
            </tbody>
         </table>
	</div>
</div>