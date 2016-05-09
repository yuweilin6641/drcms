<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<h1 class="contentTitle">新增客戶資料</h1>
<div align="center">
	<div>
		<form id="mainForm" >
			<table id="mainTable" style="width: 40%; text-align: left;">

				<tr>
					<td style="width: 25%;">*客戶名稱</td>
					<td><input name="customerName" type="text" class="required" ></td>
				</tr>
				<tr>
					<td>SAP_ID</td>
					<td><input name="sapId" type="text" ></td>
				</tr>
				<tr>
					<td>客戶類別</td>
					<td><select name="customerType" style="width: 120px">
							<option value="0">直銷客戶</option>
							<option value="1">經銷商</option>
					</select></td>
				</tr>
				<tr>
					<td>客戶狀態：</td>
					<td><select name="customerStatus" style="width: 120px">
							<option value="0">Active</option>
							<option value="1">Disabled</option>
					</select></td>
				</tr>
				<tr>
					<td>客戶簡稱：</td>
					<td><input name="customerShortName" type="text"></td>
				</tr>
				<tr>
					<td>*緯穎負責業務</td>
					<td><select id="salesManSelect" name="salesManSelect" 
					onchange="$('#owner').val($('#salesManSelect option:selected').text());" style="width: 120px">
					</select><input type="hidden" name="owner" id="owner"></td>
				</tr>
			</table>
			<table id="mainTable" style="width: 45%; text-align: left;">
				<tr>
					<td style="width: 20%;">主要聯絡人：</td>
					<td><input name="mainContact" type="text" ></td>
				</tr>
				<tr>
					<td>*統一編號：</td>
					<td><input name="vatNum" type="text" class="required" ></td>
				</tr>
				<tr>
					<td>國別：</td>
					<td><input name="country" type="text"></td>
				</tr>
				<tr>
					<td>城市：</td>
					<td><input name="city" type="text"></td>
				</tr>
				<tr>
					<td>郵遞區號：</td>
					<td><input name="zipCode" type="text"></td>
				</tr>
				<tr>
					<td>地址一：</td>
					<td><input name="street" type="text"></td>
				</tr>
				<tr>
					<td>地址二：</td>
					<td><input name="street2" type="text"></td>
				</tr>
				<tr>
					<td>*電話：</td>
					<td><input name="tel" type="text" class="required digits" ></td>
				</tr>
				<tr>
					<td>傳真：</td>
					<td><input name="fax" type="text" ></td>
				</tr>
				<tr>
					<td align="left">*E-Mail：</td>
					<td><input name="email" type="text" class="required email" ></td>
				</tr>
				<tr>
					<td align="left">業務窗口姓名：</td>
					<td><input name="bizContact" type="text"></td>
				</tr>
				<tr>
					<td align="left">業務窗口電話：</td>
					<td><input name="bizTel" type="text" class="digits"></td>
				</tr>
				<tr>
					<td align="left">業務窗口E-Mail：</td>
					<td><input name="bizEmail" type="text" class="email"></td>
				</tr>
				<tr>
					<td align="left">業務窗口傳真：</td>
					<td><input name="bizFax" type="text"></td>
				</tr>
				<tr>
					<td align="left">技術窗口姓名：</td>
					<td><input name="techContact" type="text"></td>
				</tr>
				<tr>
					<td align="left">技術窗口電話：</td>
					<td><input name="techTel" type="text" class="digits"></td>
				</tr>
				<tr>
					<td align="left">技術窗口傳真：</td>
					<td><input name="techFax" type="text"></td>
				</tr>
				<tr>
					<td align="left">技術窗口E-Mail：</td>
					<td><input name="techEmail" type="text" class="email"></td>
				</tr>
				<tr>
					<td colspan=2 align=right>
					<input class="JQbtn formButton" type="button" value="新增客戶" id="customerDataAddAjaxAddBtn" onclick=""> 
					<input class="JQbtn" type="button" value="離開" id="customerAddCancel" onclick="location.href= ('/drcms/customer');">
					</td>
				</tr>
			</table>
		</form>
	</div>

</div>

<script>
$(document).ready(function() {
	
	//for initial some object
	$.ajax({
		url: "/drcms/customer/initialPageJson",
		type: "GET",
		dataType: "json",
		success: function(res) {
			dwr.util.addOptions( "salesManSelect", res.salesUsers,'id', 'account');
			dwr.util.setValue("owner", res.salesUsers[0].account); //set default salesMan
		}
	});
	
	$('#mainForm').validate();
	
	$( "#customerDataAddAjaxAddBtn" ).click(function() {
		if($("#mainForm").valid()){
			$.ajax({
				url: "/drcms/customer/addSubmit",
				type: "POST",
				dataType: "json",
				data : $("#mainForm").serialize(),
				success: function(res) {
				},
			   
				error: function() {
					alert('error');
				}
			}).done(function() {
				window.location.href = '/drcms/customer';
			});
		}
	});
});
</script>
