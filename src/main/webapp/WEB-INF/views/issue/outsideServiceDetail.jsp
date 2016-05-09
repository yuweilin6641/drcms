<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
//page java sciprt


$(document).ready(function(){




	//for Work Log add in CustomerService
	$("#workLogAddDialog").dialog({
	    autoOpen: false,
	    modal: true,
		width: '520', height: '450',
	    buttons: {
	        "Log": function() {
	            $.ajax({
	                "url": "/echo/json/",
	                "success": function(json) {
	                    $("#workLogAddDialog").dialog("close");
	                }
	            });
	        },
			"Cancel": function() {
	            $(this).dialog("close");
	        }
	    }
	});
	
	$("#workLogAddAjaxBtn").click(function(event) {
	    event.preventDefault();
	    $("#workLogAddDialog").dialog("open");
	});

});


</script>

<style type='text/css'>
.tableShowStyle {
background-image:url('/drcms/images/arrow-up.png');
background-repeat: no-repeat;
text-shadow: 1px 1px #3ADA67;
}
.tableHideStyle {
background-image:url('/drcms/images/arrow-down.png');
background-repeat: no-repeat;
text-shadow: 1px 1px #C5C4C4;
}
legend {
margin:0 0 0px 0;
padding:0 0 15px 15px;
}
</style>
<script>
$(document).ready(function(){
	//For legend UI...
	$("legend").toggleClass("tableShowStyle");
	
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
});
</script>

<h1 class="contentTitle" style="margin-bottom: 5px;">客服單 Detail</h1>
<div align="center">
	
	<div class="CSSTableGenerator" >
		<table id="mainTable">
            <thead id="mainTableHead" >
            <tr>
                <th colspan="2" style="text-align:left;padding: 0px 0px 0px 0px;">
					<input name="" type="button" class="JQbtn" value="WorkLog" id="workLogAddAjaxBtn">
				</th>
			</tr>
            </thead>
            <tr>
                <td width="50%">
					<fieldset>
						<legend><span>Detail</span></legend>
						<table id="mainTable">
							<tr><td align="left">客戶名稱：</td><td><input name="" type="text" value="CHT" ></td></tr>
							<tr><td align="left">Status：</td><td><input name="" type="text" value="0937" ></td></tr>
							<tr><td align="left">Summary：</td><td><input name="" type="text" ></td></tr>
							<tr><td align="left">Component Type：</td><td><input name="" type="text" ></td></tr>
						</table>
					</fieldset>
					
					<fieldset>
						<legend><span>Description</span></legend>
						<table id="mainTable">
							<tr><td align="left">aaaaaa</td></tr>
						</table>
					</fieldset>
					
					<fieldset>
						<legend><span>Attachments</span></legend>
						<table id="mainTable">
							<!--<tr><td align="left">aaaaaa</td></tr>-->
						</table>
					</fieldset>
					
					<fieldset>
						<legend><span>Sub-Tasks</span></legend>
						<table id="mainTable">
							<tr><td align="left">1. Create OnSiteOrder at 10/5</td></tr>
						</table>
					</fieldset>
					
					<fieldset>
						<legend><span>WorkLog</span></legend>
						<table id="mainTable">
							<tr><td align="left">Yannel：</td><td>Comment1</td></tr>
							<tr><td align="left">Sam：</td><td>Comment2</td></tr>
						</table>
					</fieldset>
				</td>
                <td  style="vertical-align:text-top;" >
					<fieldset>
						<legend><span>People</span></legend>
						<table id="mainTable">
							<tr><td align="left">Assignee：</td><td><input name="" type="text" value="Yannel" ></td></tr>
							<tr><td align="left">Reporter：</td><td><input name="" type="text" value="Sam" ></td></tr>
						</table>
					</fieldset>
					
					<fieldset>
						<legend><span>Date</span></legend>
						<table id="mainTable">
							<tr><td align="left">Create：</td><td><input name="" type="text" value="10/01 2013" ></td></tr>
							<tr><td align="left">Due：</td><td><input name="" type="text" value="10/01 2013" ></td></tr>
							<tr><td align="left">Update：</td><td><input name="" type="text" value="10/01 2013" ></td></tr>
						</table>
					</fieldset>
					
				</td>
            </tr>
            <tfoot>
            <tr>
                <td colspan="2"  style="text-align:center;">
					<input name="" type="button" class="JQbtn" value="Save">
					<input name="" type="button" class="JQbtn" value="Cancel">
				</td>
			</tr>
            </tfoot>
         </table>
	</div>
</div>


<!-- Dialog Content -->
<div id="workLogAddDialog" title="Work Log" >
<form>
	<fieldset>
		<table align="center" >
			<tr><td align="left">Time Spent：</td><td><input name="" type="text" ></td></tr>
			<tr><td align="left">Work Desc.：</td><td><textarea rows="10" cols="30"></textarea></td></tr>
		</table>    
	</fieldset>
</form>
</div>

