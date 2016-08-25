/* *
 * 变量定义区域 $开头的变量为全局变量且在页面周期存储可变值
 * */
var selectFieldList = []; //保存当前页面选中的字段列表
var orderFieldList = []; //保存当前页面报表选中的排序字段列表
var pageCdtInfoList = null; //保存当前页面的控件列表
var rptId = "";	//当前页面的报表ID
var addOrModify = "0"; //新增或者修改标识
/* *
 * 页面jquery事件响应区域
 * */
$(document).ready(function(){
	//初始化数据
	init();
	
	//响应数据表名称的输入动态搜索
	$("#tb_name").on("input propertychange", function(){
		var divBox = $(this).siblings(".table_info_list_box");
		divBox.hide();
		var inputVal = $("#tb_name").val();
		if(!isNull(inputVal)){
			qryTableInfoByInput(divBox, inputVal);
		}
	})
	//输入框失去焦点时下拉框消息
	$(document).click(function(e){
		if(e.target.id != "tb_name"){
			var divBox = $("#table_info_list_box");
			divBox.hide();
		}
	})
	//点击弹出框下拉菜单中的选项，直接把数据表名input的值改变成那个
	$("#table_info_list").on("click", "li", function(){
		var tbId = $(this).attr("tbId");
		var tbName = $(this).text();
		$("#tb_id").val(tbId);
		$("#tb_name").val(tbName);
		$("#table_info_list_box").hide();
		//生成字段选择列表
		qryTableFieldByTbId(tbId, [], []);
	}).on("mouseover", "li", function(){
		$(".li-active").removeClass("li-active");
		$(this).addClass("li-active");
	})
	//后续可以填加对于按键的支持
	$("#tb_name").on("keydown", function(event){
		keyBoardDown($(this), event);
	})
	//对于控件选择的设置，如果控件被选中，并且控件包含父级控件，则父级控件也直接选中，如果父控件取消选中，则子控件也取消选中
	$(".cdt_select").on("click", function(event){
		var $this = $(this);
		var cdtId = $this.siblings(".cdt_id").val();
		var checked = $this.prop("checked");
		var cdtTr = $(".cdt_info_table tr");
		$(this).prop("checked", checked);
		//子控件对父控件操作
		ctlParCondition(cdtTr, cdtId, checked);
		//子控件对父控件操作
		ctlSubCondition(cdtTr, cdtId, checked);
	})
	//响应报表类型的选择
	$("input[name='rpt_type']").on("click", function(){
		//根据index获取不同位置上的类型
		var index = $(this).val()-1;
		$(".detail_panel").hide();
		$(".detail_panel").eq(index).show();
		
	})
	//多表头sql输入
	$("#var_sql_tab").on("click", "li", function(){
		var index = $("#var_sql_tab li").index($(this));
		$(".active").removeClass("active");
		$(this).addClass("active");
		$("#var_sql_txt li").hide();
		$("#var_sql_txt li").eq(index).addClass("active").show();
	})
})

/* *
 * 页面方法区域
 * */
