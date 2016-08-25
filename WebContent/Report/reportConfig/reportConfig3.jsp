<%@page import="java.awt.event.ItemEvent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/Common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>报表配置-元数据字段列表查看</title>
	<!-- 本页面资源引入 -->
	<link rel="stylesheet" type="text/css" href="${ctx }/Report/reportConfig/css/reportConfig3.css?time=.css" />
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfig.js?time=.js"></script>
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfigJson3.js?time=.js"></script>
</head>
<body>
	
	<!-- 隐藏域 -->
	<input type="hidden" id="tbId" value="${result.tableInfo.TB_ID }" />
	
	<!-- 正文 -->
	<div class="auto_content">
		<div class="panel panel-primary">
			<div class="panel-heading">
			  <h3 class="panel-title">报表元数据——${result.tableInfo.TB_NAME }(${result.tableInfo.TB_OWNER}.${result.tableInfo.TB_CODE })</h3>
			</div>
			<!-- 字段列表 -->
			<div class="panel-body">
				<div class="tablediv">
					<table class="ui-table" id="data-body" style="width:100%;">
						<thead id="reportHead">
							<tr>
								<th><a>字段顺序</a></th>
								<th><a>字段编码</a></th>
								<th><a>字段名称</a></th>
								<th><a>字段类型</a></th>
								<th><a>字段长度</a></th>
								<th><a>是否维度</a></th>
								<th><a>聚合函数</a></th>
								<th><a>操作</a></th>
							</tr>
						</thead>
						<tbody id="reportBody">
							<tr></tr>
						</tbody>
					</table>
				</div>
				<div class="no-data"></div>
				<!-- 分页 -->
				<div class="pagediv fn-hide" align="center">
					<div id="pagination"></div>
				</div>
				<!-- 返回 -->
				<div class="form-btn-group">
					<a id="back_btn" class="form-btn" onclick="backToPage()">返回</a>
				</div>
			</div>
			<div class="panel-heading">
			  <h3 class="panel-title">报表元数据字段信息</h3>
			</div>
			<!-- 页面滚动锚点 -->
			<a name="add" id="add"></a>
			<div class="panel-body">
				<form class="form-group">
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="tb_name">元数据表名：</label>
							<div class="form-item-content">
								<input type="text" id="tb_code" class="form-input form-input-width" value="${result.tableInfo.TB_CODE }"/>
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="display_order">字段顺序：</label>
							<div class="form-item-content">
								<input type="text" id="display_order" class="form-input form-input-width" />
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="field_code">字段编码：</label>
							<div class="form-item-content">
								<input type="text" id="field_code" class="form-input form-input-width" />
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="field_name">字段名称：</label>
							<div class="form-item-content">
								<input type="text" id="field_name" class="form-input form-input-width" />
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="field_type">字段类型：</label>
							<div class="form-item-content">
								<input type="text" id="field_type" class="form-input form-input-width" />
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="field_length">字段长度：</label>
							<div class="form-item-content">
								<input type="text" id="field_length" class="form-input form-input-width" />
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="is_dim">是否维度：</label>
							<div class="form-item-content">
								<input type="radio" id="is_dim" name="is_dim" class="form-radio" checked="checked" value="1"/>是 &nbsp;&nbsp;&nbsp;
								<input type="radio" id="is_dim" name="is_dim" class="form-radio" value="0"/>否
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="group_value">聚合公式：</label>
							<div class="form-item-content">
								<textarea id="group_value" class="form-textarea"></textarea>
							</div>
						</div>
					</div>
					<div class="form-btn-group">
						<input type="hidden" id="fieldId" value=""/>
						<input type="hidden" id="addOrModify" value="1"/>
						<a id="save_btn" class="form-btn" onclick="saveTableField()">新增</a>
						<a id="save_btn" class="form-btn" onclick="resetTableField()">重置</a>
					</div>
				</form>
			</div>
	</div>
</body>
</html>