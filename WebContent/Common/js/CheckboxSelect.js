/**
 * 实现checkboxSelect下拉选择框
 * need jquery
 * author ZR 20160603
 * @returns {Object} jQuery Object
 * @param $
 */ 
 //定义下拉框对象构造方法
 var Selector = function(ele, options){
	 this.$ele = ele,
	 this.defaults = {
		 id:"multiSelect",
		 max_height:280,
		 ulLi:"",
		 dataList:[],
		 disabledList:[],
		 selectAll:true,
		 cols:["KEY_","VALUE_"] 
	 },
	 this.opts = $.extend({}, this.defaults, options);
 }
 //定义下拉框的方法
 Selector.prototype = {
	 createSelector:function(){
		 var opts = this.opts;
		 var $ele = this.$ele;
		 var $eleState = false;
		//保证下拉框的惟一性
		 $ele.empty();
		 //生成html代码
		 var _html = "<div class='multiple_select_box'><input type='text' class='form-input multiple_input' id='"+opts.id+"'/><i class='icon-search select-icon'></i><ul class='multiple_select' style='overflow-y:auto; display:none;'>";
		 var _selectAllHtml = "<li class='select_all'><input type='checkbox' value='0' />全选</li>";
		 var _nullHtml = "<li><input type='checkbox' value='-1' />无选项</li>";
		 var _dataHtml = "";
		 var _endHtml = "</ul></div>";
		 //如果没有全选，则把全选的选项去除
		 if(!opts.selectAll){
			 _selectAllHtml = "";
		 }
		//根据不同的数据来源设置下拉框菜单
		 if(opts.dataList.length == 0 && $(opts.ulLi).length == 0){
			 _html += _selectAllHtml + _nullHtml + _endHtml;
		 }else if(opts.dataList.length > 0){
			 $.each(opts.dataList, function(i, item){
				 var key_ = item[opts.cols[0]];
				 var val_ = item[opts.cols[1]];
				 var disabled = "";
				 if(opts.disabledList.length > 0){
					 if(opts.disabledList.indexOf(key_) != -1){
						 disabled = "disabled";
					 }
				 }
				 _dataHtml += "<li><input type='checkbox' value='"+key_+"'"+disabled+" />"+val_+"</li>";
			 })
			 _html += _selectAllHtml + _dataHtml + _endHtml;
		 }else if($(opts.ulLi).length > 0){
			 var liList = $(opts.ulLi);
			 for(var i = 0; i<liList.length; i++){
				 var li = liList[i];
				 var liVal = li.attr("value");
				 var liText = li.text();
				 _html += "<li><input type='checkbox' value='"+liVal+"' />"+liText+"</li>";
			 }
			 _html += _selectAllHtml + _dataHtml + _endHtml;
		 }else{
			 _html += _selectAllHtml + _nullHtml + _endHtml;
		 }
		 $ele.empty();
		 $ele.html(_html);
		 
		 //绑定下拉框的显示动作
		 $(document).click(function(e){
			 if($(e.target).parents().addBack().is(".multiple_input")||$(e.target).parents().addBack().is(".select-icon")){
				 $eleState = false;
				 onEleClick(e);
			 }else{
				 $eleState = true;
				 if($eleState){
					 onEleClick(e);
				 }
			 }
		 })
		 //点击时的动作
		 function onEleClick(e){
			var $multiple_select = $(e.target).siblings(".multiple_select");
			// Do nothing, if currently animating
			if($multiple_select.is(":animated")){
				return;
			}
			if($eleState){
				if(!($(e.target).parents().addBack().is(".multiple_select_box"))){
					$eleState = false;
					$(document).find(".multiactive").slideUp(0, function(){
						//这里触发一个值变动，为外层的取下拉框值变化提供触发条件
						$(this).find("input").eq(0).trigger("change");
					}).removeClass("multiactive");
					return;
				}
			}else{
				$eleState = true;
				if(!$multiple_select.hasClass("multiactive")){
					$(".multiactive").hide().removeClass("multiactive");
					$multiple_select.slideDown(100).addClass("multiactive");
				}
				return;
			}
		 }
		 var selectorLi = $(".multiactive li");
		 //绑定全选，全不选的操作
		 $(document).on("click", ".multiactive li", function(e){
			 var selector = $(this).parents(".multiactive");
			 var selectAll = selector.children(".select_all");
			 var allCheckbox = selector.find("input[type='checkbox']:gt(0)").not(":disabled");
			 var checkedBox = selector.find("input[type='checkbox']:gt(0):checked").not(":disabled");
			 
			 var selectFlag = selector.find("input[type='checkbox']").prop("checked");
			 if($(this).hasClass("select_all")){
				 selectAllOrNot(selector, selectFlag);
			 }else{
				 //通过对全部checkbox的数量及选中状态的checkbox数量进行比较来判断是否全选
				 if(allCheckbox.length == checkedBox.length){
					 selectAll.children("input[type='checkbox']").prop("checked", true);
				 }else{
					 selectAll.children("input[type='checkbox']").prop("checked", false);
				 }
			 }
			 //写入值
			 allCheckbox = selector.find("input[type='checkbox']:gt(0)").not(":disabled");
			 checkedBox = selector.find("input[type='checkbox']:gt(0):checked").not(":disabled");
			 var text_ = setSelectedText(checkedBox);
			 var val_ = setSelectedVal(checkedBox);
			 var multiple_input = selector.siblings(".multiple_input");
			 multiple_input.val(text_);
			 multiple_input.attr("code", val_);
		 });
		 //全选OR全不选
		 function selectAllOrNot(selector, ifAll){
			selector.children("li").children("input[type='checkbox']").not(":disabled").prop("checked", ifAll);
		 }
		 //返回选中文本和值
		 function setSelectedText(checkedBox){
			 var text_ = "";
			 for(var i = 0; i < checkedBox.length; i++){
				 if(i != 0){
					 text_ += ",";
				 }
				 text_ += checkedBox[i].nextSibling.data;
			 }
			 return text_;
		 }
		//返回选中值
		 function setSelectedVal(checkedBox){
			 var val_ = "";
			 for(var i = 0; i < checkedBox.length; i++){
				 if(i != 0){
					 val_ += ",";
				 }
				 val_ += checkedBox[i].defaultValue;
			 }
			 return val_==""?"-1":val_;
		 }
		 return $ele.children(".multiple_select_box");
	 },
 	
 }
 //在下拉框中使用下拉框对象
 $.fn.CheckboxSelect = function(options){
	 //创建实体
	 var checkboxSelector = new Selector(this, options);
	 //调用他的方法
	 return checkboxSelector.createSelector();
 }
