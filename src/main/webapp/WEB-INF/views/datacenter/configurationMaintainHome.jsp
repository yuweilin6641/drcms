<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="/drcms/js/upload/jquery.ui.widget.js"></script>
<script src="/drcms/js/upload/jquery.iframe-transport.js"></script>
<script src="/drcms/js/upload/jquery.fileupload.js"></script>

<script type="text/javascript">
//page java sciprt


function confirmation(question, title) {
    var defer = $.Deferred();
    $('<div></div>').html(question).dialog({
            autoOpen: true,width: 450, height: 200,
            modal: true,
            title: title,
            buttons: {
                "僅移除料件": function () {
                    defer.resolve("OnlyRemove");
                    $(this).dialog("close");
                },
                "列為損壞料件": function () {
                    defer.resolve("AsFaliurePart");
                    $(this).dialog("close");
                },
                "取消": function () {
                    defer.resolve("Cancel");
                    $(this).dialog("close");
                }
            }
        });
    return defer.promise();
};


$(document).ready(function(){
	//for enter key
	$('#queryTable').keypress(function(e) {
		var key = window.event ? e.keyCode : e.which;
		if (key == 13) $('#queryDataAjaxBtn').click();
	});

	//initial page
	$.ajax({
		url: "/drcms/configurationMaintain/initialPageJson",
		type: "GET",
		dataType: "json",
		success: function(res) {
			dwr.util.addOptions("goodsTypesOption",res.goodsTypes,'id','goodsTypeName');
		}
	});

	//show query data...
	$("#queryDataAjaxBtn").click(function(event) {
		event.preventDefault();

		$.ajax({
    		url: "/drcms/configurationMaintain/listConfig/" + $("#queryText").val(),
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

    		$("#workLogDiv").attr('style','visibility:visible;width:auto;height:180px;overflow:auto;');
    		$("#tableTitle").text($("#queryText").val()+"查詢結果");

    		//TODO :SHOW WORK LOG
    		$.ajax({
				url: "/drcms/configurationMaintain/getConfigWorkLogs/"+res[0].id,
				type: "GET",
				dataType: "json",
				success: function(res) {
					$("#workLogDiv").html('');
					var i = res.length;
					$.each(res, function( index, value ) {
						$("#workLogDiv").append(
								i + ": " + timestampToDate(value.createDate) + ": " + value.reason + ": " + value.actor +"<BR>");
						i--;
					});
				}

			});
		});

	});

	//button click...
	$("#importDataAjaxAddBtn").click(function(event) {
	    event.preventDefault();
	    $("#importDataDialog").dialog("open");
	});


	//for Data import dialog
	$("#importDataDialog").dialog({
	    autoOpen: false,
	    modal: true,
		width: 520, height: 450,
	    buttons: {

	        "Add": function() {
	        	$.ajax({
	        		url: "configurationMaintain/import",
	        		type: "GET",
	        		data: $("#importDataDialog > form").serialize(),

	        		success: function(JData) {
	        			$(this).dialog("close");
	        		},

	        		error: function() {
	        			alert("ERROR!!!");
	        		}
	        	});
	        },
			"Cancel": function() {
	            $(this).dialog("close");
	        }
	    }
	});

	//for Data import dialog
	/* $("#insertNodeDialog").dialog({
	    autoOpen: false,
	    modal: true,
		width: 400, height: 250,
	    buttons: {

	        "Add": function() {

	        },
			"Cancel": function() {
	            $(this).dialog("close");
	        }
	    }
	}); */


	/* $('#createRootBtn').click(function() {
		$(this).attr("disabled", true);

		var newNode = {id:0,pid:-1,name:"root"};
		$.fn.zTree.getZTreeObj("ztreeFrame").addNodes(null, newNode);

	}); */
	$('#fileupload').fileupload({
	    dataType: 'json',
	    done: function (e, data) {
	    },

	    fail: function (e, data) {
	    	alert("匯入完成.");
	    },

	    progressall: function (e, data) {
	            var progress = parseInt(data.loaded / data.total * 100, 10);
	            $('#progress .bar').css(
	                'width',
	                progress + '%'
	            );
	               },

	            dropZone: $('#dropzone')
	});


	//option lock in add node dialog
	var nobj = [];
	var goodsRes = null;
	$("#goodsTypesOption").change(function() {
		if($( "#goodsTypesOption" ).val()!=-1){

			$.ajax({
	    		url: "/drcms/configurationMaintain/getFreeGoodsListbyTypeId/" + $( "#goodsTypesOption" ).val(),
	    		type: "GET",
	    		success: function(res) {
	    			goodsRes = res;
	    			dwr.util.removeAllOptions("parts");
	    			dwr.util.removeAllOptions("id");

	    			var nres = [];
	    			nobj = [];
	    			for(var i=0;i<res.length;i++){
	    				if($.inArray(res[i].parts.id, nres) == -1){
	    					nres.push(res[i].parts.id);
	    					nobj.push(res[i].parts);
	    				}
	    			}
	    			
	    			dwr.util.addOptions("parts", nobj, "id", "description");
	    			$("#insertNodeDialog #parts").change();
	    		},
	    		error: function() {
	    			alert("ERROR!!!");
	    		}
	    	});
		}else{
			$("#insertNodeDialog #parts").prop('disabled', true);
			$("#insertNodeDialog #id").prop('disabled', true);
			dwr.util.removeAllOptions("parts");
		}


	});


	$("#insertNodeDialog #parts").change(function() {
		
		if($("#insertNodeDialog #parts").val()!=-1){
			dwr.util.removeAllOptions("id");
			var goods = [];
			for(var i = 0;i<goodsRes.length;i++){
				if(goodsRes[i].parts.id == $(this).val())goods.push(goodsRes[i]);
			}
			dwr.util.addOptions("id", goods, "id", snformatter);
			$("#insertNodeDialog #id").prop('disabled', false);
		}else{
			$("#insertNodeDialog #id").prop('disabled', true);
		}
	});
	
});


