package com.aiutil.report.services;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.aiutil.report.daos.ReportConfigJsonDao;
import com.aiutil.report.entities.ReportModel;
@Service("reportConfigJsonService")
public class ReportConfigJsonService {
	
	@Autowired
	private ReportConfigJsonDao reportConfigJsonDao;
	
	/**
	 * 动态sql查询数据
	 * @param sql
	 * @param orderBy 
	 * @param orderBy2 
	 * @param patValue 
	 * @return
	 */
	public List<Map<String, Object>> qryDataListService(String bodySql, String whereSql, String patValue, String orderBy) {
		String sql = "";
		String[] patValueArray = patValue.split(",");
		if(!patValue.isEmpty()){
			whereSql += " (";
			for(int i=0; i<patValueArray.length; i++){
				if(i>=1){
					whereSql += ",";
				}
				whereSql += "'"+patValueArray[i]+"'";
			}
			whereSql += ")";
			sql += bodySql + " " + whereSql + orderBy;
		}else{
			sql += bodySql + orderBy;
		}
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sql", sql);
		return reportConfigJsonDao.qryDataListDao(params);
	}
	/**
	 * 响应数据表名称的输入动态搜索
	 * @return
	 */
	public List<Map<String, Object>> qryDbTableNameService(Map<String, Object> params) {
		return reportConfigJsonDao.qryDbTableNameDao(params);
	}
	/**
	 * 保存报表元数据
	 * @param params
	 */
	public void saveTableInfoService(Map<String, Object> params) {
		reportConfigJsonDao.saveTableInfoDao(params);
	}
	/**
	 * 保存报表字段列表数据
	 * @param params
	 */
	public void createTableFieldService(Map<String, Object> params) {
		reportConfigJsonDao.insertTableFieldDao(params);
	}
	/**
	 * 更新报表字段列表数据
	 * @param params
	 */
	public void updateTableFieldService(Map<String, Object> params) {
		
	}
	/**
	 * 查询报表元数据列表
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> qryTableInfoService(Map<String, Object> params) {
		return reportConfigJsonDao.qryTableInfoDao(params);
	}
	/**
	 * 查询报表元数据记录数
	 * @param params
	 * @return
	 */
	public int qryTableInfoCountService(Map<String, Object> params) {
		return reportConfigJsonDao.qryTableInfoCountDao(params);
	}
	/**
	 * 删除报表元数据
	 * @param tbId
	 */
	public void deleteTableInfoService(String tbId) {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tbId", tbId);
		
		reportConfigJsonDao.deleteTableInfoDao(params);
	}
	/**
	 * 根据元数据ID查看字段列表
	 * @param tbId
	 * @return
	 */
	public List<Map<String, Object>> qryTableFieldByIdService(String tbId, String startIndex, String endIndex) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tbId", tbId);
		params.put("startIndex", startIndex);
		params.put("endIndex", endIndex);
		List<Map<String, Object>> tableFieldList = reportConfigJsonDao.qryTableFieldByIdDao(params);
		return tableFieldList;
	}
	/**
	 * 查询元数据字段列表记录数
	 * @param tbId
	 * @return
	 */
	public int qryTableFieldCountByIdService(String tbId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tbId", tbId);
		
		return reportConfigJsonDao.qryTableFieldCountByIdDao(params);
	}
	/**
	 * 按照字段编码查询元数据中字段是否存在
	 * @param params
	 * @return
	 */
	public int qryTableFieldByCodeService(Map<String, Object> params) {
		return reportConfigJsonDao.qryTableFieldByCodeDao(params);
	}
	/**
	 * 根据元数据字段ID删除字段
	 * @param tbId
	 */
	public void updateTableFieldService(String tbId, String fieldId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tbId", tbId);
		params.put("fieldId", fieldId);
		reportConfigJsonDao.updateTableFieldDao(params);
	}
	/**
	 * 打开元数据字段详细信息
	 * @param fieldId
	 */
	public Map<String, Object> openTableFieldService(String fieldId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fieldId", fieldId);
		List<Map<String, Object>> tableFieldList = reportConfigJsonDao.openTableFieldDao(params);
		return tableFieldList.get(0);
	}
	/**
	 * 保存元数据字段信息
	 * @param params
	 */
	public void saveTableFieldService(String addOrModify, Map<String, Object> params) {
		//执行新增或者修改
		if("1".equals(addOrModify)){
			reportConfigJsonDao.addTableFieldDao(params);
		}else if("0".equals(addOrModify)){
			reportConfigJsonDao.modifyTableFieldDao(params);
		}
	}
	/**
	 * 刷新报表元数据
	 * @param tbId
	 */
	public void flushTableFieldService(String tbId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tbId", tbId);
		//首先把原来的更新成失效
		reportConfigJsonDao.updateTableFieldDao(params);
		//重新插入数据
		reportConfigJsonDao.insertTableFieldDao(params);
		//使用旧的元数据更新新的元数据
		reportConfigJsonDao.mergeTableFieldDao(params);
		//删除元数据字段列表中的数据
		reportConfigJsonDao.deleteTableFieldDao(params);
	}
	/**
	 * 查询报表配置信息
	 * @param params
	 * @return 
	 */
	public List<Map<String, Object>> qryReportInfoService() {
		return reportConfigJsonDao.qryReportInfoDao();
	}
	/**
	 * 保存控件信息
	 * @param params
	 */
	public void saveConditionService(Map<String, Object> params) {
		if("1".equals(params.get("addOrModify"))){
			reportConfigJsonDao.updateConditionDao(params);
		}else{
			reportConfigJsonDao.saveConditionDao(params);
		}
	}
	/**
	 * 查询控件信息
	 * @return
	 */
	public List<Map<String, Object>> qryConditionService() {
		return reportConfigJsonDao.qryConditionDao();
	}
	/**
	 * 删除控件信息
	 * @param params
	 */
	public void deleteConditionService(Map<String, Object> params) {
		reportConfigJsonDao.deleteConditionDao(params);
	}
	/**
	 * 根据输入的内容模糊查询报表元数据
	 * @param inputVal
	 * @return
	 */
	public List<Map<String, Object>> qryTableInfoByInputService(String inputVal) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("inputVal", inputVal);
		return reportConfigJsonDao.qryTableInfoByInputDao(params);
	}
	/**
	 * 查询报表元数据的字段列表
	 * @param tbId
	 * @return
	 */
	public List<Map<String, Object>> qryTableFieldByTbIdService(String tbId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tbId", tbId);
		return reportConfigJsonDao.qryTableFieldByTbIdDao(params);
	}
	/**
	 * 保存报表配置信息
	 * @param params
	 */
	public void saveReportInfoService(Map<String, Object> params) {
		if("1".equals(params.get("addOrModify"))){
			reportConfigJsonDao.deleteReportInfoByIdDao(params);
			reportConfigJsonDao.saveReportInfoDao(params);
		}else{
			reportConfigJsonDao.saveReportInfoDao(params);
		}
		
	}
	/**
	 * 报表查询条件配置
	 * @param cdtInfo
	 */
	public void saveReportConditionService(Map<String, Object> params) {
		reportConfigJsonDao.saveReportConditionDao(params);
	}
	/**
	 * 删除报表查询条件配置
	 * @param params
	 */
	public void deleteReportConditionByIdService(Map<String, Object> params){
		reportConfigJsonDao.deleteReportConditionByIdDao(params);
	}
	/**
	 * 保存报表的字段信息
	 * @param params
	 */
	public void saveReportFieldService(Map<String, Object> params) {
		if("1".equals(params.get("addOrModify"))){
			reportConfigJsonDao.deleteReportFieldByIdDao(params);
			reportConfigJsonDao.saveReportFieldDao(params);
		}else{
			reportConfigJsonDao.saveReportFieldDao(params);
		}
	}
	/**
	 * 根据rptId查询报表信息
	 * @param rptId
	 * @return
	 */
	public Map<String, Object> qryReportInfoByIdService(String rptId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rptId", rptId);
		return reportConfigJsonDao.qryReportInfoByIdDao(params).get(0);
	}
	/**
	 * 根据rptId查询报表信息
	 * @param rptId
	 * @return
	 */
	public List<Map<String, Object>> qryRptCdtInfoListService(String rptId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rptId", rptId);
		return reportConfigJsonDao.qryRptCdtInfoListDao(params);
	}
	/**
	 * 根据rptId查询报表信息
	 * @param rptId
	 * @return
	 */
	public List<Map<String, Object>> qryRptFieldListService(String rptId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rptId", rptId);
		return reportConfigJsonDao.qryRptFieldListDao(params);
	}
	/**
	 * 根据rptId删除报表信息
	 * @param rptId
	 * @param rptStatus 
	 */
	public void deleteReportInfoByIdService(String rptId, String rptStatus) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rptId", rptId);
		params.put("rptStatus", rptStatus);
		reportConfigJsonDao.updateReportInfoByIdDao(params);
	}
	/**
	 * 根据rptId重新启用报表
	 * @param rptId
	 */
	public void reUseReportInfoByIdService(String rptId, String rptStatus) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rptId", rptId);
		params.put("rptStatus", rptStatus);
		reportConfigJsonDao.updateReportInfoByIdDao(params);
	}
	/**
	 * 查询表头及字段选择列表重载的方法-只有报表ID
	 * @param rptId
	 * @return
	 */
	public List<Map<String, Object>> qryReportFieldListService(String rptId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rptId", rptId);
		return reportConfigJsonDao.qryRptFieldListDao(params);
	}
	/**
	 * 查询表头及字段选择列表重载的方法-有报表ID及字段列表ID
	 * @param rptId
	 * @return
	 */
	public List<Map<String, Object>> qryReportFieldListService(String rptId, String rptFieldIdList) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rptId", rptId);
		String[] rptFieldIdArray = rptFieldIdList.split(",");
		params.put("rptFieldIdArray", rptFieldIdArray);
		return reportConfigJsonDao.qryRptFieldListDao(params);
	}
	/**
	 * 根据构建查询的要素查询报表数据记录
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> qryReportDataListService(Map<String, Object> params) {
		return reportConfigJsonDao.qryReportDataListDao(params);
	}
	/**
	 * 根据构建查询的要素查询报表数据记录数
	 * @param params
	 * @return
	 */
	public int qryReportDataCountService(Map<String, Object> params) {
		return reportConfigJsonDao.qryReportDataCountDao(params);
	}
	/**
	 * 存储模板信息
	 * @param params
	 */
	public void insertModelInfoService(Map<String, Object> params) {
		reportConfigJsonDao.insertModelInfoDao(params);
	}
	/**
	 * 把sql变量信息插入到数据库
	 * @param varList
	 */
	public void insertModelSqlService(Map<String, Object> params) {
		reportConfigJsonDao.insertModelSqlDao(params);
	}
	/**
	 * 更新模板的sql
	 * @param params
	 */
	public void updateModelSqlService(Map<String, Object> params) {
		reportConfigJsonDao.updateModelSqlDao(params);
	}
	/**
	 * 删除旧的报表与模板关系
	 * @param params
	 */
	public void deleteReportModelService(Map<String, Object> params) {
		reportConfigJsonDao.deleteReportModelDao(params);
	}
	/**
	 * 保存报表与模板的对应关系
	 * @param params
	 */
	public void insertReportModelService(Map<String, Object> params) {
		reportConfigJsonDao.insertReportModelDao(params);
	}
	/**
	 * 查询报表模板信息
	 * @param params
	 * @return
	 */
	public Map<String, Object> qryRptModelInfoService(Map<String, Object> params) {
		List<Map<String, Object>> rptModelInfo = reportConfigJsonDao.qryRptModelInfoDao(params);
		if(rptModelInfo.size() >0){
			return rptModelInfo.get(0);
		}else{
			return null;
		}
	}
	/**
	 * 查询模板对应的变量列表信息
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> qryVarListService(Map<String, Object> params) {
		return reportConfigJsonDao.qryVarListDao(params);
	}
	/**
	 * 更新模板是否可翻页
	 * @param params
	 */
	public void updateModelInfoService(Map<String, Object> params) {
		reportConfigJsonDao.updateModelInfoDao(params);
	}
	/**
	 * 查询的报表的模板代码
	 * @param params
	 * @return
	 */
	public ReportModel qryReportModelService(String rptId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rptId", rptId);
		return reportConfigJsonDao.qryReportModelDao(params);
	}
	/**
	 * 查询每个变量对应的数据
	 * @param params
	 */
	public List<LinkedHashMap<String, Object>> qryDataBySqlService(Map<String, Object> params) {
		return reportConfigJsonDao.qryDataBySqlDao(params);
	}
	/**
	 * 查询每个变量对应的数据量
	 * @param params
	 * @return
	 */
	public int qryDataBySqlCountService(Map<String, Object> params) {
		return reportConfigJsonDao.qryDataBySqlCountDao(params);
	}
	/**
	 * 插入下载记录信息
	 * @param params
	 */
	public void insertDownloadInfoService(Map<String, Object> params) {
		reportConfigJsonDao.insertDownloadInfoDao(params);
	}
	/**
	 * 查询下载清单
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> qryDownloadInfoListService(Map<String, Object> params) {
		return reportConfigJsonDao.qryDownloadInfoListDao(params);
	}
	/**
	 * 查询下载清单记录数
	 * @param params
	 * @return
	 */
	public int qryDownloadInfoCountService(Map<String, Object> params) {
		return reportConfigJsonDao.qryDownloadInfoCountDao(params);
	}
}
