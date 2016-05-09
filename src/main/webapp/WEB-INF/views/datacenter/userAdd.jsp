<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">


$(document).ready(function(){
	//for enter key
	$('#mainForm').keypress(function(e) {
		var key = window.event ? e.keyCode : e.which;
		if (key == 13) $('#applyBtn').click();
	});
	$('#mainForm').validate();
	

	$("#applyBtn").click(function() {
			if ($("#mainForm").valid()) {
 				$.ajax({
					url : "/drcms/userManagement/updateUser",
					type : "POST",
					dataType : "json",
					data : $("#mainForm").serialize(), 
					success : function() {
					},
					error : function() {
						alert("error!!" + "\n" + $("#mainForm").serialize());
					}
				}).done(function() {
					window.location.href = '/drcms/userManagement';
				});
			}
		});

	});

	$(window).load(function() {

	});
</script>



<h1 class="contentTitle">新增使用者</h1>
<div align="center">

	<div class="CSSTableGenerator" style="width: 35%; text-align: left;">
	<form id="mainForm" >
		<table id="mainTable">
            	<TR><TH colspan=2>新增使用者資料</TH></TR>
            	<TR>
	            	<Td>*帳號</Td><td><input type="text" name="account" required maxLength="20"></td>
            	</TR>
            	<TR>
	            	<Td>*密碼</Td><td><input type="text" name="userPassword" required minLength=4 maxLength=12></td>
            	</TR>
            	<TR>
            		<Td>姓</Td><td><input type="text" name="lastName" maxLength="20"></td>
            	</tr>
            	<TR>
            		<Td>名</td><td><input type="text" name="firstName" maxLength="20"></td>
            	</tr>
            	<TR>
            		<Td>*電子郵件</Td><td><input type="email" name="email" required></td>
            	</tr>
            	<TR>
            		<Td>電話(公)</Td><td><input type="text" name="phoneWork" maxLength="20"></td>
            	</tr>
            	<TR>
            		<Td>電話(私)</Td><td><input type="text" name="phoneCell" maxLength="20"></td>
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
            	<tr style="text-align:center"><td colspan=2>
            		<input class="JQbtn" type="button" value="確認" id="applyBtn">
            		<input class="JQbtn" type="button" value="取消" id="cancelBtn" onClick="location.href= ('/drcms/userManagement');">
            	</td></tr>
         </table>
    </form>
	</div>
	 
</div>


<!-- Dialog Content -->




