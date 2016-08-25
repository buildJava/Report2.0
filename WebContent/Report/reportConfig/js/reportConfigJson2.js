/* *
 * 变量定义区域
 * */

/* *
 * 页面jquery事件响应区域
 * */
$(document).ready(function(){
	//初始化数据
	init();
})

/* *
 * 页面方法区域
 * */
//初始化数据
function init(){
	qryTableInfo(0);
	qryTableInfoCount();
}

//设置参数
function setParams(){
	var tbOwner = $("#tb_owner").val();
	var tbCode = $("#tb_code").val();
	var tbName = $("#tb_name").val();
	var fieldName = $("#field_name").val();
	
	//组合参数
	var params = {};
	params.tbOwner = tbOwner;
	params.tbCode = tbCode;
	params.tbName = tbName;
	params.fieldName = fieldName;

	//校验参数
	if(validateParams(params)){
		return params;
	}
	
}

//校验输入项
function validateParams(params){
	return true;
}

//查询报表元数据
function qryTableInfo(curPage){
	$("#loading-box").show();
	var params = {};
	params = setParams();
	
	//查询页码设置
	params.pageSize = pageSize;
	params.startIndex = curPage*pageSize+1;
	params.endIndex = (curPage+1)*pageSize;
	
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryTableInfo.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			$("#loading-box").fadeOut();
			var tableInfoList = data.result.tableInfoList;
			var reportBody = $("#reportBody");
			var _html = "";
			if(isEmptyObj(tableInfoList)){
				reportBody.empty();
				$(".no-data").show();
				return;
			}else{
				$(".no-data").hide();
				$.each(tableInfoList, function(i, item){
					if((i+1)%2){
						_html += "<tr>"
							  +  	"<td>"+item.RN+"</td>"
							  +  	"<td class='text-overflow'><a class='ui-table-href' title='"+item.TB_NAME+"' onclick=\"openTableField('"+item.TB_ID+"')\">"+item.TB_NAME+"</a></td>"
							  +  	"<td>"+item.TB_OWNER+"</td>"
							  +  	"<td class='text-overflow'>"+item.TB_CODE+"</td>"
							  +  	"<td>"+item.SPLIT_FLAG+"</td>"
							  +  	"<td>"+item.SPLIT_CODE+"</td>"
							  +  	"<td>"+item.CREATER_NAME+"</td>"
							  +  	"<td>"+item.UPDATE_DATE+"</td>"
							  +  	"<td>"
							  +			"<a class='oper-btn' onclick=\"deletetableInfo('"+item.TB_ID+"')\">删除</a> | "
							  +			"<a class='oper-btn' onclick=\"flushTableField('"+item.TB_ID+"')\">刷新</a>"
							  +		"</td>"
							  +  "</tr>";
					}else{
						_html += "<tr class='ui-table-split'>"
							  +  	"<td>"+item.RN+"</td>"
							  +  	"<td class='text-overflow'><a class='ui-table-href' title='"+item.TB_NAME+"' onclick=\"openTableField('"+item.TB_ID+"')\">"+item.TB_NAME+"</a></td>"
							  +  	"<td>"+item.TB_OWNER+"</td>"
							  +  	"<td class='text-overflow'>"+item.TB_CODE+"</td>"
							  +  	"<td>"+item.SPLIT_FLAG+"</td>"
							  +  	"<td>"+item.SPLIT_CODE+"</td>"
							  +  	"<td>"+item.CREATER_NAME+"</td>"
							  +  	"<td>"+item.UPDATE_DATE+"</td>"
							  +  	"<td>"
							  +			"<a class='oper-btn' onclick=\"deletetableInfo('"+item.TB_ID+"')\">删除</a> | "
							  +			"<a class='oper-btn' onclick=\"flushTableField('"+item.TB_ID+"')\">刷新</a>"
							  +		"</td>"
							  +  "</tr>";
					}
				})
				reportBody.empty();
				reportBody.html(_html);
			}
			
		},
		error:function(e){}
	})
}
//查询报表元数据记录数
function qryTableInfoCount(){
	var params = {};
	params = setParams();
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryTableInfoCount.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var tableInfoCount = data.result.tableInfoCount;
			//分页
			$("#pagination").pagination(tableInfoCount, {
			    num_edge_entries: 2,
			    num_display_entries: 4,
			    callback: qryTableInfo,
				items_per_page:pageSize,
				prev_text:" ",
				next_text:" "
			});
		},
		error:function(e){}
	})
}
//打开报表元数据字段列表
function openTableField(tbId){
	var url = ctx+"/report/reportConfigAction!reportConfig3.do?tbId="+tbId;
	window.location.href = url;
}
//删除报表元数据
function deletetableInfo(tbId){
	var _confirmMsg = "<div class='confirm-msg-box'><img src='"+ctx+"/Common/plugin/dialog/skins/icons/warning.png' /><span>确认要删除吗？<span></div>";
	art.dialog({
	    content: _confirmMsg,
	    ok: function () {
	    	var params = {};
	    	params.tbId = tbId;
	    	var _parStr = JSON.stringify(params);
	    	$.ajax({
	    		url:ctx+"/report/json/reportConfigJsonAction!deleteTableInfo.action",
	    		data:{_params:_parStr},
	    		async:false,
	    		dataType:"json",
	    		type:"post",
	    		success:function(data){
	    			art.dialog.tips("报表元数据删除成功！");
	    			//刷新数据
	    			init();
	    		},
	    		error:function(e){}
	    	})
	        return true;
	    },
	    cancelVal: '关闭',
	    cancel: true
	});
}
//刷新报表元数据字段列表
function flushTableField(tbId){
	
	var _confirmMsg = "<div class='confirm-msg-box'><img src='"+ctx+"/Common/plugin/dialog/skins/icons/warning.png' /><span>确认要刷新元数据吗？<span></div>";
	art.dialog({
	    content: _confirmMsg,
	    ok: function () {
	    	var params = {};
	    	params.tbId = tbId;
	    	var _parStr = JSON.stringify(params);
	    	$.ajax({
	    		url:ctx+"/report/json/reportConfigJsonAction!flushTableField.action",
	    		data:{_params:_parStr},
	    		async:false,
	    		dataType:"json",
	    		type:"post",
	    		success:function(data){
	    			art.dialog.tips("报表元数据刷新成功！");
	    		},
	    		error:function(e){}
	    	})
	    },
	    cancelVal: '关闭',
	    cancel: true
	});
}

//新增报表元数据
function addTableInfo(){
	var url = ctx+"/report/reportConfigAction!reportConfig1.do";
	window.location.href = url;
}