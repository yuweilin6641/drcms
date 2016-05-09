<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
	$(document).ready(function() {
		//for enter key
		$('#queryTable').keypress(function(e) {
			var key = window.event ? e.keyCode : e.which;
			if (key == 13)
				$('#queryBtn').click();
		});

		//list user data
		$("#queryBtn").click(function() {
			$(".CSSTableGenerator").removeClass();
			$("#mainTable").attr("id", "jqGridTable");
			showTable();
		});
		
		
		//for User Data modify dialog
		$("#userEditDialog").dialog({
		    autoOpen: false,
		    modal: true,
			width: 330, height: 580,
		    buttons: {
		        "修改": function() {
		        	if($("#editForm").valid()){
			        	$.ajax({
			        		url : "/drcms/userManagement/updateUser",
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
							$("#userEditDialog").dialog("close");
						});
		        	}
		        },
				"取消": function() {
		            $(this).dialog("close");
		        }
		    }
		});

	});

	
	
	$(window).load(function() {
		$("#editForm").validate();
		$("#queryBtn").click();
		
		
		//delete confirm Dialog
		var $confirmDialog = $('<div></div>').html('確認刪除此資料??').dialog({
			autoOpen: false, title: '刪除確認',
			buttons: {
			"OK": function () {
				$.ajax({
					url: "/drcms/userManagement/deleteSubmit/"+dIndex,
					type: "GET",
					dataType: "json",
					success: function() {
						$("#queryAjaxBtn").click(); //refresh
						$("#jqGridTable").trigger("reloadGrid");
					},
					error: function(res) {
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
		        selector: '.userActionList', trigger: 'left',
		        callback: function(key, options) { 
					if(key=='edit'){
						$.ajax({
							url: "/drcms/userManagement/get/"+$(this).attr("value"),
							type: "GET",
							dataType: "json",
							success: function(res) {
								dwr.util.setValues(objectEval(JSON.stringify(res)));
								dwr.util.setValue('rolesId', [res.roleIdList]);
							},
							error: function() {
								alert('error');
							}
						}).done(function( data ) {
							$("#userEditDialog").dialog("open");
						});
					}else if(key=='delete'){
						dIndex = $(this).attr("value");
						$confirmDialog.dialog('open');
					}
		        },
		        items: {
					"edit": {name: "編輯"},
		            "delete": {name: "刪除"}
		        }
		    });
		});
	});

	
	
	//jqGridTable code...
	function showTable() {

		//processUrl();

		$("#jqGridTable").jqGrid(
				{
					url : 'userManagement/list' + processUrl(),
					datatype : "json",
					width : $(".pageFirstDiv").width(),
					height : '100%',
					loadonce : false,
					colNames : [ '帳號', '使用者名稱', 'E-mail', '角色', '動作' ],
					colModel : [ {
						name : 'account',
						index : 'account',
						width : 15,
						align:"center",
						sortable : false
					}, {
						name : 'fullName',
						index : 'fullName',
						width : 20,
						sortable : false
					}, {
						name : 'email',
						index : 'email',
						width : 40,
						sortable : false
					}, {
						name : 'roleNameList',
						index : 'roles',
						width : 50,
						sortable : false
					}, {
						name : 'action',
						index : 'action',
						width : 10,
						align:"center",
						formatter:actionItem
					} ],
					rowNum : 15,
					pager : '#jqGridPager',
					sortname : 'id',
					viewrecords : true,
					sortorder : "desc",
					onPaging : function(pgButton) {
						$("#jqGridTable").setGridParam({
							url : 'userManagement/list' + processUrl()
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
			url : 'userManagement/list' + url
		}).trigger("reloadGrid");
	}

	//process url value...
	function processUrl() {
		var tempUrl = $("#tempUrl").val();

		url = '?account=' + $("#queryAccount").val() + 
				'&role=' + $("#queryRole").val();

		$("#tempUrl").val(url);

		if (tempUrl != url) {
			url += "&queryChange=true";
		} else {
			url += "&queryChange=false";
		}

		return url;
	}
	
	function actionItem (cellvalue, options, rowObject){
		return "<img src='/drcms/images/action.png' class='actionImg userActionList' value="+rowObject.id+" ></img>";
	}
	
</script>



<h1 class="contentTitle">使用者管理</h1>
<div align="center">
	<div class="pageFirstDiv">
		<table id="queryTable">
			<tr>
				<td class="contentTD">
					<p>帳號：</p>
					<input type="text" id="queryAccount">
				</td>
				<td class="contentTD">
				<p>角色：</P>
				<select id="queryRole" >
					<option value=""></option>
					<option value="Administrator">Administrator</option>
					<option value="CSR">CSR</option>
					<option value="Engineer">Engineer</option>
					<option value="Sales">Sales</option>
					<option value="Sales_Manager">Sales_Manager</option>
					<option value="Finance">Finance</option>
					<option value="Partner">Partner</option>
				</select>
				</td>
				<td class="lastTD">
					<input class="JQbtn" type="button" value="查詢" id="queryBtn">
					<input class="JQbtn" type="button" value="新增" id="useraddBtn" onClick="location.href= ('/drcms/userManagement/add')">
					<input type="hidden" id="tempUrl">
				</td>
			</tr>
		</table>
	</div>

	<div class="CSSTableGenerator">
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


<div id="userEditDialog" style="width: 40%" title="修改基本資料">
	<form id="editForm">
		<table id="editTable">
			<TR>
				<TH colspan=2>個人基本資料</TH>
			</TR>
			<TR>
				<Td>*帳號</Td>
				<Td><input type="text" name="account" required maxLength="20"></Td>
			</TR>
			<TR>
				<Td>*密碼</Td>
				<Td><input type="password" name="userPassword" required minLength=4 maxLength=12></Td>
			</TR>
			<TR>
				<Td>姓</Td>
				<td><input type="text" name="lastName" maxLength="20"></td>
			</tr>
			<TR>
				<Td>名</td>
				<td><input type="text" name="firstName" maxLength="20"></td>
			</tr>
			<TR>
				<Td>*電子郵件</Td>
				<td><input type="email" name="email" required></td>
			</tr>
			<TR>
				<Td>電話(公)</Td>
				<td><input type="text" name="phoneWork" maxLength="20"></td>
			</tr>
			<TR>
				<Td>電話(私)</Td>
				<td><input type="text" name="phoneCell" maxLength="20"></td>
			</tr>
			<tr>
					<td></td>
					<td><input id="id" name="id" type="hidden"></td>
				</tr>
			<TR>
            	<Td>角色</Td>
            		<td>
            		<input type="checkbox" name="rolesId" value="1" checked hidden>
            		<input type="checkbox" name="rolesId" value="6">Administrator<br>
            		<input type="checkbox" name="rolesId" value="7">CSR<br>
            		<input type="checkbox" name="rolesId" value="2">Engineer<br>
            		<input type="checkbox" name="rolesId" value="4">Sales<br>
            		<input type="checkbox" name="rolesId" value="5">Sales Manager<br>
            		<input type="checkbox" name="rolesId" value="8">Finance<br>
            		<input type="checkbox" name="rolesId" value="3">Partner<br>
            		</td>
            </TR>
		</table>
	</form>
</div>

