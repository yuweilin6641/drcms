<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script type="text/javascript">
	//page java sciprt
	var dIndex;
	
	$(window).load(function() {
		$("#editForm").validate();
		$("#addForm").validate();
		$("#queryBtn").click();
		
		
		//delete confirm Dialog
		var $confirmDialog = $('<div></div>').html('確認刪除此資料??').dialog({
			autoOpen: false, title: '刪除確認',
			buttons: {
			"OK": function () {
				$.ajax({
					url: "/drcms/warrantyManagement/deleteSubmit/"+dIndex,
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
		});
		
		
		$(function(){
		    $.contextMenu({
		        selector: '.warrantyActionList', trigger: 'left',
		        callback: function(key, options) { 
					if(key=='edit'){
						$.ajax({
							url: "/drcms/warrantyManagement/get/"+$(this).attr("value"),
							type: "GET",
							dataType: "json",
							success: function(res) {
								dwr.util.setValues(objectEval(JSON.stringify(res)));
							},
							error: function() {
								alert('error');
							}
						}).done(function( data ) {
							$("#warrantyEditDialog").dialog("open");
						});
					}else if(key=='delete'){
						dIndex = $(this).attr("value");
						$confirmDialog.dialog('open');
/* 						$.ajax({
							url: "/drcms/warrantyManagement/removePermit/"+$(this).attr("value"),
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
		            "delete": {name: "刪除"}
		        }
		    });
		});		
		
	});
	
	
	$(document).ready(function() {
		
		$("#queryBtn").click(function() {
			$(".CSSTableGenerator").removeClass();
			$("#mainTable").attr("id", "jqGridTable");
			showTable();
		});
		
		$("#addBtn").click(function() {
			$("#warrantyAddDialog").dialog("open");
		});
		
		
		$("#warrantyEditDialog").dialog({
		    autoOpen: false,
		    modal: true,
			width: 400, height: 500,
		    buttons: {
		        "修改": function() {
		        	if($("#editForm").valid()){
			        	$.ajax({
			        		url : "/drcms/warrantyManagement/update",
							type : "POST",
							dataType : "json",
							data : $("#editForm").serialize(),
			        		success: function(JData) {
			        			$('#jqGridTable').trigger( 'reloadGrid' );
			        			$("#queryBtn").click(); //refresh
			        		},
			        		error: function() {
			        			alert("ERROR!!!");
			        		}
			        	}).done(function( data ) {
							$("#warrantyEditDialog").dialog("close");
						});
		        	}
		        },
				"取消": function() {
		            $(this).dialog("close");
		        }
		    }
		});

		
		$("#warrantyAddDialog").dialog({
		    autoOpen: false,
		    modal: true,
			width: 400, height: 500,
		    buttons: {
		        "新增": function() {
		        	if($("#addForm").valid()){
			        	$.ajax({
			        		url : "/drcms/warrantyManagement/update",
							type : "POST",
							dataType : "json",
							data : $("#addForm").serialize(),
			        		success: function(JData) {
			        			$('#jqGridTable').trigger( 'reloadGrid' );
			        			$("#queryBtn").click(); //refresh
			        		},
			        		error: function() {
			        			alert("ERROR!!!");
			        		}
			        	}).done(function( data ) {
							$("#warrantyAddDialog").dialog("close");
						});
		        	}
		        },
				"取消": function() {
		            $(this).dialog("close");
		        }
		    }
		});
	});

	//jqGridTable code...
	function showTable() {

		//processUrl();

		$("#jqGridTable").jqGrid(
				{
					url : 'warrantyManagement/list' + processUrl(),
					datatype : "json",
					width : $(".CSSTableGenerator").width(),
					height : '100%',
					loadonce : false,
					colNames : [ 'Warranty ID', 'Warranty Year',
							'Warranty Month', 'Service Grade',
							'Service Response Time', 'Description', 'Action' ],
					colModel : [ {
						name : 'id',
						index : 'id',
						width : 20,
						align : "center",
						sortable : false
					}, {
						name : 'warrantyPeriodYear',
						width : 30,
						sortable : false
					}, {
						name : 'warrantyPeriodMonth',
						width : 30,
						sortable : false
					}, {
						name : 'serviceGrade',
						width : 30,
						sortable : false
					}, {
						name : 'serviceResponseTime',
						width : 40,
						sortable : false
					}, {
						name : 'description',
						width : 50,
						sortable : false
					}, {
						name : 'action',
						index : 'action',
						width : 10,
						align : "center",
						formatter : actionItem
					} ],
					rowNum : 15,
					pager : '#jqGridPager',
					sortname : 'id',
					viewrecords : true,
					sortorder : "desc",
					onPaging : function(pgButton) {
						$("#jqGridTable").setGridParam({
							url : 'warrantyManagement/list' + processUrl()
						});
					},
				});
		$("#jqGridTable").jqGrid('navGrid', '#jqGridPager', {
			edit : false,
			add : false,
			del : false,
			search : false
		});

		$("#jqGridTable").setGridParam({
			url : 'warrantyManagement/list' + url
		}).trigger("reloadGrid");
	}

	//process url value...
	function processUrl() {
		var tempUrl = $("#tempUrl").val();

		url = "";

		$("#tempUrl").val(url);

		if (tempUrl != url) {
			url += "?queryChange=true";
		} else {
			url += "?queryChange=false";
		}

		return url;
	}
	
	function actionItem (cellvalue, options, rowObject){
		return "<img src='/drcms/images/action.png' class='actionImg warrantyActionList' value="+rowObject.id+" ></img>";
	}
	
</script>

<h1 class="contentTitle">保固資料維護</h1>
<div align="center">
	<div class="pageFirstDiv" style="width: 20%">
		<table>
			<tr>
				<td class="lastTD">
				<input class="JQbtn" type="button" value="查詢" id="queryBtn">
				<input class="JQbtn" type="button" value="新增" id="addBtn">
				<input type="hidden" id="tempUrl">
				</td>
			</tr>
		</table>
	</div>

	<div class="CSSTableGenerator" style="width: 90%">
		<table id="mainTable">
			<thead id="mainTableHead">
			</thead>
			<tbody id="mainTableBody">
			</tbody>
		</table>
	</div>
	<div id="jqGridPager"></div>


</div>

<!-- Dialog Content -->



<div id="warrantyEditDialog" style="width: 35%" title="修改保固資料">
	<form id="editForm">
		<table id="editTable">
			<TR>
				<TH colspan=2>保固資料</TH>
			</TR>
			<TR>
				<Td>保固名稱</Td>
				<Td><label id="id"></label></Td>
			</TR>
			<TR>
				<Td>Warranty Year</Td>
				<Td><input type="text" name="warrantyPeriodYear"></Td>
			</TR>
			<TR>
				<Td>Warranty Month</Td>
				<td><input type="text" name="warrantyPeriodMonth" ></td>
			</tr>
			<TR>
				<Td>Service Grade</td>
				<td><input type="text" name="serviceGrade" ></td>
			</tr>
			<TR>
				<Td>Service Response Time</Td>
				<td><input type="text" name="serviceResponseTime" ></td>
			</tr>
			<TR>
				<Td>Description</Td>
				<td><input type="text" name="description" ></td>
			</tr>
		</table>
	</form>
</div>


<div id="warrantyAddDialog" style="width: 35%" title="新增保固資料">
	<form id="addForm">
		<table id="addTable">
			<TR>
				<TH colspan=2>保固資料</TH>
			</TR>
			<TR>
				<Td>*保固名稱</Td>
				<Td><input type="text" name="id" required maxLength="30"></Td>
			</TR>
			<TR>
				<Td>Warranty Year</Td>
				<Td><input type="text" name="warrantyPeriodYear"></Td>
			</TR>
			<TR>
				<Td>Warranty Month</Td>
				<td><input type="text" name="warrantyPeriodMonth" ></td>
			</tr>
			<TR>
				<Td>Service Grade</td>
				<td><input type="text" name="serviceGrade" ></td>
			</tr>
			<TR>
				<Td>Service Response Time</Td>
				<td><input type="text" name="serviceResponseTime" ></td>
			</tr>
			<TR>
				<Td>Description</Td>
				<td><input type="text" name="description" ></td>
			</tr>
		</table>
	</form>
</div>


