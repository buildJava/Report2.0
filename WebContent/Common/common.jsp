<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="shortcut icon" type="image/x-icon" href="${ctx }/Common/image/favicon.ico" media="screen" />
    <link rel="stylesheet" type="text/css" href="${ctx }/Common/css/Font-Awesome-3.2.1/css/font-awesome.min.css" />
    <script type="text/javascript" src="${ctx }/Common/js/jquery-3.0.0.min.js"></script>
    <script type="text/javascript" src="${ctx }/Common/js/jquery-ui.min.js"></script>
    
    <!-- 插件引入 -->
    <!-- 弹出窗插件 -->
	<link rel="stylesheet" type="text/css" href="${ctx}/Common/plugin/dialog/skins/simpopo.css">
	<script type="text/javascript" src="${ctx}/Common/plugin/dialog/artDialog.js"></script>
	<script type="text/javascript" src="${ctx}/Common/plugin/dialog/iframeTools.js"></script>
	<!-- 分页插件 -->
	<script type="text/javascript" src="${ctx}/Common/plugin/pagination/jquery.pagination.js"></script>
	<!-- juery.datatables.js -->
	<link rel="stylesheet" type="text/css" href="${ctx}/Common/plugin/DataTables/css/jquery.dataTables.min.css">
	<script type="text/javascript" src="${ctx}/Common/plugin/DataTables/jquery.dataTables.min.js"></script>
	<!-- 日历控件My97DatePicker -->
	<script type="text/javascript" src="${ctx}/Common/plugin/My97DatePicker/WdatePicker.js"></script>
	<!-- 文件上传插件 -->
	<script type="text/javascript" src="${ctx}/Common/js/ajaxfileupload.js"></script>
	
	<!-- 本地资源引入 -->
    <link rel="stylesheet" type="text/css" href="${ctx }/Common/css/common.css" />
    <script type="text/javascript" src="${ctx }/Common/js/common.js"></script>
    
</head>
