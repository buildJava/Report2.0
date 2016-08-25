package com.aiutil.report.actions;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.aiutil.report.utils.JSONHelper;
import com.aiutil.report.utils.StringUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class BaseAction {
	private static Logger logger = Logger.getLogger(BaseAction.class);	
	protected Map<String,Object> params;
	protected Map<String,Object> result;
	/**
	 * 构造基础Action
	 */
	@SuppressWarnings("unchecked")
	public BaseAction(){
		String paramstr = getParam("_params");
		logger.debug("new BaseAction()...paramstr="+paramstr);
		params = paramstr==null?new HashMap<String,Object>():JSONObject.fromObject(paramstr);
		result = new HashMap<String,Object>();
		result.put("fileTimeStamp", getTimeStamp());
	}
	/**
	 * 从request中获取参数
	 * @param str
	 * @return
	 */
	protected String getParam(String str){
		return ServletActionContext.getRequest().getParameter(str);
	}
	/**
	 * 从session中获取参数
	 * @param str
	 * @return
	 */
	protected String getStrFromSession(String str){
		HttpSession session = ServletActionContext.getRequest().getSession();
		Object obj = session.getAttribute(str);
		return obj==null?"":obj.toString();
	}
	/**
	 * 返回应用的servlet下下文
	 * @return
	 */
	protected ServletContext getServletContext() {
		ServletContext servletContext = ServletActionContext.getServletContext();
		return servletContext;
	}
	/**
	 * 获取web的根路径
	 * @return
	 */
	protected String getWebRootPath() {
		String classPath = this.getClass().getClassLoader().getResource("/").getPath();
		String rootPath = classPath.substring(0, classPath.indexOf("/WEB-INF/"));
		String webName = this.getServletContext().getContextPath();
		logger.info(rootPath.substring(0, rootPath.lastIndexOf(webName)));
		return rootPath.substring(0, rootPath.lastIndexOf(webName));
	}
	/**
	 * 设置session值
	 * @param key
	 * @param val
	 */
	protected void setValueForSession(String key, String val){
		HttpSession session = ServletActionContext.getRequest().getSession();
		session.setAttribute(key, val);;
	}
	/**
	 * 将requst中的参数转换为字符串
	 * @param str
	 * @return
	 */
	protected String str(String str){
		return params.get(str) == null ?"" : (params.get(str)+"").trim();
	}
	/**
	 * 将request中的参数转换为对象
	 * @param str
	 * @return
	 */
	protected Object get(String str){
		return params.get(str);
	}
	/**
	 * 从par这个Map对象中将获取的键值转换为String对象
	 * @param str
	 * @param par
	 * @return
	 */
	protected String str(String str,Map<String,Object> par){
		return par.get(str) == null ?"" : ((String)par.get(str)).trim();
	}
	/**
	 * 将request中的参数转换为Integer对象
	 * @param str
	 * @return
	 */
	protected Integer integer(String str){
		if(StringUtils.empty(str))
			return -1;
		
		try{
			return Integer.parseInt(params.get(str).toString());
		}catch(Exception e){
			e.printStackTrace();
			return -1;
		}
	}
	/**
	 * 从par这个Map对象中将获取的键值转换为Integer对象
	 * @param str
	 * @param par
	 * @return
	 */
	protected Integer integer(String str,Map<String,Object> par){
		if(StringUtils.empty(par.get(str)))
			return -1;
		try{
			return Integer.parseInt(par.get(str).toString());
		}catch(Exception e){
			e.printStackTrace();
			return -1;
		}
	}
	/**
	 * 将request中的参数转换为Long对象
	 * @param str
	 * @return
	 */
	protected Long toLong(String str){

		if(StringUtils.empty(str) || "".equals(params.get(str).toString().trim()))
			return -1L;
		
		try{
			return Long.parseLong(params.get(str).toString());
		}catch(Exception e){
			e.printStackTrace();
			return -1L;
		}
	}
	/**
	 * 将request中的参数转换为Date格式字符串
	 * @param str
	 * @return
	 */
	protected String date(String str) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat format2 = new SimpleDateFormat("yyyyMMdd");
		try {
			return format2.format( format.parse(params.get(str).toString()));
		} catch (ParseException e) {
			return "";
		}
	}
	/**
	 * 将request中的参数转换为List对象
	 * @param str
	 * @return
	 */
	@SuppressWarnings("unchecked")
	protected List<Map<String, Object>> list(String str){
		JSONArray jArray = JSONArray.fromObject(params.get(str));
		JSONHelper jHelper = new JSONHelper();
		return (List<Map<String, Object>>) jHelper.reflect(jArray);
	}
	/**
	 * 返回时间标签，用于标记文件版本
	 * @return
	 */
	protected String getTimeStamp(){
		SimpleDateFormat timeFormat = new SimpleDateFormat("yyMMddHHmmssSSS");
		Date sysTime = new Date();
		return timeFormat.format(sysTime);
	}
	/**
	 * 返回当前统计天，系统时间前一天,当前统计月，系统时间前一月
	 * @return
	 */
	protected String getDateFormat(String cycle, String formater, int converter){
		String dateFormat = "";
		SimpleDateFormat timeFormat = null;
		//得到日历
		Calendar calendar = Calendar.getInstance();
		if("day".equals(cycle)){
			calendar.add(Calendar.DATE, converter); //根据需要转换天
			Date date = calendar.getTime();
			timeFormat = new SimpleDateFormat(formater);
			dateFormat = timeFormat.format(date);
		}else if("month".equals(cycle)){
			calendar.add(Calendar.MONTH, converter); //根据需要转换天
			Date date = calendar.getTime();
			timeFormat = new SimpleDateFormat(formater);
			dateFormat = timeFormat.format(date);
		}
		return dateFormat;
	}
}
