/* *
 * 变量定义区域
 * */
var rptId = "";	//当前页面的报表ID
var rptName = "";	//当前页面的报表名称
var reportCdtList = null; //保存当前报表的查询条件列表
var reportFieldList = null; //保存当前报表的字段列表
var rptFieldIdList = []; //保存当前报表选择的字段列表
var rptFieldCodeList = []; //保存当前报表展示的字段的编码列表，用于输入数据

/* *
 * 页面jquery事件响应区域
 * */
$(document).ready(function(){
	//初始化数据
	init();
	
	//监听在所有的rpt_condition下面的input select上的change时去触发
	$(".rpt_condition").on("change", "input,select", function(){
		var $rptCondition = $(this).parents(".rpt_condition");
		//找到当前控件对应的隐藏信息对象
		var $cdtId = $rptCondition.children(".cdt_id");
		var cdtId = $cdtId.val();//当前控件id
		var showtype = $cdtId.attr("showtype");
		var cdtCode = $cdtId.attr("cdtCode"); //当前控件的cdtCode
		//判断当前更改的这个控件是否为多选下拉框，并且下拉框还显示时，直接返回，不做查询，只有当其完全选择完成后才进行查询
//		if(showtype==5&&$rptCondition.find(".multiactive").is(":visible")){
//			return;
//		}
		var patValue;
		if(showtype==5){
			patValue = $.trim($("#"+cdtCode).attr("code"));
		}else{
			patValue = $.trim($("#"+cdtCode).val());
		}
		var patValueDesc = "";
		if(showtype==5){
			patValueDesc = $.trim($("#"+cdtCode).val());
			$cdtId.attr("cdtvaluedesc", patValueDesc);
		}else if(showtype==6){
			patValueDesc = $.trim($("#"+cdtCode).children("option:selected").text());
			$cdtId.attr("cdtvaluedesc", patValueDesc);
		}
		
		//当前层级操作完成后，如果其值发生变化，则将其值赋给他们各自对应的隐藏对象cdt_id中，用于拼接查询条件，日期控件在控件的回调函数中进行处理
		if(showtype!=1&&showtype!=2&&showtype!=3&&showtype!=4){
			$cdtId.attr("cdtvalue", patValue);
		}
		
		//判断其值是否为空
		if(isNull(patValue)){
			return;
		}
		
		var subCondition = getObjFromArray(reportCdtList, "PAT_CDT_ID", cdtId); //当前控件的子控件
		//如果没有子控件，则直接返回
		if(isEmptyObj(subCondition)){
			return;
		}
		var subShowType = parseInt(subCondition["CDT_SHOW_TYPE"]);
		var subCdtId = subCondition["CDT_ID"];
		var subCdtShowBox = $("#"+subCdtId);
		var changeFlush = true;
		subCondition.patValue = patValue;
		subCondition.flushData = true;
		buildCdtShow(subShowType, subCondition, subCdtShowBox);
		//重建完子级之后去触发子级的子级，对于多级的数据一致性
		$("#"+subCdtId).children("input, select").trigger("change");
		$("#"+subCdtId).siblings(".cdt_id").attr("cdtvalue", "-1");
		
	})
	//字段选择全选与全不选
	$(document).on("click", "#field_all_btn", function(){
		var checked = $(this).prop("checked");
		$(".fieldOption").prop("checked", checked);
	})
})

/* *
 * 页面方法区域
 * */
