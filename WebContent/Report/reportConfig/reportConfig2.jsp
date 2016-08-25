<%@page import="java.awt.event.ItemEvent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/Common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>报表配置-元数据管理</title>
	<!-- 本页面资源引入 -->
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfig.js?time=.js"></script>
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfigJson2.js?time=.js"></script>
</head>
<body>
	<img alt="" src="">
	<!-- 隐藏域 -->
	<input type="hidden" id="" value="" />
	
	<!-- 正文 -->
	<div class="auto_content">
		<div class="panel panel-primary">
			<div class="panel-heading">
			  <h3 class="panel-title">报表元数据管理</h3>
			</div>
			<div class="panel-body">
				<form class="form-group">
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="tb_owner">元数据用户：</label>
							<div class="form-item-content">
								<select id="tb_owner" class="form-select form-select-width">
									<c:forEach var="item" items="${result.rptDbUsersList }" varStatus="status">
										<option value="${item.USER_CODE }">${item.USERNAME }</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="tb_code">元数据表名：</label>
							<div class="form-item-content">
								<input type="text" id="tb_code" class="form-input form-input-width" placeholder="请输入需要查询的数据表名称" />
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="tb_name">元数据名称：</label>
							<div class="form-item-content">
								<input type="text" id="tb_name" class="form-input form-input-width" placeholder="请输入需要查询的报表名称" />
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="field_name">指标模糊查询：</label>
							<div class="form-item-content">
								<input type="text" id="field_name" class="form-input form-input-width" placeholder="请输入需要查询的指标名称"/>
							</div>
						</div>
					</div>
					<div class="form-btn-group">
						<a id="qry_btn" class="form-btn" onclick="init()">查询</a>
						<a id="new_btn" class="form-btn" onclick="addTableInfo()">新增元数据</a>
					</div>
				</form>
			</div>
			<!-- 数据加载等待 -->
			<div id="loading-box" class="loading-box" style="display:none;">
				<div class="ui-loading">正在努力加载，请稍后...</div>
			</div>
			<div class="panel-body">
				<div class="tablediv">
					<table class="ui-table" id="data-body" style="width:100%;">
						<thead id="reportHead">
							<tr>
								<th><a>序号</a></th>
								<th><a>元数据名称</a></th>
								<th><a>元数据用户</a></th>
								<th><a>元数据表名</a></th>
								<th><a>是否分表</a></th>
								<th><a>分表字段</a></th>
								<th><a>创建人</a></th>
								<th><a>更新时间</a></th>
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
			</div>
	    </div>
	</div>
</body>
</html>