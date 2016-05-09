<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<h1 class="contentTitle">新增銷售資料</h1>

<div align="center">
	<div>
		<form id="mainForm">
			<table id="mainTable" style="width: 40%; text-align: left;">
				<tr>
					<td align="left" width="30%">*SAP SO</td>

					<td><select id="sapSalesOrder" name="sapSalesOrder" style="width: 120px" class="required">
					</select></td>
				</tr>
				<tr>
					<td>客戶名稱</td>
					<td><select id="customerNameOption" name="customerId"
						style="width: 120px" disabled></select></td>
				</tr>
				<tr>
					<td>經銷商名稱</td>
					<td><select id="resellerNameOption" name="resellerId"
						style="width: 120px" disabled></select></td>
				</tr>
				<tr>
					<td>銷售日期</td>
					<td><input type="text" id="salesDate" name="salesDate"
						class="pickDate dateISO date" style="width: 120px"></td>
				</tr>
				<tr>
					<td>銷售類型</td>
					<td><select name="salesType" id="salesType" style="width: 120px">
							<option value="0">直銷</option>
							<option value="1">經銷</option>
					</select></td>
				</tr>
				<tr>

					<td>*緯穎業務負責人</td>
					<td><select id="salesManSelect" name="salesManSelect"
						onchange="$('#salesMan').val($('#salesManSelect option:selected').text());"
						style="width: 120px"></select> <input type="hidden"
						name="salesMan" id="salesMan"></td>
				</tr>
				<tr>
					<td>業務窗口姓名</td>
					<td><input type="text" name="bizContact" id="bizContact"></td>
				</tr>
				<tr>
					<td>業務窗口電話</td>

					<td><input type="text" name="bizPhone" id="bizTel" class="digits" ></td>
				</tr>
				<!-- <tr>
					<td>Biz Cell :</td>
					<td><input type="text" name="bizCell"></td>
				</tr> -->
				<tr>

					<td>業務窗口E-Mail</td>
					<td><input type="text" name="bizEmail" id="bizEmail" class="email"></td>
				</tr>
				<tr>
					<td>技術窗口姓名</td>
					<td><input type="text" name="techContact" id="techContact"></td>
				</tr>
				<tr>
					<td>技術窗口電話</td>

					<td><input type="text" name="techPhone" id="techTel" class="digits" ></td>
				</tr>
				<!-- <tr>
					<td>Tech Cell :</td>
					<td><input type="text" name="techCell"></td>
				</tr> -->
				<tr>

					<td>技術窗口E-Mail</td>
					<td><input type="text" name="techEmail" id="techEmail" class="email"></td>
				</tr>
				<tr>
					<td>預設保固類型</td>
					<td><select id="warrantyType" name="warrantyType"
						style="width: 120px"></select></td>
				</tr>
				<tr>

					<td>預設保固起始日期</td>
					<td><input type="text" name="warrantyDate" id="warrantyDate"

						class="pickDate required dateISO date"></td>
				</tr>
				<tr>
					<td colspan=2 align=right><input id="salesDetailAjaxAddBtn"
						type="button" class="JQbtn" value="新增銷售明細">&nbsp;&nbsp;
						<input id="salesDataAddAjaxAddBtn" type="button" class="JQbtn"
						value="新增銷售單">&nbsp;&nbsp; <input id="" type="button"
						class="JQbtn" value="清除資料" onclick="location.href= ('/drcms/sales/add');">&nbsp;&nbsp;
						<input id="" type="button" class="JQbtn" value="取消新增"
						onclick="location.href= ('/drcms/sales');"></td>
				</tr>
			</table>


			<table id="jqGridTable" name="jqGridTable"></table>
			<div id="jqGridPager"></div>
			<P></P>
		</form>
	</div>
</div>

