/* *
 * 变量定义区域 $开头的变量为全局变量且在页面周期存储可变值
 * */
var $fieldType = ['VARCHAR2', 'CHAR', 'VARCHAR', 'NUMBER', 'LONG', 'CLOB', 'DATE']; //用于校验字段类型
var _curPage = 0;

/* *
 * 页面jquery事件响应区域
 * */
$(document).ready(function(){
	init();
})

/* *
 * 页面方法区域
 * */
//初始化数据
function init(){
	qryTableFieldById(_curPage);
	qryTableFieldCountById();
}

//设置参数
function setParams(){
	var fieldId = $("#fieldId").val();
	var tbId = $("#tbId").val();
	var addOrModify = $("#addOrModify").val();
	var displayOrder = $("#display_order").val();
	var fieldCode = $("#field_code").val();
	var fieldName = $("#field_name").val();
	var fieldType = $("#field_type").val();
	var fieldLength = $("#field_length").val();
	var isDim = $("input[type='radio'][name='is_dim']:checked").val();
	var groupValue = $("#group_value").val();
	
	//组合参数
	var params = {};
	params.fieldId = fieldId;
	params.tbId = tbId;
	params.addOrModify = addOrModify;
	params.displayOrder = displayOrder;
	params.fieldCode = fieldCode;
	params.fieldName = fieldName;
	params.fieldType = fieldType;
	params.fieldLength = fieldLength;
	params.isDim = isDim;
	params.groupValue = groupValue;

	//校验参数
	if(validateParams(params)){
		return params;
	}
	
}

//校验输入项
function validateParams(params){
	if(isNull(params.tbId)){
		art.dialog.tips("应用错误请联系管理员或重新登录！");
		return false;
	}else if(isNull(params.addOrModify)){
		art.dialog.tips("应用错误请联系管理员或重新登录！");
		return false;
	}else if(isNull(params.displayOrder)){
		art.dialog.tips("字段顺序不能为空！");
		return false;
	}else if(isNull(params.fieldCode)){
		art.dialog.tips("字段编码不能为空！");
		return false;
	}else if(isNull(params.fieldName)){
		art.dialog.tips("字段名称不能为空！");
		return false;
	}else if(isNull(params.fieldType)){
		art.dialog.tips("字段类型不能为空！");
		return false;
	}else if($fieldType.indexOf(params.fieldType) == -1){ 
		art.dialog.tips("字段类型不合法！");
		return false;
	}else if(isNull(params.fieldLength)){
		art.dialog.tips("字段长度不能为空！");
		return false;
	}else{
		return true;
	}
}

