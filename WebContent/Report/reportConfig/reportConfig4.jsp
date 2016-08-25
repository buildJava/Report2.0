<%@page import="java.awt.event.ItemEvent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/Common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>报表配置-报表配置信息</title>
	<!-- 本页面资源引入 -->
	<link rel="stylesheet" type="text/css" href="${ctx }/Report/reportConfig/css/reportConfig4.css?time=.css" />
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfig.js?time=.js"></script>
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfigJson4.js?time=.js"></script>
</head>
<body>
	
	<!-- 隐藏域 -->
	<input type="hidden" id="" value="" />
	
	<!-- 正文 -->
	<div class="auto_content">
		<div class="panel panel-primary">
			<div class="panel-heading">
			  <h3 class="panel-title">报表配置信息</h3>
			</div>
			<!-- 字段列表 -->
			<div class="panel-body">
				<h3 class="sub-panel-title" onclick="redirectToPage('${ctx }/report/reportConfigAction!reportConfig6.do')">【新增报表配置】</h3>
				<div class="tablediv">
					<table class="ui-table" id="data-body" style="width:100%;">
						<thead id="reportHead">
							<tr>
								<th><a>序号</a></th>
								<th><a>报表名称</a></th>
								<th><a>报表周期</a></th>
								<th><a>报表类型</a></th>
								<th><a>更新时间</a></th>
								<th><a>创建用户</a></th>
								<th><a>报表状态</a></th>
								<th><a>操作</a></th>
							</tr>
						</thead>
						<tbody id="reportBody">
						</tbody>
					</table>
				</div>
				<div class="no-data"></div>
			</div>
			<div class="panel-heading">
			  <h3 class="panel-title">报表监控</h3>
			</div>
			<div class="panel-body">
			</div>
		</div>
	</div>
</body>
</html>