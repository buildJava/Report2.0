package com.aiutil.report.daos;

import java.util.List;
import java.util.Map;

public interface ReportConfigDao {

	public abstract List<Map<String, Object>> qryRptDbUsersDao();

	public abstract List<Map<String, Object>> qrySplitCodeDao();

	public abstract List<Map<String, Object>> qryTableInfoByIdDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryReportInfoDao();

	public abstract List<Map<String, Object>> qryCdtInfoDao();

	public abstract List<Map<String, Object>> qrySysCodeDao(Map<String, Object> params);

}
