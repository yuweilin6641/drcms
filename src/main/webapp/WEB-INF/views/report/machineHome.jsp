<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script type="text/javascript" src="/drcms/js/jquery/jquery.quicksearch.js"></script>

<br/>
<h1 class="contentTitle">各機型損壞料件統計</h1>
<div align="center">
	<div>
		<form id="mainForm" method="post" action="/drcms/report/machineSubmit">
			<table id="mainTable" style="width: 45%; text-align: left;">
				<tr>
					<td style="width: 20%;">機型：</td>
					<td><select id="modelName" name="modelName">
					<option value="Knox">Knox</option>
					<option value="Teatree">Teatree</option>
							<option value="6U48">6U48</option>
<option value="Apricot">Apricot</option>
<option value="Aspen">Aspen</option>
<option value="Babylonia">Babylonia</option>
<option value="Cherry">Cherry</option>
<option value="CIB">CIB</option>
<option value="CLOUD MARCOM">CLOUD MARCOM</option>
<option value="Compute14">Compute14</option>
<option value="Diamond SSD23">Diamond SSD23</option>
<option value="DS1U8">DS1U8</option>
<option value="Empress">Empress</option>
<option value="F11DRH1">F11DRH1</option>
<option value="F12DRH1">F12DRH1</option>
<option value="Galaxy">Galaxy</option>
<option value="Glacier S1">Glacier S1</option>
<option value="Hawthorn">Hawthorn</option>
<option value="Honey Badger">Honey Badger</option>
<option value="IAK">IAK</option>
<option value="IMK">IMK</option>
<option value="Independence Switch">Independence Switch</option>
<option value="iway">iway</option>

<option value="Liberty">Liberty</option>
<option value="Lion2 Switch">Lion2 Switch</option>
<option value="Matrix">Matrix</option>
<option value="Mt. Hood">Mt. Hood</option>
<option value="P11DCV10">P11DCV10</option>
<option value="P92TB2">P92TB2</option>
<option value="R1113IL1">R1113IL1</option>
<option value="Redbud">Redbud</option>
<option value="SV118">SV118</option>

<option value="W1CR12I1">W1CR12I1</option>
<option value="W2CR12I2">W2CR12I2</option>
<option value="W2CR12I3">W2CR12I3</option>
<option value="Windmill">Windmill</option>
<option value="WYHQ PMA">WYHQ PMA</option>
					</select></td>
				</tr>
				<tr>
					<td style="width: 20%;">客戶：</td>
					<td>
						<input type="text" id="customer" name="customer" style="width:45%;" >
						<input class="JQbtn formButton" type="button" value="..." id="CustomerChooseBtn" onclick=""> 
					</td>
				</tr>
				<tr>
					<td style="width: 20%;">銷售區間：</td>
					<td><input type="text" id="fromDate" name="fromDate" style="width:45%;" >~<input type="text" id="toDate" name="toDate" style="width:45%;"></td>
				</tr>
				<tr>
					<td>料號：</td>
					<td>
						<input id="partsNo" name="partsNo" type="text" style="width:45%;">
						<input class="JQbtn formButton" type="button" value="..." id="PartsChooseBtn" onclick=""> 
					</td>
				</tr>
				<tr>
					<td colspan=2 align=center>
					<input class="JQbtn formButton" type="button" value="查詢" id="reportSubmitBtn">
					</td>
				</tr>
			</table>
		</form>

	</div>

	<div id="customerChooseDialog" title="客戶選擇">
		
		<form action="#">
			<fieldset>
				<input type="search" name="search" value="" id="customerSearch" /> <span class="loading">Loading...</span>
			</fieldset>
		</form>
		
		<table id="customerMatrix" border=1>
			<thead>
				<tr>
					<th width="10%"><input type="button" id="customerSelectAll" value="全選"><br>
									<input type="button" id="customerCancelAll" value="取消"></th>
					<th width="45%">客戶ID</th>
					<th width="45%">客戶名稱</th>
				</tr>
			</thead>
		
			<tbody>
				<tr id="customerNoResults">
					<td colspan="6" align="center">查無資料</td>
				</tr>
			</tbody>
			
			
		</table>
		
	</div>
	
	<div id="partChooseDialog" title="料號選擇">
		
		<form action="#">
			<fieldset>
				<input type="search" name="search" value="" id="partSearch" /> <span class="loading">Loading...</span>
			</fieldset>
		</form>
		
		<table id="partMatrix" border=1>
			<thead>
				<tr>
					<th width="10%"><input type="button" id="partSelectAll" value="全選"><br>
									<input type="button" id="partCancelAll" value="取消"></th>
					<th width="20%">料件編號</th>
					<th width="70%">料件描述</th>
				</tr>
			</thead>
		
			<tbody>
				<tr id="partNoResults">
					<td colspan="6" align="center">查無資料</td>
				</tr>
			</tbody>
			
			
		</table>
		
	</div>