<div id="salesDetailAddDialog" title="新增銷售明細" >
	<fieldset>
	<form id="detailForm">
		<table>
			<tr><td align="left" width="20%">料件名稱 :</td><td>
			<select id="partsOption" name="dtlsPartsName" class="required"><option value="-1">請選擇一個</option></select>
			<!-- <input type="text" name="sku" id="sku" value="Product-A" ><input type="hidden" name="skuId" id="skuId" ><input type="button" class="JQbtn" value="Choose Product" id="skuChoose"> --></td></tr>
			<tr><td align="left">料件序號 :</td><td>
			<select id="snOption" name="dtlsPartsSn" class="required"><!-- <option></option> --></select>
			<!-- <input type="text" name="goodsSn" id="goodsSn" value="Configuration-A" ><input type="hidden" name="goodId" id="goodId" ><input type="button" class="JQbtn" value="Mapping Config." id="goodChoose"> --></td></tr>
			<tr><td align="left">客戶名稱 :</td><td><select id="dtlsCustomerSelect" name="dtlsCustomerSelect"></select>
			<input type="hidden" name="dtlsCustomerName" id="dtlsCustomerName"></td></tr>
			<tr><td align="left">保固類型 :</td><td><select id="warrantyTypeSelect" name="warrantyType" ></select></td></tr>
			<tr><td align="left">保固起始日 :</td><td><input type="text" name="warrantyDate" id="dtlsWarrantyDate" class="pickDate"></td></tr>
			<tr><td align="left">保固備註 :</td><td><input type="text" name="comments" id="dtlsWarrantyAlt"></td></tr>
		</table>
	</form>
	</fieldset>
	
	<!-- <div id="skuSelect" title="Choose Product" >
		<fieldset>
		<select id="skuOption" onchange="$('#sku').val($('#skuOption option:selected').text());$('#skuId').val($('#skuOption').val());">
		<option></option>
		</select>
		</fieldset> 
	</div>
	
	<div id="goodSelect" title="Mapping Confirguation"  >
		<fieldset>
		<select id="goodOption" onchange="$('#goodsSn').val($('#goodOption option:selected').text());$('#goodId').val($('#goodOption').val());">
		<option></option>
		</select>
		</fieldset> 
	</div> -->
</div>

<script type="text/javascript">
//page java sciprt

jQuery("#jqGridTable").jqGrid({
    mtype : 'GET',
    url : "",
    datatype : "json",
    colNames : [ '料件編號', '料件序號', '客戶名稱', '保固類型', '保固日期', '保固備註', '刪除'],
    colModel : 
    	[{name : 'dtlsPartsName',index : 'PartsName',sortable:false,width : 50, formatter:productFormatter}, 
    	 {name : 'dtlsPartsSn',index : 'PartsSn',sortable:false,width : 80,formatter:goodsFormatter},
    	 {name : 'dtlsCustomerName',index : 'warrantyType',sortable:false,width : 50,formatter:customerFormatter}, 
    	 {name : 'warrantyType',index : 'warrantyType',sortable:false,width : 50,formatter:typeFormatter}, 
    	 {name : 'warrantyDate',index : 'warrantyDate',sortable:false,width : 50,formatter:dateFormatter}, 
    	 {name : 'comments',index : 'warrantyAlt',sortable:false,width : 50,formatter:altFormatter}, 
    	 {name : 'del',index : 'del',width : 20,align:"center",sortable:false,formatter:actionItem}],
    viewrecords : true,

    caption : "銷售明細清單",
    width : 940,
    height: '100%'
});

function productFormatter(cellvalue, options, rowObject){
	return cellvalue + "<input type=hidden name=partsId[] value="+cellvalue+">";
}

function goodsFormatter(cellvalue, options, rowObject){
	return cellvalue + "<input type=hidden name=goodsId[] value="+cellvalue+">";
}

function customerFormatter(cellvalue, options, rowObject){
	return cellvalue + "<input type=hidden name=dtlsCustomerId[] value="+rowObject.dtlsCustomerSelect+">";
}

function typeFormatter(cellvalue, options, rowObject){
	return cellvalue + "<input type=hidden name=type[] value="+cellvalue+">";
}

