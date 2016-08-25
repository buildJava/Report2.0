/**
 * 全局变量
 */
var ctx = "/Report";

//判断变量是否为空
function isNull(obj){
	if(obj == null){
		return true;
	}
	var objType = typeof(obj);
	//按照不同的类型进行判断
	if(objType == "undefined"){
		return true;
	}else if(objType == "number"){
		return false;
	}else if(objType == "string"){
		if(obj == "" || obj == null || obj.length == 0 || obj == 'null'){
			return true;
		}
	}else if(objType == "boolean"){
		return obj;
	}else if(objType == "object"){
		if(obj instanceof Array && obj.length == 0){
			return true;
		}else if(!(obj instanceof Array)){
			isEmptyObj(obj);
		}
	}else{
		return false;
	}
}
//判断对象是否为空
function isEmptyObj(obj) {
    for (var key in obj){
    	return false;
    }
    return true; 
}
//根据key val获取对象
function getObjFromArray(objArray, key, val){
	
	for(i=0; i<objArray.length; i++){
		var obj = objArray[i];
		if(isObjContainVal(obj, key, val)){
			return obj;
			break;
		}
	}
	return {};
}
//判断对象是否包含某个值
function isObjContainVal(obj, key, val){
	if(obj[key]==val){
		return true;
	}else{
		return false;
	}
}
/*自动生成控件方法*/
//1 3 生成日期控件 月份
function buildDatePicker(format, divObj, dateFormat){
	if(isNull(dateFormat)){
		dateFormat = "";
	}
	var _html = "";
	if(format=="YYYYMMDD"){
		_html += "<input type='text' class='form-input date-picker' id='datePicker' value='"+dateFormat+"'"
			  +  "onclick='WdatePicker({isShowClear:false,readOnly:true})' onchange='dateOnpicked($(this), 1)'  />"
			  +  "<i class='icon-calendar cdt-icon-css date-input-icon'></i>";
	}else if(format=="YYYYMM"){
		_html += "<input type='text' class='form-input date-picker' id='datePicker' value='"+dateFormat+"'"
			  +  "onclick='WdatePicker({isShowClear:false,readOnly:true,dateFmt:\"yyyy-MM\"})' onchange='dateOnpicked($(this), 1)' />"
			  +  "<i class='icon-calendar cdt-icon-css date-input-icon'></i>";
	}
	divObj.empty();
	divObj.html(_html);
}
//2 4 生成日期控件(开始-结束) 月份(开始-结束)
function buildDateBwnPicker(format, divObj, dateFormat){
	if(isNull(dateFormat)){
		dateFormat = "";
	}
	var _html = "";
	if(format=="YYYYMMDD"){
		_html += "<input type='text' class='form-input date-picker' id='datePickerStart' value='"+dateFormat+"'"
			  +  "onclick='WdatePicker({isShowClear:false,readOnly:true})' onchange='dateOnpicked($(this), 1)' />"
			  +  "<i class='icon-calendar cdt-icon-css date-input-icon'></i>"
			  +	 "<span style='margin-left: 6px;'> 至 </span>"
			  +	 "<input type='text' class='form-input date-picker' id='datePickerEnd' value='"+dateFormat+"'"
			  +  "onclick='WdatePicker({isShowClear:false,readOnly:true})' onchange='dateOnpicked($(this), 0)' />"
			  +  "<i class='icon-calendar cdt-icon-css date-input-icon'></i>";
	}else if(format=="YYYYMM"){
		_html += "<input type='text' class='form-input date-picker' id='datePickerStart' value='"+dateFormat+"'"
			  +  "onclick='WdatePicker({isShowClear:false,readOnly:true,dateFmt:\"yyyy-MM\"})' onchange='dateOnpicked($(this), 1)' />"
			  +  "<i class='icon-calendar cdt-icon-css date-input-icon'></i>"
			  +	 "<span style='margin-left: 6px;'> 至 </span>"
			  +	 "<input type='text' class='form-input date-picker' id='datePickerEnd' value='"+dateFormat+"'"
			  +  "onclick='WdatePicker({isShowClear:false,readOnly:true,dateFmt:\"yyyy-MM\"})' onchange='dateOnpicked($(this), 0)' />"
			  +  "<i class='icon-calendar cdt-icon-css date-input-icon'></i>";
		
	}
	divObj.empty();
	divObj.html(_html);
}
//5 多选框
function buildCheckPicker(condition, dataList, divObj){
	var id = condition["CDT_CODE"];
	divObj.CheckboxSelect({id:id, dataList:dataList});
}
//6 单选框
function buildRadioPicker(condition, dataList, divObj){
	var _html = "<select id='"+condition["CDT_CODE"]+"' class='form-select form-select-width'>"
		      + 	"<option value='-1'>请选择"+condition["CDT_NAME"]+"</option>";
	$.each(dataList, function(i, item){
		_html += "<option value="+item.KEY_+">"+item.VALUE_+"</option>";
	})
	_html += "</select>";
	divObj.empty();
	divObj.html(_html);
}
//7 文本框
function buildTextPicker(condition, divObj){
	var _html = "<input type='text' class='form-input' id='"+condition["CDT_CODE"]+"' placeholder='请输入"+condition["CDT_NAME"]+"' \>";
	divObj.empty();
	divObj.html(_html);
}
//8 固定值列表
function buildSelectPicker(condition, divObj){
	var cdtSql = condition["CDT_SQL"]; //1@是,0@否
	var keyValArray = cdtSql.split(",");
	var _html  = "<select id='"+condition["CDT_CODE"]+"' class='form-select form-select-width'>"
    		   + 	"<option value='-1'>请选择"+condition["CDT_NAME"]+"</option>";
	for(var i = 0; i < keyValArray.length; i++){
		var keyVal = keyValArray[i].split("@");
		_html += "<option value="+keyVal[0]+">"+keyVal[1]+"</option>";
	}
	_html += "</select>";
	divObj.empty();
	divObj.html(_html);
}
/*自动生成控件方法*/
/*下拉框对于按键的响应*/
function keyBoardDown($this, event){
	var $tar = $(event.target);
	var $toggleDiv = $this.siblings("div").eq(0);
	$toggleDiv.focus();
	var $toggleLi = $toggleDiv.find("li");
	var index = $toggleLi.index($(".li-active"));;
	var length = $toggleLi.length-1;
	var height = $toggleDiv.css("height").replace(/px/g, "");
	var scroll = (index/length)*height;
	var keyCode = event.which;
	switch(keyCode){
		case 13:
			$toggleLi.eq(index).trigger("click");
			$toggleDiv.hide();
			break;
		case 38:
			index = index-1<0?0:index-1;
			$(".li-active").removeClass("li-active");
			$toggleDiv.scrollTop(scroll);
			$toggleLi.eq(index).addClass("li-active");
			break;
		case 40:
			index = index+1>length?length:index+1;
			$(".li-active").removeClass("li-active");
			$toggleDiv.scrollTop(scroll);
			$toggleLi.eq(index).addClass("li-active");
			break;
		default:
			return;
	}
}