//初始化数据
function init(){
	//查询并创建报表查询控件
	qryReportCdtList();
	//查询报表字段列表并用于展示及操作
	reportFieldList = qryReportFieldList();
	//字段查询完成后才可以进行下面的操作
	//创建表头,如果表头刷新成功，则刷新表数据，刷新字段选择列表，否则不进行表数据查询
	var rptHeadFlag = buildReportHead(reportFieldList);
	//如果表头刷新成功，则刷新表数据，刷新字段选择列表，否则不进行表数据查询
	if(rptHeadFlag){
		buildReportFieldSelect(reportFieldList);
		//刷新表数据
		qryReportData();
	}
}
//设置参数
function setParams(){
	rptId = $("#rptId").val();
	rptName = $("#rptName").val();
	var rptType = $("#rptType").val();
	//组合参数
	var params = {};
	params.rptId = rptId;
	params.rptName = rptName;
	params.rptType = rptType;
	//当前选中的字段列表
	params.rptFieldIdList = rptFieldIdList.join(",");
	//当前的选择条件
	var $cdt = $(".cdt_id");
	var cdtValList = [];
	for(var i=0; i<$cdt.length; i++){
		var cdtId = $cdt.eq(i).val();
		var cdtCode = $cdt.eq(i).attr("cdtcode");
		var cdtName = $cdt.eq(i).attr("cdtname");
		var showType = $cdt.eq(i).attr("showtype");
		var calType = $cdt.eq(i).attr("caltype");
		var calDesc = $cdt.eq(i).attr("caldesc");
		var cdtValue = $cdt.eq(i).attr("cdtvalue")=="-1"?"":$cdt.eq(i).attr("cdtvalue");
		var cdtValueDesc = $cdt.eq(i).attr("cdtvaluedesc");
		
		cdtValList.push({
			"cdtId":cdtId,
			"cdtCode":cdtCode,
			"cdtName":cdtName,
			"showType":showType,
			"calType":calType,
			"calDesc":calDesc,
			"cdtValue":cdtValue,
			"cdtValueDesc":cdtValueDesc,
		});
	}
	params.cdtValList = cdtValList;
	//校验参数
	if(validateParams(params)){
		return params;
	}
}
//校验输入项
function validateParams(params){
	
	return true;
}
//加载查询条件区域
function qryReportCdtList(){
	var params = {};
	params = setParams();
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryReportCdtList.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			reportCdtList = data.result.reportCdtList;
			var reportCdtBox = $("#report_condition_box");
			var _html = "<div class='fn-clear'>";
			if(isEmptyObj(reportCdtList)){
				return;
			}else{
				$.each(reportCdtList, function(i, item){
					//如果控件类型为2，或者4即开始到结束的这种类型，则长度占一行
					var widthClass = "form-item-width200";
					if(item.CDT_SHOW_TYPE == 2 || item.CDT_SHOW_TYPE == 4){
						widthClass = "";
					}
					var defaultVal = "";
					var dateFormat = $("#dateFormat").val(); //根据报表的周期传递的数据日期
					if(item.CDT_SHOW_TYPE == 1 || item.CDT_SHOW_TYPE == 3){
						defaultVal = dateFormat.replace(/-/g, "");
					}else if(item.CDT_SHOW_TYPE == 2 || item.CDT_SHOW_TYPE == 4){
						defaultVal = dateFormat.replace(/-/g, "")+","+dateFormat.replace(/-/g, "");
					}
					if(!isNull(item.DEFAULT_VAL)){
						defaultVal = item.DEFAULT_VAL;
					}
					_html += "<div class='form-item fn-left rpt_condition'>"
						   + 	"<label class='form-label' for='"+item.CDT_CODE+"-"+item.CDT_ID+"'>"+item.CDT_NAME+"：</label>"
						   +	"<input type='hidden' class='cdt_id' value='"+item.CDT_ID+"' ifPat='"+item.IF_PAT+"' cdtcode='"+item.CDT_CODE+"' cdtname='"+item.CDT_NAME+"' showtype='"+item.CDT_SHOW_TYPE+"' caltype='"+item.CDT_CAL_TYPE+"' caldesc='"+item.CDT_CAL_DESC+"' cdtvalue='"+defaultVal+"'/>"
						   +    "<div class='form-item-content "+widthClass+"' id='"+item.CDT_ID+"'>"
						   +		"<input type='text' id='"+item.CDT_CODE+"' class='form-input form-input-width160'/>"
						   +	"</div>"
						   + "</div>";
					
					if((i+1)==reportCdtList.length){
						_html += "</div>";
					}else if(item.CDT_SHOW_TYPE == 2 || item.CDT_SHOW_TYPE == 4){
						_html += "</div>"
							   + "<div class='fn-clear'>";
					}
				})
			}
			reportCdtBox.empty();
			reportCdtBox.html(_html);
			drowReportCdtShow(reportCdtList, reportCdtBox)
		},
		error:function(e){}
	})
}
//渲染各查询条件样式
function drowReportCdtShow(reportCdtList, reportCdtBox){
	var $rptCdtList = reportCdtBox.find(".rpt_condition");
	for(var i = 0; i < $rptCdtList.length; i++){
		var cdtId = $rptCdtList.eq(i).find(".cdt_id").val();
		var cdtShowType = parseInt($rptCdtList.eq(i).find(".cdt_id").attr("showtype"));
		var cdtShowBox = $("#"+cdtId);
		var condition = getObjFromArray(reportCdtList, "CDT_ID", cdtId);
		var dataList = [{"KEY_":"-1","VALUE_":"请先选择父级"}];
		var parCdtId = condition["PAT_CDT_ID"]; //取当前控件的父级，如果父级是0则代表其为最高级，则直接刷新其数据，或者是父级触发的子级需要刷新数据
		var flushData = parCdtId=="0"?true:false;
		condition.flushData = flushData;
		buildCdtShow(cdtShowType, condition, cdtShowBox);
	}
	
}
//按照类型创建控件
function buildCdtShow(cdtShowType, condition, cdtShowBox){
	var flushData = condition.flushData;
	var dataList = [{"KEY_":"","VALUE_":""}];
	var dateFormat = $("#dateFormat").val(); //根据报表的周期传递的数据日期
	//showType是控件的展现形式1	日期，2 日期(开始-结束)，3 月份，4 月份(开始-结束)，5 多选框，6 单选框，7 文本框，8 固定值列表
	switch(cdtShowType){
		case 1:
			buildDatePicker("YYYYMMDD", cdtShowBox, dateFormat);
			break;
		case 2:
			buildDateBwnPicker("YYYYMMDD", cdtShowBox, dateFormat);
			break;
		case 3:
			buildDatePicker("YYYYMM", cdtShowBox, dateFormat);;
			break;
		case 4:
			buildDateBwnPicker("YYYYMM", cdtShowBox, dateFormat);;
			break;
		case 5:
			if(flushData){
				dataList = qryDataList(condition);
				dataList = dataList[0].KEY_ != "-1" ? dataList : [{"KEY_":"-1","VALUE_":"请选择父级"}];
			}else{
				dataList = [{"KEY_":"-1","VALUE_":"请选择父级"}];
			}
			buildCheckPicker(condition, dataList, cdtShowBox);
			break;
		case 6:
			if(flushData){
				dataList = qryDataList(condition);
				dataList = dataList[0].KEY_ != "-1" ? dataList : [{"KEY_":"-1","VALUE_":"请选择父级"}];
			}else{
				dataList = [{"KEY_":"-1","VALUE_":"请选择父级"}];
			}
			buildRadioPicker(condition, dataList, cdtShowBox);
			break;
		case 7:
			buildTextPicker(condition, cdtShowBox);
			break;
		case 8:
			buildSelectPicker(condition, cdtShowBox);
			break;
	}
}
//查询报表字段列表
function qryReportFieldList(){
	var params = {};
	params = setParams();
	var _parStr = JSON.stringify(params);
	var reportFieldList; //保存报表字段列表
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryReportFieldList.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			reportFieldList = data.result.reportFieldList;
		},
		error:function(e){}
	})
	return reportFieldList;
}
//加载报表表头部分
function buildReportHead(reportFieldList){
	var reportHead = $("#reportHead");
	var _html = "";
	var rptHeadFlag = true; //返回表头加载的状态，如果返回false则后续的表数据就无需加载，直接前台提示错误
	var fieldLength = 0;
	if(isEmptyObj(reportFieldList)){
		_html += "<tr><th>报表配置异常，未查询到字段信息！<th></tr>";
		rptHeadFlag = false;
	}else{
		_html = "<tr>";
		rptFieldIdList = [];
		rptFieldCodeList = [];
		$.each(reportFieldList, function(i, item){
			if(item.IS_SHOW == "1"){
				rptFieldIdList.push(item.FIELD_ID);
				rptFieldCodeList.push(item.FIELD_CODE);
				var isDim = item.IS_DIM;
				var textAlign = "text-alignc";
				if(isDim == "1"){
					textAlign = "text-alignc";
				}else{
					textAlign = "text-alignr";
				}
				_html += "<th class='"+textAlign+"'><a title='"+item.FIELD_NAME+"'>"+item.FIELD_NAME+"</a></th>";
				fieldLength += item.FIELD_NAME.length+2;//两边各增加两个空格
			}
		})
		_html += "</tr>";
	}
	var tabWidth = fieldLength*15+"px";//最终table的宽度,由报表字段的单个comment字长再各加上两个空格*每个字长13px计算来确定最终的报表宽度，防止出现换行问题
	$(".ui-table").css("width", tabWidth);
	reportHead.empty();
	reportHead.html(_html);
	return rptHeadFlag;
}
//生成字段选择页面html
function buildReportFieldSelect(reportFieldList){
	var $fieldListBox = $(".dialog_field_box");
	var _html = "<div class='fn-clear'>";
	var maxi = reportFieldList.length-1; //字段列表的长度
	$.each(reportFieldList, function(i, item){
		//如果是当前行的最后一个或者是为所有字段的最后一个
		//判断当前字段是否选中
		var checkFlag = item.IS_SHOW=="1"?"checked":"";
		if((i+1)%3 == 0 || i == maxi){
			if(i == maxi){
				_html += "<div class='form-item fn-left'>"
					   +  	"<div class='form-item-content form-item-width220 overflow-ellipsis' title='"+item.FIELD_NAME+"'>"
					   +		"<input type='checkbox' class='fieldOption' fname='"+item.FIELD_NAME+"' code='"+item.FIELD_CODE+"' dim='"+item.IS_DIM+"' value='"+item.FIELD_ID+"' "+checkFlag+"/>"+item.FIELD_NAME
					   +	"</div>"
					   + "</div>"
				  + "</div>" ;
			}else{
				_html += "<div class='form-item fn-left'>"
					   +  	"<div class='form-item-content form-item-width220 overflow-ellipsis' title='"+item.FIELD_NAME+"'>"
					   +		"<input type='checkbox' class='fieldOption' fname='"+item.FIELD_NAME+"' code='"+item.FIELD_CODE+"' dim='"+item.IS_DIM+"' value='"+item.FIELD_ID+"' "+checkFlag+" />"+item.FIELD_NAME
					   +	"</div>"
					   + "</div>"
				  + "</div>"
				  + "<div class='fn-clear'>";
			}
			
		}else{
			_html += "<div class='form-item fn-left'>"
				   +  	"<div class='form-item-content form-item-width220 overflow-ellipsis' title='"+item.FIELD_NAME+"'>"
				   +		"<input type='checkbox' class='fieldOption' fname='"+item.FIELD_NAME+"' code='"+item.FIELD_CODE+"' dim='"+item.IS_DIM+"' value='"+item.FIELD_ID+"' "+checkFlag+" />"+item.FIELD_NAME
				   +	"</div>"
				   + "</div>";
		}
	})
	_html += "<div class='fn-clear'>"
		   + 	"<div class='form-btn-group'>"
		   +		"<a id='saveBtn' class='form-btn' onclick='saveReportSField()'>保存</a>"
		   + 	"</div>"
		   + "</div>";
	$fieldListBox.empty();
	$fieldListBox.html(_html);
}
//字段选择窗口
function openFieldSelect(){
	var dialog_win_html = $("#dialog_win").html();
	var allHtml = "<input type='checkbox' class='fieldOption' id='field_all_btn' style='margin-left:15px;' checked />全选/反选";
	var fieldListBox = art.dialog({
		title:"字段选择"+allHtml,
	    fixed:true,
	    id:'fieldListBox',
		lock:true,
	    content:dialog_win_html
	});
	
	$(".aui_content").find(".dialog_field_box").attr("id", "fieldListBox");
}
//保存字段选择列表
function saveReportSField(){
	var $fieldListBox = $("#fieldListBox");
	//将已经选择的字段列表放入数组
	var selectFieldIdList = setSelectFieldIdList($fieldListBox);
	if(selectFieldIdList.length == 0){
		art.dialog.tips("字段选择中请至少选中一个要展示的字段！");
		return;
	}
	//判断选择的字段列表与保存的字段列表两个数组是否一致，如果一致，则不需要查询，否则需要重新查询生成报表
	if(selectFieldIdList.sort().toString() != rptFieldIdList.sort().toString()){
		//重新生成表头
		buildReportHead(reportFieldList);
		//重新刷新字段选择列表
		buildReportFieldSelect(reportFieldList);
		//刷新表数据
		qryReportData();
	}
	//关闭字段选择窗口
	art.dialog.list['fieldListBox'].close();
}
//将已经选择的字段列表放入数组
function setSelectFieldIdList($fieldListBox){
	var selectFieldIdList = [];
	var fieldInput = $fieldListBox.find("input[type='checkbox']");
	reportFieldList = [];
	for(var i=0; i<fieldInput.length; i++){
		var fieldId = fieldInput.eq(i).val();
		var fieldCode = fieldInput.eq(i).attr("code");
		var fieldName = fieldInput.eq(i).attr("fname");
		var isDim = fieldInput.eq(i).attr("dim");
		var checkFlag = "0";
		if(fieldInput.eq(i).prop("checked")){
			selectFieldIdList.push(fieldInput.eq(i).val());
			checkFlag = "1";
		}
		//将值保存在页面中用来控件表头及字段选择
		reportFieldList.push({
			"FIELD_ID":fieldId,
			"FIELD_CODE":fieldCode,
			"FIELD_NAME":fieldName,
			"IS_DIM":isDim,
			"IS_SHOW":checkFlag
		});
	}
	return selectFieldIdList;
}
//刷新报表数据
function qryReportData(){
	//展示正在查询并且清查现有查询
	$(".no-data").hide();
	$("#reportBody").empty();
	$("#loading-box").show();
	setTimeout("qryReportAction()", 300);
}
//查询报表动作
function qryReportAction(){
	//查询报表数据
	qryReportDataList(0);
	//查询报表数据量
	qryReportDataCount();
}
//查询报表数据
function qryReportDataList(curPage){
	var reportBody = $("#reportBody");
	var params = {};
	params = setParams();
	//查询页码设置
	params.pageSize = pageSize;
	params.startIndex = curPage*pageSize+1;
	params.endIndex = (curPage+1)*pageSize;
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryReportDataList.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var reportDataList = data.result.reportDataList;
			var _html = "";
			document.getElementById("tablediv").scrollLeft = 0;
			if(isEmptyObj(reportDataList)){
				reportBody.empty();
				$("#loading-box").fadeOut();
				$(".no-data").show();
				return;
			}else{
				$(".no-data").hide();
				$.each(reportDataList, function(i, item){
					//当前页面的展现字段顺序rptFieldCodeList
					if((i+1)%2){
						_html += "<tr>";
					}else{
						_html += "<tr class='ui-table-split'>";
					}
					//拼接表格信息
					for(var n=0; n<rptFieldCodeList.length; n++){
						var key = rptFieldCodeList[n];
						var itemVal = item[key];
						//取这个字段对应的字段对象
						var field = getObjFromArray(reportFieldList, "FIELD_CODE", key);
						var isDim = field["IS_DIM"];
						if(itemVal==undefined||itemVal==null){
							itemVal = "-";
						}
						var textAlign = "text-alignl";
						//判断值是否为数字，如查是数值则右对齐
						var regexStr = /\d+(\%)?/;
						if(isDim == "0" || regexStr.test(itemVal)){
							textAlign = "text-alignr";
						}else{
							textAlign = "text-alignc";
						}
						_html += "<td class='text-overflow "+textAlign+"' title='"+itemVal+"'>"+itemVal+"</td>";
					}
					_html += "</tr>";
				})
			}
			//隐藏正要查询显示查询数据
			reportBody.empty();
			$("#loading-box").fadeOut();
			reportBody.html(_html);
		},
		error:function(e){}
	})
}
//查询报表数据量
function qryReportDataCount(){
	var params = {};
	params = setParams();
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryReportDataCount.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var reportDataCount = data.result.reportDataCount;
			//是否有数据可以下载
			var $exportFlag = $("#exportFlag");
			if(reportDataCount == 0||reportDataCount == undefined){
				$exportFlag.val(0);
			}else{
				$exportFlag.val(1);
			}
			$("#dataCount").val(reportDataCount);
			//分页
			$("#pagination").pagination(reportDataCount, {
			    num_edge_entries: 2,
			    num_display_entries: 4,
			    callback: qryReportDataList,
				items_per_page:pageSize,
				prev_text:" ",
				next_text:" "
			});
		},
		error:function(e){}
	})
}
//下载报表
function exportData(ifDownload){
	//判断报表是否可以下载
	if(ifDownload == 0 || ifDownload == undefined){
		art.dialog.tips("报表无下载权限！");
		return;
	}
	//判断是否有可下载的数据
	var exportFlag = $("#exportFlag").val();
	if(exportFlag == 0){
		art.dialog.tips("暂无可下载的数据！");
		return;
	}
	var $download_percent = $("#download_percent");
	$download_percent.show();
	$download_percent.find(".pro-bar-candy").addClass("candy-ltr");
	//开始异步下载
	var params = {};
	params = setParams();
	//当前需要下载的记录数量
	var dataCount = $("#dataCount").val();
	params.dataCount = dataCount;
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!exportData.action",
		data:{_params:_parStr},
		dataType:"json",
		type:"post",
		success:function(data){
			$download_percent.hide();
			$(".go-download").show();
		},
		error:function(e){}
	});
}
