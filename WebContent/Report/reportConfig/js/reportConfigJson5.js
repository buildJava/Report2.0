/* *
 * 变量定义区域 $开头的变量为全局变量且在页面周期存储可变值
 * */
var pageCdtInfoList = null; //保存当前刷新出来的列表用来对控件进行预览，初始化数据时进行初始化，数据类似于[{},{}]

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
	qryCondition();
	//使用dataTable实例化表格，遗留问题，如何能在整体刷新页面的情况下更新DataTable的数据
	var reportData = $('#data-body').DataTable({
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
}
//初始化输入框
function resetPage(){
	var _blank = "";
	$("#cdt_id").val(_blank);
	$("#cdt_code").val(_blank);
	$("#cdt_name").val(_blank);
	$("#cdt_desc").val(_blank);
	$("#cdt_sql").val(_blank);
	$("#pat_cdt_id").val(0);
	$("#pat_col_code").val(_blank);
	$("#addOrModify").val(0);
}
//新增报表查询控件
function addConditionInfo(pos){
	scrollToPos(pos);
	resetPage();
}
//查询控件信息
function qryCondition(){
	var params = {};
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryCondition.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var cdtInfoList = data.result.cdtInfoList;
			var _html = "";
			var reportBody = $("#reportBody");
			if(isEmptyObj(cdtInfoList)){
				reportBody.empty();
				$(".no-data").show();
				return;
			}else{
				//保存当前刷新出来的列表用来对控件进行预览
				pageCdtInfoList = cdtInfoList;
				$.each(cdtInfoList, function(i, item){
					if((i+1)%2){
						_html += "<tr>"
							  +  	"<td>"+item.RN+"</td>"
							  +  	"<td><a class='ui-table-href' onclick=\"modifyCondition('"+item.CDT_ID+"')\">"+item.CDT_NAME+"</a></td>"
							  +  	"<td class='text-overflow'>"+item.CDT_DESC+"</td>"
							  +  	"<td>"+item.CDT_SHOW_DESC+"</td>"
							  +  	"<td>"+item.CDT_CAL_DESC+"</td>"
							  +  	"<td>"+item.PAT_CDT_NAME+"</td>"
							  +  	"<td>"+item.PAT_COL_CODE+"</td>"
							  +  	"<td>"
							  +			"<a class='oper-btn' onclick=\"openCondition('"+item.CDT_ID+"')\">预览</a> | "
							  +			"<a class='oper-btn' onclick=\"modifyCondition('"+item.CDT_ID+"')\">修改</a> | "
							  +			"<a class='oper-btn' onclick=\"deleteCondition('"+item.CDT_ID+"')\">删除</a>"
							  +		"</td>"
							  +  "</tr>";
					}else{
						_html += "<tr class='ui-table-split'>"
							  +  	"<td>"+item.RN+"</td>"
							  +  	"<td><a class='ui-table-href' onclick=\"modifyCondition('"+item.CDT_ID+"')\">"+item.CDT_NAME+"</a></td>"
							  +  	"<td class='text-overflow'>"+item.CDT_DESC+"</td>"
							  +  	"<td>"+item.CDT_SHOW_DESC+"</td>"
							  +  	"<td>"+item.CDT_CAL_DESC+"</td>"
							  +  	"<td>"+item.PAT_CDT_NAME+"</td>"
							  +  	"<td>"+item.PAT_COL_CODE+"</td>"
							  +  	"<td>"
							  +			"<a class='oper-btn' onclick=\"openCondition('"+item.CDT_ID+"')\">预览</a> | "
							  +			"<a class='oper-btn' onclick=\"modifyCondition('"+item.CDT_ID+"')\">修改</a> | "
							  +			"<a class='oper-btn' onclick=\"deleteCondition('"+item.CDT_ID+"')\">删除</a>"
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
//设置参数
function setParams(){
	//增加或者修改，0增加，1修改
	var addOrModify = $("#addOrModify").val();
	var cdtId = "";
	if(addOrModify == 1){
		cdtId = $("#cdt_id").val();
	}
	var cdtCode = $("#cdt_code").val();
	var cdtName = $("#cdt_name").val();
	var cdtDesc = $("#cdt_desc").val();
	var cdtShowType = $("#cdt_show_type").val();
	var cdtCalType = $("#cdt_cal_type").val();
	var cdtSql = $("#cdt_sql").val();
	var patCdtId = $("#pat_cdt_id").val();
	var patColCode = $("#pat_col_code").val();
	//组合参数
	var params = {};
	params.addOrModify = addOrModify;
	params.cdtId = cdtId;
	params.cdtCode = cdtCode;
	params.cdtName = cdtName;
	params.cdtDesc = cdtDesc;
	params.cdtCalType = cdtCalType;
	params.cdtShowType = cdtShowType;
	params.cdtSql = cdtSql;
	params.patCdtId = patCdtId;
	params.patColCode = patColCode;

	//校验参数
	if(validateParams(params)){
		return params;
	}
	
}

//校验输入项
function validateParams(params){
	if(isNull(params.cdtCode)){
		art.dialog.tips("控件编码必须填写！");
		return false;
	}else if(isNull(params.cdtName)){
		art.dialog.tips("控件名称必须填写！");
		return false;
	}else if(isNull(params.cdtDesc)){
		art.dialog.tips("控件描述必须填写！");
		return false;
	}else if(!isNull(params.patCdtId) && params.patCdtId != 0 && isNull(params.patColCode)){
		art.dialog.tips("父级控件存在时级联字段必须填写！");
		return false;
	}else if(isNull(params.patColCode)){
		params.patColCode = "—";
		return true;
	}else{
		return true;
	}
}
//保存控件信息
function saveCondition(){
	var params = {};
	params = setParams();
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!saveCondition.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			art.dialog.tips("报表查询控件保存成功！");
			var url = ctx+"/report/reportConfigAction!reportConfig5.do";
			setTimeout(function(){window.location.href=url}, 500);
		},
		error:function(e){}
	})
}
//打开查询控件
function openCondition(cdtId){
	//从控件列表中获取控件对角
	var condition = getObjFromArray(pageCdtInfoList, "CDT_ID", cdtId);
	//改变控件名称
	var cdtName = condition.CDT_NAME;
	$("#dialog_cdt_name").text(cdtName+"：");
	//获取控件展示div
	var dialog_cdt_show = $("#dialog_cdt_show");
	//获取控件的展现类型
	var showType = parseInt(condition.CDT_SHOW_TYPE);
	//showType是控件的展现形式1	日期，2 日期(开始-结束)，3 月份，4 月份(开始-结束)，5 多选框，6 单选框，7 文本框，8 固定值列表
	switch(showType){
		case 1:
			buildDatePicker("YYYYMMDD", dialog_cdt_show);
			break;
		case 2:
			buildDateBwnPicker("YYYYMMDD", dialog_cdt_show);
			break;
		case 3:
			buildDatePicker("YYYYMM", dialog_cdt_show);;
			break;
		case 4:
			buildDateBwnPicker("YYYYMM", dialog_cdt_show);;
			break;
		case 5:
			var dataList = qryDataList(condition);
			buildCheckPicker(condition, dataList, dialog_cdt_show);
			break;
		case 6:
			var dataList = qryDataList(condition);
			buildRadioPicker(condition, dataList, dialog_cdt_show);
			break;
		case 7:
			buildTextPicker(condition, dialog_cdt_show);
			break;
		case 8:
			buildSelectPicker(condition, dialog_cdt_show);
			break;
	}
	
	var dialog_win_html = $("#dialog_win").html();
	var dialogWin = art.dialog({
		title:"控件预览-"+cdtName,
	    fixed:true,
	    id:'dialogWin'+cdtId,
	    drag:true,
		resize:true,
		lock:true,
	    content:dialog_win_html
	})
}
//修改控件信息
function modifyCondition(cdtId){
	//从控件列表中获取控件对角
	var condition = getObjFromArray(pageCdtInfoList, "CDT_ID", cdtId);
	$("#addOrModify").val(1);
	$("#cdt_id").val(cdtId);
	$("#cdt_code").val(condition["CDT_CODE"]);
	$("#cdt_name").val(condition["CDT_NAME"]);
	$("#cdt_desc").val(condition["CDT_DESC"]);
	$("#cdt_cal_type").val(condition["CDT_CAL_TYPE"]);
	$("#cdt_show_type").val(condition["CDT_SHOW_TYPE"]);
	$("#cdt_sql").val(condition["CDT_SQL"]);
	$("#pat_cdt_id").val(condition["PAT_CDT_ID"]);
	$("#pat_col_code").val(condition["PAT_COL_CODE"]);
	scrollToPos('#add');
}
//删除控件信息
function deleteCondition(cdtId){
	var params = {};
	params.cdtId = cdtId;
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!deleteCondition.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			art.dialog.tips("报表查询控件删除成功！");
			var url = ctx+"/report/reportConfigAction!reportConfig5.do";
			setTimeout(function(){window.location.href=url}, 500);
		},
		error:function(e){}
	})
}
