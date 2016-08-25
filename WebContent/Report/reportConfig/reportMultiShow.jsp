<%@page import="com.opensymphony.xwork2.Result"%>
<%@page import="java.awt.event.ItemEvent"%>
<%@page import="com.aiutil.report.entities.ReportModel" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/Common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>报表配置-多表头报表查看</title>
	<!-- 本页面资源引入 -->
	<link rel="stylesheet" type="text/css" href="${ctx }/Report/reportConfig/css/reportMultiShow.css?time=.css" />
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfig.js?time=.js"></script>
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportMultiShow.js?time=.js"></script>
	
	<!-- 多选下拉框 -->
	<script type="text/javascript" src="${ctx }/Common/js/CheckboxSelect.js"></script>
	<!-- 百分比 -->
	<link rel="stylesheet" type="text/css" href="${ctx}/Common/plugin/jquery.percent/pro-bars.min.css">
	<script type="text/javascript" src="${ctx}/Common/plugin/jquery.percent/pro-bars.min.js"></script>
	<script type="text/javascript" src="${ctx}/Common/plugin/jquery.percent/visible.min.js"></script>
	<!-- 多表头excel样式 -->
	<link rel="stylesheet" type="text/css" href="${ctx }/Common/css/excelStyle.css?time=.css" />
</head>
<body>
	
	<!-- 正文 -->
	<div class="auto_content">
		<div class="panel panel-primary">
			<div class="panel-heading">
			  <h3 class="panel-title">报表查看-${result.rptName }</h3>
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
							<label class="form-label" for="DEAL_DATE">统计日期：</label>
							<input type="hidden" class="cdt_id" value="160526102105976"/>
							<div class="form-item-content form-item-width200">
								<input type="text" id="DEAL_DATE" class="form-input date-picker"/>
								<i class="icon-calendar cdt-icon-css date-input-icon"></i>
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="REGION_CODE">地市：</label>
							<input type="hidden" class="cdt_id" value="160526102605913"/>
							<div class="form-item-content form-item-width200">
								<input type="text" id="REGION_CODE" class="form-input multiple_input"/>
								<i class="icon-search select-icon"></i>
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="CITY_CODE">区县：</label>
							<input type="hidden" class="cdt_id" value="160526102705998"/>
							<div class="form-item-content form-item-width200">
								<input type="text" id="CITY_CODE" class="form-input multiple_input"/>
								<i class="icon-search select-icon"></i>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 功能按钮区域 -->
			<div class="form-btn-group">
				<a id="save_btn" class="form-btn" onclick="qryReportData()">查询</a>
				<input type="hidden" id="exportFlag" value="0"/>
				<input type="hidden" id="dataCount" value="0"/>
				<a id="save_btn" class="form-btn" onclick="exportData(${result.reportInfo.IF_DOWNLOAD })">数据导出</a>
			</div>
			<!-- 数据加载等待 -->
			<div id="loading-box" class="loading-box" style="display:none;">
				<div class="ui-loading">正在努力加载，请稍后...</div>
			</div>
			<!-- 数据展示区域 -->
			<div class="panel-body" style="min-height: 400px;">
				<!-- 去往下载页面 -->
				<div class="go-download" style="display:none;" onclick="goToDownload()">
					<i class="icon-signin">&nbsp;&nbsp;去往下载页面</i>
				</div>
				<div class="tablediv" id="tablediv">
					<c:if test="${result.reportModel != null }">
						${result.reportModel.modelHtml }
					</c:if>
					<c:if test="${result.reportModel == null }">
						<table class="ui-table" id="data-body">
							<tbody id="reportBody">
								<tr></tr>
							</tbody>
						</table>
					</c:if>
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
				  <i class="icon-spinner icon-spin" style="margin-right:5px;"></i>正在下载。。。请到报表下载管理中进行查看！
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
	
	<!-- 隐藏域 -->
	<input type="hidden" id="rptId" value="${result.rptId }" />
	<input type="hidden" id="rptName" value="${result.rptName }" />
	<input type="hidden" id="rptCycle" value="${result.rptCycle }" />
	<input type="hidden" id="ifPage" value="${result.reportModel.ifPage }" />
	<input type="hidden" id="rptType" value="${result.reportInfo.RPT_TYPE }" />
	<input type="hidden" id="dateFormat" value="${result.dateFormat }" />
</body>
	<!-- 加载报表样式 -->
	<style type="text/css">
		${result.reportModel.modelCss }
	</style>
</html>