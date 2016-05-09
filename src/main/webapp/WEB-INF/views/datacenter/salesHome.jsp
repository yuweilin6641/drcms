<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
.ui-dialog{font-size:14px;}
</style>

<script type="text/javascript">
//page java sciprt
var salesTypeArr=["直銷","經銷"];
var salesDtlsJson = "";
var pickDtlsJson = "";

//For left click item list...
$(window).load(function(){
	//delete sales mst confirm Dialog
	var $confirmDialog = $('<div></div>').html('確定要刪除此銷售單??').dialog({
		autoOpen: false, title: '刪除確認',
		buttons: {
		"OK": function () {
			$.ajax({
				url: "/drcms/sales/deleteSubmit/"+dIndex,
				type: "GET", dataType: "json",
				success: function() {
					//$("#queryAjaxBtn").click(); //refresh
					$("#jqGridTable").trigger("reloadGrid");
				},
				error: function() {
					alert('error');
				}
			});
			
			$(this).dialog("close");
		},
		"Cancel": function () {
			$(this).dialog("close");
		}
		}
	});
	
	//delete sales dtl confirm Dialog
	var $confirmDialogDtls = $('<div></div>').html('確定要刪除此銷售明細??').dialog({
		autoOpen: false, title: '刪除確認',
		buttons: {
		"OK": function () {
			$.ajax({
				url: "/drcms/sales/deleteSalesDtl/"+dIndex,
				type: "POST", dataType: "json",
				success: function(res) {
				},
				error: function() {
					alert('error');
				}
			});
			
			$(this).dialog("close");
		},
		"Cancel": function () {
			$(this).dialog("close");
		}
		}
	});
	
$(function(){
    $.contextMenu({
        selector: '.salesDataActionList', 
		trigger: 'left', 
        callback: function(key, options) { //function
			if(key=='editMst'){				
				$("#salesDataModifyMstDialog").dialog("open");
			}else if(key=='editDtl'){
				$("#salesDataModifyDtlDialog").dialog("open");

			}else if(key=='delete'){
				dIndex = $(this).attr("value");
				$confirmDialog.dialog('open');
			}
        },
        items: {
			"editMst": {name: "修改銷售單"},
			"editDtl": {name: "修改銷售明細"},
			<c:if test="${fn:contains(sessionScope.USER_ROLES, 'ROLE_6')}">
            "delete": {name: "刪除"}
            </c:if>
        }
    });
});

$(function(){
    $.contextMenu({
        selector: '.salesDtlDataActionList', 
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
			"edit": {name: "修改"},
			<c:if test="${fn:contains(sessionScope.USER_ROLES, 'ROLE_6')}">
            "delete": {name: "刪除"}
            </c:if>
        }
    });
});

//for enter key
$('#queryTable').keypress(function(e) {
	var key = window.event ? e.keyCode : e.which;
	if (key == 13) $('#queryAjaxBtn').click();
});

//clear button
$("#clearBtn").click(function() {
	location.reload();
});

//first load (debug)
$('#queryAjaxBtn').click();
});//]]> 

