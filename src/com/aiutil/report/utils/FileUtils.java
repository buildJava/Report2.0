package com.aiutil.report.utils;

import java.io.File;
import java.io.IOException;

import org.apache.log4j.Logger;

public class FileUtils {

	private static Logger logger = Logger.getLogger(PropertiesUtils.class);

	private static FileUtils instance = new FileUtils();

	private FileUtils() {
	}

	public static FileUtils getInstance() {
		return instance;
	}

	public File createFile(String destFileName) {
		File file = new File(destFileName);
		if (file.exists()) {
			logger.info("创建单个文件" + destFileName + "失败，目标文件已存在！");
		}
		if (destFileName.endsWith(File.separator)) {
			logger.info("创建单个文件" + destFileName + "失败，目标文件不能为目录！");
		}
		// 判断目标文件所在的目录是否存在
		if (!file.getParentFile().exists()) {
			// 如果目标文件所在的目录不存在，则创建父目录
			logger.info("目标文件所在目录不存在，准备创建它！");
			if (!file.getParentFile().mkdirs()) {
				logger.info("创建目标文件所在目录失败！");
			}
		}
		// 创建目标文件
		try {
			if (file.createNewFile()) {
				logger.info("创建单个文件" + destFileName + "成功！");
			} else {
				logger.info("创建单个文件" + destFileName + "失败！");
			}
		} catch (IOException e) {
			e.printStackTrace();
			logger.info("创建单个文件" + destFileName + "失败！" + e.getMessage());
		}
		return file;
	}

	public File createDir(String destDirName) {
		File dir = new File(destDirName);
		if (dir.exists()) {
			logger.info("创建目录" + destDirName + "失败，目标目录已经存在");
		}
		if (!destDirName.endsWith(File.separator)) {
			destDirName = destDirName + File.separator;
		}
		// 创建目录
		if (dir.mkdirs()) {
			logger.info("创建目录" + destDirName + "成功！");
		} else {
			logger.info("创建目录" + destDirName + "失败！");
		}
		return dir;
	}

	public String createTempFile(String prefix, String suffix, String dirName) {
		File tempFile = null;
		if (dirName == null) {
			try {
				// 在默认文件夹下创建临时文件
				tempFile = File.createTempFile(prefix, suffix);
				// 返回临时文件的路径
				return tempFile.getCanonicalPath();
			} catch (IOException e) {
				e.printStackTrace();
				logger.info("创建临时文件失败！" + e.getMessage());
				return null;
			}
		} else {
			File dir = new File(dirName);
			// 如果临时文件所在目录不存在，首先创建
			if (!dir.exists()) {
				if (createDir(dirName) != null) {
					logger.info("创建临时文件失败，不能创建临时文件所在的目录！");
					return null;
				}
			}
			try {
				// 在指定目录下创建临时文件
				tempFile = File.createTempFile(prefix, suffix, dir);
				return tempFile.getCanonicalPath();
			} catch (IOException e) {
				e.printStackTrace();
				logger.info("创建临时文件失败！" + e.getMessage());
				return null;
			}
		}
	}

}
