package com.aiutil.report.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.log4j.Logger;

public class PropertiesUtils {
	private Logger logger = Logger.getLogger(PropertiesUtils.class);
	private String config = "application.properties";
	private Properties props = new Properties();
	//单例模式
	private static PropertiesUtils instance = new PropertiesUtils();
	
	private PropertiesUtils(){
		InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream(config);
		try {
			props.load(inputStream);
		} catch (IOException e) {
			logger.info("无法加载配置文件！");
			e.printStackTrace();
		}finally {
			try {
				inputStream.close();
			} catch (IOException e) {
				logger.info("无法关闭输入流");
				e.printStackTrace();
			}
		}
	}

	public static PropertiesUtils getInstance() {
		return instance;
	}

	public String getProperty(String key){
		logger.info("获取配置文件中"+key+"的属性！");
		return props.get(key).toString();
	}
}
