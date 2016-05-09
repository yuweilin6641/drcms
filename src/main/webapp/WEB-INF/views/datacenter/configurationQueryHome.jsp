<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<script type="text/javascript">
//page java sciprt

$(document).ready(function(){

	//for enter key
	$('#queryTable').keypress(function(e) {
		var key = window.event ? e.keyCode : e.which;
		if (key == 13) $('#queryDataAjaxBtn').click();
	});
	
	//show query data...
	$("#queryDataAjaxBtn").click(function(event) {
		event.preventDefault();
		
		$.ajax({
    		url: "/drcms/configurationQuery/listConfig/" + $("#queryText").val(),
    		type: "GET",
    		
    		success: function(res) {
    			var hightLightIndex = -1;
    			$.each(res, function( index, value ) {
    				if(value.id==$("#queryText").val())hightLightIndex = index + 1;
				});
    			$.fn.zTree.init($("#ztreeFrame"), setting, res);
    			$("#ztreeFrame_"+hightLightIndex+"_span").addClass("workLogHighLight");
    		},
    		error: function() {
    			alert("找不到"+$("#queryText").val()+"相關資訊。請重新查詢！！");
    			location.reload();
    		}
    	}).done(function(res) {
    		//show root work log
    		//$("#workLogDiv").attr('style','visibility:visible;width:auto;height:180px;overflow:auto;');
    		$("#tableTitle").text($("#queryText").val()+"查詢結果");
    		
    		//TODO :SHOW WORK LOG
    		/* $.ajax({
				url: "/drcms/good/getConfigWorkLogs/"+res[0].id,
				type: "GET",
				dataType: "json",
				success: function(res) {
					$("#workLogDiv").html('');
					$.each(res, function( index, value ) {
						$("#workLogDiv").append(
								value.id + ": " + value.reason + ": " + timestampToDate(value.createDate)+"<BR>");
					});
					
				}
			}); */
		});
		
	});
	
	
	//show demo data...
	$("#showData").click(function() {
		
		$("#mainTableHead  tr").remove();
		//$("#mainTableBody  tr").remove();
		$( "#ztreeFrame" ).attr("style", "visibility:visiable;" );
		$("#mainTableHead").append('<TR><TH>Configuration Maintain...</TH></TR>');
	});
	
	
});


</script>


