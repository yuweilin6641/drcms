<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<script type="text/javascript">
//page java sciprt
$(window).load(function(){
$(function(){
    $.contextMenu({
        selector: '.salesDataActionList', 
		trigger: 'left', 
        callback: function(key, options) { //function
			if(key=='edit'){
				$("#salesDtlDataModifyDialog").dialog("open");
			}
			else if(key=='delete'){
				dIndex = pickDtlsJson.id;
				$confirmDialogDtls.dialog('open');
			}
        },
        items: {
			"edit": {name: "改為以付款"},
            "delete": {name: "改為未付款"}
        }
    });
});
});

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



<h1 class="contentTitle">Credit Back資料維護</h1>
<div align="center">
	<div class="pageFirstDiv"  style="width:50%" >
		<table id="queryTable">
			<tr>
				<td class="contentTD">
				<p>料件類型：</p>
				<select id="customerType" name="customerType">
							<option value="0">ALL</option>
							<option value="0">HDD</option>
							<option value="1">DIMM</option>
							<option value="1">MAINBOARD</option>
							<option value="1">RAID CARD</option>
							<option value="1">PSU</option>
					</select>
				</td>
				<td class="contentTD">
				<p>序號：</p>
				<input type="text" id="GoodsSN" >
				</td>
				<td class="contentTD">
				<p>批次查詢：</p>
				<input id="fileupload" type="file" name="files[]">
				</td>
                <td class="lastTD">
					<input class="JQbtn" type="button" value="查詢" id="showData">&nbsp;&nbsp;<br/>
				</td>
            </tr>
         </table>
         
	</div>
	<div class="CSSTableGenerator" >
		<table  id="mainTable"  style="width:60%">
            <thead id="mainTableHead">
			<TR><th><input type="checkbox" /></th><th>SN</th><th>Description</th><th>paid</th><th>動作</th></TR>
            </thead>
            <tbody  id="mainTableBody">
            <tr><td><input type="checkbox" /></td><td style="width:50%">HDD1110001</td><td>Hitachi 10TB 3.5 HDD</td><td>已付款</td><td><img class='actionImg salesDataActionList' value="1" ></img></td></tr>
            <tr><td><input type="checkbox" /></td><td>HDD1110002</td><td>Hitachi 10TB 3.5 HDD</td><td>未付款</td><td><img class='actionImg salesDataActionList' value="1" ></img></td></tr>
            <tr><td><input type="checkbox" /></td><td>HDD1110003</td><td>Hitachi 10TB 3.5 HDD</td><td>未付款</td><td><img class='actionImg salesDataActionList' value="2" ></img></td></tr>
            <tr><td><input type="checkbox" /></td><td>RAM1110001</td><td>Kingston DDR3 PC1333 ECC Register 8G</td><td>已付款</td><td><img class='actionImg salesDataActionList' value="3" ></img></td></tr>
            <tr><td><input type="checkbox" /></td><td>RAM1110002</td><td>Kingston DDR3 PC1333 ECC Register 8G</td><td>已付款</td><td><img class='actionImg salesDataActionList' value="4" ></img></td></tr>
            <tr><td><input type="checkbox" /></td><td>RAM1110002</td><td>Kingston DDR3 PC1333 ECC Register 8G</td><td>不存在</td><td><img class='actionImg salesDataActionList' value="4" ></img></td></tr>
            </tbody>
            
         </table>
         <table style="width:60%"><tr align="center"><td align="center"><input class="JQbtn" type="button" value="批次已付款" id="showData"></td></tr></table>
	</div>
</div>