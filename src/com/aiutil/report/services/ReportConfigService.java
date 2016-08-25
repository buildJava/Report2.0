package com.aiutil.report.services;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.aiutil.report.daos.ReportConfigDao;

@Service("reportConfigService")
public class ReportConfigService {
	
	@Autowired
	private ReportConfigDao reportConfigDao;
	/**
	 * 查询数据库用户列表
	 * @return
	 */
	public List<Map<String, Object>> qryRptDbUsersService(){
		return reportConfigDao.qryRptDbUsersDao();
	}
	/**
	 * 查询分表变量列表
	 * @return
	 */
	public List<Map<String, Object>> qrySplitCodeService() {
		return reportConfigDao.qrySplitCodeDao();
	}
	/**
	 * 根据元数据ID查询元数据
	 * @param rptId
	 * @return
	 */
	public Map<String, Object> qryTableInfoByIdService(String tbId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tbId", tbId);
		List<Map<String, Object>> tableInfoList = reportConfigDao.qryTableInfoByIdDao(params);
		Map<String, Object> tableInfo = tableInfoList.get(0);
		return tableInfo;
	}
	/**
	 * 查询报表配置信息
	 * @param params
	 * @return 
	 */
	public List<Map<String, Object>> qryReportInfoService() {
		return reportConfigDao.qryReportInfoDao();
	}
	/**
	 * 查询报表查询控件配置信息
	 * @return
	 */
	public List<Map<String, Object>> qryCdtInfoService() {
		return reportConfigDao.qryCdtInfoDao();
	}
	/**
	 * 查询维值
	 * @return
	 */
	public List<Map<String, Object>> qrySysCodeService(String codeTypeId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codeTypeId", codeTypeId);
		return reportConfigDao.qrySysCodeDao(params);
	}
}
