<%@page import="java.awt.event.ItemEvent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/Common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>报表配置-报表下载页面</title>
	<!-- 本页面资源引入 -->
	<link rel="stylesheet" type="text/css" href="${ctx }/Report/reportConfig/css/reportShow.css?time=.css" />
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfig.js?time=.js"></script>
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/downloadShowJson.js?time=.js"></script>
	
	<!-- 百分比 -->
	<link rel="stylesheet" type="text/css" href="${ctx}/Common/plugin/jquery.percent/pro-bars.min.css">
	<script type="text/javascript" src="${ctx}/Common/plugin/jquery.percent/pro-bars.min.js"></script>
	<script type="text/javascript" src="${ctx}/Common/plugin/jquery.percent/visible.min.js"></script>
</head>
<body>
	
	<!-- 正文 -->
	<div class="auto_content">
		<div class="panel panel-primary">
			<div class="panel-heading">
			  <h3 class="panel-title">报表下载</h3>
			</div>
			<!-- 报表信息 -->
			<div class="panel-body">
				<h3 class="panel-body-title" onclick="panelSlideToggle($(this))">
					<i class="icon-file-alt config-icon"></i>查询条件
					<span class="toggle_btn"><i class="icon-double-angle-up"></i>隐藏</span>
				</h3>
				<div class="panel-body-content" id="report_condition_box">
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="rpt_name">报表名称：</label>
							<div class="form-item-content">
								<input type="text" id="rpt_name" class="form-input form-input-width"/>
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="creater_name">下载帐号：</label>
							<div class="form-item-content">
								<input type="text" id="creater_name" class="form-input form-input-width"/>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 功能按钮区域 -->
			<div class="form-btn-group">
				<a id="save_btn" class="form-btn" onclick="qryDownloadData()">查询</a>
			</div>
			<!-- 数据加载等待 -->
			<div id="loading-box" class="loading-box" style="display:none;">
				<div class="ui-loading">正在努力加载，请稍后...</div>
			</div>
			<!-- 数据展示区域 -->
			<div class="panel-body" style="min-height: 400px;">
				<div class="tablediv" id="tablediv">
					<table class="ui-table" id="data-body">
						<thead id="reportHead">
							<tr>
								<th><a>序号</a></th>
								<th><a>报表编码</a></th>
								<th><a>报表名称</a></th>
								<th><a>创建时间</a></th>
								<th><a>下载</a></th>
								<th><a>状态</a></th>
								<th><a>下载条件</a></th>
								<th><a>下载帐号</a></th>
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
			<!-- 下载进度条 -->
			<div id="download_percent" class="download_percent" style="display:none;">
				<h3 class="panel-body-title">
				  <i class="icon-spinner icon-spin" style="margin-right:5px;"></i>正在下载。。。请稍后
				</h3>
				<div class="percent-bar">
					<div class="pro-bar-container color-belize-hole">
						<div class="pro-bar color-peter-river" data-pro-bar-percent="100">
							<div class="pro-bar-candy candy-ltr"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 字段选择弹出层 -->
	<div class="dialog_win" id="dialog_win" style="display:none;">
		<div class="panel-primary panel-border-none padding-lr30">
			<div class="panel-body">
				<form class="form-group dialog_field_box">
				</form>
			</div>
		</div>
	</div>
	
	<!-- 隐藏域 -->
	<input type="hidden" id="" value="" />
</body>
</html>