</script>


<!-- ztree js code  -->
<SCRIPT type="text/javascript">

		var setting = {
			view: {
				showIcon: false,
				addHoverDom: addHoverDom,
				removeHoverDom: removeHoverDom,
				selectedMulti: false,
				nameIsHTML: true
			},
			edit: {

				enable: false,
				editNameSelectAll: true,

				//showRemoveBtn: showRemoveBtn,
				//showRenameBtn: showRenameBtn
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			callback: {
				beforeDrag: beforeDrag,

				//beforeEditName: beforeEditName,
				//beforeRemove: beforeRemove,
				//beforeRename: beforeRename,
				//onRemove: onRemove,
				//onRename: onRename,
			}
		};


		var zNodes =[];

		var log, className = "dark";


		function beforeDrag(treeId, treeNodes) {
			return false;
		}


		/* function beforeEditName(treeId, treeNode) {
			//className = (className === "dark" ? "":"dark");
			//showLog("[ "+getTime()+" beforeEditName ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
			var zTree = $.fn.zTree.getZTreeObj("ztreeFrame");
			zTree.selectNode(treeNode);
			return confirm("Start node '" + treeNode.name + "' editorial status?");
		}

		function beforeRemove(treeId, treeNode) {
			//className = (className === "dark" ? "":"dark");
			//showLog("[ "+getTime()+" beforeRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
			var zTree = $.fn.zTree.getZTreeObj("ztreeFrame");
			zTree.selectNode(treeNode);
			return confirm("Confirm delete node '" + treeNode.name + "' it?");
		}

		function onRemove(event, treeId, treeNode) {
			var n = treeNode.name;
			var gdsn = n.substring(n.indexOf("｜")+1, n.length);



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
		} */
		/* function showRemoveBtn(treeId, treeNode) {
			if(treeNode.level!=0)return true;
			else return false;
		}
		function showRenameBtn(treeId, treeNode) {
			if(treeNode.level!=0)return true;
			else return false;
		} */
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

		var newCount = 1;
		function addHoverDom(treeId, treeNode) {
			
			//show button
			var sObj = $("#" + treeNode.tId + "_span");
			if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;

			//if (treeNode.editNameFlag || $("#changePNBtn_"+treeNode.tId).length>0) return;
			//if (treeNode.editNameFlag || $("#editSNBtn_"+treeNode.tId).length>0) return;
			if (treeNode.editNameFlag || $("#removeBtn_"+treeNode.tId).length>0) return;

			var addStr = "";
			if(treeNode.level!=0){
				addStr = "<button title='加入料件' id='addBtn_" + treeNode.tId + "' >Add</button>"
				//+ "<button title='Edit SN' id=editSNBtn_" + treeNode.tId + ">Edit</button>"
				//+ "<button title='Change PN' id=changePNBtn_" + treeNode.tId + ">Change PN</button>"
				+ "<button class=testBtn title='Remove Node' id='removeBtn_" + treeNode.tId + "' >Remove</button>";
			}else{
				addStr = "<button title='Add node' id='addBtn_" + treeNode.tId + "' >Add</button>";
			}

			sObj.after(addStr);

			var zTree = $.fn.zTree.getZTreeObj("ztreeFrame");

			//create new child node
			var btn = $("#addBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){

				//initilize goodstype option...
				$.ajax({
					url: "/drcms/configurationMaintain/findbyGoodSn/" + treeNode.id,
					type: "GET", dataType: "json",
					success: function(res) {
						$.ajax({
							url: "/drcms/configurationMaintain/initilizeGoodsTypeOptionbyType/" + res.parts.partType,
							type: "GET", dataType: "json",
							success: function(resn) {								
								if(resn.length==0){
									$("#msgDiv").attr('style','display:inline;');
									$('.ui-dialog-buttonpane').find('button:contains("新增")').hide();
									$("#insertNodeDialog fieldset").attr('style','display:none;');
									$('.ui-button:contains(Add)').hide();
								}else{
									$("#msgDiv").attr('style','visibility:hidden;');
									$('.ui-dialog-buttonpane').find('button:contains("新增")').show();
									$("#insertNodeDialog fieldset").attr('style','display:inline;border: 0;');
									dwr.util.removeAllOptions("goodsTypesOption");
									dwr.util.addOptions("goodsTypesOption", resn, 'id', 'goodsTypeName');
									$('#goodsTypesOption').change();
								}
							},
							error: function() {}
						});
					},
					error: function() {}
				});
				
				//clear
				//dwr.util.removeAllOptions("parts");
				//dwr.util.removeAllOptions("id");
				//dwr.util.setValue("goodsTypesOption","");
				dwr.util.setValue("parentSn", treeNode.id);
				
				$("#insertNodeDialog").attr('style','visibility:visible;').dialog({
				    autoOpen: false, modal: true,
					width: 550, height: 300,
				    buttons: {
				        "新增": function() {
				        	//TODO : add btn
				        	$.ajax({
								url: "/drcms/configurationMaintain/addGoodsSubmit",
								type: "GET", dataType: "json",
								data: $("#insertNodeDialog > form").serialize(),
								success: function(res) {},
								error: function() {}
							}).done(function(res) {
								$("#queryDataAjaxBtn").click();
							});

				        	if($('#parts').val()!=-1&&$('#id').val()!=-1)
				        		zTree.addNodes(treeNode, {id:(100 + newCount), pId:treeNode.id, name:($('#id  option:selected').text())});

				        	$(this).dialog("close");
				        },
						"取消": function() {
				            $(this).dialog("close");
				        }
				    }
				}).dialog("open");
				return false;
			});

			//edit SN button...
			//TODO : EDIT SN
			var btn = $("#editSNBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				$('#snSelect option').remove(); //clear select box
				$('#editSNDialog #log').val(""); //clear log textarea


				$("#editSNDialog #oldSN").val(treeNode.id);
				$("#editSNDialog #pId").val(treeNode.pId);

				$.ajax({
					url: "/drcms/configurationMaintain/listSNOption/" + treeNode.id,
					type: "GET", dataType: "json",

					success: function(res) {
						dwr.util.addOptions("snSelect", res, 'id', snformatter);
					},
					error: function() {
						alert('error');
					}
				});

				$("#editSNDialog").attr('style','visibility:visible;').dialog({
				    autoOpen: false,
				    modal: true,
					width: 450, height: 370,
				    buttons: {
				        "Add": function() {

				        	$.ajax({
								url: "/drcms/configurationMaintain/editSN",
								type: "GET", dataType: "json",
								data: $("#editSNDialog > form").serialize(),

								success: function(res) {},
								error: function() {
									alert('error');
								}

							}).done(function(res) {
								$("#queryDataAjaxBtn").click();
							});
				        	$(this).dialog("close");
				        },
						"Cancel": function() {
				            $(this).dialog("close");
				        }
				    }
				}).dialog("open");

				return false;
			});


			//edit PN button...
			//TODO : change pn
			var btn = $("#changePNBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				$('#pnSelect option').remove(); //clear select box
				$("#changePNDialog #log").val(""); //clear log textarea


				$("#changePNDialog #oldSN").val(treeNode.id);
				$("#changePNDialog #pId").val(treeNode.pId);

				$.ajax({
					url: "/drcms/configurationMaintain/listPNOption/" + treeNode.id,
					type: "GET", dataType: "json",
					data: $("#changePNDialog > form").serialize(),
					success: function(res) {
						dwr.util.addOptions("pnSelect", res, 'id', pnformatter);
					},
					error: function() {
						alert('error');
					}
				});

				$("#changePNDialog").attr('style','visibility:visible;').dialog({
				    autoOpen: false,
				    modal: true,
					width: 450, height: 370,
				    buttons: {
				        "Add": function() {

				        	//alert($("#changePNDialog > form").serialize());
				        	$.ajax({
								url: "/drcms/configurationMaintain/editSN/",

								type: "GET", dataType: "json",
								data: $("#changePNDialog > form").serialize(),
								success: function(res) {},
								error: function() {
									alert('error');
								}

							}).done(function(res) {
								$("#queryDataAjaxBtn").click();
							});
				        	$(this).dialog("close");
				        },
						"Cancel": function() {
				            $(this).dialog("close");
				        }
				    }
				}).dialog("open");
				return false;
			});


			//remove button...
			//TODO : remove
			var btn = $("#removeBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				
				var question = "確定移除料件<B>["+treeNode.id+"]</B>?";
				confirmation(question, "請選擇移除方式...").then(function (answer) {
			        if(answer=='OnlyRemove'){
						var node = zTree.getNodeByTId(treeNode.tId);

			            $.ajax({
							url: "/drcms/configurationMaintain/deleteGoodsSubmit/",
							type: "POST", dataType: "json",
							data:{"id" : node.id},
							success: function(res) {
								zTree.removeNode(node);
							},
							error: function() {}
						}).done(function(res) {
							$("#queryDataAjaxBtn").click();
						});
			        }else if(answer=='AsFaliurePart'){
			        	//insert into failurepart table...
			        	var node = zTree.getNodeByTId(treeNode.tId);

			            $.ajax({
							url: "/drcms/configurationMaintain/insertFailPart/",
							type: "POST", dataType: "json",
							data:{"sn" : node.id, "parentSn" : node.pId},
							success: function(res) {
								zTree.removeNode(node);
							},
							error: function() {}
						}).done(function(res) {
							$("#queryDataAjaxBtn").click();
						});
			        	
			        }else if(answer=='Cancel'){
			        	
			        }
			    });

				return false;
			});
		};

		function snformatter(obj) { return obj.id+ "｜" + obj.parts.description; }
		function pnformatter(obj) { return obj.id+ "｜" + obj.parts.description; }

		function removeHoverDom(treeId, treeNode) {
			$("#addBtn_"+treeNode.tId).unbind().remove();
			$("#removeBtn_"+treeNode.tId).unbind().remove();
			$("#editSNBtn_"+treeNode.tId).unbind().remove();
			$("#changePNBtn_"+treeNode.tId).unbind().remove();
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
	font-size: 14px;
	font-weight: bold;
	background-color: blue;
	color: white;
}
</style>