<!-- ztree js code  -->
<SCRIPT type="text/javascript">
		
		var setting = {
			view: {
				showIcon: false,
				//addHoverDom: addHoverDom,
				//removeHoverDom: removeHoverDom,
				selectedMulti: false
			},
			edit: {
				enable: false,
			},
			data: {
				simpleData: {
					enable: true
				}
			}/* ,
			callback: {
				beforeDrag: beforeDrag,
				beforeEditName: beforeEditName,
				beforeRemove: beforeRemove,
				beforeRename: beforeRename,
				onRemove: onRemove,
				onRename: onRename
			} */
		};

		var zNodes =[
			/* { id:1, pId:0, name:"root", open:true},
			{ id:11, pId:1, name:"S/N:XXXXXXXXXXXOOOOOOOOOOOOO"},
			{ id:12, pId:1, name:"Structer:AAA"},
			{ id:14, pId:1, name:"NIVIDA VGA Card"},
			{ id:2, pId:1, name:"HD", open:true},
			{ id:21, pId:2, name:"HD_A"},
			{ id:22, pId:2, name:"HD_B"},
			{ id:23, pId:2, name:"HD_C"},
			{ id:3, pId:1, name:"Other", open:true },
			{ id:31, pId:3, name:"Other_1"},
			{ id:32, pId:3, name:"Other_2"},
			{ id:33, pId:3, name:"Other_3"} */
		];
		/* 
		function beforeEditName(treeId, treeNode) {
			className = (className === "dark" ? "":"dark");
			showLog("[ "+getTime()+" beforeEditName ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
			var zTree = $.fn.zTree.getZTreeObj("ztreeFrame");
			zTree.selectNode(treeNode);
			return confirm("Start node '" + treeNode.name + "' editorial status?");
		}
		function beforeRemove(treeId, treeNode) {
			className = (className === "dark" ? "":"dark");
			showLog("[ "+getTime()+" beforeRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
			var zTree = $.fn.zTree.getZTreeObj("ztreeFrame");
			zTree.selectNode(treeNode);
			return confirm("Confirm delete node '" + treeNode.name + "' it?");
		}
		function onRemove(e, treeId, treeNode) {
			showLog("[ "+getTime()+" onRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
		}
		function beforeRename(treeId, treeNode, newName, isCancel) {
			className = (className === "dark" ? "":"dark");
			showLog((isCancel ? "<span style='color:red'>":"") + "[ "+getTime()+" beforeRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name + (isCancel ? "</span>":""));
			if (newName.length == 0) {
				alert("Node name can not be empty.");
				var zTree = $.fn.zTree.getZTreeObj("ztreeFrame");
				setTimeout(function(){zTree.editName(treeNode)}, 10);
				return false;
			}
			return true;
		}
		function onRename(e, treeId, treeNode, isCancel) {
			showLog((isCancel ? "<span style='color:red'>":"") + "[ "+getTime()+" onRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name + (isCancel ? "</span>":""));
		}
		function showRemoveBtn(treeId, treeNode) {
			return true;
		}
		function showRenameBtn(treeId, treeNode) {
			return true;
		}
		function showLog(str) {
			if (!log) log = $("#log");
			log.append("<li class='"+className+"'>"+str+"</li>");
			if(log.children("li").length > 8) {
				log.get(0).removeChild(log.children("li")[0]);
			}
		}
		function getTime() {
			var now= new Date(),
			h=now.getHours(),
			m=now.getMinutes(),
			s=now.getSeconds(),
			ms=now.getMilliseconds();
			return (h+":"+m+":"+s+ " " +ms);
		}
 */
		var newCount = 1;
		function addHoverDom(treeId, treeNode) {
		};
		function removeHoverDom(treeId, treeNode) {
			//$("#addBtn_"+treeNode.tId).unbind().remove();
		};
		function selectAll() {
			var zTree = $.fn.zTree.getZTreeObj("ztreeFrame");
			zTree.setting.edit.editNameSelectAll =  $("#selectAll").attr("checked");
		}
		
		$(document).ready(function(){
			$.fn.zTree.init($("#ztreeFrame"), setting, zNodes);
			//$("#selectAll").bind("click", selectAll);
		});
		
	</SCRIPT>

<!-- ztree plus css  -->
<style type="text/css">
.ztree li span.button.add {
	margin-left: 2px;
	margin-right: -1px;
	background-position: -144px 0;
	vertical-align: top;
	*vertical-align: middle
}

.workLogHighLight {
	font-size: 15px;
	font-weight: bold;
	background-color: red;
	color: white;
}
</style>



<h1 class="contentTitle">Configuration 查詢</h1>
<div align="center">
	<div class="pageFirstDiv" >
		<table id="queryTable">
			<tr>
                <td class="contentTD">
				<p>請輸入完整序號：</p>
				<input type="text" id="queryText">
				</td>
                <td class="lastTD">
					<input class="JQbtn" type="button" value="查詢" id="queryDataAjaxBtn">
				</td>
            </tr>
         </table>
	</div>
	<div class="CSSTableGenerator" >
		<table  id="mainTable">
            <thead id="mainTableHead">
            <TR>
                <th><label id="tableTitle">Configuration Query...</label></th>
			</TR>
            </thead>
            <tbody  id="mainTableBody">
            <tr >
                <td>
				<div id="ztreeFrame" class="ztree"></div>
				</td>
            </tr>
            <tr><td><div id="workLogDiv" style="display:none;"></div></td></tr>
            </tbody>
         </table>
	</div>
</div>