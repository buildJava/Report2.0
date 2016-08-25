<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>索引页</title>
</head>
<body>
	<h2>索引</h2>
	<ul>
		<li><a href="${ctx }/report/reportConfigAction!reportConfig1.do">报表配置-保存元数据</a></li>
		<li><a href="${ctx }/report/reportConfigAction!reportConfig2.do">报表配置-元数据管理</a></li>
		<li><a href="${ctx }/report/reportConfigAction!reportConfig3.do?tbId=160812145641772">报表配置-元数据字段列表查看</a></li>
		<li><a href="${ctx }/report/reportConfigAction!reportConfig4.do">报表配置-报表管理</a></li>
		<li><a href="${ctx }/report/reportConfigAction!reportConfig5.do">报表配置-查询控件配置</a></li>
		<li><a href="${ctx }/report/reportConfigAction!reportConfig6.do">报表配置-报表配置</a></li>
		<li><a href="${ctx }/report/reportConfigAction!reportShow.do?rptId=160816165522871">报表配置-报表展示</a></li>
		<li><a href="${ctx }/report/reportConfigAction!downloadShow.do">报表下载页面</a></li>
		<li><a href="${ctx }/Common/error404.jsp">错误页面</a></li>
		<li><a href="${ctx }/Report/reportConfig/package.html">生成的html页面</a></li>
	</ul>
</body>
</html>