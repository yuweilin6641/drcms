<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
//page java sciprt

$(document).ready(function(){
	//enter key
	$('#GoodsSN').keypress(function(e) {
		var key = window.event ? e.keyCode : e.which;
		if (key == 13) $('#showData').click();
	});
	
	
	$("#showData").click(function() {
		if ($('#GoodsSN').val() == "" ) alert("no S/N input");
		else {
		$.ajax({
			url: "/drcms/warranty/list",
			type: "GET",
			dataType: "json",
			data:{"sn" : $('#GoodsSN').val()},
			success: function(JData) {
				//clear table...
				$("#mainTableHead  tr").remove();
				$("#mainTableBody  tr").remove();
			
				//get table tbody data...
				$("#mainTableHead").append('<TR><TH colspan=2 width=50%>' + JData['goodsSN'] + '</TH></TR>');
				$("#mainTableBody").append('<TR><Td>客戶名稱:</Td><Td>' + JData['customer']['customerName'] + '</Td></TR>');
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


</script>

<h1 class="contentTitle">保固資料查詢</h1>
<div align="center">
	<div class="pageFirstDiv" style="width:50%">
		<table>
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
		
	<div class="CSSTableGenerator" style="width:40%;">
		<table id="mainTable">
            <thead id="mainTableHead">
                <th>None</th>
            </thead>
            <tbody id="mainTableBody">
            <tr style="text-align:center;"><td>No Data...</td></tr>
            </tbody>           
			
         </table>
	</div>
	
	
</div>

<!-- Dialog Content -->