//初始化数据
function init(){
	//保存当前页面的控件列表
	qryCondition();
	rptId = $("#rptId").val();
	addOrModify = $("#addOrModify").val();
	if(!isNull(rptId)&&addOrModify=="1"){
		setRptInfoBack(rptId);
	}
}
//子控件对父控件操作
function ctlParCondition(cdtTr, cdtId, checked){
	//如果子级是选中，则父级选中，如果子级取消选中，父级不变
	var flag = checked;
	while(flag){
		var cdtInfo = getObjFromArray(pageCdtInfoList, "CDT_ID", cdtId);
		var parCdtId = cdtInfo["PAT_CDT_ID"];
		if(!isNull(parCdtId)&&parCdtId!=0){
			for(var i = 0; i < cdtTr.length; i++){
				var cdtIdInput = cdtTr.eq(i).find(".cdt_id");
				if(cdtIdInput.val() == parCdtId){
					cdtTr.eq(i).find(".cdt_select").prop("checked", checked);
					cdtId = parCdtId;
					continue;
				}
			}
		}else{
			flag = false;
		}
	}
}
//父级控件对子控件操作
function ctlSubCondition(cdtTr, cdtId, checked){
	//如果父级取消选中，则子级也取消选中，如果是选中，则子级不做操作
	var flag = !checked;
	while(flag){
		//获取父级编码为当前控件的子控件的控件ID
		var subCdtId = getObjFromArray(pageCdtInfoList, "PAT_CDT_ID", cdtId)["CDT_ID"];
		if(!isNull(subCdtId)){
			for(var i = 0; i < cdtTr.length; i++){
				var cdtIdInput = cdtTr.eq(i).find(".cdt_id");
				if(cdtIdInput.val() == subCdtId){
					cdtTr.eq(i).find(".cdt_select").prop("checked", checked);
					cdtId = subCdtId;
					continue;
				}
			}
		}else{
			flag = false;
		}
	}
}
//查询控件列表信息
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
			pageCdtInfoList = data.result.cdtInfoList;
			var cdtShowTypeList = data.result.cdtShowTypeList;
			var cdtCalList = data.result.cdtCalList;
			var _html = "";
			var reportBody = $("#reportBody");
			if(isEmptyObj(pageCdtInfoList)){
				reportBody.empty();
				$(".no-data").show();
				return;
			}else{
				$.each(pageCdtInfoList, function(i, item){
					if((i+1)%2){
						_html += "<tr>"
							  +  	"<td>"
							  +			"<input type='checkbox' class='zoom-130 cdt_select' name='cdt_select'/>"
							  +			"<input type='hidden' class='cdt_id' value='"+item.CDT_ID+"'/>"
							  +	 	"</td>"
							  +  	"<td><input type='text' class='form-input width-40 cdt_order' value='"+item.RN+"' /></td>"
							  +  	"<td><input type='text' class='form-input width-160 cdt_code' value='"+item.CDT_CODE+"' /></td>"
							  +  	"<td><input type='text' class='form-input width-160 cdt_name' value='"+item.CDT_NAME+"' /></td>"
							  +  	"<td>"
							  +			"<select class='form-select width-120 cdt_show_type'>";
						
									$.each(cdtShowTypeList, function(j, show){
										var selected = "";
										if(show.CODE_ID == item.CDT_SHOW_TYPE){
											selected = "selected='selected'";
										}
										_html += "<option value='"+show.CODE_ID+"' "+selected+">"+show.CODE_NAME+"</option>";
									})
												
						_html += 		"</select>"
							  +		"</td>"
							  +  	"<td>"
							  +			"<select class='form-select width-120 cdt_cal_type'>";;
						
									$.each(cdtCalList, function(j, cal){
										var selected = "";
										if(cal.CODE_ID == item.CDT_CAL_TYPE){
											selected = "selected='selected'";
										}
										_html += "<option value='"+cal.CODE_ID+"' "+selected+">"+cal.CODE_NAME+"</option>";
									})
						_html += 		"</select>"
							  +		"</td>"
							  +  	"<td><input type='text' class='form-input width-100 default_val' /></td>"
							  +  "</tr>";
					}else{
						_html += "<tr class='ui-table-split'>"
							  +  	"<td>"
							  +			"<input type='checkbox' class='zoom-130 cdt_select' name='cdt_select'/>"
							  +			"<input type='hidden' class='cdt_id' value='"+item.CDT_ID+"'/>"
							  +	 	"</td>"
							  +  	"<td><input type='text' class='form-input width-40 cdt_order' value='"+item.RN+"' /></td>"
							  +  	"<td><input type='text' class='form-input width-160 cdt_code' value='"+item.CDT_CODE+"' /></td>"
							  +  	"<td><input type='text' class='form-input width-160 cdt_name' value='"+item.CDT_NAME+"' /></td>"
							  +  	"<td>"
							  +			"<select class='form-select width-120 cdt_show_type'>";
						
									$.each(cdtShowTypeList, function(j, show){
										var selected = "";
										if(show.CODE_ID == item.CDT_SHOW_TYPE){
											selected = "selected='selected'";
										}
										_html += "<option value='"+show.CODE_ID+"' "+selected+">"+show.CODE_NAME+"</option>";
									})
												
						_html += 		"</select>"
							  +		"</td>"
							  +  	"<td>"
							  +			"<select class='form-select width-120 cdt_cal_type'>";;
						
									$.each(cdtCalList, function(j, cal){
										var selected = "";
										if(cal.CODE_ID == item.CDT_CAL_TYPE){
											selected = "selected='selected'";
										}
										_html += "<option value='"+cal.CODE_ID+"' "+selected+">"+cal.CODE_NAME+"</option>";
									})
						_html += 		"</select>"
							  +		"</td>"
							  +  	"<td><input type='text' class='form-input width-100 default_val' /></td>"
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

//根据rptId设置当前配置页面的信息，相当于修改的回写
function setRptInfoBack(rptId){
	var params = {};
	params.rptId = rptId;
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryReportInfoById.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var reportInfo = data.result.reportInfo;
			if(isEmptyObj(reportInfo)){
				return;
			}else{
				//设置报表信息
				$("#rpt_name").val(reportInfo.RPT_NAME);
				$("input[name='if_download']").val(reportInfo.IF_DOWNLOAD);
				$("#rpt_cycle").val(reportInfo.RPT_CYCLE);
				$("#rpt_desc").val(reportInfo.RPT_DESC);
				var rptType = reportInfo.RPT_TYPE;
				$("input[name='rpt_type'][value='"+rptType+"']").prop("checked", true);
				//设置选中的控件信息
				var rptCdtInfoList = data.result.rptCdtInfoList;
				var cdtInfoTableTr = $(".cdt_info_table tr");
				var cdtInfoList = [];
				for(var i = 0; i < cdtInfoTableTr.length; i++){
					var tr = cdtInfoTableTr.eq(i);
					var $cdtSelect = tr.find(".cdt_select")
					var $cdtOrder = tr.find(".cdt_order");
					var cdtId = tr.find(".cdt_id").val();
					var $fieldCode = tr.find(".cdt_code");//对应最终的元数据字段
					var $fieldName = tr.find(".cdt_name");//对应最终的筛选条件展示名称
					var $cdtShowType = tr.find(".cdt_show_type");
					var $cdtCalType = tr.find(".cdt_cal_type");
					var $defaultVal = tr.find(".default_val");
					$.each(rptCdtInfoList, function(j, item){
						var sCdtId = item.CDT_ID;
						if(cdtId == sCdtId){
							$cdtSelect.prop("checked", true);
							$cdtOrder.val(item.CDT_ORDER);
							$fieldCode.val(item.CDT_CODE);
							$fieldName.val(item.CDT_NAME);
							$cdtShowType.val(item.CDT_SHOW_TYPE);
							$cdtCalType.val(item.CDT_CAL_TYPE);
							$defaultVal.val(item.DEFAULT_VAL);
							return false;
						}
					})
				}
				if(rptType == 1){
					//设置元数据信息
					$("#tb_id").val(reportInfo.TB_ID);
					$("#tb_name").val(reportInfo.TB_NAME+" | "+reportInfo.TB_OWNER+"."+reportInfo.TB_CODE);
					//设置字段列表
					var selectedFieldList = data.result.selectedFieldList;
					//设置排序字段列表
					var orderedFieldList = data.result.orderedFieldList;
					qryTableFieldByTbId(reportInfo.TB_ID, selectedFieldList, orderedFieldList);
				}else if( rptType == 2){
					//将这部分显示出来
					$(".detail_panel").hide();
					$(".multi_title").show();
					
					//重写model部分
					var rptModelInfo = data.result.rptModelInfo;
					var varList = data.result.varList;
					
					if(!isEmptyObj(rptModelInfo)&&!isEmptyObj(varList)){
						$("#model_id").val(rptModelInfo.MODEL_ID);
			    		$("#model_path").text(rptModelInfo.MODEL_NAME);
			    		$("#model_path").attr("href", rptModelInfo.MODEL_PATH);
			    		$("input[name='if_page'][value='"+rptModelInfo.IF_PAGE+"']").prop("checked", true);
						
						var $var_sql_tab = $("#var_sql_tab");
						var _tabHtml = "";
						var $var_sql_txt = $("#var_sql_txt");
						var _txtHtml = "";
						$.each(varList, function(i, item){
							if(i==0){
								_tabHtml += "<li class='active' value='"+item.VAR_ID+"'><a>"+item.VAR_CODE+"</a></li>";
					    		_txtHtml += "<li class='active'><textarea class='form-textarea var_sql' style='height: 450px;'>"+item.VAR_SQL+"</textarea></li>";
							}else{
								_tabHtml += "<li value='"+item.VAR_ID+"'><a>"+item.VAR_CODE+"</a></li>";
					    		_txtHtml += "<li><textarea class='form-textarea var_sql' style='height: 450px;'>"+item.VAR_SQL+"</textarea></li>";
							}
							
						})
						$var_sql_tab.empty();
						$var_sql_tab.html(_tabHtml);
						$var_sql_txt.empty();
						$var_sql_txt.html(_txtHtml);
					}
				}
			}
		},
		error:function(e){}
	})
}
//初始化输入框
function resetPage(){
	var _blank = "";
}
//设置参数
function setParams(){
	//增加或者修改，0增加，1修改
	rptId = $("#rptId").val();
	addOrModify = $("#addOrModify").val();
	var rptName = $("#rpt_name").val();
	var ifDownload = $("input[name='if_download']:checked").val();
	var rptCycle = $("#rpt_cycle").val();
	var rptDesc = $("#rpt_desc").val();
	var cdtInfoList = getCdtInfoList();
	var rptType = $("input[name='rpt_type']:checked").val();
	var tbId = $("#tb_id").val();
	var selectFieldListInfo = selectFieldList.join(",");
	var orderFieldListInfo = orderFieldList.join(",");
	
	//组合参数
	var params = {};
	params.rptId = rptId;
	params.addOrModify = addOrModify;
	params.rptName = rptName;
	params.ifDownload = ifDownload;
	params.rptCycle = rptCycle;
	params.rptDesc = rptDesc;
	params.cdtInfoList = cdtInfoList;
	params.rptType = rptType;
	params.tbId = tbId;
	params.selectFieldListInfo = selectFieldListInfo;
	params.orderFieldListInfo = orderFieldListInfo;
	
	if(rptType == "2"){
		//多表头模板相关
		var modelId = $("#model_id").val();
		var ifPage = $("input[name='if_page']:checked").val();
		//查询sql
		var varSqlCnt = $("#var_sql_txt li").length;
		var varSqlList = getVarSqlList();
		//判断是否填写完整的SQL信息
		if(!varSqlList){
			return false;
		}

		//多表头模板相关
		params.modelId = modelId;
		params.ifPage = ifPage;
		//查询sql
		params.varSqlCnt = varSqlCnt;
		params.varSqlList = varSqlList;
	}
	
	//校验参数
	if(validateParams(params)){
		return params;
	}else{
		return false;
	}
	
}
//拼接当前选中的条件控件信息
function getCdtInfoList(){
	var cdtInfoTableTr = $(".cdt_info_table tr");
	var cdtInfoList = [];
	for(var i = 0; i < cdtInfoTableTr.length; i++){
		var tr = cdtInfoTableTr.eq(i);
		var cdtInfo = {};
		//选中状态
		if(tr.find(".cdt_select").prop("checked")){
			var cdtOrder = tr.find(".cdt_order").val();
			var cdtId = tr.find(".cdt_id").val();
			var fieldCode = tr.find(".cdt_code").val();//对应最终的元数据字段
			var fieldName = tr.find(".cdt_name").val();//对应最终的筛选条件展示名称
			var cdtShowType = tr.find(".cdt_show_type").val();
			var cdtCalType = tr.find(".cdt_cal_type").val();
			var defaultVal = tr.find(".default_val").val();
			cdtInfo.cdtOrder = cdtOrder;
			cdtInfo.cdtId = cdtId;
			cdtInfo.fieldCode = fieldCode;
			cdtInfo.fieldName = fieldName;
			cdtInfo.cdtShowType = cdtShowType;
			cdtInfo.cdtCalType = cdtCalType;
			cdtInfo.defaultVal = defaultVal;
			cdtInfoList.push(cdtInfo);
		}
	}
	return cdtInfoList;
}
//获取输入的sql信息
function getVarSqlList(){
	var varSqlList = [];
	//sql变量列表
	var $var_sql_tab_li = $("#var_sql_tab li");
	//sql内容列表
	var $var_sql_txt_li = $("#var_sql_txt li");
	var length = $var_sql_tab_li.length;
	
	for(i=0; i<length; i++){
		var varSqlMap = {};
		var varId = $var_sql_tab_li.eq(i).attr("value");
		var varCode = $var_sql_tab_li.eq(i).find("a").text();
		var varSql = $var_sql_txt_li.eq(i).children(".var_sql").val();
		//判断SQL是否输入
		if(isNull(varSql)){
			art.dialog.tips("所有SQL变量必须填写对应的查询语句！");
			return false;
		}else{
			//判断sql语句中是否包含where条件的占位符
			if(varSql.indexOf("${where}") < 0){
				art.dialog.tips("【"+varCode+"】SQL变量没有${where}条件占位符！");
			}else{
				varSqlMap.varId = varId;
				varSqlMap.varSql = varSql;
				varSqlList.push(varSqlMap);
			}
		}
		
	}
	return varSqlList;
}
//校验输入项
function validateParams(params){
	if(isNull(params.rptName)){
		art.dialog.tips("报表名称必须填写！");
		return false;
	}else if(isNull(params.rptDesc)){
		art.dialog.tips("报表描述必须填写！");
		return false;
	}else if(isNull(params.cdtInfoList)){
		art.dialog.tips("报表控件至少选择一个！");
		return false;
	}else if(params.rptType==1&&isNull(params.tbId)){
		art.dialog.tips("报表元数据必须选择！");
		return false;
	}else if(params.rptType==1&&isNull(params.selectFieldListInfo)){
		art.dialog.tips("报表元数据字段必须选择！");
		return false;
	}else if(params.rptType==2&&params.modelId==0){
		art.dialog.tips("多表头必须上传报表模板！");
		return false;
	}else if(params.rptType==2&&params.varSqlCnt>params.varSqlList.length){
		art.dialog.tips("所有SQL变量必须填写对应的查询语句！");
		return false;
	}else{
		return true;
	}
}
//保存报表配置
function saveReport(){
	var params = {};
	params = setParams();
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!saveReport.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			//保存成功后重定向到报表配置，报表管理页面
			window.location.href = ctx+"/report/reportConfigAction!reportConfig4.do";
		},
		error:function(e){}
	})
}
//根据输入的字符模糊查询报表元数据
function qryTableInfoByInput(divBox, inputVal){
	var params = {};
	params.inputVal = inputVal;
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryTableInfoByInput.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var tableInfoList = data.result.tableInfoList;
			var _html = "";
			var tableUl = divBox.children("#table_info_list");
			if(isEmptyObj(tableInfoList)){
				_html += "<li>查无此元数据！</li>";
			}else{
				$.each(tableInfoList, function(i, item){
					_html += "<li tbId='"+item.TB_ID+"'>"+item.TB_NAME+" | "+item.TB_OWNER+"."+item.TB_CODE+"</li>";
				})
			}
			tableUl.empty();
			tableUl.html(_html);
			divBox.show();
		},
		error:function(e){}
	})
}
//查询报表元数据的字段列表
function qryTableFieldByTbId(tbId, selectedFieldList, orderedFieldList){
	var params = {};
	params.tbId = tbId;
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryTableFieldByTbId.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			var tableFieldList = data.result.tableFieldList;
			if(isEmptyObj(tableFieldList)){
				_html += "<option>报表元数据配置错误！</option>";
			}else{
				//设置报表字段选择
				buildRptFieldSelect(tableFieldList, selectedFieldList);
				//设置排序字段选择
				buildRptOrderSelect(tableFieldList, orderedFieldList);
			}
			
		},
		error:function(e){}
	})
}
//设置报表字段选择
function buildRptFieldSelect(tableFieldList, selectedFieldList){
	var _html = "";
	var multi_select = $("#multi-select");
	
	$.each(tableFieldList, function(i, item){
		if(isNull(selectedFieldList)){
			_html += "<option value='"+item.FIELD_ID+"'>"+item.FIELD_NAME+"</option>";
		}else{
			var index = selectedFieldList.indexOf(item.FIELD_ID);
			var sflag = index==-1?"":"selected";
			_html += "<option value='"+item.FIELD_ID+"' "+sflag+">"+item.FIELD_NAME+"</option>";
		}
		
	})
	
	multi_select.empty();
	multi_select.html(_html);
	$("#ms-ms-container").remove();
	multi_select.multiSelect({
		afterSelect:function(values){
			operSelectFieldList(values, 1);
		},
		afterDeselect:function(values){
			operSelectFieldList(values, -1);
		}
	});
	multi_select.multiSelect("refresh");
	//此时需要把保留的这个值重置下,重置成已经选择的字段列表
	selectFieldList = selectedFieldList;
}
//设置报表排序字段选择
function buildRptOrderSelect(tableFieldList, orderedFieldList){
	var _html = "";
	var order_multi_select = $("#order-multi-select");
	
	$.each(tableFieldList, function(i, item){
		if(item.IS_DIM=="1"){
			if(isNull(orderedFieldList)){
				_html += "<option value='"+item.FIELD_ID+"'>"+item.FIELD_NAME+"</option>";
			}else{
				var index = orderedFieldList.indexOf(item.FIELD_ID);
				var sflag = index==-1?"":"selected";
				_html += "<option value='"+item.FIELD_ID+"' "+sflag+">"+item.FIELD_NAME+"</option>";
			}
		}
	})
	
	order_multi_select.empty();
	order_multi_select.html(_html);
	$("#order-ms-container").remove();
	order_multi_select.multiSelect({
		afterSelect:function(values){
			operOrderFieldList(values, 1);
		},
		afterDeselect:function(values){
			operOrderFieldList(values, -1);
		}
	});
	order_multi_select.multiSelect("refresh");
	//此时需要把保留的这个值重置下,重置成已经选择的字段列表
	orderFieldList = orderedFieldList;
}
//对选中或者非选中的字段进行值的操作 values为当前操作的字段ID数组
function operSelectFieldList(values, oper){
	if(oper == 1){
		selectFieldList = selectFieldList.concat(values);
	}else{
		for(var i = 0; i < values.length; i++){
			var index = selectFieldList.indexOf(values[i]);
			selectFieldList.splice(index, 1);
		}
	}
}
//对选中或者非选中的排序字段进行操作
function operOrderFieldList(values, oper){
	if(oper == 1){
		orderFieldList = orderFieldList.concat(values);
	}else{
		for(var i = 0; i < values.length; i++){
			var index = orderFieldList.indexOf(values[i]);
			orderFieldList.splice(index, 1);
		}
	}
}
//上传模板
function importRptModel(){
	//导入的excel文件
	var filePath = $("#modelFile").val();
	//上传的文件必须选择
	if(filePath == "" || filePath == "undefined" || filePath == null){
		art.dialog.tips("请选择文件！");
		return false;
	}
	var fileExt = filePath.substring(filePath.lastIndexOf('.') + 1).toLowerCase();
	if(fileExt != "xls" && fileExt != "xlsx"){
		art.dialog.tips("文件必须为EXCEL文件类型！");
		return false;
	}
	
	var url = "";
	//导入的url
	url = ctx+"/report/json/reportConfigJsonAction!importRptModel.action?filePath="+filePath+"&fileExt="+fileExt;
	
	$.ajaxFileUpload({
		url:url,
		type:"post",
        secureuri:false,
        fileElementId:'modelFile',
        dataType:'json',
        success:function(data){
    		var uploadStatus = data.result.uploadStatus;
    		var modelId = data.result.modelId;
    		var modelName = data.result.modelName;
    		var modelPath = data.result.modelPath;
    		var varList = data.result.varList;
    		
    		if(uploadStatus == "-1"){
    			art.dialog.tips("文件不存在，请重新上传模板！");
    			return;
    		}else if(uploadStatus == "-2"){
    			art.dialog.tips("无法创建模板目录及文件！");
    			return;
    		}else if(uploadStatus == "-3"){
    			art.dialog.tips("从临时文件复制到目标文件时报错！");
    			return;
    		}else if(isEmptyObj(varList)){
    			art.dialog.tips("模板中无SQL变量，请检查并重新上传！");
    			return;
    		}else{
    			art.dialog.tips("模板上传成功，请填写对应的查询SQL!");
    		}
    		//上传完成后，设置model部分
    		//上传完成后，需要将modelId返回
    		$("#model_id").val(modelId);
    		$("#model_path").text(modelName);
    		$("#model_path").attr("href", ctx+modelPath);
    		
    		var $var_sql_tab = $("#var_sql_tab");
    		var _tabHtml = "";
    		var $var_sql_txt = $("#var_sql_txt");
    		var _txtHtml = "";
    		$.each(varList, function(i, item){
    			if(i==0){
    				_tabHtml += "<li class='active' value='"+modelId+i+"'><a>"+item.varCode+"</a></li>";
    	    		_txtHtml += "<li class='active'><textarea class='form-textarea var_sql' style='height: 450px;'></textarea></li>";
    			}else{
    				_tabHtml += "<li value='"+modelId+i+"'><a>"+item.varCode+"</a></li>";
    	    		_txtHtml += "<li><textarea class='form-textarea var_sql' style='height: 450px;'></textarea></li>";
    			}
    			
    		})
    		$var_sql_tab.empty();
    		$var_sql_tab.html(_tabHtml);
    		$var_sql_txt.empty();
    		$var_sql_txt.html(_txtHtml);
    		
        },
        error:function(e){art.dialog.tips("报表模版导入失败！");}
	});
}