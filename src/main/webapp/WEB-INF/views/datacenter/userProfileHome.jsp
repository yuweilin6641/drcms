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
					url : "/drcms/userprofile/applyChange",
					type : "POST",
					dataType : "json",
					data : $("#mainForm").serialize(),
					success : function() {
						alert("Apply Changes.");
					},
					error : function() {
						alert("error!");
					}
				});
			}
		});

	});

	$(window).load(function() {
		$.ajax({
			url : "/drcms/userprofile/userInfo",
			type : "GET",
			dataType : "json",
			success : function(res) {
				dwr.util.setValues(objectEval(JSON.stringify(res)));
			},
			error : function() {
				alert("error");
			}
		});
	});
</script>



<h1 class="contentTitle">個人基本資料</h1>
<div align="center">

	<div class="CSSTableGenerator" style="width: 35%; text-align: left;">
	<form id="mainForm" >
		<table id="mainTable">
            	<TR><TH colspan=2>個人基本資料</TH></TR>
            	<TR>
	            	<Td>帳號</Td><Td><label id="account" ></label></Td>
            	</TR>
            	<TR>
            		<Td>姓</Td><td><input type="text" name="lastName" maxLength="20"></td>
            	</tr>
            	<TR>
            		<Td>名</td><td><input type="text" name="firstName" maxLength="20"></td>
            	</tr>
            	<TR>
            		<Td>電子郵件</Td><td><input type="email" name="email"></td>
            	</tr>
            	<TR>
            		<Td>電話(公)</Td><td><input type="text" name="phoneWork" maxLength="20"></td>
            	</tr>
            	<TR>
            		<Td>電話(私)</Td><td><input type="text" name="phoneCell" maxLength="20"></td>
            	</tr>
            	<tr style="text-align:center"><td colspan=2>
            		<input class="JQbtn" type="button" value="確認" id="applyBtn">
            		<input class="JQbtn" type="button" value="取消" id="cancelBtn" onClick="location.href= ('/drcms/dash');">
            	</td></tr>
         </table>
    </form>
	</div>
	 
</div>


<!-- Dialog Content -->




