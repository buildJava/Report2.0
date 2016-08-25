/* *
 * 变量定义区域
 * */

/* *
 * 页面jquery事件响应区域
 * */
$(document).ready(function(){
	
	//响应数据表名称的输入动态搜索
	$("#db_table_code").on("input propertychange", function(){
		var divBox = $(this).siblings(".db_table_list_box");
		divBox.hide();
		var owner = $("#db_user").val();
		var tableName = $("#db_table_code").val();
		if(!isNull(tableName)){
			qryDbTableName(divBox, owner, tableName);
		}
	})
	//输入框失去焦点时下拉框消息
	$(document).click(function(e){
		if(e.target.id != "db_table_code"){
			var divBox = $("#db_table_list_box");
			divBox.hide();
		}
	})
	//点击弹出框下拉菜单中的选项，直接把数据表名input的值改变成那个
	$("#db_table_list_ul").on("click", "li", function(){
		var tableName = $(this).text();
		$("#db_table_code").val(tableName);
		$("#db_table_list_box").hide();
	}).on("mouseover", "li", function(){
		$(".li-active").removeClass("li-active");
		$(this).addClass("li-active");
	})
	//填加对于按键的支持
	$("#db_table_code").on("keydown", function(event){
		keyBoardDown($(this), event);
	})
	//是否分表选择为否，则分表变量置为请选择，且disable
	$("input[name='split_flag']").change(function(){
		var splitFlag = $("input[name='split_flag']:checked").val();
		if(splitFlag == 0){
			$("#split_code").val(0);
			$("#split_code").attr("disabled", true);
		}else{
			$("#split_code").attr("disabled", false);
		}
	})
})

/* *
 * 页面方法区域
 * */
//设置参数
function setParams(){
	var tbOwner = $("#db_user").val();
	var tbCode = $("#db_table_code").val();
	var tbName = $("#db_table_desc").val();
	var splitFlag = $("input[name='split_flag']:checked").val();
	var splitCode = $("#split_code").val()=="0"?"":$("#split_code").val();
	var tbDesc = $("#table_desc").val();
	//组合参数
	var params = {};
	params.tbOwner = tbOwner;
	params.tbName = tbName;
	params.tbCode = tbCode;
	params.splitFlag = splitFlag;
	params.splitCode = splitCode;
	params.tbDesc = tbDesc;
	//校验参数
	if(validateParams(params)){
		return params;
	}
	
}

//校验输入项
function validateParams(params){
	//校验非空
	if(isNull(params.tbCode)){
		art.dialog.tips("数据表名称必填！");
		return false;
	}else if(isNull(params.tbName)){
		art.dialog.tips("数据表描述必填！");
		return false;
	}else if(isNull(params.tbDesc)){
		art.dialog.tips("数据表描述必填！");
		return false;
	}else if(params.splitFlag == 1 && params.splitCode == 0){
		art.dialog.tips("分表变量必选！");
		return false;
	}else{
		//循环检查数据表名称是否为下拉列表中的一项，如果是则合法否则提示不合法
		var ulList = $("#db_table_list_ul li");
		var flag = false;
		for(i=0; i<ulList.length; i++){
			if(ulList.eq(i).text() == params.tbCode){
				flag = true;
				break;
			}else{
				flag = false;
			}
		}
		if(!flag){
			art.dialog.tips("数据表名称无效，非数据库数据表！");
			return false;
		}else{
			return true;
		}
	}
}

//响应数据表名称的输入动态搜索
function qryDbTableName(divBox, owner, tableName){
	
	var params = {};
	params.owner = owner;
	params.tableName = tableName;
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryDbTableName.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var dbTableList = data.result.dbTableList;
			var _html = "";
			var tableUl = divBox.children(".db_table_list_ul");
			if(isEmptyObj(dbTableList)){
				_html += "<li class='li-active'>查无此表</li>";
			}else{
				$.each(dbTableList, function(i, item){
					if(i==0){
						_html += "<li class='li-active'>"+item.TABLE_NAME+"</li>";
					}else{
						_html += "<li>"+item.TABLE_NAME+"</li>";
					}
				})
			}
			tableUl.empty();
			tableUl.html(_html);
			divBox.show();
		},
		error:function(e){}
	})
}

//保存报表元数据
function saveTableInfo(){
	
	var params = {};
	params = setParams();
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!saveTableInfo.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			art.dialog.tips("报表元数据保存成功！");
			var url = ctx+"/report/reportConfigAction!reportConfig2.do";
			window.location.href = url;
		},
		error:function(e){}
	})
}

//返回元数据管理页面
function backToPage(){
	var url = ctx+"/report/reportConfigAction!reportConfig2.do";
	window.location.href = url;
}