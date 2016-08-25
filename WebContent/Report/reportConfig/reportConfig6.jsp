<%@page import="java.awt.event.ItemEvent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/Common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>报表配置-新增报表配置</title>
	<!-- 本页面资源引入 -->
	<link rel="stylesheet" type="text/css" href="${ctx }/Report/reportConfig/css/reportConfig6.css?time=.css" />
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfig.js?time=.js"></script>
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfigJson6.js?time=.js"></script>
	<!-- 左右多选下拉框 -->
	<link rel="stylesheet" type="text/css" href="${ctx }/Common/plugin/multiselect/multi-select.css" />
	<script type="text/javascript" src="${ctx }/Common/plugin/multiselect/jquery.multi-select.js"></script>
</head>
<body>
	
	<!-- 正文 -->
	<div class="auto_content">
		<div class="panel panel-primary">
			<div class="panel-heading">
			  <h3 class="panel-title">新增报表配置</h3>
			</div>
			<!-- 报表信息 -->
			<div class="panel-body">
				<h3 class="panel-body-title" onclick="panelSlideToggle($(this))">
					<i class="icon-file-alt config-icon"></i>报表信息
					<span class="toggle_btn"><i class="icon-double-angle-up"></i>隐藏</span>
				</h3>
				<div class="panel-body-content">
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="rpt_name">报表名称：</label>
							<div class="form-item-content">
								<input type="text" id="rpt_name" class="form-input form-input-width"/>
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="if_download">是否可下载：</label>
							<div class="form-item-content">
								<input type="radio" id="if_download" name="if_download" class="form-radio" checked="checked" value="1"/>是 &nbsp;&nbsp;&nbsp;
								<input type="radio" id="if_download" name="if_download" class="form-radio" value="0"/>否
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="rpt_cycle">周期选择：</label>
							<div class="form-item-content">
								<select class="form-select width-120 rpt_cycle" id="rpt_cycle">
									<c:forEach var="show" items="${result.rptCycleList }" varStatus="showStatus">
										<option value="${show.CODE_ID }" >${show.CODE_NAME }</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="rpt_desc">报表描述：</label>
							<div class="form-item-content">
								<textarea id="rpt_desc" class="form-textarea"></textarea>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 控件选择列表 -->
			<div class="panel-body">
				<h3 class="panel-body-title" onclick="panelSlideToggle($(this))">
					<i class="icon-tasks config-icon"></i>控件选择
					<span class="toggle_btn"><i class="icon-double-angle-down"></i>显示</span>
				</h3>
				<div class="panel-body-content" style="display:none;">
					<div class="tablediv">
						<table class="ui-table" id="data-body" style="width:100%;">
							<thead id="reportHead">
								<tr>
									<th><a>勾选</a></th>
									<th><a>顺序</a></th>
									<th><a>控件编码</a></th>
									<th><a>控件名称</a></th>
									<th><a>展示类型</a></th>
									<th><a>计算方式</a></th>
									<th><a>默认值</a></th>
								</tr>
							</thead>
							<tbody id="reportBody" class="cdt_info_table">
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<!-- 报表元数据设置 -->
			<div class="panel-body">
				<h3 class="panel-body-title" onclick="panelSlideToggle($(this))">
					<i class="icon-list-alt config-icon"></i>报表元数据设置
					<span class="toggle_btn"><i class="icon-double-angle-down"></i>显示</span>
				</h3>
				<div class="panel-body-content" style="display:none;">
					<div class="panel-body-content">
						<div class="fn-clear">
							<div class="form-item fn-left">
								<label class="form-label" for="rpt_type">报表类型：</label>
								<div class="form-item-content">
									<c:forEach var="item" items="${result.rptTypeList }" varStatus="status">
										<input type="radio" name="rpt_type" class="form-radio" value="${item.CODE_ID }" ${status.index==0?"checked":"" }/>${item.CODE_NAME }
									</c:forEach>
								</div>
							</div>
						</div>
						<div class="detail_panel single_title">
							<div class="fn-clear">
								<div class="form-item fn-left">
									<label class="form-label" for="tb_id">报表元数据：</label>
									<div class="form-item-content">
										<input type="hidden" id="tb_id" value=""/>
										<input type="text" id="tb_name" class="form-input form-input-width" placeholder="请输入数据库表名"  value=""/>
										<div id="table_info_list_box" class="table_info_list_box" style="display:none;">
											<ul id="table_info_list" class="table_info_list">
												<li value="160526102105976">营业厅渠道推荐受理统计数据 | AP_RPT_CRM_AREA_TRACE_D_ZJ</li>
											</ul>
										</div>
									</div>
								</div>
							</div>
							<div class="fn-clear">
								<div class="form-item fn-left">
									<label class="form-label" for="field_select_box">报表字段选择：</label>
									<div class="form-item-content">
										<select class="multi-select" multiple="multiple" id="multi-select" style="display:none;">
											<option></option>
										</select>
										<div class="ms-container" id="ms-ms-container">
											<div class="ms-selectable">
												<ul class="ms-list"></ul>
											</div>
											<div class="ms-selectbtn">
												<i class="icon-double-angle-right icon-select-all-btn" title="全选"></i>
												<i class="icon-double-angle-left icon-unselect-all-btn" title="全不选"></i>
											</div>
											<div class="ms-selection">
												<ul class="ms-list"></ul>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="fn-clear">
								<div class="form-item fn-left">
									<label class="form-label" for="field_select_box">排序字段选择：</label>
									<div class="form-item-content">
										<select class="multi-select" multiple="multiple" id="order-multi-select" style="display:none;">
											<option></option>
										</select>
										<div class="ms-container" id="order-ms-container">
											<div class="ms-selectable">
												<ul class="ms-list"></ul>
											</div>
											<div class="ms-selectbtn">
												<i class="icon-double-angle-right icon-select-all-btn" title="全选"></i>
												<i class="icon-double-angle-left icon-unselect-all-btn" title="全不选"></i>
											</div>
											<div class="ms-selection">
												<ul class="ms-list"></ul>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="detail_panel multi_title" style="display:none;">
							<div class="fn-clear">
								<div class="form-item fn-left">
									<label class="form-label" for="rpt_model">报表模板：</label>
									<div class="form-item-content">
										<input type="hidden" id="model_id" value="0">
										<input type="file" id="modelFile" name="modelFile" class="form-input form-input-width"/>
										<input type="button" class="form-btn" value="上传" onclick="importRptModel()"/>
									</div>
								</div>
							</div>
							<div class="fn-clear">
								<div class="form-item fn-left">
									<label class="form-label" for="model_path">模板：</label>
									<div class="form-item-content">
										<a id="model_path" class="model_path" href="" title="点击下载模板">模板地址</a>
									</div>
								</div>
								<div class="form-item fn-left">
									<label class="form-label" for="if_page">是否可翻页：</label>
									<div class="form-item-content">
										<input type="radio" id="if_page" name="if_page" class="form-radio if_page" value="1"/>是 &nbsp;&nbsp;&nbsp;
										<input type="radio" id="if_page" name="if_page" class="form-radio if_page" checked="checked" value="0"/>否
									</div>
								</div>
							</div>
							<div class="fn-clear var_sql_box" id="var_sql_box">
								<div class="form-item fn-left">
									<label class="form-label" for="">查询sql：</label>
									<div class="form-item-content" style="width:720px; overflow-x:auto;">
										<ul class="var_sql_tab" id="var_sql_tab">
											<li class="active" value="" rowindex="" colindex="" orderid=""><a><%="${sql}" %></a></li>
										</ul>
										<ul class="var_sql_txt" id=var_sql_txt>
											<li><textarea class="form-textarea var_sql" style="height: 450px;"></textarea></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<div class="detail_panel smart_query" style="display:none;">
							<div class="fn-clear">
								<div class="form-item fn-left">
									<label class="form-label" for="rpt_sql">查询sql：</label>
									<div class="form-item-content">
										<textarea id="rpt_sql" class="form-textarea"></textarea>
									</div>
								</div>
							</div>
						</div>
						<div class="detail_panel data_chart" style="display:none;">
							<div class="fn-clear">
								<div class="form-item fn-left">
									<label class="form-label" for="chart_type">图表类型：</label>
									<div class="form-item-content">
										<input type="text" id="chart_type" class="form-input form-input-width" placeholder="请选择图表类型" />
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="form-btn-group">
				<input type="hidden" id="addOrModify" value="${result.addOrModify }" />
				<a id="save_btn" class="form-btn" onclick="saveReport()">保存</a>
			</div>
		</div>
	</div>
	
	<!-- 隐藏域 -->
	<input type="hidden" id="rptId" value="${result.rptId }" />
</body>
</html>