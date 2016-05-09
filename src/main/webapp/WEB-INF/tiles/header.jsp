<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<head>
<title>Issue System</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="shortcut icon" href="/drcms/images/favicon.ico" type="image/x-icon" /> 




<!-- Css script -->
<link rel="stylesheet" href="/drcms/styles/menu.css" type="text/css" media="screen" />
<link rel="stylesheet" href="/drcms/styles/TableCSSCode.css" type="text/css" media="screen" />
<link rel="stylesheet" href="/drcms/styles/jquery-ui-theme/flick/jquery-ui-1.9.2.custom.min.css" type="text/css" media="screen" />
<link rel="stylesheet" href="/drcms/styles/jquery.contextMenu.css" type="text/css" media="screen" />
<link rel="stylesheet" href="/drcms/styles/zTreeStyle/zTreeStyle.css" type="text/css" media="screen" />
<link rel="stylesheet" type="text/css" media="screen" href="/drcms/styles/ui.jqgrid.css" />
<link rel="stylesheet" type="text/css" media="screen" href="/drcms/styles/jquery-ui-timepicker-addon.css" />

<!-- Js script -->
<script type='text/javascript' src='/drcms/js/jquery/jquery-1.9.1.js'></script>
<script type='text/javascript' src='/drcms/js/jquery/jquery-ui-1.9.2.custom.min.js'></script>
<script type='text/javascript' src="/drcms/js/jquery/jquery.contextMenu.js"></script>
<script type='text/javascript' src="/drcms/js/jquery/jquery.blockUI.js"></script>
<script type='text/javascript' src="/drcms/js/jquery/jquery.ztree.all-3.5.js"></script>
<script type='text/javascript' src='/drcms/js/dwr/eval.js'></script>
<script type='text/javascript' src='/drcms/js/dwr/util.js'></script>
<script type='text/javascript' src='/drcms/js/jquery/json2.js'></script>
<script type="text/javascript" src="/drcms/js/jqgrid/grid.locale-tw.js"></script>
<script type="text/javascript" src="/drcms/js/jqgrid/jquery.jqGrid.min.js"></script>

<!-- <script type="text/javascript" src="http://jquery.bassistance.de/validate/lib/jquery.js"></script> -->
<script type="text/javascript" src="/drcms/js/jquery/validation/jquery.mockjax.js"></script>
<script type="text/javascript" src="/drcms/js/jquery/validation/jquery.validate.js"></script>
<script type="text/javascript" src="/drcms/js/jquery/jquery-ui-timepicker-addon.js"></script>