</div>

<script>
var customerSearch = '0';
var partsSearch = '0';

$(document).ready(function() {
	
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
	
	$("#reportSubmitBtn").click(function() {
		if($("#mainForm").valid()){
			$("#mainForm").submit();
		}
	});
	

	//for Customer selection
	$("#customerChooseDialog").dialog({
	    autoOpen: false, modal: true,
		width: 500, height: 500,
	    buttons: {
	        "新增": function() {
	        	$( ".customerCheckbox" ).each(function (i, item) {
	        		if($(this).prop('checked'))$("#customer").val($("#customer").val()+$(this).val()+",");
	        		$(this).removeAttr('checked');
	        	});
	        	$("#customer").val($("#customer").val().substr(0,$("#customer").val().length-1));
	        	$(this).dialog("close");
	        },
			"取消": function() {
				$( ".customerCheckbox" ).each(function (i, item) {
	        		$(this).removeAttr('checked');
	        	});
	            $(this).dialog("close");
	        }
	    }
	});
	
	//for Part selection
	$("#partChooseDialog").dialog({
	    autoOpen: false, modal: true,
		width: 700, height: 500,
	    buttons: {
	        "新增": function() {
	        	$( ".partCheckbox" ).each(function (i, item) {	        		
	        		if($(this).prop('checked'))$("#partsNo").val($("#partsNo").val()+$(this).val()+",");
	        		$(this).removeAttr('checked');
	        	});
	        	$("#partsNo").val($("#partsNo").val().substr(0,$("#partsNo").val().length-1));
	        	$(this).dialog("close");
	        },
			"取消": function() {
				$( ".partCheckbox" ).each(function (i, item) {
	        		$(this).removeAttr('checked');
	        	});
	            $(this).dialog("close");
	        }
	    }
	});
	
	$("#CustomerChooseBtn").click(function(event) {
	    event.preventDefault();
	    $("#customer").val("");
	    if(customerSearch=='0'){
	    	//create table and set filter function...
			$.ajax({
				url: "/drcms/report/initialPageJson/customer",
				type: "GET",
				dataType: "json",
				success: function(res) {
					$.each(res.customers, function(i, item) {
						trStr = '<tr><th><input class="customerCheckbox" type="checkbox" value=' + item.id + ' ></th>';
						trStr += '<th>' + item.id + '</th>';
						trStr += '<th>' + item.customerName + '</th></tr>';
						$('#customerMatrix > tbody').append(trStr);
						
					});
				}
			}).done(function(res) {
				$("#customerSearch").quicksearch("#customerMatrix tbody tr", {
					noResults: '#customerNoResults',
					loader: 'span.loading'
				});
				$("#customerChooseDialog").dialog("open");
				customerSearch = '1';
			});
	    }
	    else{	
	    	$("#customerChooseDialog").dialog("open");
	    }
	});
	
	$("#PartsChooseBtn").click(function(event) {
	    event.preventDefault();
	    $("#partsNo").val("");
	    if(partsSearch=='0'){
	    	//create table and set filter function...
			$.ajax({
				url: "/drcms/report/initialPageJson/parts",
				type: "GET",
				dataType: "json",
				success: function(res) {
					$.each(res.parts, function(i, item) {
						trStr = '<tr><th><input class="partCheckbox" type="checkbox" value=' + item.id + ' ></th>';
						trStr += '<th>' + item.id + '</th>';
						trStr += '<th>' + item.description + '</th></tr>';
						$('#partMatrix > tbody:last').append(trStr);
						
					});
				}
			}).done(function(res) {
				$("#partSearch").quicksearch("#partMatrix tbody tr", {
					noResults: '#partNoResults',
					loader: 'span.loading'
				});
				partsSearch = '1';
				$("#partChooseDialog").dialog("open");
			});
	    }
	    else{
	    	$("#partChooseDialog").dialog("open");
	    }
	});
	//select all button
	$("#customerSelectAll").click(function(event) {
	    event.preventDefault();
	    $( ".customerCheckbox" ).each(function (i, item) {
	    	if($(this).is(':visible'))$(this).prop("checked", true);
    	});
	});
	
	$("#partSelectAll").click(function(event) {
	    event.preventDefault();
	    $( ".partCheckbox" ).each(function (i, item) {
	    	if($(this).is(':visible'))$(this).prop("checked", true);
    	});
	});
	
	//cancel all button
	$("#customerCancelAll").click(function(event) {
	    event.preventDefault();
	    $( ".customerCheckbox" ).each(function (i, item) {
	    	$(this).removeAttr('checked');
    	});
	});
	
	$("#partCancelAll").click(function(event) {
	    event.preventDefault();
	    $( ".partCheckbox" ).each(function (i, item) {
	    	$(this).removeAttr('checked');
    	});
	});
});
</script>