//查询元数据字段列表
function qryTableFieldById(curPage){
	var params = {};
	params.tbId = $("#tbId").val();
	
	//查询页码设置
	params.pageSize = pageSize;
	params.startIndex = curPage*pageSize+1;
	params.endIndex = (curPage+1)*pageSize;
	_curPage = curPage;
	
	var _parStr = JSON.stringify(params);
	
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryTableFieldById.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var tableFieldList = data.result.tableFieldList;
			var reportBody = $("#reportBody");
			var _html = "";
			if(isEmptyObj(tableFieldList)){
				reportBody.empty();
				$(".no-data").show();
				return;
			}else{
				$fieldOrder = [];
				$.each(tableFieldList, function(i, item){
					var group_value = item.GROUP_VALUE;
					if(group_value != "—"){
						group_value = group_value.substring(0,5)+"...";
					}
					if((i+1)%2){
						_html += "<tr>"
							  +  	"<td>"+item.DISPLAY_ORDER+"</td>"
							  +  	"<td><a class='ui-table-href' onclick=\"openTableField('"+item.FIELD_ID+"')\">"+item.FIELD_CODE+"</a></td>"
							  +  	"<td>"+item.FIELD_NAME+"</td>"
							  +  	"<td>"+item.FIELD_TYPE+"</td>"
							  +  	"<td>"+item.FIELD_LENGTH+"</td>"
							  +  	"<td>"+item.IS_DIM+"</td>"
							  +  	"<td title='"+item.GROUP_VALUE+"'>"+group_value+"</td>"
							  +  	"<td><a class='oper-btn' onclick=\"deleteTableField('"+item.TB_ID+"', '"+item.FIELD_ID+"')\">删除</a></td>"
							  +  "</tr>";
					}else{
						_html += "<tr class='ui-table-split'>"
							  +  	"<td>"+item.DISPLAY_ORDER+"</td>"
							  +  	"<td><a class='ui-table-href' onclick=\"openTableField('"+item.FIELD_ID+"')\">"+item.FIELD_CODE+"</a></td>"
							  +  	"<td>"+item.FIELD_NAME+"</td>"
							  +  	"<td>"+item.FIELD_TYPE+"</td>"
							  +  	"<td>"+item.FIELD_LENGTH+"</td>"
							  +  	"<td>"+item.IS_DIM+"</td>"
							  +  	"<td title='"+item.GROUP_VALUE+"'>"+group_value+"</td>"
							  +  	"<td><a class='oper-btn' onclick=\"deleteTableField('"+item.TB_ID+"', '"+item.FIELD_ID+"')\">删除</a></td>"
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
//查询元数据字段列表记录数
function qryTableFieldCountById(){
	var params = {};
	params.tbId = $("#tbId").val();
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryTableFieldCountById.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var tableFieldCount = data.result.tableFieldCount;
			//分页
			$("#pagination").pagination(tableFieldCount, {
			    num_edge_entries: 2,
			    num_display_entries: 4,
			    callback: qryTableFieldById,
			    current_page:_curPage,
				items_per_page:pageSize,
				prev_text:" ",
				next_text:" "
			});
		},
		error:function(e){}
	})
}
//根据元数据字段ID删除字段
function deleteTableField(tbId, fieldId){
	var _confirmMsg = "<div class='confirm-msg-box'><img src='"+ctx+"/Common/plugin/dialog/skins/icons/warning.png' /><span>确认要删除字段吗？<span></div>";
	art.dialog({
	    content: _confirmMsg,
	    ok: function () {
	    	//删除
	    	var params = {};
	    	params.tbId = tbId;
	    	params.fieldId = fieldId;
	    	var _parStr = JSON.stringify(params);
	    	$.ajax({
	    		url:ctx+"/report/json/reportConfigJsonAction!deleteTableField.action",
	    		data:{_params:_parStr},
	    		async:false,
	    		dataType:"json",
	    		type:"post",
	    		success:function(data){
	    			art.dialog.tips("报表元数据字段删除成功！");
	    			//刷新数据
	    			init();
	    		},
	    		error:function(e){}
	    	})
	    },
	    cancelVal: '关闭',
	    cancel: true
	});
}
//打开元数据字段详细信息
function openTableField(fieldId){
	scrollToPos("#add");
	//把按钮改成修改
	$("#save_btn").text("修改");
	$("#addOrModify").val(0);
	var params = {};
	params.fieldId = fieldId;
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!openTableField.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var tableField = data.result.tableField;
			if(isEmptyObj(tableField)){
				return;
			}else{
				$("#display_order").val(tableField.DISPLAY_ORDER);
				$("#field_code").val(tableField.FIELD_CODE);
				$("#field_name").val(tableField.FIELD_NAME);
				$("#field_type").val(tableField.FIELD_TYPE);
				$("#field_length").val(tableField.FIELD_LENGTH);
				$("input[type='radio'][name='is_dim'][value='"+tableField.IS_DIM+"']").prop("checked", true);
				$("#group_value").val(tableField.GROUP_VALUE);
				$("#fieldId").val(tableField.FIELD_ID);
			}
		},
		error:function(e){}
	})
}
//保存元数据字段信息
function saveTableField(){
	var params = {};
	params = setParams();

	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!saveTableField.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var warnMsg = data.result.warnMsg;
			var status = data.result.status;
			art.dialog.tips(warnMsg);
			//是否操作成功
			if(status != -1){
				//刷新数据
				init();
				//重置新增窗口
				resetTableField();
			}
		},
		error:function(e){}
	})
}
//重置新增窗口
function resetTableField(){
	//把按钮改成修改
	$("#save_btn").text("新增");
	$("#addOrModify").val(1);
	var _blank = "";
	$("#display_order").val(_blank);
	$("#field_code").val(_blank);
	$("#field_name").val(_blank);
	$("#field_type").val(_blank);
	$("#field_length").val(_blank);
	$("input[type='radio'][name='is_dim'][value='1']").prop("checked", true);
	$("#group_value").val(_blank);
	$("#fieldId").val(_blank);
}
//返回元数据管理页面
function backToPage(){
	var url = ctx+"/report/reportConfigAction!reportConfig2.do";
	window.location.href = url;
}