$(document).ready(function(){
	
//initial page
$.ajax({
	url: "/drcms/sales/initialPageJson",
	type: "GET",
	dataType: "json",
	success: function(res) {
		dwr.util.addOptions( "sapSalesOrder",res.saps,'id','id');
		dwr.util.addOptions( "customerNameOption",res.customers,'id','customerName');
		dwr.util.addOptions( "resellerNameOption",res.customers,'id','customerName');

		dwr.util.addOptions( "dtlsCustomerSelect",res.customers,'id','customerName');
		//dwr.util.addOptions( "skuOption",res.skus,'id','skuName');
		//dwr.util.addOptions( "goodOption",res.goods,'id','id');
		dwr.util.addOptions( "warrantyType",res.warrantyTypes,'id','id');
		dwr.util.addOptions( "sd.warrantyType",res.warrantyTypes,'id','id');
		dwr.util.addOptions( "partsOption",res.parts,'id', partsFormatter);
		dwr.util.addOptions( "salesManSelect",res.salesUsers,'id', 'account');
	}
});

//for create customer option...
$.ajax({
	url: "/drcms/customer/listforOption",
	type: "GET",
	dataType: "json",
	success: function(res) {
		dwr.util.addOptions( "customerNameOption",res,'id','customerName');
		dwr.util.addOptions( "resellerNameOption",res,'id','customerName');
	}
});	

//list all customer data...
$("#queryAjaxBtn").click(function(event) {
	event.preventDefault();
	$(".CSSTableGenerator").removeClass();
	$("#mainTable").attr("id","jqGridTable");
	showTable();
		
});

$("#salesDataAjaxAddBtn").click(function(event) {
    event.preventDefault();
    window.location = "sales/add";
});

//custom validation for option select...
$.validator.addMethod("valueNotEquals", function(value, element, arg){
	return arg != value;
}, "Value must not equal arg.");

$('#modifyForm').validate({
	rules: {
		'sapSalesOrder': { valueNotEquals: "-1" },
		'warrantyType': { valueNotEquals: "-1" },
		'salesManSelect': { valueNotEquals: "-1" }
	},
	messages: {
		'sapSalesOrder': { valueNotEquals: "請選擇一個!!!" },
		'warrantyType': { valueNotEquals: "請選擇一個!!!" },
		'salesManSelect': { valueNotEquals: "請選擇一個!!!" }
	}  
});

//for salesMst Data edit dialog
$("#salesDataModifyMstDialog").dialog({
    autoOpen: false,
    modal: true,
	width: 550, height: 530,
    buttons: {

    	"Save": function() {
    		if($("#modifyForm").valid()){
	        	$.ajax({
	
	        		url: "/drcms/sales/editSubmit",
	        		type: "GET",
	        		data: $("#salesDataModifyMstDialog > form").serialize(),
	
	        		success: function(res) {
	        			$('#jqGridTable').trigger( 'reloadGrid' );
	        			//$("#queryAjaxBtn").click(); //refresh
	        		},
	        		error: function() {
	        			alert("ERROR!!!");
	        		}
	
	        	}).done(function( data ) {
					$("#salesDataModifyMstDialog").dialog("close");
				});
    		}
        },
		"Cancel": function() {
            $(this).dialog("close");
        }
    }
});

//show dtls dialog
$("#salesDataModifyDtlDialog").dialog({
    autoOpen: false,
    modal: true,
	width: 800, height: 400,
    buttons: {
		"OK": function() {
            $(this).dialog("close");
        }
    }
});

//edit dtls dialog
$("#salesDtlDataModifyDialog").dialog({
    autoOpen: false,
    modal: true,

	width: 750, height: 400,
    buttons: {
        "Save": function() {
        	//TODO: detail edit...
        	//alert($("#salesDtlEditForm").serialize()+"zzzzzzzzzzzzzzzzz");
        	$.ajax({
        		url: "sales/editSalesDtls",
        		type: "GET",
        		data: $("#salesDtlEditForm").serialize(),
        		
        		success: function(res) {
        			//alert(res);
        			//$(this).dialog("close");
        		},
        		error: function() {
        			alert("ERROR!!!");
        		}
        	}).done(function( data ) {
        		//refresh detail jqgrid table...        		
        		$.ajax({
					url: "/drcms/sales/get/"+data.salesMstId,
					type: "GET",
					dataType: "json",
					success: function(res) {
						
					},
					error: function() {
						alert('detail refresh error');
					}
				}).done(function( data ) {
					//refresh

					$("#jqgridTableDtl").jqGrid('setGridParam',{datatype:'jsonstring',datastr:data.salesDtls}).trigger("reloadGrid"); 
				});
        		
				$("#salesDtlDataModifyDialog").dialog("close");

			});
        },
		"Cancel": function() {
            $(this).dialog("close");
        }
    }
});


//parts option
$("#partsOption").change(function() {
	var partsId = $("#partsOption").val();
	//$('#partsId').val($('#partsOption').val());
	createGoodsSnOptionWithPartsId(partsId, null);
});


/* //sku select
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
}); */


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


});


