<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
.ui-dialog{font-size:14px;}
</style>


<script type="text/javascript">
//page java sciprt
var customerTypeArr=["直銷客戶","經銷商"];
var customerStatusArr=["Active","Disabled"];
var dIndex;
//For left click item list...
$(window).load(function(){
	
	//delete confirm Dialog
	/* var $confirmDialog = $('<div></div>').html('確認刪除此客戶資料??').dialog({
		autoOpen: false, title: '刪除確認',
		buttons: {
		"OK": function () {
			$.ajax({
				url: "/drcms/customer/deleteSubmit/"+dIndex,
				type: "GET",
				dataType: "json",
				success: function() {
					$("#queryAjaxBtn").click(); //refresh
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
	}); */
	
	//msg Dialog
	var $msgDialog = $('<div></div>').html('因此客戶有被SAP資料或銷售資料參考，故無法刪除。').dialog({
		autoOpen: false, title: '訊息提示',
		buttons: {
		"OK": function () {$(this).dialog("close");}
		}
	});
	
$(function(){
    $.contextMenu({
        selector: '.customerDataActionList', trigger: 'left',
        callback: function(key, options) { 
			if(key=='edit'){
				$.ajax({
					url: "/drcms/customer/get/"+$(this).attr("value"),
					type: "GET",
					dataType: "json",
					success: function(res) {
						res.customerType = customerTypeArr[res.customerType];
						res.customerStatus = customerStatusArr[res.customerStatus];
						dwr.util.setValues(objectEval(JSON.stringify(res)));
					    dwr.util.setValue('salesManSelect', res.owner);
					},
					error: function() {
						alert('error');
					}
				}).done(function( data ) {
					$("#customerDataModifyDialog").dialog("open");
				});
			}else if(key=='delete'){
				/* dIndex = $(this).attr("value");
				$.ajax({
					url: "/drcms/customer/removePermit/"+$(this).attr("value"),
					type: "POST", dataType: "json",
					success: function(res) {
						if((res===true)){
							$confirmDialog.dialog('open');
						}else{
							$msgDialog.dialog('open');
						}
					},
					error: function() {}
				}); */
			}
        },
        items: {
			"edit": {name: "編輯"},
			<c:if test="${fn:contains(sessionScope.USER_ROLES, 'ROLE_6')}">
            //"delete": {name: "刪除"}
			</c:if>
        }
    });
});

//for cusomter modify validate
$("#modifyForm").validate();

});



