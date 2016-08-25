<%@page import="java.awt.event.ItemEvent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/Common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>报表配置-报表查询控件配置</title>
	<!-- 本页面资源引入 -->
	<link rel="stylesheet" type="text/css" href="${ctx }/Report/reportConfig/css/reportConfig5.css?time=.css" />
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfig.js?time=.js"></script>
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfigJson5.js?time=.js"></script>
	<script type="text/javascript" src="${ctx }/Common/js/CheckboxSelect.js"></script>
</head>
<body>
	
	<!-- 隐藏域 -->
	<input type="hidden" id="" value="" />
	<!-- 控件弹出层 -->
	<div class="dialog_win" id="dialog_win" style="display:none;">
		<div class="panel panel-primary panel-border-none margintop-20">
			<div class="panel-body">
				<form class="form-group">
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="dialog_cdt_show" id="dialog_cdt_name">控件描述：</label>
							<div class="form-item-content dialog_cdt_show" id="dialog_cdt_show">
								<input type="text" class="form-input"/>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<!-- 正文 -->
	<div class="auto_content">
		<div class="panel panel-primary">
			<div class="panel-heading">
			  <h3 class="panel-title">报表查询控件配置</h3>
			</div>
			<!-- 控件列表 -->
			<div class="panel-body">
				<h3 class="sub-panel-title" onclick="addConditionInfo('#add')">【新增查询控件】</h3>
				<div class="tablediv">
					<table class="ui-table" id="data-body" style="width:100%;">
						<thead id="reportHead">
							<tr>
								<th><a>序号</a></th>
								<th><a>控件名称</a></th>
								<th><a>控件描述</a></th>
								<th><a>展现类型</a></th>
								<th><a>计算类型</a></th>
								<th><a>父级控件名称</a></th>
								<th><a>级联字段</a></th>
								<th><a>操作</a></th>
							</tr>
						</thead>
						<tbody id="reportBody">
						</tbody>
					</table>
				</div>
			</div>
			<div class="panel-heading">
			  <h3 class="panel-title">报表查询控件详情</h3>
			</div>
			<!-- 页面滚动锚点 -->
			<a name="add" id="add"></a>
			<div class="panel-body">
				<form class="form-group">
					<div class="fn-clear">
						<input type="hidden" id="cdt_id" value=""/>
						<div class="form-item fn-left">
							<label class="form-label" for="cdt_code">控件编码：</label>
							<div class="form-item-content">
								<input type="text" id="cdt_code" class="form-input form-input-width" placeholder=""/>
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="cdt_name">控件名称：</label>
							<div class="form-item-content">
								<input type="text" id="cdt_name" class="form-input form-input-width" placeholder=""/>
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="cdt_desc">控件描述：</label>
							<div class="form-item-content">
								<input type="text" id="cdt_desc" class="form-input form-input-width" placeholder=""/>
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="cdt_show_type">控件展现类型：</label>
							<div class="form-item-content">
								<select id="cdt_show_type" class="form-select form-select-width">
									<c:forEach var="item" items="${result.cdtShowTypeList }" varStatus="status">
										<option value="${item.CODE_ID }">${item.CODE_NAME }</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="cdt_cal_type">控件计算类型：</label>
							<div class="form-item-content">
								<select id="cdt_cal_type" class="form-select form-select-width">
									<c:forEach var="item" items="${result.cdtCalList }" varStatus="status">
										<option value="${item.CODE_ID }">${item.CODE_NAME }</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="cdt_sql">控件条件SQL：</label>
							<div class="form-item-content">
								<textarea id="cdt_sql" class="form-textarea"></textarea>
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="pat_cdt_id">父级控件名称：</label>
							<div class="form-item-content">
								<select id="pat_cdt_id" class="form-select form-select-width">
										<option value="0">请选择父级控件</option>
									<c:forEach var="item" items="${result.cdtInfoList }" varStatus="status">
										<option value="${item.CDT_ID }">${item.CDT_NAME } | ${item.CDT_DESC }</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="pat_col_code">级联字段编码：</label>
							<div class="form-item-content">
								<input type="text" id="pat_col_code" class="form-input form-input-width" placeholder=""/>
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="">使用说明：</label>
							<ul class="common-input-explain">
								<li>1.多选框及单选框均为下拉选择的形式;</li>
								<li>2.文档框为手工输入模糊查询的形式，需要在报表配置时指定模糊查询的字段;</li>
								<li>3.控件条件SQL：code字段加上别名 "KEY_";desc描述字段加上别名"VALUE_";</li>
								<li>4.父级控件如有需要可以选择指定，如未选择默认无，如指定的父级控件，则必需指定与父级控件的级联字段编码</li>
							</ul>
						</div>
					</div>
					<div class="form-btn-group">
						<input type="hidden" id="addOrModify" value="0" />
						<a id="save_btn" class="form-btn" onclick="saveCondition()">保存</a>
						<a id="reset_btn" class="form-btn" onclick="resetPage()">重置</a>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>