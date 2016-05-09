<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<h1 class="contentTitle">Dashboard</h1>

<style type='text/css'>
.tableShowStyle {
background-image:url('/drcms/images/TriangleUp.png');
background-repeat: no-repeat;
text-shadow: 0px 1px #3ADA67;
}


.tableHideStyle {
background-image:url('/drcms/images/TriangleDown.png');
background-repeat: no-repeat;
text-shadow: 0px 1px #C5C4C4;
}

legend {
margin:0 0 0px 0;
padding:0 0 20px 23px;
font-size: 14px;
}
</style>
<script>

var priorityArr = ['不重要','普通','重要','極為重要'];
$(document).ready(function(){
	//For legend UI...
	$("legend").toggleClass("tableHideStyle");
	
	//For Hide and Show action...
	$("legend").click(function(){
		var tableObj = $(this).next("table");
		var fff = $(this).parent();
		tableObj.toggle("slow",
			function(){				
				if (tableObj.is(':visible')) {
					fff.css("border-bottom-width","1px");
					fff.css("border-right-width","1px");
					fff.css("border-left-width","1px");
					fff.children('legend').attr("class", "tableShowStyle");
					
				}else{
					fff.children('legend').attr("class", "tableHideStyle");
					fff.css("border-bottom-width","0px");
					fff.css("border-right-width","0px");
					fff.css("border-left-width","0px");
				}
			}
		); 
	});

	
	//show billboard
	$.ajax({
		url: "/drcms/dash/listBillboard/",
		type: "GET", dataType: "json",
		success: function(res) {
			$.each(res, function( index, value ) {
				var tdStr = "<tr><td>"+priorityArr[value.priority]+"</td><td>"
							/* +value.id+"</td><td>" */
							+value.summary+"</td><td>"
							/* +timestampToDateWithoutTime(value.startDate)+"</td><td>"
							+timestampToDateWithoutTime(value.dueDate)+"</td><td>" */
							+"<button onclick=showDetail("+value.id+");>Detail</button>"+"</td></tr>";
				$('#billboardTable > tbody:last').append(tdStr);
			});
			
		},
		error: function() {}
	});
	

	
	
	
});


//show announcement detail...
function showDetail(id){
	$.ajax({
		url: "/drcms/dash/getOneAnnouncement/"+id,
		type: "GET", dataType: "json",
		success: function(res) {
			$('<div></div>')
		    .html(res.description)
		    .dialog({
		    	height:400,
		    	width:400,
		        autoOpen: true,
		        modal: true,
		        title: res.summary,
		        buttons: {
		            "Close": function () {
		                $(this).dialog("close");
		            }
		        }
		    }).dialog("open");
		},
		error: function() {}
	});
}

</script>


<div align="center">
	<div class="CSSTableGenerator" >
		<table id="mainTable" >
            <tr>
                <td>
                <fieldset>
					<legend><span>公告欄</span></legend>
					<table id="billboardTable"  style='width: 100%;'>
						<thead>
						<tr>
							<th>重要程度</th>
							<!-- <th>系統編號</th> -->
				            <th>摘要</th>
							<!-- <th>Start Date</th>
							<th>End Date</th> -->
							<th width='20px'>細節</th>
						</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</fieldset>
				
				</td>				
				
                <td style="vertical-align: top;">
                
                <!-- <fieldset>
					<legend><span>關注列表</span></legend>
					<table id="mainTable">
						<thead>
						<tr>
							<th>ID</th>
							<th>Company Name</th>
				            <th>Summary</th>
							<th>Assignee</th>
				        </tr>
				    	</thead>
				            <tr>
				                <td>001</td>
				                <td>CHT</td>
				                <td>無法開機</td>
								<td>Sam</td>
				            </tr>
					</table>
				</fieldset> -->
                
				</td>
            </tr>
         </table>
         
	</div>
</div>

<!-- Dialog Content -->
<!-- <div id="customerDataModifyDialog" title="公告內容" >
<form method="post" id="modifyForm">
	<fieldset>
	<table >
		
	</table>    
	</fieldset>
</form>
</div> -->