function dateFormatter(cellvalue, options, rowObject){
	return cellvalue + "<input type=hidden name=date[] value="+cellvalue+">";
}

function altFormatter(cellvalue, options, rowObject){
	return cellvalue + "<input type=hidden name=alts[] value="+cellvalue+">";
}

function actionItem (cellvalue, options, rowObject){

	return "<input type='button' value='刪除' onclick=\"$('#jqGridTable').jqGrid('delRowData', "+options.rowId+");\" />";
}


$(document).ready(function(){
var dindex = 0;

//for initial some object
$.ajax({
	url: "/drcms/sales/initialPageJson",
	type: "GET",
	dataType: "json",
	success: function(res) {
		dwr.util.addOptions( "customerNameOption",res.customers,'id','customerName');
		dwr.util.addOptions( "resellerNameOption",res.customers,'id','customerName');
		dwr.util.addOptions( "dtlsCustomerSelect",res.customers,'id','customerName');
		//dwr.util.addOptions( "skuOption",res.skus,'id','skuName');
		//dwr.util.addOptions( "goodOption",res.goods,'id','id');
		dwr.util.addOptions( "warrantyType",res.warrantyTypes,'id','id');
		dwr.util.addOptions( "warrantyTypeSelect",res.warrantyTypes,'id','id');		
		dwr.util.addOptions( "sapSalesOrder",res.saps,'id','id');
		$('#sapSalesOrder').change();
		dwr.util.addOptions( "partsOption",res.parts,'id', partsFormatter);
		//$("#partsOption").val($("#partsOption option:first").val());
		//$('#partsOption').change();
		dwr.util.addOptions( "salesManSelect",res.salesUsers,'id', 'account');
		$('#salesManSelect').change();
		$("#salesManSelect").val($("#salesManSelect option:first").val());
		
		var d = new Date();
		dwr.util.setValue("warrantyDate", d.getFullYear() + "-" + (d.getMonth()+1) + "-" + d.getDate());
	}
});


//for Sales Detail Add dialog
$("#salesDetailAddDialog").dialog({
    autoOpen: false,
    modal: true,
	width: 600, height: 400,
    buttons: {
        "新增": function() {
        	if($('#detailForm').valid()){
	        	var parameters = $('#detailForm').serializeObject();
	        	$("#jqGridTable").jqGrid("addRowData", dindex++, parameters);
				$(this).dialog("close");
        	}
        },
		"取消": function() {
            $(this).dialog("close");
        }
    }
});

$("#salesDetailAjaxAddBtn").click(function(event) {
    event.preventDefault();
    $('#detailForm')[0].reset();
    $('#snOption option').remove();
    dwr.util.setValue("dtlsCustomerSelect", $( "#customerNameOption option:selected" ).text());
    dwr.util.setValue("dtlsCustomerName", $( "#customerNameOption option:selected" ).text());
    dwr.util.setValue("warrantyTypeSelect", $( "#warrantyType option:selected" ).text());
    dwr.util.setValue("dtlsWarrantyDate", $( "#warrantyDate" ).val());
    $("#salesDetailAddDialog").dialog("open");
});

//sku select
$("#skuSelect").dialog({
    autoOpen: false,
    modal: true,
	width: 300, height: 220,
    buttons: {
		"OK": function() {
            $(this).dialog("close");
        }
    }
});

$("#skuChoose").click(function(event) {
    event.preventDefault();
    $("#skuSelect").dialog("open");
});

//good select 
$("#goodSelect").dialog({
    autoOpen: false,
    modal: true,
	width: 300, height: 220,
    buttons: {
    	"OK": function() {
            $(this).dialog("close");
        }
    }
});

$("#goodChoose").click(function(event) {
    event.preventDefault();
    $("#goodSelect").dialog("open");
});


//custom validation for option select...
$.validator.addMethod("valueNotEquals", function(value, element, arg){
	return arg != value;
}, "Value must not equal arg.");

$.validator.addMethod('greaterThanOne', function(value, element) {
	var rowCount = $("#jqGridTable tr").length;
    return rowCount > 1;
}, " Amount must be greater than one");

$('#mainForm').validate({
	rules: {
		
		'warrantyType': { valueNotEquals: "-1" },
		jqGridTable: { greaterThanOne: true }
	},
	messages: {
		sapSalesOrder: "請至少選擇一個SAP" ,
		'warrantyType': { valueNotEquals: "請選擇一個!!!" },
		jqGridTable: { greaterThanOne: "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" }
	}  
});

$('#detailForm').validate({
	rules: {
		'dtlsPartsName': { valueNotEquals: "-1" }
	},
	messages: {
		'dtlsPartsName': { valueNotEquals: "請選擇一個料件，才有辦法選擇料件序號。" },
		'dtlsPartsSn': "請至少選擇一個閒置的料件序號。",
	}  
});

//add submit and validate
$( "#salesDataAddAjaxAddBtn" ).click(function() {
	if($("#mainForm").valid()){
		$.ajax({
			url: "/drcms/sales/addSubmit",
			type: "POST",
			dataType: "json",
			data : $("#mainForm").serialize(),
			success: function(res) {},
			error: function() {
				alert('新增錯誤!!!請確認是否資料有誤或者沒有新增銷售單明細!!!');
			}
		}).done(function() {
			setTimeout(function () {$.growlUI('銷售單建立完成!!!', '轉頁中... 請稍後...');}, 1);
        	setTimeout(function () {window.location.href = '/drcms/sales';}, 4000);
		});
	}
});

//SapSO change event...
$("#sapSalesOrder").change(function() {
	
	var sapId = $("#sapSalesOrder").val();
	if(sapId !=-1){
		$("#customerNameOption").prop('disabled', false);
		$("#resellerNameOption").prop('disabled', false);
		
		$.ajax({
			url: "/drcms/sales/querySAPbyId/" + sapId,
			type: "GET", dataType: "json",
			success: function(res) {
				dwr.util.setValue("customerNameOption", res.customer.customerName);
				dwr.util.setValue("resellerNameOption", res.customer.customerName);
				dwr.util.setValue("salesDate", res.salesDate);
			}
		}).done(function(res){
			$("#customerNameOption").change();
		});
	}else{
		$("#customerNameOption").prop('disabled', true);
		$("#resellerNameOption").prop('disabled', true);
		$("#salesDate").val('');
	}
});

//customer change event
$("#customerNameOption").change(function() {
	$.ajax({
		url: "/drcms/customer/get/" + $("#customerNameOption").val(),
		type: "GET", dataType: "json",
		success: function(res) {
			var salesTypeArr=["直銷","經銷"];
			dwr.util.setValue("salesManSelect", res.owner);
			dwr.util.setValue("salesType", salesTypeArr[res.customerType]);
			dwr.util.setValues(objectEval(JSON.stringify(res)));
			$("#salesManSelect").change();
		}
	});
});


$("#dtlsCustomerSelect").change(function() {
	dwr.util.setValue("dtlsCustomerName", $( "#dtlsCustomerSelect option:selected" ).text());
});

//parts option
$("#partsOption").change(function() {
	var partsId = $("#partsOption").val();
	
	$.ajax({
		url: "/drcms/sales/listGoodsbyPartsId",
		type: "GET", dataType: "json", data: {'id' : partsId},
		success: function(res) {
			dwr.util.removeAllOptions("snOption");
			dwr.util.addOptions( "snOption", res, 'id','id');
			$("input[name='goodsId[]']").each(function(){
				tmp = $(this).val();
				$("#snOption option[value="+tmp+"]").remove();
			}); 
			$("#snOption").val($("#snOption option:first").val());
		}
	});
});

});



function partsFormatter(obj) { return obj.id+ "｜" + obj.description; }
</script>