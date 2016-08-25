package com.aiutil.report.daos;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.aiutil.report.entities.ReportModel;

public interface ReportConfigJsonDao {

	public abstract List<Map<String, Object>> qryDataListDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryDbTableNameDao(Map<String, Object> params);

	public abstract void saveTableInfoDao(Map<String, Object> params);

	public abstract void insertTableFieldDao(Map<String, Object> params);
	
	public abstract void flushTableFieldDao(Map<String, Object> params);

	public abstract void mergeTableFieldDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryTableInfoDao(Map<String, Object> params);

	public abstract int qryTableInfoCountDao(Map<String, Object> params);

	public abstract void deleteTableInfoDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryTableFieldByIdDao(Map<String, Object> params);

	public abstract int qryTableFieldByCodeDao(Map<String, Object> params);
	
	public abstract int qryTableFieldCountByIdDao(Map<String, Object> params);

	public abstract void updateTableFieldDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> openTableFieldDao(Map<String, Object> params);

	public abstract void addTableFieldDao(Map<String, Object> params);

	public abstract void modifyTableFieldDao(Map<String, Object> params);

	public abstract void deleteTableFieldDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryReportInfoDao();

	public abstract List<Map<String, Object>> qryConditionDao();

	public abstract void saveConditionDao(Map<String, Object> params);

	public abstract void updateConditionDao(Map<String, Object> params);

	public abstract void deleteConditionDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryTableInfoByInputDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryTableFieldByTbIdDao(Map<String, Object> params);

	public abstract void saveReportConditionDao(Map<String, Object> params);

	public abstract void saveReportInfoDao(Map<String, Object> params);

	public abstract void saveReportFieldDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryReportInfoByIdDao(Map<String, Object> params);

	public abstract void deleteReportInfoByIdDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryRptCdtInfoListDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryRptFieldListDao(Map<String, Object> params);

	public abstract void deleteReportConditionByIdDao(Map<String, Object> params);

	public abstract void deleteReportFieldByIdDao(Map<String, Object> params);

	public abstract void updateReportInfoByIdDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryReportDataListDao(Map<String, Object> params);

	public abstract int qryReportDataCountDao(Map<String, Object> params);

	public abstract void insertModelInfoDao(Map<String, Object> params);

	public abstract void insertModelSqlDao(Map<String, Object> params);

	public abstract void updateModelSqlDao(Map<String, Object> params);

	public abstract void insertReportModelDao(Map<String, Object> params);

	public abstract void deleteReportModelDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryRptModelInfoDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryVarListDao(Map<String, Object> params);

	public abstract void updateModelInfoDao(Map<String, Object> params);

	public abstract ReportModel qryReportModelDao(Map<String, Object> params);

	public abstract List<LinkedHashMap<String, Object>> qryDataBySqlDao(Map<String, Object> params);

	public abstract int qryDataBySqlCountDao(Map<String, Object> params);

	public abstract void insertDownloadInfoDao(Map<String, Object> params);

	public abstract List<Map<String, Object>> qryDownloadInfoListDao(Map<String, Object> params);

	public abstract int qryDownloadInfoCountDao(Map<String, Object> params);

}
