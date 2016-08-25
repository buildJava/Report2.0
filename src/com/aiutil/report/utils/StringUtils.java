package com.aiutil.report.utils;

public class StringUtils {
	/**
	 * 判断字符串是否为空
	 * @param obj
	 * @return
	 */
	public static boolean empty(Object obj){		
		return obj == null || "".equals(obj+"");
	}
	/**
	 * 判断字符串是否非空
	 * @param obj
	 * @return
	 */
	public static boolean notEmpty(Object obj){
		return !empty(obj);
	}
}
