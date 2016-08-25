<%@page import="java.awt.event.ItemEvent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/Common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>报表配置-保存元数据</title>
	<!-- 本页面资源引入 -->
	<link rel="stylesheet" type="text/css" href="${ctx }/Report/reportConfig/css/reportConfig1.css?time=.css" />
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfig.js?time=.js"></script>
	<script type="text/javascript" src="${ctx }/Report/reportConfig/js/reportConfigJson1.js?time=.js"></script>
</head>
<body>
	
	<!-- 隐藏域 -->
	<input type="hidden" id="" value="" />
	
	<!-- 正文 -->
	<div class="auto_content">
		<div class="panel panel-primary">
			<div class="panel-heading">
			  <h3 class="panel-title">报表数据表导入</h3>
			</div>
			<div class="panel-body">
				<form class="form-group">
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="db_user">所属用户：</label>
							<div class="form-item-content">
								<select id="db_user" class="form-select form-select-width">
									<c:forEach var="item" items="${result.rptDbUsersList }" varStatus="status">
										<option value="${item.USER_CODE }">${item.USERNAME }</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="db_table_code">数据表名称：</label>
							<div class="form-item-content">
								<input type="text" id="db_table_code" class="form-input form-input-width" placeholder="请输入数据库表名" />
								<div id="db_table_list_box" class="db_table_list_box" style="display:none;">
									<ul id="db_table_list_ul" class="db_table_list_ul">
										<li>AP_RPT_CRM_CNTCT_DTL_D_ZJ</li>
									</ul>
								</div>
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="db_table_desc">数据表描述：</label>
							<div class="form-item-content">
								<input type="text" id="db_table_desc" class="form-input form-input-width" placeholder="请输入数据表描述"/>
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="split_flag">是否分表：</label>
							<div class="form-item-content">
								<input type="radio" id="split_flag" name="split_flag" class="form-radio" checked="checked" value="1"/>是 &nbsp;&nbsp;&nbsp;
								<input type="radio" id="split_flag" name="split_flag" class="form-radio" value="0"/>否
							</div>
						</div>
						<div class="form-item fn-left">
							<label class="form-label" for="split_code">分表变量：</label>
							<div class="form-item-content">
								<select id="split_code" class="form-select form-select-width">
										<option value="0">请选择分表变量</option>
									<c:forEach var="item" items="${result.splitCodeList }" varStatus="status">
										<option value="${item.VAR_CODE }">${item.VAR_CODE }</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>
					<div class="fn-clear">
						<div class="form-item fn-left">
							<label class="form-label" for="table_desc">口径描述：</label>
							<div class="form-item-content">
								<textarea id="table_desc" class="form-textarea"></textarea>
							</div>
						</div>
					</div>
					<div class="form-btn-group">
						<a id="save_btn" class="form-btn" onclick="saveTableInfo()">保存</a>
						<a id="back_btn" class="form-btn" onclick="backToPage()">返回</a>
					</div>
				</form>
			</div>
	    </div>
	</div>
</body>
</html>