//jqGridTable code...
function showTable(){
	cindex = 0;
	dindex = 0;
	
	//sales mst table
	$("#jqGridTable").jqGrid({
	   	url:'/drcms/sales/list' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width(),
		height: '100%',
		loadonce:false,

	   	colNames:['系統編號','客戶','經銷商','銷售方式','SAP ORDER', '銷售日期', '銷售人員' ,'動作'],
	   	colModel:[ //name for json data

	   		{name:'id',index:'id', width:27, align:"center",sortable:false},
	   		{name:'customer.customerName',index:'customer', width:90,sortable:false},
	   		{name:'reseller.customerName',index:'reseller', width:90,sortable:false},
	   		{name:'salesType',index:'SalesType', width:50, align:"center", sortable:false, formatter:turnSalesType},
	   		{name:'sapSalesOrder',index:'SAPSO', width:90,sortable:false},
	   		{name:'salesDate',index:'date', width:50,sortable:false, formatter:timetostampFn},
	   		{name:'salesMan',index:'salesMan', width:90,sortable:false},
	   		{name:'action', index:'action', width:20, align:"center", sortable:false, formatter:actionItem}		   		
	   	],
	   	rowNum:15,
	   	pager: '#jqGridPager',
	   	sortname: 'id',
	    viewrecords: true,
	    sortorder: "desc",
	    onPaging: function(pgButton){ 
			$("#jqGridTable").setGridParam({url:'sales/list' + processUrl()});
		},
		onSelectRow: function(ids) {
			
			if(cindex != ids){
				cindex = ids;
				
				$.ajax({
					url: "/drcms/sales/get/"+ids,
					type: "GET",
					dataType: "json",
					success: function(res) {

						res.salesType = salesTypeArr[res.salesType];
						dwr.util.setValues(objectEval(JSON.stringify(res)));
						dwr.util.setValue('customerNameOption',res.customer.customerName);
						dwr.util.setValue('resellerNameOption',res.reseller.customerName);
						dwr.util.setValue('salesDate',timestampToDateWithoutTime(res.salesDate));
						dwr.util.setValue('salesManSelect', res.salesMan);
						salesDtlsJson = res.salesDtls;
					},
					error: function() {
						alert('error');
					}
				}).done(function( data ) {
					//list Dtl for Dtl dialog

					$("#jqgridTableDtl").jqGrid('setGridParam',{datatype:'jsonstring',datastr:salesDtlsJson}).trigger("reloadGrid"); 
				});
				
			}else{
				
			}
			
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});
	

	$("#jqGridTable").setGridParam({url:'sales/list' + processUrl() }).trigger("reloadGrid");
	
	

	//Sales Detail table...
	$('#jqgridTableDtl').jqGrid({

		width: 750,
		height: '100%',
		loadonce:false,

		colNames : [ '料件名稱', '料件序號', '客戶名稱', '保固類型', '保固日期', '保固備註', '動作'],
	   	colModel:[
				{name : 'parts.id',index : 'id',sortable:false,width : 50}, 
	   	    	{name : 'goodsSn',index : 'goodsSn',sortable:false,width : 90},
	   	    	{name : 'customer.customerName',index : 'customer.customerName',sortable:false,width : 50},
	   	    	{name : 'warrantyType',index : 'warrantyType',sortable:false,width : 25, formatter:warrantyTypeItem}, 
	   	    	{name : 'warrantyDate',index : 'warrantyDate',sortable:false,width : 50}, 
	   	    	{name : 'comments',index : 'comments',sortable:false,width : 50}, 
	   	    	{name : 'del',index : 'del',width : 20,align:"center",sortable:false,formatter:dtlActionItem}
	   	    	],
	    viewrecords: true,

	    onSelectRow: function(ids) {	
	    	//set values into salesDtls Dialog...
	    	if(dindex != ids){

	    		for(var i = 0;i<salesDtlsJson.length;i++)if(ids==salesDtlsJson[i].id)pickDtlsJson = salesDtlsJson[i];
				dindex = ids;
				dwr.util.setValues(objectEval(JSON.stringify(pickDtlsJson)), { idPrefix : 'sd' });
				dwr.util.setValue('partsOption',pickDtlsJson.parts.id);
				dwr.util.setValue('partsId',pickDtlsJson.parts.id);
				createGoodsSnOptionWithPartsId(pickDtlsJson.parts.id , pickDtlsJson.goodsSn);
				dwr.util.setValue('dtlsCustomerSelect',pickDtlsJson.customer.customerName);
				dwr.util.setValue('sd.warrantyType',pickDtlsJson.warrantyType.id);
	    	}
	    }
	});
}


//process url value...
function processUrl(){
	var tempUrl = $("#tempUrl").val();
	
	url = '?sap='+$("#sapQuery").val()+
		'&customerName='+$("#customerNameQuery").val()+
		'&salesType='+$("#salesTypeQuery").val()+
		'&fromDate='+$("#fromDate").val()+
		'&toDate='+$("#toDate").val();
	
	$("#tempUrl").val(url);
	
	if(tempUrl != url){
		url+="&queryChange=true";
	}else{
		url+="&queryChange=false";
	}
			
	return url;
}

function createGoodsSnOptionWithPartsId(partsId, goodsSn){
	$.ajax({
		url: "/drcms/sales/listGoodsbyPartsId",
		type: "GET", dataType: "json", data: {'id' : partsId},
		success: function(res) {
			dwr.util.removeAllOptions('snOption');
			dwr.util.addOptions( "snOption", res, 'id','id');
			//dwr.util.setValue("goodsSn",$("#snOption option").val());
		}
	}).done(function(res) {
		if(goodsSn!=null){
			dwr.util.setValue('snOption',pickDtlsJson.goodsSn);
		}
	});
}

function turnSalesType(cellvalue, options, rowObject){
	return salesTypeArr[rowObject.salesType];
}

function timetostampFn(cellvalue, options, rowObject){
	return timestampToDateWithoutTime(rowObject.salesDate);
}

function actionItem (cellvalue, options, rowObject){
	return "<img class='actionImg salesDataActionList' value="+rowObject.id+" ></img>";
}

function warrantyTypeItem (cellvalue, options, rowObject){
	return rowObject.warrantyType.id;
}

function dtlActionItem (cellvalue, options, rowObject){
	return "<img class='actionImg salesDtlDataActionList' value="+rowObject.id+" ></img>";
}

function partsFormatter(obj) { return obj.id+ "｜" + obj.description; }
</script>

<h1 class="contentTitle">銷售資料維護</h1>
<div align="center">
	<div class="pageFirstDiv" >
		<table id="queryTable" >
			<tr>
                <td class="contentTD">
				<p>SAP_SO：</p>
				<input type="text" id="sapQuery" >
				</td>
				<td class="contentTD">
				<p>客戶名稱：</p>
				<input type="text" id="customerNameQuery" >
				</td>
				
				<td class="contentTD" style="width:20%;" >
				<p>銷售日期：</p>
				
				<input type="text" id="fromDate" style="width:45%;" >~<input type="text" id="toDate" style="width:45%;">
				</td>
				<td class="contentTD">
				<p>銷售方式：</p>
				<select id="salesTypeQuery">
					<option value="-1">全部</option>
					<option value="0">直銷</option>
					<option value="1">經銷商</option>
				</select>
				</td>
                <td class="lastTD">
					<input class="JQbtn" type="button" value="查詢" id="queryAjaxBtn" >
					<input class="JQbtn" type="button" value="清除" id="clearBtn" >
					<input type="hidden" id="tempUrl"  >
				</td>
            </tr>
         </table>
	</div>

	
	<div class="CSSTableGenerator">
		<table id="mainTable">
            <thead id="mainTableHead">

            <TR><th>None</th></TR>
            </thead>
            <tbody id="mainTableBody">
            <tr style="text-align:center;"><td>No Data...</td></tr>
            </tbody>           
			
         </table>
	</div>
	<div id="jqGridPager"></div>
	
</div>

<!-- Dialog Content -->

<div id="salesDataModifyMstDialog" title="修改銷售資料">
	<form method="post" id="modifyForm">
		<fieldset>
			<table>
				<tr>
					<td style="width: 30%">*SAP SO :</td>
					<td><input type="hidden" id="id" name="id">
						<select name="sapSalesOrder" id="sapSalesOrder" style="width: 120px" class="textbox">
					</select></td>
				</tr>
				<tr>
					<td>客戶名稱 :</td>
					<td><select id="customerNameOption" name="customerId" style="width: 120px"></select></td>
				</tr>
				<tr>
					<td>經銷商名稱 :</td>
					<td><select id="resellerNameOption" name="resellerId" style="width: 120px"></select></td>
				</tr>
				<tr>
					<td>銷售日期 :</td>
					<td><input type="text" id="salesDate" name="salesDate"
						class="pickDate required dateISO date textbox"></td>
				</tr>
				<tr>
					<td>銷售類型 :</td>
					<td><select name="salesType" id="salesType" style="width: 120px">
							<option value="0">直銷</option>
							<option value="1">經銷</option>
					</select></td>
				</tr>
				<tr>
					<td>*緯穎業務負責人 :</td>
					<td><select name="salesManSelect" id="salesManSelect"
						onchange="$('#salesMan').val($('#salesManSelect option:selected').text());" style="width: 120px"></select>
						<input type="hidden" name="salesMan" id="salesMan"></td>
				</tr>
				<!-- <tr><td>Sale Date :</td><td><input type="text" name="salesDate" id="salesDate" class="pickDate" ></td></tr> -->
				<tr>
					<td>業務窗口姓名 :</td>
					<td><input type="text" name="bizContact" id="bizContact"></td>
				</tr>
				<tr>
					<td>業務窗口電話 :</td>
					<td><input type="text" name="bizPhone" id="bizPhone" class="digits" ></td>
				</tr>
				<!-- <tr><td>Biz Cell :</td><td><input type="text" name="bizCell" id="bizCell" ></td></tr> -->
				<tr>
					<td>業務窗口E-Mail :</td>
					<td><input type="text" name="bizEmail" id="bizEmail" class="email" ></td>
				</tr>
				<tr>
					<td>技術窗口姓名 :</td>
					<td><input type="text" name="techContact" id="techContact"></td>
				</tr>
				<tr>
					<td>技術窗口電話 :</td>
					<td><input type="text" name="techPhone" id="techPhone" class="digits" ></td>
				</tr>
				<!-- <tr><td>Tech Cell :</td><td><input type="text" name="techCell" id="techCell" ></td></tr> -->
				<tr>
					<td>技術窗口E-Mail :</td>
					<td><input type="text" name="techEmail" id="techEmail" class="email" ></td>
				</tr>
				<tr>
					<td>預設保固類型 :</td>
					<td><select name="warrantyType" id="warrantyType" style="width: 120px">
					</select></td>
				</tr>
				<tr>
					<td>預設保固起始日期 :</td>
					<td><input type="text" name="warrantyDate" id="warrantyDate"
						class="pickDate required dateISO date"></td>
				</tr>
			</table>
		</fieldset>
	</form>
</div>

<!-- Dialog Content -->

<div id="salesDataModifyDtlDialog" title="修改銷售明細資料" >
<form method="post">
	<table id="jqgridTableDtl"></table>
</form>

<div id="salesDtlDataModifyDialog" title="修改銷售明細" >
	<fieldset>
	<form id="salesDtlEditForm">

	<table>
		<tr><td width="25%">料件名稱 :</td><td>
		<select id="partsOption" name="partsId">
		</select><!-- <input type="hidden" name="partsId" id="partsId" > --></td></tr>
		<tr><td>料件序號 :</td><td>
		<select id="snOption" name="goodsSn"></select>
		<!-- <input type="hidden" name="goodsSn" id="sd.goodsSn"> --></td></tr>
		<tr><td>客戶名稱 :</td><td><select name="dtlsCustomerSelect" id="dtlsCustomerSelect"></select></td></tr>
		<tr><td>保固類型 :</td><td><select name="warrantyTypeStr" id="sd.warrantyType" ></select></td></tr>
		<tr><td>保固日期 :</td><td><input type="text" name="warrantyDate" id="sd.warrantyDate" class="pickDate" ></td></tr>
		<tr><td>保固備註 :</td><td><input type="text" name="comments" id="sd.comments"></td></tr>
		<tr><td><input type="hidden" name="id" id="sd.id"><input type="hidden" name="salesMstId" id="sd.salesMstId"></td></tr>
	</table>
	</form>
	</fieldset> 
	

	<!-- <div id="skuSelect" title="Choose Product" >
		<fieldset>
		<select id="skuOption" onchange="$('#sd\\.sku').val($('#skuOption option:selected').text());$('#skuId').val($('#skuOption').val());">
		<option></option>
		</select>
		</fieldset> 
	</div>
	
	<div id="goodSelect" title="Mapping Confirguation"  >
		<fieldset>
		<select id="goodOption" onchange="$('#sd\\.goodsSn').val($('#goodOption option:selected').text());$('#goodId').val($('#goodOption').val());">
		<option></option>
		</select>
		</fieldset> 

	</div> -->
</div>
</div>