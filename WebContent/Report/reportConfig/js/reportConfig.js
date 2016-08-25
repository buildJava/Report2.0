/**
 * 公用方法区
 */
/* *
 * 变量定义区域
 * */
var pageSize = 15;
/* *
 * 页面jquery事件响应区域
 * */
$(document).ready(function(){
	//表格的hover效果
	$("#reportBody").on("mouseover", "tr", function(){
		$(this).toggleClass("ui-table-hover");
	})
})

/* *
 * 页面方法区域
 * */
//根据锚点跳转到页面位置
function scrollToPos(pos){
	var scrollWin = $(pos).offset().top;
	$(window).scrollTop(scrollWin);
}
//根据url跳转页面
function redirectToPage(url){
	window.location.href=url;
}
//显示与收起
function panelSlideToggle($this){
	var index = $(".panel-body-title").index($this);
	var panelBodyContent = $(".panel-body-content").eq(index);
	panelBodyContent.slideToggle(100);
	var toggleBtn = $this.children(".toggle_btn");
	var showText = toggleBtn.text();
	if(showText == "隐藏"){
		toggleBtn.empty();
		toggleBtn.html("<i class='icon-double-angle-down'></i>显示");
	}else{
		toggleBtn.empty();
		toggleBtn.html("<i class='icon-double-angle-up'></i>隐藏");
	}
}
//查询列表
function qryDataList(condition){
	//拼接查询sql
	var patColCode = condition["PAT_COL_CODE"];
	var cdtSql = condition["CDT_SQL"];
	//父级控件ID,来获取父级的当前取值
	var patCdtCode = condition["PAT_CDT_CODE"];
	var patValue = condition["patValue"];
	
	var bodySql = cdtSql;
	var whereSql = "";
	//如果没有父级控件关联编码或者父级控件值为空，则sql保持不变
	if(!(patColCode == "—" || isNull(patValue))){
		whereSql = "WHERE T."+patColCode+" IN";
	}
	var dataList;
	var params = {};
	params.bodySql = bodySql;
	params.whereSql = whereSql;
	params.patValue = patValue;
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryDataList.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			dataList = data.result.dataList;
			if(isEmptyObj(dataList)){
				dataList = [{"KEY_":"-1","VALUE_":"无数据"}];
			}
		},
		error:function(e){}
	})
	return dataList;
}
//时间控件的onpicked触发方法 flag 标识是开始时间还是结束时间
function dateOnpicked($this, flag){
	var _val = $this.val();
	var $cdt = $this.parent("div").siblings(".cdt_id");
	var showType = $cdt.attr("showtype");
	var _date = $cdt.attr("cdtvalue");
	if(showType == "1" || showType == "3"){
		_val = _val.replace(/-/g, "");
		_date = _val;
	}else if(showType == "2" || showType == "4"){
		_val = _val.replace(/-/g, "");
		if(flag == 1){
			if((_val > _date.split(",")[1]) && !isNull(_date.split(",")[1]) && !isNull(_val)){
				art.dialog.tips("开始时间必须小于结束时间");
				_date = _val + "," + _date.split(",")[1];
			}else{
				_date = _val + "," + _date.split(",")[1];
			}
		}else if(flag == 0){
			if((_date.split(",")[0] > _val) && !isNull(_date.split(",")[0]) && !isNull(_val)){
				art.dialog.tips("开始时间必须小于结束时间");
				_date = _date.split(",")[0] + "," + _val;
			}else{
				_date = _date.split(",")[0] + "," + _val;
			}
		}
	}
	$cdt.attr("cdtvalue", _date);
}
//跳转到下载页面
function goToDownload(){
	var url = ctx+"/report/reportConfigAction!downloadShow.do";
	window.location.href = url;
}