/* *
 * 变量定义区域
 * */
var rptId = "";	//当前页面的报表ID
var rptName = "";	//当前页面的报表名称
var reportCdtList = null; //保存当前报表的查询条件列表
var _tableHtml = "";
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
		if(showtype==5&&$rptCondition.find(".multiactive").is(":visible")){
			return;
		}
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
})

/* *
 * 页面方法区域
 * */
//初始化数据
function init(){
	//保存原始的模板代码
	_tableHtml = $("#tablediv").html();
	//查询并创建报表查询控件
	qryReportCdtList();
	//刷新表数据
	qryReportData();
}
//设置参数
function setParams(){
	rptId = $("#rptId").val();
	rptName = $("#rptName").val();
	var rptCycle = $("#rptCycle").val();
	var ifPage = $("#ifPage").val();
	var rptType = $("#rptType").val();
	//组合参数
	var params = {};
	params.rptId = rptId;
	params.rptName = rptName;
	params.rptCycle = rptCycle;
	params.ifPage = ifPage;
	params.rptType = rptType;
	
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
	rptId = $("#rptId").val();
	params.rptId = rptId;
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
						   +	"<input type='hidden' class='cdt_id' value='"+item.CDT_ID+"' ifPat='"+item.IF_PAT+"' cdtCode='"+item.CDT_CODE+"' cdtname='"+item.CDT_NAME+"' showtype='"+item.CDT_SHOW_TYPE+"' caltype='"+item.CDT_CAL_TYPE+"' caldesc='"+item.CDT_CAL_DESC+"' cdtvalue='"+defaultVal+"'/>"
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
			buildDatePicker("YYYYMM", cdtShowBox, dateFormat);
			break;
		case 4:
			buildDateBwnPicker("YYYYMM", cdtShowBox, dateFormat);
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
//刷新表数据
function qryReportData(){
	//显示正在查询
	$("#loading-box").show();
	setTimeout("qryReportAction()", 300);
}
//查询数据的动作
function qryReportAction(){
	//注入表数据
	qryReportDataList(0);
	//仅在支持翻页时才显示
	var ifPage = $("#ifPage").val();
	if(ifPage == 1){
		qryReportDataCount();
	}
}
//刷新表数据
function qryReportDataList(curPage){
	
	var params = {};
	params = setParams();
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
			var varSqlList = data.result.varSqlList;
			//清空原来数据
			$("#tablediv").html(_tableHtml);
			var $trGroup = $("#reportBody tr");
			var tableSpan = tableSpanFun($trGroup);
			$("#loading-box").fadeOut();

			//根据是否需要翻页选择不同的数据生成方法
			if(params.ifPage == 1){
				//需要翻页的，不固定表格

				//用于无数据时的遮罩
				var dataFlag = 1;
				var startRow = -1;
				var startCol = -1;
				//循环出每个SQL对象
				$.each(varSqlList, function(i, item){
					var varId = item.varId;
					var varCode = item.varCode;
					var rowIndex = item.rowIndex;
					var colIndex = item.colIndex;
					var orderId = item.orderId;
					var varData = item.varData;
					var varKey = item.varKey;
					
					if(isEmptyObj(varData)||isEmptyObj(varKey)||dataFlag==0){
						dataFlag = 0;
						if(startRow == -1 || startCol == -1){
							startRow = rowIndex;
							startCol = colIndex;
						}else{
							startRow = startRow < rowIndex ? startRow : rowIndex;
							startCol = startCol < colIndex ? startCol : colIndex;
						}
					}else{
						$(".no-data").hide();
						var $lastTr = $trGroup.eq(rowIndex);
						//从开始行开始写入数据，如果当前行存在，则直接写入，如果不存在，则创建当前行
						for(row=rowIndex; row<rowIndex+varData.length; row++){
							var $tr = $trGroup.eq(row);
							if($tr.length == 0){
								$tr = $("<tr></tr>");
								$lastTr.after($tr);
							}
							var $tdGroup = $tr.children("td");
							for(k=0; k<varKey.length; k++){
								var $td = $tdGroup.eq(k+colIndex);
								if($td.length == 0){
									$td = $("<td></td>");
									$tr.append($td);
								}
								var key = varKey[k];
								var val = varData[row-rowIndex][key];
								if(isNull(val)||val==" "){
									val = "-";
								}
								$td.text(val);
								//判断值是否为数字，如查是数值则右对齐
								var regexStr = /\d+(\%)?/;
								if(regexStr.test(val)){
									$td.css("text-align", "right");
								}
								if(val == "-"){
									$td.css("text-align", "center");
								}
							}
							//保存上一行用于在下一行增加对象
							$lastTr = $tr;
						}
					
					}
					
				})
				//是否有数据可以下载
				var $exportFlag = $("#exportFlag");
				if(dataFlag == 0){
					$exportFlag.val(0);
					$("#reportBody tr:eq("+(startRow)+")").remove();
					$(".no-data").show();
					return;
				}else{
					$exportFlag.val(1);
				}
			}else{
				//用于无数据时的遮罩
				var dataFlag = 1;
				var startRow = -1;
				var startCol = -1;
				var dataCount = 0;

				//循环出每个SQL对象
				$.each(varSqlList, function(i, item){
					var varId = item.varId;
					var varCode = item.varCode;
					var rowIndex = item.rowIndex;
					var colIndex = item.colIndex;
					var orderId = item.orderId;
					var varData = item.varData;
					var varKey = item.varKey;
					
					dataCount += varData.length;
					//固定列的表格
					if(isEmptyObj(varData)||isEmptyObj(varKey)){
						dataFlag = 0;
						if(startRow == -1 || startCol == -1){
							startRow = rowIndex;
							startCol = colIndex;
						}else{
							startRow = startRow < rowIndex ? startRow : rowIndex;
							startCol = startCol < colIndex ? startCol : colIndex;
						}
					}else{
						flushDataToTable($trGroup, rowIndex, colIndex, varData, varKey, tableSpan);
					}
				})
				
				//如果没有数据
				//是否有数据可以下载
				var $exportFlag = $("#exportFlag");
				if(dataFlag == 0){
					$exportFlag.val(0);
					var $endTd = $trGroup.last().children("td").last();
					noDataWarn($trGroup, startRow, startCol, $endTd, tableSpan);
				}else{
					$exportFlag.val(1);
				}
				//页面总数据量
				$("#dataCount").val(dataCount);
			}
		},
		error:function(e){}
	})
}
//将数据刷新到表格中
function flushDataToTable($trGroup, rowIndex, colIndex, varData, varKey, tableSpan){
	var dataRow = varData.length;
	var dataCol = varKey.length; //根据key值的长度来确定列数
	//循环行
	//读取的数据行
	var curRow = -1;
	for(row=0; row<$trGroup.length; row++){
		//得到当前循环的行
		var $tr = $trGroup.eq(row);
		//如果行小于当前行或者当前行大于等于开始行加上数据总行数，则退出当前循环
//		if(row<rowIndex || row>=rowIndex+dataRow){
		if(row<rowIndex){
			continue;
		}else{
			//是否换行
			var nextRowFlag = 1;
			$tdGroup = $tr.children("td");
			//循环列
			for(col=0; col<$tdGroup.length; col++){
				//得到当前列
				var $td = $tdGroup.eq(col);
				//获取当前单元格的前面是否有合并
				var nextColCnt = 0;
				nextColCnt = tdMoveNext(tableSpan, row, col);
				if(col+nextColCnt<colIndex || col+nextColCnt>=colIndex+dataCol){
					continue;
				}else{
					//如果当前外层循环换行且能往里面写数据时，内层数据行数加1
					if(nextRowFlag == 1){
						nextRowFlag = 0;
						curRow++;
					}
					//读取的记录列
					var curCol = col+nextColCnt-colIndex;
					var cellKey = varKey[curCol];
					var rowData = varData[curRow];
					var cellData = "-";
					if(!isEmptyObj(rowData)){
						cellData = varData[curRow][cellKey];
					}
					if(isNull(cellData)||cellData==" "){
						cellData = "-";
					}
					$td.text(cellData);
					//判断值是否为数字，如查是数值则右对齐
					var regexStr = /\d+(\%)?/;
					if(regexStr.test(cellData)){
						$td.css("text-align", "right");
					}
					if(cellData == "-"){
						$td.css("text-align", "center");
					}
				}
			}
		}
	}
}
//存储行合并情况和列合并情况
function tableSpanFun($trGroup){
	//行合并情况
	var rowspanCnt = 1;
	//被合并的首行
	var spanRow = []; //第几列，合并了几行
	//列合并情况
	var colspanCnt = 1;
	//被合并的首列
	var spanCol = [];
	var tableSpan = {};
	for(row=0; row<$trGroup.length; row++){
		//得到当前循环的行
		var $tr = $trGroup.eq(row);
		$tdGroup = $tr.children("td");
		for(col=0; col<$tdGroup.length; col++){
			//得到当前列
			var $td = $tdGroup.eq(col);
			//行合并情况
			rowspanCnt = parseInt($td.attr("rowspan"));
			if(rowspanCnt > 1){
				spanRow.push({
					row:row,
					col:col,
					rowspanCnt:rowspanCnt
				});
			}
			//列合并情况
			colspanCnt = parseInt($td.attr("colspan"));
			if(colspanCnt > 1){
				spanCol.push({
					row:row,
					col:col,
					colspanCnt:colspanCnt
				});
			}
		}
	}
	tableSpan.spanRow = spanRow;
	tableSpan.spanCol = spanCol;
	return tableSpan;
}
//计算当前单元格需要往后移几个
function tdMoveNext(tableSpan, row, col){
	var nextColCnt = 0;
	//合并行移动
	$.each(tableSpan.spanRow, function(i, item){
		if(item.row < row && (item.row + item.rowspanCnt) > row && item.col < col){
			nextColCnt++; //前面有几个合并行他就往后跳几个
		}
	})
	//合并列移动
	$.each(tableSpan.spanCol, function(i, item){
		if(item.row == row && item.col < col){
			nextColCnt += item.colspanCnt-1; //前面有几个合并行他就往后跳几个
		}
	})
	
	return nextColCnt;
}
//无数据时展示无数据遮罩
function noDataWarn($trGroup, startRow, startCol, $endTd, tableSpan){
	//平移的单元格数
	var nextColCnt = tdMoveNext(tableSpan, startRow, startCol);
	//左上角起点
	var $startTd = $trGroup.eq(startRow).children("td").eq(startCol-nextColCnt);
	var startLeft = $startTd.position().left;
	var startTop = $startTd.position().top;
	var endLeft = $endTd.position().left;
	var endTop = $endTd.position().top;
	var endWidth = $endTd.outerWidth();
	var endHeight = $endTd.outerHeight();
	console.log("start:"+startLeft+","+startTop);
	console.log("end:"+endLeft+","+endTop);
	
	var $warnDiv = $("<div>暂无数据！</div>");
	$warnDiv.attr("class", "warnDiv");
	$warnDiv.css("position", "absolute");
	$warnDiv.css("left", startLeft+"px");
	$warnDiv.css("top", startTop+"px");
	$warnDiv.css("width", (endLeft+endWidth-startLeft)+"px");
	$warnDiv.css("height", (endTop+endHeight-startTop)+"px");
	$warnDiv.css("background", "#000");
	$warnDiv.css("opacity", "0.3");
	$warnDiv.css("text-align", "center");
	$warnDiv.css("color", "#fff");
	$warnDiv.css("font-size", "16px");
	$warnDiv.css("vertical-align", "middle");
	$warnDiv.css("line-height", (endTop+endHeight-startTop)+"px");
	$("#tablediv").append($warnDiv);
}
//刷新表数据
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
			var dataCount = data.result.dataCount;
			//数据量
			$("#dataCount").val(dataCount);
			//分页
			$("#pagination").pagination(dataCount, {
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