<h1 class="contentTitle">序號資料維護</h1>
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

					<!-- <input class="JQbtn" type="button" value="Create Root" id="createRootBtn"> -->
				</td>
            </tr>
         </table>
	</div>
	<div class="CSSTableGenerator" >
		<table  id="mainTable">
            <thead id="mainTableHead">
            <TR>

                <th><label id="tableTitle">Configuration Maintain...</label></th>
			</TR>
            </thead>
            <tbody  id="mainTableBody">

            <tr>
                <td>
				<div id="ztreeFrame" class="ztree"></div>
				</td>
            </tr>

            <tr><td><div id="workLogDiv" style="display:none;"></div></td></tr>
            </tbody>
         </table>
	</div>
</div>

<!-- Dialog Content -->
<!-- <div id="importDataDialog" title="import data" >
<form method="get">
	<fieldset>

	<table>
		<tr><td align="left">Attachment：</td><td><input name="attachment" type="file" ></td></tr>
	</table>
	</fieldset>

</form>
</div> -->



<div id="insertNodeDialog" title="新增新料件" style="display:none;" >
<form>
	<fieldset>
	<table>
		<tr><td align="left">Type：</td><td><select id="goodsTypesOption" name="goodsTypesOption">
		</select></td></tr>
		<tr><td align="left">Parts Name：</td><td><select name="partsSn" id="parts" >
		</select></td></tr>
		<tr><td align="left">S/N：</td><td><select name="id" id="id" >
		</select></td></tr>
		<tr><td><input type="hidden" id="parentSn" name="parentSn"></td></tr>
	</table>
	</fieldset>
