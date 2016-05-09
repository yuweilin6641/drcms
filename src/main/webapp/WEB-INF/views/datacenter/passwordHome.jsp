<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">


$(document).ready(function(){
	//for enter key
	$('#mainTableBody').keypress(function(e) {
		var key = window.event ? e.keyCode : e.which;
		if (key == 13) $('#change').click();
	});
	$('#currentPasswd').focus();
	$('#passwdForm').validate();
	
	
	$("#change").click(function() {
			if ($("#passwdForm").valid()) {
				$.ajax({
					url : "/drcms/password/changePasswd",
					type : "POST",
					dataType : "json",
					data : {
						"currentPasswd" : $('#currentPasswd').val(),
						"newPasswd" : $('#newPasswd').val()
					},
					success : function(res) {
						if (res) {
							alert("Password Reset");
							$('#reset').click();
						} else {
							alert("wrong Password");
							$('#currentPasswd').val("");
							$('#currentPasswd').focus();
						}
					},
					error : function() {
						alert("error");
					}
				});
			}
			;
		});

		$("#reset").click(function() {
			$('#currentPasswd').focus();
			$('#currentPasswd').val("");
			$('#newPasswd').val("");
			$('#confirmNewPasswd').val("");
		});

	});
</script>

<h1 class="contentTitle">修改密碼</h1>
<div align="center">
		
	<div class="CSSTableGenerator" style="width:35%;">
	<form id="passwdForm">
		<table id="mainTable">
            <thead id="mainTableHead">
                <tr><th colspan=2>修改密碼</th></tr>
            </thead>
            <tbody id="mainTableBody">
            <tr >
            	<td>目前密碼</td>
            	<td><input type="password" id="currentPasswd" name=currentPasswd required></td>
            </tr>
            <tr >
            	<td>新密碼</td>
            	<td><input type="password" id="newPasswd" name=newPasswd required minLength=4 maxLength=12></td>
            </tr>
            <tr >
            	<td>確認新密碼</td>
            	<td><input type="password" id="confirmNewPasswd" name=confirmNewPasswd required equalTo="#newPasswd"></td>
            </tr>
            <tr style="text-align:center"><td colspan=2>
            	<input class="JQbtn" type="button" value="確認" id="change">
            	<input class="JQbtn" type="button" value="重置" id="reset">
            </td></tr>
            </tbody>
		</table>
	</form>
	</div>
	
	
</div>


<!-- Dialog Content -->




