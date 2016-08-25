<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Marking project Eleks">
<meta name="author" content="Banakh Nazariy">
<link href="${ctx }/Common/css/error/404.css" rel="stylesheet" type="text/css">
<link href="${ctx }/Common/css/error/font_all.css" rel="stylesheet" type="text/css">
<title>Error 404</title>
</head>
<body>
	<div class="error_box_wrap">
        <div class="robot-wrap">
            <div class="robot-head">
                <div class="robot-head-with-gradient"></div>
                <div class="left-eye"></div>
                <div class="right-eye"></div>
                <div class="robot-mouth"></div>
            </div>
            <div class="robot-body-wrap">
                <div class="body-right-wire"></div>
                <div class="robot-body"></div>
                <div class="left-hand">
                    <div class="left-top-hand-brokenness"></div>
                    <div class="left-top-hand"></div>
                    <div class="left-bottom-hand"></div>
                </div>
                <div class="right-hand">
                    <div class="right-hand-wire"></div>
                    <div class="right-top-hand"></div>
                    <div class="right-bottom-hand"></div>
                </div>
                <div class="left-top-hand"></div>
            </div>
            <div class="right-hand-shadow"></div>
            <div class="robot-body-bottom-brokenness"></div>
            <div class="robot-body-bottom"></div>
        </div>
        <div class="error_box">
            <a class="logo" href="http://eleks.com/">
                <img alt="Eleks" src="image/error/eleks_logo_adm.png">
            </a>
            <p class="error-number">404</p>
            <p class="error-text">… Oops! Something is missing</p>
            <p class="go-home">
                <a href="${ctx }/app/personHome.do">个人工作台</a>
            </p>
      </div>
    </div>
</body>
</html>