</form>
<div id='msgDiv' style="display: none; "><font color=red>此料件下無法新增料件</font></div>
</div>


<div id="editSNDialog" title="Edit SN" style="display:none;" >
<form>
	<fieldset>
	<table>
		<tr><td align="left">S/N：</td><td><select name="sn" id="snSelect" ></select></td></tr>
		<tr><td align="left">Log：</td><td><textarea id="log" name="log" rows="5" cols="30"></textarea></td></tr>

		<tr><td colspan=2><input type="hidden" id="oldSN" name="oldSN" ></td></tr>
		<tr><td colspan=2><input type="hidden" id="pId" name="pId" ></td></tr>
	</table>
	</fieldset>
</form>
</div>


<div id="changePNDialog" title="Change PN" style="display:none;" >
<form>
	<fieldset>
	<table>
		<tr><td align="left"><label id="pnLabel"></label>：</td><td><select name="sn" id="pnSelect" ></select></td></tr>
		<tr><td align="left">Log：</td><td><textarea id="log" name="log" rows="5" cols="30"></textarea></td></tr>

		<tr><td colspan=2><input type="hidden" id="oldSN" name="oldSN" ></td></tr>
		<tr><td colspan=2><input type="hidden" id="pId" name="pId" ></td></tr>
	</table>
	</fieldset>
</form>
</div>