<!-- JQUERY script for test... -->
<script type="text/javascript">
$(function() {
	//for button UI
	$(".JQbtn").button().click(function( event ) {event.preventDefault();});
	
	$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
	
		
	//JS datePicker
	$(function() {
		$( ".pickDate" ).datepicker({
			changeYear: true,
			changeMonth: true,
			dateFormat:"yy-mm-dd",
			showAnim:"blind",
			showButtonPanel: true,       
			onClose: function( selectedDate ) {
				$( "#toDate" ).datepicker("option", "minDate", new Date(selectedDate));          
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

//timestamp to date...
function timestampToDate(timestamp){
	var date = new Date(timestamp);
	var yyyy = date.getFullYear().toString();
	var mm = (date.getMonth()+1).toString();
	var dd  = date.getDate().toString();
	var mmChars = mm.split('');
	var ddChars = dd.split('');
	var hour = date.getHours();
	var min = date.getMinutes();
	var sec = date.getSeconds();
	var datestring = yyyy + '-' + (mmChars[1]?mm:"0"+mmChars[0]) + '-' + (ddChars[1]?dd:"0"+ddChars[0])
	 +' '+hour+':'+min+':'+sec;
	return datestring;
}

//timestamp to date without time...
function timestampToDateWithoutTime(timestamp){
	var date = new Date(timestamp);
	var yyyy = date.getFullYear().toString();
	var mm = (date.getMonth()+1).toString();
	var dd  = date.getDate().toString();
	var mmChars = mm.split('');
	var ddChars = dd.split('');
	// CONCAT THE STRINGS IN YYYY-MM-DD FORMAT
	var datestring = yyyy + '-' + (mmChars[1]?mm:"0"+mmChars[0]) + '-' + (ddChars[1]?dd:"0"+ddChars[0]);
	return datestring;
}

//serializeObject
$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};
</script>

<!-- CSS script for test... -->
<style type='text/css'>
/* menu header */
.css-title:before {
    content: "some title";
    display: block;
    position: absolute;
    top: 0;
    right: 0;
    left: 0;
    background: #DDD;
    padding: 2px;
    
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    font-weight: bold;
}
.css-title :first-child {
    margin-top: 20px;
}


/* menu header via data attribute */
.data-title:before {
    content: attr(data-menutitle);
    display: block;
    position: absolute;
    top: 0;
    right: 0;
    left: 0;
    background: #DDD;
    padding: 2px;
    
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    font-weight: bold;
}
.data-title :first-child {
    margin-top: 20px;
}


/* demo trigger boxes */
.box {
    color: #EEE;
    background: #666;
    font-weight: bold;
    padding: 20px;
    text-align: center;
    font-size: 20px;
    margin: 5px 0;
}
.box:hover {
    background: #777;
}
.box > * {
    display:block;
}
.menu-injected { background-color: #C87958; }
.box.context-menu-disabled { background-color: red; }


.contentTitle{
	font: normal 20px/22px Lucida Sans Unicode, Lucida Grande, Arial, sans-serif;
	color: #888889;
	font-weight: bold;
	margin-left: 2.5%;
	margin-right: 2.5%;
	margin-bottom: 20px;
	padding-bottom: 5px;
	padding-left: 5px;
	border-bottom: 1px solid #e0e0e0;
	letter-spacing: -0.05em;
}

.pageFirstDiv{
text-align: left;
padding: 8px;
color: #888888;
font-size: 11px;
margin-bottom:25px;
border-style:solid;
border-width:1px;
width:95%;
padding:10px 0px;
border-color: #A3A3A3;
border-radius: 5px 5px 5px 5px;
}

.pageFirstDiv table{
	width: 100%;
}

.pageFirstDiv table, tr, td{
	border-collapse: collapse;
	padding: 0px;
}

.pageFirstDiv p{
	margin-left: 2px;
	margin-top: 0px;
	margin-bottom: 4px;
	line-height: 100%;
}

.pageFirstDiv .contentTD{
	padding: 2px 8px;
	border-right: 1px dotted #bbbbbb;
}

.pageFirstDiv .lastTD{
	text-align:center;
	padding: 2px 8px;
}

.pageFirstDiv input[type="text"], select , input[type="button"]:not(.JQbtn){
	width:100%;
}

.actionImg{
	content:url("/drcms/images/new-action.png");
}

input.JQbtn {
	border-radius: 5px;
	font-size: small;
}

label.error{
	border:1px solid #99182c;
	margin-left:-1px;
	color:black;
	padding:1px 5px 1px 5px;
	font-size:small;
	color: crimson;
}

.textbox{ 
border: 1px solid #B9BDC1; 
color: #898989; 
-moz-box-shadow: 0 1px 1px #bbb inset; 
-webkit-box-shadow: 0 1px 1px #BBB inset; 
box-shadow: 0 1px 1px #BBB inset; 
-moz-border-radius: 2px; 
-webkit-border-radius: 2px; 
border-radius: 2px; 
} 
.textbox:focus { 
background-color: #E7E8E7; 
outline: 0; 
}   
</style>


  
</head>

<body>

<div id="header">
<ul id="menu">
    <li ><a href="/drcms/dash"><label>Home</label> </li> <!-- "LOGO" Item -->

	<li><label class="drop">系統管理</label> 
		<div class="dropdown_1column">
                <div class="col_1">                
                    <ul class="simple">
                    <li><a href="/drcms/userManagement">使用者管理</a></li>
                    <li><a href="/drcms/configurationMaintain">SMTP設定</a></li>
                    <li><a href="/drcms/configurationMaintain">登入紀錄查詢</a></li>
                    </ul>
                </div>
		</div>
	</li>
	<li><label class="drop">網站結構維護</label>     
		<div class="dropdown_1column">
                <div class="col_1">                
                    <ul class="simple">
                    <li><a href="/drcms/warranty">Menu管理</a></li>
                    <li><a href="/drcms/warrantyModify/bySales">Page Element</a></li>
                    <li><a href="/drcms/warrantyModify/byMachine">Page Structure</a></li>
                    </ul>
                </div>
		</div>
	</li>
	<li><label class="drop">網站內容維護</label>     
		<div class="dropdown_1column">
                <div class="col_1">                
                    <ul class="simple">
                    <li><a href="/drcms/report/failParts">首頁維護</a></li>
                    <li><a href="/drcms/report/machine">醫療團隊維護</a></li>
                    <li><a href="/drcms/report/parts">最新消息維護</a></li>
                    <li><a href="/drcms/report/parts">治療項目維護</a></li>
                    <li><a href="/drcms/report/parts">治療案例維護</a></li>
                    <li><a href="/drcms/report/parts">衛教文章維護</a></li>
                    <li><a href="/drcms/report/parts">問與答維護</a></li>
                    <li><a href="/drcms/report/parts">搜尋維護</a></li>
                    <li><a href="/drcms/report/parts">使用者留言查詢</a></li>
                    <li><a href="/drcms/report/parts">線上預約查詢</a></li>
                    </ul>
                </div>
		</div>
	</li>
	
	<li class="menu_right"><label class="drop"><%= session.getAttribute("LOGIN_ACCOUNT") %></label>
		<div class="dropdown_1column align_right">        
            <div class="col_1">                
                    <ul class="simple">
                    <c:if test="${fn:contains(sessionScope.FUNCTIONS, 'userprofile')}">
                        <li><a href="/drcms/userprofile">個人基本資料</a></li>
                    </c:if>
                    <li><a href="/drcms/logout">登出</a></li>
                    </ul>                        
                </div>                
		</div>
	</li>
	
	
<!--     <li class="menu_right"><label class="drop">我的報表</label>Begin "我的報表" Item    
		<div class="dropdown_1column align_right">        
            <div class="col_1">                
                    <ul class="simple">
                        <li><a href="#">修改密碼</a></li>
                        <li><a href="#">通知設定</a></li>
                    </ul>                        
            </div>                
		</div>        
	</li> End "我的報表" Item


	<li class="menu_right"><label class="drop">平台設定</label>Begin "平台設定" Item    
		<div class="dropdown_1column align_right">        
            <div class="col_1">                
                    <ul class="simple">
                        <li><a href="#">權限設定</a></li>
                    </ul>                        
                </div>                
		</div>        
	</li> End "平台設定" Item -->
</ul> <!-- Header Menu End!! -->
</div>