$(document).ready(function(){

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
	
//list all customer data...
$("#queryAjaxBtn").click(function() {
	$(".CSSTableGenerator").removeClass();
	$("#mainTable").attr("id","jqGridTable");
	showTable();
});

//add customer data button click...
$("#customerDataAddAjaxAddBtn").click(function(event) {
    event.preventDefault();
    window.location = "/drcms/customer/add";
});



//for Customer Data modify dialog
$("#customerDataModifyDialog").dialog({
    autoOpen: false,
    modal: true,
	width: 800, height: 600,
    buttons: {
        "修改": function() {
        	if($("#modifyForm").valid()){
	        	$.ajax({
	        		url: "/drcms/customer/editSubmit",
	        		type: "POST", data: $("#customerDataModifyDialog > form").serialize(),
	        		success: function(JData) {
	        			$('#jqGridTable').trigger( 'reloadGrid' );
	        			$("#queryAjaxBtn").click(); //refresh
	        		},
	        		error: function() {
	        			alert("ERROR!!!");
	        		}
	        	}).done(function( data ) {
					$("#customerDataModifyDialog").dialog("close");
				});
        	}
        },
		"取消": function() {
            $(this).dialog("close");
        }
    }
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

//reload when first coming
$('#queryAjaxBtn').click();

});


//jqGridTable code...
function showTable(){
	//processUrl();
	
	$("#jqGridTable").jqGrid({			
	   	url:'customer/list' + processUrl(),
		datatype: "json",
		width:$(".pageFirstDiv").width(),
		height: '100%',
		loadonce:false,
	   	colNames:['ID','客戶名稱','客戶類別', '電話', '傳真' , '業務聯絡人', '業務電話', '業務E-mail', '技術聯絡人', '動作'],
	   	colModel:[
	   		{name:'id',index:'id', width:50, align:"center",sortable:false},
	   		{name:'customerName',index:'customerName', width:90,sortable:false},
	   		{name:'customerType',index:'customerType', width:50,sortable:false, formatter:turnCsrType},
	   		{name:'tel',index:'tel', width:50,sortable:false},
	   		{name:'fax',index:'fax', width:50,sortable:false},
	   		{name:'bizContact',index:'bizContact', width:90,sortable:false},
	   		{name:'bizTel',index:'bizTel', width:50,sortable:false},
	   		{name:'bizEmail',index:'bizEmail', width:90,sortable:false},
	   		{name:'techContact',index:'techContact', width:90,sortable:false},
	   		{name:'action', index:'action', width:20, align:"center", formatter:actionItem}		   		
	   	],
	   	rowNum:15,
	   	pager: '#jqGridPager',
	   	sortname: 'id',
	    viewrecords: true,
	    sortorder: "desc",
	    onPaging: function(pgButton){ 
			$("#jqGridTable").setGridParam({url:'customer/list' + processUrl()});
		},
	});
	$("#jqGridTable").jqGrid('navGrid','#jqGridPager',{edit:false,add:false,del:false,search:false});

	$("#jqGridTable").setGridParam({url:'customer/list' + processUrl()}).trigger("reloadGrid");
}

//process url value...
function processUrl(){
	var tempUrl = $("#tempUrl").val();
	
	url = '?customerSapId='+$("#customerSapId").val()+
		'&customerName='+$("#customerNameQuery").val()+
		'&customerStatus='+$("#customerStatusQuery").val()+
		'&customerType='+$("#customerTypeQuery").val() +
		'&bizContact='+$("#bizContactQuery").val() +
		'&techContact='+$("#techContactQuery").val();
	
	$("#tempUrl").val(url);
	
	if(tempUrl != url){
		url+="&queryChange=true";
	}else{
		url+="&queryChange=false";
	}
			
	return url;
}

function actionItem (cellvalue, options, rowObject){
	return "<img src='/drcms/images/action.png' class='actionImg customerDataActionList' value="+rowObject.id+" ></img>";
}
	
function turnCsrType (cellvalue, options, rowObject){
	return customerTypeArr[rowObject.customerType];
}
	
function turnCsrStatus (cellvalue, options, rowObject){
	return customerStatusArr[rowObject.customerStatus];
}


</script>


<h1 class="contentTitle">客戶資料維護</h1>
<div align="center">
	<div class="pageFirstDiv" >
		<table id="queryTable">
			<tr>
                <td class="contentTD">
                <p>SAP ID：</P>
				<input type="text" id="customerSapId" >
				</td>
				<td class="contentTD">
				<p>客戶名稱：</P>
				<input type="text" id="customerNameQuery" >
				</td>
				<td class="contentTD">
				<p>狀態：</P>
				<select id="customerStatusQuery" >
					<option value="">全部</option>
					<option value="0">Active</option>
					<option value="1">Disabled</option>
				</select>
				</td>
				<td class="contentTD">
				<p>業務類別：</p>
				<select id="customerTypeQuery">
					<option value="">全部</option>
					<option value="0">直銷客戶</option>
					<option value="1">經銷商</option>
				</select>				
				</td>
				<td class="contentTD">
				<p>業務聯絡人：</P>
				<input type="text" id="bizContactQuery" >
				</td>
				<td class="contentTD">
				<p>技術聯絡人：</P>
				<input type="text" id="techContactQuery" >
				</td>
                <td  class="lastTD">
					<input class="JQbtn" type="button" value="查詢" id="queryAjaxBtn" >
					<!-- <input class="JQbtn" type="button" value="新增" id="customerDataAddAjaxAddBtn" > -->
					<input class="JQbtn" type="button" value="清除" id="clearBtn">
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
<div id="customerDataModifyDialog" title="修改客戶資料">
	<form method="post" id="modifyForm">
		<fieldset>
			<table>
				<tr>
					<td width="40%">*客戶名稱：</td>
					<td><input id="customerName" name="customerName" type="text"
						class="required"></td>
				</tr>
				<tr>
					<td>SAP_ID：</td>
					<td><input id="sapId" name="sapId" type="text"></td>
				</tr>
				<tr>
					<td>客戶類別：</td>
					<td><select id="customerType" name="customerType">
							<option value="0">直銷客戶</option>
							<option value="1">經銷商</option>
					</select></td>
				</tr>
				<tr>
					<td>客戶狀態：</td>
					<td><select id="customerStatus" name="customerStatus">
							<option value="0">Active</option>
							<option value="1">Disabled</option>
					</select></td>
				</tr>
				<tr>
					<td>客戶簡稱：</td>
					<td><input id="customerShortName" name="customerShortName"
						type="text"></td>
				</tr>
				<tr>
					<td>*緯穎負責業務：</td>
					<td><select id="salesManSelect" name="salesManSelect"
						onchange="$('#owner').val($('#salesManSelect option:selected').text());" class="required" >
					</select><input type="hidden" name="owner" id="owner"></td>
				</tr>
			</table>
			<HR>
			<table>
				<tr>
					<td>主要聯絡人：</td>
					<td><input id="mainContact" name="mainContact" type="text"></td>
				</tr>
				<tr>
					<td>*統一編號：</td>
					<td><input id="vatNum" name="vatNum" type="text" class="required"></td>
				</tr>
				<tr>
					<td>國別：</td>
					<td><input id="country" name="country" type="text"></td>
				</tr>
				<tr>
					<td>城市：</td>
					<td><input id="city" name="city" type="text"></td>
				</tr>
				<tr>
					<td>郵遞區號：</td>
					<td><input id="zipCode" name="zipCode" type="text"></td>
				</tr>
				<tr>
					<td>地址一：</td>
					<td><input id="street" name="street" type="text"></td>
				</tr>
				<tr>
					<td>地址二：</td>
					<td><input id="street2" name="street2" type="text"></td>
				</tr>
				<tr>
					<td>*電話：</td>
					<td><input id="tel" name="tel" type="text" class="required digits" ></td>
				</tr>
				<tr>
					<td>傳真：</td>
					<td><input id="fax" name="fax" type="text"></td>
				</tr>
				<tr>
					<td>*電子郵件：</td>
					<td><input id="email" name="email" type="text" class="required email"></td>
				</tr>
				<tr>
					<td>業務窗口姓名：</td>
					<td><input id="bizContact" name="bizContact" type="text"></td>
				</tr>
				<tr>
					<td>業務窗口電話：</td>
					<td><input id="bizTel" name="bizTel" type="text" class="digits"></td>
				</tr>
				<tr>
					<td>業務窗口傳真：</td>
					<td><input id="bizFax" name="bizFax" type="text"></td>
				</tr>
				<tr>
					<td>業務窗口E-Mail：</td>
					<td><input id="bizEmail" name="bizEmail" type="text" class="email"></td>
				</tr>
				<tr>
					<td>技術窗口姓名：</td>
					<td><input id="techContact" name="techContact" type="text"></td>
				</tr>
				<tr>
					<td>技術窗口電話：</td>
					<td><input id="techTel" name="techTel" type="text" class="digits"></td>
				</tr>
				<tr>
					<td>技術窗口傳真：</td>
					<td><input id="techFax" name="techFax" type="text"></td>
				</tr>
				<tr>
					<td>技術窗口E-Mail：</td>
					<td><input id="techEmail" name="techEmail" type="text" class="email"></td>
				</tr>
				<tr>
					<td></td>
					<td><input id="id" name="id" type="hidden"></td>
				</tr>
			</table>
		</fieldset>
	</form>
</div>


