/* *
 * 变量定义区域 $开头的变量为全局变量且在页面周期存储可变值
 * */

/* *
 * 页面jquery事件响应区域
 * */
$(document).ready(function(){
	//初始化数据
	init();
	//使用dataTable实例化表格
	$('#data-body').DataTable({
		"oLanguage": {
    		"sLengthMenu": "每页显示 _MENU_ 条记录",
    		"sZeroRecords": "抱歉， 没有找到",
    		"sInfo": "",
    		"sInfoEmpty": "",
    		"sInfoFiltered": "",
    		"oPaginate": {
	    		"sFirst": "",
	    		"sPrevious": "",
	    		"sNext": "",
	    		"sLast": ""
	    	}
    	}
	});
})

/* *
 * 页面方法区域
 * */
//初始化数据
function init(){
	qryReportInfo();
}
//查询报表配置信息
function qryReportInfo(){
	var params = {};
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryReportInfo.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var reportInfoList = data.result.reportInfoList;
			var _html = "";
			var reportBody = $("#reportBody");
			if(isEmptyObj(reportInfoList)){
				reportBody.empty();
				$(".no-data").show();
				return;
			}else{
				$.each(reportInfoList, function(i, item){
					if((i+1)%2){
						_html += "<tr>"
							  +  	"<td>"+item.RN+"</td>"
							  +  	"<td class='text-overflow'><a class='ui-table-href' title='"+item.RPT_NAME+"' onclick=\"openReport('"+item.RPT_ID+"')\">"+item.RPT_NAME+"</a></td>"
							  +  	"<td>"+item.RPT_CYCLE_DESC+"</td>"
							  +  	"<td>"+item.RPT_TYPE_DESC+"</td>"
							  +  	"<td>"+item.UPDATE_DATE+"</td>"
							  +  	"<td>"+item.CREATER_NAME+"</td>"
							  +  	"<td>"+item.RPT_STATUS+"</td>"
							  +  	"<td>"
							  +			"<a class='oper-btn' onclick=\"openReport('"+item.RPT_ID+"')\">预览</a> | "
							  +			"<a class='oper-btn' onclick=\"modifyReportInfo('"+item.RPT_ID+"')\">修改</a> | ";
						if(item.RPT_STATUS == "有效"){
							_html += "<a class='oper-btn' onclick=\"deleteReportInfo('"+item.RPT_ID+"')\">删除</a>";
						}else{
							_html += "<a class='oper-btn' onclick=\"reUseReportInfo('"+item.RPT_ID+"')\">启用</a>";
						}
					}else{
						_html += "<tr class='ui-table-split'>"
							  +  	"<td>"+item.RN+"</td>"
							  +  	"<td class='text-overflow'><a class='ui-table-href' title='"+item.RPT_NAME+"' onclick=\"openReport('"+item.RPT_ID+"')\">"+item.RPT_NAME+"</a></td>"
							  +  	"<td>"+item.RPT_CYCLE_DESC+"</td>"
							  +  	"<td>"+item.RPT_TYPE_DESC+"</td>"
							  +  	"<td>"+item.UPDATE_DATE+"</td>"
							  +  	"<td>"+item.CREATER_NAME+"</td>"
							  +  	"<td>"+item.RPT_STATUS+"</td>"
							  +  	"<td>"
							  +			"<a class='oper-btn' onclick=\"openReport('"+item.RPT_ID+"')\">预览</a> | "
							  +			"<a class='oper-btn' onclick=\"modifyReportInfo('"+item.RPT_ID+"')\">修改</a> | "
					    if(item.RPT_STATUS == "有效"){
							_html += "<a class='oper-btn' onclick=\"deleteReportInfo('"+item.RPT_ID+"')\">删除</a>";
						}else{
							_html += "<a class='oper-btn' onclick=\"reUseReportInfo('"+item.RPT_ID+"')\">启用</a>";
						}
					}
				})
				_html += 	"</td>"
					   +  "</tr>";
				reportBody.empty();
				reportBody.html(_html);
			}
		},
		error:function(e){}
	})
}
//设置参数
function setParams(){
	
	//组合参数
	var params = {};

	//校验参数
	if(validateParams(params)){
		return params;
	}
	
}
//校验输入项
function validateParams(params){
	return true;
}
//修改报表配置信息
function modifyReportInfo(rptId){
	var url = ctx + "/report/reportConfigAction!reportConfig6.do?rptId="+rptId;
	window.location.href=url;
}
//删除报表配置信息
function deleteReportInfo(rptId){
	var _confirmMsg = "<div class='confirm-msg-box'><img src='"+ctx+"/Common/plugin/dialog/skins/icons/warning.png' /><span>确认要删除吗？<span></div>";
	art.dialog({
	    content: _confirmMsg,
	    ok: function () {
	    	var params = {};
	    	params.rptId = rptId;
	    	var _parStr = JSON.stringify(params);
	    	$.ajax({
	    		url:ctx+"/report/json/reportConfigJsonAction!deleteReportInfoById.action",
	    		data:{_params:_parStr},
	    		async:false,
	    		dataType:"json",
	    		type:"post",
	    		success:function(data){
	    			art.dialog.tips("报表配置删除成功！");
	    			init();
	    		},
	    		error:function(e){}
	    	})
	    },
	    cancelVal: '关闭',
	    cancel: true
	});	
}
//重新启用报表配置信息
function reUseReportInfo(rptId){
	var params = {};
	params.rptId = rptId;
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!reUseReportInfoById.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			art.dialog.tips("报表配置启用成功！");
			init();
		},
		error:function(e){}
	})
}
//打开报表
function openReport(rptId){
	var url = ctx + "/report/reportConfigAction!reportShow.do?rptId="+rptId;
	window.location.href=url;
}