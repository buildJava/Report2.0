package com.aiutil.report.actions;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;

import com.aiutil.report.services.ReportConfigJsonService;
import com.aiutil.report.services.ReportConfigService;
import com.aiutil.report.utils.ExcelUtils;
import com.aiutil.report.utils.PropertiesUtils;
import com.aiutil.report.utils.StringUtils;
import com.aiutil.report.utils.ToHtml;

/**
 * ReportConfigJsonAction
 * @Description: 报表配置的json数据处理Action
 * 要实现文件上传，必须要求1.jsp页面中文件标签的name 例如：excelFile action中定义的 File excelFile, String excelFileFileName, String excelFileContentType必须是一致
 * 满足以上条件时，struts2自身的fileUploadFilter拦截器会自动装载文件，如果需要指定临时文件的上传地址可以在struts2中配置struts.multipart.saveDir，还可配置上传文件的最大限制
 * @author zhangrui
 * @date 2016年5月19日 下午5:55:49
 */
@ParentPackage("json-default")
@Namespace("/report/json")
@Action("reportConfigJsonAction")
@Result(type="json")
public class ReportConfigJsonAction extends BaseAction {
	
	/**
	 * 记录日志
	 */
	private Logger logger = Logger.getLogger(ReportConfigJsonAction.class);
	private final int MAX_ONETIME_COUNT = 1000; //下载数据一次最大下载量
	@Resource(name="reportConfigService")
	private ReportConfigService reportConfigService;
	@Resource(name="reportConfigJsonService")
	private ReportConfigJsonService reportConfigJsonService;
	
	//需要上传的文件名列表
	private File modelFile;
	private String modelFileFileName;
	private String modelFileContentType;

	public File getModelFile() {
		return modelFile;
	}

	public void setModelFile(File modelFile) {
		this.modelFile = modelFile;
	}
	
	public String getModelFileFileName() {
		return modelFileFileName;
	}

	public void setModelFileFileName(String modelFileFileName) {
		this.modelFileFileName = modelFileFileName;
	}

	public String getModelFileContentType() {
		return modelFileContentType;
	}

	public void setModelFileContentType(String modelFileContentType) {
		this.modelFileContentType = modelFileContentType;
	}

	/**
	 * 默认调用的execute方法
	 * @return
	 */
	public String execute(){
		logger.info("execute()");
		try{
			return "success";
		}catch(Exception e){
			e.printStackTrace();
			return "error";
		}
	}
	
	/**
	 * 提供给Struts2的反射方法用来将数据反馈给应用
	 * @return result
	 */
	public Map<String, Object> getResult(){
		return result;
	}
	/**
	 * 动态sql查询数据
	 * @return
	 */
	public String qryDataList(){
		String bodySql = str("bodySql");
		String whereSql = str("whereSql");
		String patValue = str("patValue");
		String orderBy = " ORDER BY KEY_";
		List<Map<String, Object>> dataList = reportConfigJsonService.qryDataListService(bodySql, whereSql, patValue, orderBy);
		result.put("dataList", dataList);
		return "success";
	}
	/**
	 * 响应数据表名称的输入动态搜索
	 * @return
	 */
	public String qryDbTableName(){
		String owner = str("owner");
		String tableName = str("tableName").toUpperCase();
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("owner", owner);
		params.put("tableName", tableName);
		
		List<Map<String, Object>> dbTableList = reportConfigJsonService.qryDbTableNameService(params);
		
		result.put("dbTableList", dbTableList);
		return "success";
	}
	/**
	 * 保存报表元数据
	 * @return
	 */
	public String saveTableInfo(){
		String tbId = super.getTimeStamp();
		String tbName = str("tbName");
		String tbCode = str("tbCode").toUpperCase();
		String tbOwner = str("tbOwner");
		String tbDesc = str("tbDesc");
		String splitFlag = str("splitFlag");
		String splitCode = str("splitCode");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tbId", tbId);
		params.put("tbName", tbName);
		params.put("tbCode", tbCode);
		params.put("tbOwner", tbOwner);
		params.put("tbDesc", tbDesc);
		params.put("splitFlag", splitFlag);
		params.put("splitCode", splitCode);
		//保存报表元数据
		reportConfigJsonService.saveTableInfoService(params);
		//保存报表字段列表数据
		reportConfigJsonService.createTableFieldService(params);
		return "success";
	}
	/**
	 * 查询报表元数据列表
	 * @return
	 */
	public String qryTableInfo(){
		String tbName = str("tbName");
		String fieldName = str("fieldName");
		String tbOwner = str("tbOwner");
		String tbCode = str("tbCode").toUpperCase();
		String startIndex = str("startIndex");
		String endIndex = str("endIndex");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tbName", tbName);
		params.put("fieldName", fieldName);
		params.put("tbOwner", tbOwner);
		params.put("tbCode", tbCode);
		params.put("startIndex", startIndex);
		params.put("endIndex", endIndex);
		
		//查询报表元数据列表
		List<Map<String, Object>> tableInfoList = reportConfigJsonService.qryTableInfoService(params);
		
		result.put("tableInfoList", tableInfoList);
		return "success";
	}
	/**
	 * 查询报表元数据记录数
	 * @return
	 */
	public String qryTableInfoCount(){
		String tbName = str("tbName");
		String fieldName = str("fieldName");
		String tbOwner = str("tbOwner");
		String tbCode = str("tbCode").toUpperCase();

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tbName", tbName);
		params.put("fieldName", fieldName);
		params.put("tbOwner", tbOwner);
		params.put("tbCode", tbCode);
		
		//查询报表元数据列表
		int tableInfoCount = reportConfigJsonService.qryTableInfoCountService(params);
		
		result.put("tableInfoCount", tableInfoCount);
		return "success";
	}
	/**
	 * 删除报表元数据
	 * @return
	 */
	public String deleteTableInfo(){
		String tbId = str("tbId");
		//删除报表元数据
		reportConfigJsonService.deleteTableInfoService(tbId);
		
		return "success";
	}
	/**
	 * 查询元数据字段列表
	 * @return
	 */
	public String qryTableFieldById(){
		String tbId = str("tbId");
		String startIndex = str("startIndex");
		String endIndex = str("endIndex");
		
		List<Map<String, Object>> tableFieldList = reportConfigJsonService.qryTableFieldByIdService(tbId, startIndex, endIndex);
		result.put("tableFieldList", tableFieldList);
		return "success";
	}
	/**
	 * 查询元数据字段列表记录数
	 * @return
	 */
	public String qryTableFieldCountById(){
		String tbId = str("tbId");
		int tableFieldCount = reportConfigJsonService.qryTableFieldCountByIdService(tbId);
		result.put("tableFieldCount", tableFieldCount);
		return "success";
	}
	/**
	 * 根据元数据字段ID删除字段
	 * @return
	 */
	public String deleteTableField(){
		String tbId = str("tbId");
		String fieldId = str("fieldId");
		//根据元数据字段ID删除字段
		reportConfigJsonService.updateTableFieldService(tbId, fieldId);
		return "success";
	}
	/**
	 * 打开元数据字段详细信息
	 * @return
	 */
	public String openTableField(){
		String fieldId = str("fieldId");
		//打开元数据字段详细信息
		Map<String, Object> tableField = reportConfigJsonService.openTableFieldService(fieldId);
		
		result.put("tableField", tableField);
		return "success";
	}
	/**
	 * 保存元数据字段信息
	 * @return
	 */
	public String saveTableField(){
		String tbId = str("tbId");
		String addOrModify = str("addOrModify");
		String displayOrder = str("displayOrder");
		String fieldId = str("fieldId")==null||str("fieldId").isEmpty()?(tbId+displayOrder):str("fieldId");
		String fieldCode = str("fieldCode").toUpperCase();
		String fieldName = str("fieldName");
		String fieldType = str("fieldType").toUpperCase();
		String fieldLength = str("fieldLength");
		String isDim = str("isDim");
		String groupValue = str("groupValue");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tbId", tbId);
		params.put("fieldId", fieldId);
		params.put("displayOrder", displayOrder);
		params.put("fieldCode", fieldCode);
		params.put("fieldName", fieldName);
		params.put("fieldType", fieldType);
		params.put("fieldLength", fieldLength);
		params.put("isDim", isDim);
		params.put("groupValue", groupValue);
		
		//假设是存在这个字段的
		int fieldCnt = 1;
		//如果是新增判断下是否是存在的字段，如果存在则直接增加，如果不存在只能增加值字段，且他所对应的聚合函数中的字也必须存在
		if("1".equals(addOrModify)){
			//按照字段编码查询元数据中字段是否存在
			fieldCnt = reportConfigJsonService.qryTableFieldByCodeService(params);
		}
		String warnMsg = "";
		//修改标识
		int status = 0;
		if(fieldCnt == 0 && "1".equals(isDim)){
			status = -1;
			warnMsg = "新增字段在元数据中不存在，则只能是值，不能是维度，且聚合公式必须填写，所依赖字段必须是元数据中存在的字段！";
		}else if(fieldCnt == 0 && "0".equals(isDim) && groupValue.isEmpty()){
			status = -1;
			warnMsg = "新增元数据不存在的字段，其聚合公式必须填写，所依赖字段必须是元数据中存在的字段！";
		}else{
			//条件均满足后才能执行新增或者修改
			reportConfigJsonService.saveTableFieldService(addOrModify, params);
			warnMsg = "元数据字段操作成功！";
			status = 1;
		}
		result.put("warnMsg", warnMsg);
		result.put("status", status);
		
		return "success";
	}
	/**
	 * 刷新报表元数据
	 * @return
	 */
	public String flushTableField(){
		String tbId = str("tbId");
		
		reportConfigJsonService.flushTableFieldService(tbId);
		
		return "success";
	}
	/**
	 * 查询报表配置信息
	 * @return
	 */
	public String qryReportInfo(){
		List<Map<String, Object>> reportInfoList = reportConfigJsonService.qryReportInfoService();
		result.put("reportInfoList", reportInfoList);
		return "success";
	}
	/**
	 * 查询报表查询控件配置信息
	 * @return
	 */
	public String qryCondition(){
		List<Map<String, Object>> cdtInfoList = reportConfigJsonService.qryConditionService();
		result.put("cdtInfoList", cdtInfoList);
		//查询控件的展现类型
		List<Map<String, Object>> cdtShowTypeList = reportConfigService.qrySysCodeService("CDT_SHOW_TYPE");
		result.put("cdtShowTypeList", cdtShowTypeList);
		//查询控件的计算方式
		List<Map<String, Object>> cdtCalList = reportConfigService.qrySysCodeService("CDT_CAL_TYPE");
		result.put("cdtCalList", cdtCalList);
		return "success";
	}
	/**
	 * 保存控件信息
	 * @return
	 */
	public String saveCondition(){
		//增加或者修改，0增加，1修改
		String addOrModify = str("addOrModify");
		String cdtId = "";
		if("1".equals(addOrModify)){
			cdtId = str("cdtId");
		}else{
			cdtId = getTimeStamp();
		}
		String cdtCode = str("cdtCode");
		String cdtName = str("cdtName");
		String cdtDesc = str("cdtDesc");
		String cdtCalType = str("cdtCalType");
		String cdtShowType = str("cdtShowType");
		String cdtSql = str("cdtSql");
		String patCdtId = str("patCdtId");
		String patColCode = str("patColCode");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("addOrModify", addOrModify);
		params.put("cdtId", cdtId);
		params.put("cdtCode", cdtCode);
		params.put("cdtName", cdtName);
		params.put("cdtDesc", cdtDesc);
		params.put("cdtCalType", cdtCalType);
		params.put("cdtShowType", cdtShowType);
		params.put("cdtSql", cdtSql);
		params.put("patCdtId", patCdtId);
		params.put("patColCode", patColCode);
		
		reportConfigJsonService.saveConditionService(params);
		
		return "success";
	}
	/**
	 * 删除控件信息
	 * @return
	 */
	public String deleteCondition(){
		String cdtId = str("cdtId");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cdtId", cdtId);
		reportConfigJsonService.deleteConditionService(params);
		return "success";
	}
	/**
	 * 根据输入的内容模糊查询报表元数据
	 * @return
	 */
	public String qryTableInfoByInput(){
		String inputVal = str("inputVal").toUpperCase();
		List<Map<String, Object>> tableInfoList = reportConfigJsonService.qryTableInfoByInputService(inputVal);
		result.put("tableInfoList", tableInfoList);
		return "success";
	}
	/**
	 * 查询报表元数据的字段列表
	 * @return
	 */
	public String qryTableFieldByTbId(){
		String tbId = str("tbId");
		List<Map<String, Object>> tableFieldList = reportConfigJsonService.qryTableFieldByTbIdService(tbId);
		result.put("tableFieldList", tableFieldList);
		return "success";
	}
	/**
	 * 保存报表配置
	 * @return
	 */
	public String saveReport(){
		String addOrModify = str("addOrModify");
		String rptId = "";
		if("1".equals(addOrModify)){
			rptId = str("rptId");
		}else{
			rptId = getTimeStamp();
		}
		String rptName = str("rptName");
		String ifDownload = str("ifDownload");
		String rptCycle = str("rptCycle");
		String rptDesc = str("rptDesc");
		
		String rptType = str("rptType");
		String tbId = str("tbId");
		String[] selectFieldList = str("selectFieldListInfo").split(",");
		String[] orderFieldList = str("orderFieldListInfo").split(",");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("addOrModify", addOrModify);
		params.put("rptId", rptId);
		params.put("rptName", rptName);
		params.put("ifDownload", ifDownload);
		params.put("rptCycle", rptCycle);
		params.put("rptDesc", rptDesc);
		params.put("rptType", rptType);
		params.put("tbId", tbId);
		params.put("selectFieldList", selectFieldList);
		params.put("orderFieldList", orderFieldList);
		//保存报表配置信息
		reportConfigJsonService.saveReportInfoService(params);
		
		//报表查询条件配置
		List<Map<String, Object>> cdtInfoList = list("cdtInfoList");
		Iterator<Map<String, Object>> cdtItr = cdtInfoList.iterator();
		//如果是修改先删除报表查询条件配置
		if(addOrModify.equals("1")){
			reportConfigJsonService.deleteReportConditionByIdService(params);
		}
		while(cdtItr.hasNext()){
			Map<String, Object> cdtInfo = cdtItr.next();
			cdtInfo.put("rptId", rptId);
			cdtInfo.put("addOrModify", addOrModify);
			reportConfigJsonService.saveReportConditionService(cdtInfo);
		}
		//按照类型执行不同的插入操作1单表头， 2多表头的需要插入模板的相关信息
		if("1".equals(rptType)){
			//保存报表的字段信息
			reportConfigJsonService.saveReportFieldService(params);
		}else if("2".equals(rptType)){
			//多表头模板相关
			String modelId = str("modelId");
			String ifPage = str("ifPage");
			List<Map<String, Object>> varSqlList = list("varSqlList");
			params.put("modelId", modelId);
			params.put("ifPage", ifPage);
			params.put("varSqlList", varSqlList);
			//更新模板的sql及更新报表与模板的对应关系，更新模板是否可翻页
			reportConfigJsonService.updateModelSqlService(params);
			reportConfigJsonService.deleteReportModelService(params);
			reportConfigJsonService.insertReportModelService(params);
			reportConfigJsonService.updateModelInfoService(params);
		}
		return "success";
	}
	/**
	 * 根据rptId查询报表信息
	 * @return
	 */
	public String qryReportInfoById(){
		String rptId = str("rptId");
		Map<String, Object> reportInfo = reportConfigJsonService.qryReportInfoByIdService(rptId);
		//取报表查询条件列表
		List<Map<String, Object>> rptCdtInfoList = reportConfigJsonService.qryRptCdtInfoListService(rptId);
		//获取报表类型
		String rptType = reportInfo.get("RPT_TYPE")==null?"1":reportInfo.get("RPT_TYPE").toString();
		//1单表头，2多表头，3智能查询，4图表
		if("1".equals(rptType)){
			//取报表字段列表
			List<Map<String, Object>> rptFieldList = reportConfigJsonService.qryRptFieldListService(rptId);
			//循环取出已选择的报表字段信息
			Iterator<Map<String, Object>> rptFieldItr = rptFieldList.iterator();
			String[] selectedFieldList = new String[rptFieldList.size()];
			List<String> orderedFieldArrayList = new ArrayList<String>();
			int index = 0;
			while(rptFieldItr.hasNext()){
				//把已经选择的字段放入数组中
				Map<String, Object> rptFieldMap = rptFieldItr.next();
				String fieldId = (String) rptFieldMap.get("FIELD_ID");
				selectedFieldList[index] = fieldId;
				index++;
				//把排序字段放到数组中
				String isOrderCol = StringUtils.empty(rptFieldMap.get("IS_ORDER_COL"))?"0":rptFieldMap.get("IS_ORDER_COL").toString();
				
				if("1".equals(isOrderCol)){
					orderedFieldArrayList.add(fieldId);
				}
			}
			String[] orderedFieldList = (String[]) orderedFieldArrayList.toArray(new String[0]);

			result.put("selectedFieldList", selectedFieldList);
			result.put("orderedFieldList", orderedFieldList);
		}else if("2".equals(rptType)){
			//查询报表模板信息
			Map<String, Object> rptModelInfo = reportConfigJsonService.qryRptModelInfoService(params);
			//查询模板对应的变量列表信息
			List<Map<String, Object>> varList = reportConfigJsonService.qryVarListService(params);
			result.put("rptModelInfo", rptModelInfo);
			result.put("varList", varList);
		}
		
		result.put("reportInfo", reportInfo);
		result.put("rptCdtInfoList", rptCdtInfoList);
		return "success";
	}
	/**
	 * 根据rptId删除报表信息
	 * @return
	 */
	public String deleteReportInfoById(){
		String rptId = str("rptId");
		String rptStatus = "0";
		reportConfigJsonService.deleteReportInfoByIdService(rptId, rptStatus);
		return "success";
	}
	/**
	 * 根据rptId重新启用报表
	 * @return
	 */
	public String reUseReportInfoById(){
		String rptId = str("rptId");
		String rptStatus = "1";
		reportConfigJsonService.reUseReportInfoByIdService(rptId, rptStatus);
		return "success";
	}
	/**
	 * 根据报表rptId加载查询条件区域
	 * @return
	 */
	public String qryReportCdtList(){
		String rptId = str("rptId");
		//取报表查询条件列表
		List<Map<String, Object>> reportCdtList = reportConfigJsonService.qryRptCdtInfoListService(rptId);
		result.put("reportCdtList", reportCdtList);
		return "success";
	}
	/**
	 * 查询表头及字段选择列表
	 * @return
	 */
	public String qryReportFieldList(){
		String rptId = str("rptId");
		//查询表头及字段选择列表
		List<Map<String, Object>> reportFieldList = reportConfigJsonService.qryReportFieldListService(rptId);
		result.put("reportFieldList", reportFieldList);
		return "success";
	}
	/**
	 * 根据报表ID构建数据查询表名
	 * @param rptId
	 * @return
	 */
	public String buildQryTableName(String rptId){
		//根据报表ID查询报表信息
		Map<String, Object> reportInfo = reportConfigJsonService.qryReportInfoByIdService(rptId);
		//拼接查询的表信息
		String tableName = reportInfo.get("TB_OWNER")+"."+reportInfo.get("TB_CODE");
		String splitFlag = reportInfo.get("SPLIT_FLAG").toString();
		String splitCode = StringUtils.empty(reportInfo.get("SPLIT_CODE"))?"":reportInfo.get("SPLIT_CODE").toString();
		//判断是否分表，如果分表按照分表字段进行拼接
		if("1".equals(splitFlag)){
			if("REGION_CODE".equals(splitCode)){
				String u_region = this.getStrFromSession("j_region");
				tableName += "_"+u_region;
			}
		}
		return tableName;
	}
	/**
	 * 根据报表ID及查询的字段ID列表构建查询的select,group by,order by列表
	 * @param rptId
	 * @param rptFieldIdList
	 * @return
	 */
	public Map<String, Object> buildQryFieldList(String rptId, String rptFieldIdList){
		//根据字段ID查询字段列表
		List<Map<String, Object>> rptFieldList = reportConfigJsonService.qryReportFieldListService(rptId, rptFieldIdList);
		
		//拼接字段列表
		String selectFieldList = ""; //构建一个查询字段的列表
		//groupby列表
		String groupByFieldList = "";
		//orderby列表
		String orderByFieldList = "";
		Iterator<Map<String, Object>> rptFieldItr = rptFieldList.iterator();
		int index = 0;
		while (rptFieldItr.hasNext()) {
			Map<String, Object> rptField = rptFieldItr.next();
			String fieldCode = rptField.get("FIELD_CODE").toString();
			String isDim = rptField.get("IS_DIM").toString();
			String isOrderCol = StringUtils.empty(rptField.get("IS_ORDER_COL"))?"0":rptField.get("IS_ORDER_COL").toString();
			String groupValue = StringUtils.empty(rptField.get("GROUP_VALUE"))?"":rptField.get("GROUP_VALUE").toString();
			//如果字段为值，并且groupvalue为空，则直接对其进行sum操作,非空，则直接采用groupvalue作为聚合的计算方法
			//如groupvalue=null，则字段变为SUM(fieldCode),如果groupvalue!=null,则字段变为groupvalue例DECODE(SUM()/COUNT()*100, 2)
			if(StringUtils.empty(groupValue)&&"0".equals(isDim)){
				fieldCode = "SUM("+fieldCode+") " + fieldCode;
			}else if(StringUtils.notEmpty(groupValue)&&"0".equals(isDim)){
				fieldCode = groupValue + " "+ fieldCode;
			}
			if(index>0){
				selectFieldList += "," + fieldCode;
			}else{
				selectFieldList += fieldCode;
			}
			index++;
			//拼接group by 字段列表
			if(!"".equals(groupByFieldList)&&"1".equals(isDim)){
				groupByFieldList += ",";
			}
			if("1".equals(isDim)){
				groupByFieldList += fieldCode;
			}
			//拼接order by 字段列表
			if(!"".equals(orderByFieldList)&&"1".equals(isOrderCol)){
				orderByFieldList += ",";
			}
			if("1".equals(isOrderCol)){
				orderByFieldList += fieldCode;
			}

		}
		logger.info(selectFieldList);
		logger.info(groupByFieldList);
		logger.info(orderByFieldList);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("selectFieldList", selectFieldList);
		params.put("groupByFieldList", groupByFieldList);
		params.put("orderByFieldList", orderByFieldList);
		
		return params;
	}
	/**
	 * 根据前端页面查询条件查询查询条件
	 * @param cdtValList
	 * @return
	 */
	public List<Object> buildQryWhereSql(List<Map<String, Object>> cdtValList) {
		//拼接条件
		List<Object> whereSqlList = new ArrayList<Object>();
		Iterator<Map<String, Object>> cdtValItr = cdtValList.iterator();
		while(cdtValItr.hasNext()){
			Map<String, Object> cdtVal = cdtValItr.next();
			//如果值为空，则不需要写入筛选条件直接继续下一步
			if(StringUtils.empty(cdtVal.get("cdtValue")))
				continue;
			
			String cdtCode = cdtVal.get("cdtCode").toString();
			int calType = Integer.parseInt(cdtVal.get("calType").toString());
			String calDesc = cdtVal.get("calDesc").toString();
			String cdtValue = cdtVal.get("cdtValue").toString();
			
			//保存对筛选条件的值拆分后的字符串
			String cdtValStr = "";
			String[] cdtValArray = cdtValue.split(",");
			switch (calType) {
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:
					cdtValStr = cdtCode+" "+calDesc+" '"+cdtValue+"'";
					break;
				case 7:
				case 8:
					cdtValStr = cdtCode+" "+calDesc+" '%"+cdtValue+"%'";
					break;
				case 9:
				case 10:
					cdtValStr = cdtCode+" "+calDesc+" (";
					for(int i=0; i<cdtValArray.length; i++){
						if(i >0){
							cdtValStr += ",";
						}
						cdtValStr += "'"+cdtValArray[i]+"'";
					}
					cdtValStr += ")";
					break;
				case 11:
					cdtValStr = cdtCode+" "+calDesc;
					cdtValStr += " '" +cdtValArray[0] + "' AND '" + cdtValArray[1] + "'";
						break;
					default:
						break;
				}
				whereSqlList.add(cdtValStr);
				logger.info(cdtValStr);
			}
		return whereSqlList;
	}
	
	/**
	 * 查询报表数据
	 */
	public String qryReportDataList(){
		String rptId = str("rptId");
		String rptType = str("rptType");
		Map<String, Object> params = new HashMap<>();
		params.put("rptId", rptId);
		params.put("rptType", rptType);
		//根据报表类型确定需要查询的数据
		if("1".equals(rptType)){
			String rptFieldIdList = str("rptFieldIdList");
			
			//根据报表信息拼接查询的表信息
			String tableName = buildQryTableName(rptId);
			
			//前端页面查询条件
			List<Map<String, Object>> cdtValList = list("cdtValList");
			//根据前端页面查询条件查询查询条件
			List<Object> whereSqlList = buildQryWhereSql(cdtValList);
			
			//根据字段ID列表及报表ID构建查询的字段列表，包括select,group by,order by
			params = buildQryFieldList(rptId, rptFieldIdList);
			params.put("tableName", tableName);
			params.put("whereSqlList", whereSqlList);
			
			//获取当前页码及第展示的记录范围
			String startIndex = str("startIndex");
			String endIndex = str("endIndex");
			params.put("startIndex", startIndex);
			params.put("endIndex", endIndex);
			//根据构建查询的要素查询报表数据记录
			List<Map<String, Object>> reportDataList = reportConfigJsonService.qryReportDataListService(params);
			result.put("reportDataList", reportDataList);
		}else if("2".equals(rptType)){
			//是否翻页
			String ifPage = str("ifPage");
			params.put("ifPage", ifPage);
			//如果支持翻页，则需要加入页码信息
			if("1".equals(ifPage)){
				String startIndex = str("startIndex");
				String endIndex = str("endIndex");
				params.put("startIndex", startIndex);
				params.put("endIndex", endIndex);
			}
			//前端页面查询条件
			List<Map<String, Object>> cdtValList = list("cdtValList");
//			ListUtils.listToString(cdtValList);
			//根据前端页面查询条件查询查询条件
			List<Object> whereSqlList = buildQryWhereSql(cdtValList);
			//将条件拼接成字符串
			String whereSql = "";
			Iterator<Object> whereSqlItr = whereSqlList.iterator();
			while(whereSqlItr.hasNext()){
				whereSql += " AND "+whereSqlItr.next().toString();
			}
			//查询出模板对应的SQL变量列表
			List<Map<String, Object>> varList = reportConfigJsonService.qryVarListService(params);
			Iterator<Map<String, Object>> varItr = varList.iterator();
			//用于保存查询SQL变量的相关信息
			List<Map<String, Object>> varSqlList = new ArrayList<Map<String, Object>>();
			while(varItr.hasNext()){
				Map<String, Object> var = varItr.next();
				String varId = var.get("VAR_ID")==null?"1":var.get("VAR_ID").toString();
				String varCode = var.get("VAR_CODE")==null?"${sql}":var.get("VAR_CODE").toString();
				String varSql = var.get("VAR_SQL")==null?"SELECT * FROM DUAL":var.get("VAR_SQL").toString();
				int orderId = var.get("ORDER_ID")==null?1:Integer.parseInt(var.get("ORDER_ID").toString());
				int rowIndex = var.get("ROWINDEX")==null?1:Integer.parseInt(var.get("ROWINDEX").toString());
				int colIndex = var.get("COLINDEX")==null?1:Integer.parseInt(var.get("COLINDEX").toString());
				//检查SQL看最后是否带where条件，即最后一个where的后面是否有)，约定最外层的where条件必须以where 1=1 开头 在需要插入前台传入的where 条件位上有标记位 ${where}
				int whereIndex = varSql.lastIndexOf("${where}");
				if(whereIndex != -1){
					varSql = varSql.replace("${where}", whereSql);
				}
				params.put("sql", varSql);
				//查询每个变量对应的数据
				List<LinkedHashMap<String, Object>> dataList = reportConfigJsonService.qryDataBySqlService(params);
				//清空这个MAP
				var.clear();
				var.put("varId", varId);
				var.put("varCode", varCode);
				var.put("varSql", varSql);
				var.put("orderId", orderId);
				var.put("rowIndex", rowIndex);
				var.put("colIndex", colIndex);
				var.put("varData", dataList);
				//表头顺序
				List<String> varKey = new ArrayList<String>();
				Set<String> varKeySet = null;
				if(dataList.size()!=0){
					varKeySet = dataList.get(0).keySet();
					Iterator<String> keyItr = varKeySet.iterator();
					while(keyItr.hasNext()){
						String key = keyItr.next();
						if(!"RN".equals(key)){
							varKey.add(key);
						}
					}
				}
				var.put("varKey", varKey);
				//放入列表
				varSqlList.add(var);
			}
			result.put("varSqlList", varSqlList);
		}
		return "success";
	}
	/**
	 * 查询报表数据记录数
	 */
	public String qryReportDataCount(){
		String rptId = str("rptId");
		String rptType = str("rptType");
		Map<String, Object> params = new HashMap<>();
		params.put("rptId", rptId);
		params.put("rptType", rptType);
		//根据报表类型确定需要查询的数据
		if("1".equals(rptType)){
			String rptFieldIdList = str("rptFieldIdList");
			
			//根据报表信息拼接查询的表信息
			String tableName = buildQryTableName(rptId);
			
			//前端页面查询条件
			List<Map<String, Object>> cdtValList = list("cdtValList");
			//根据前端页面查询条件查询查询条件
			List<Object> whereSqlList = buildQryWhereSql(cdtValList);
			
			//根据字段ID列表及报表ID构建查询的字段列表，包括select,group by,order by
			params = buildQryFieldList(rptId, rptFieldIdList);
			params.put("rptId", rptId);
			params.put("tableName", tableName);
			
			params.put("whereSqlList", whereSqlList);

			//根据构建查询的要素查询报表数据记录数
			int reportDataCount = reportConfigJsonService.qryReportDataCountService(params);
			result.put("reportDataCount", reportDataCount);
		}else if("2".equals(rptType)){
			//是否翻页
			String ifPage = str("ifPage");
			//如果支持翻页，则需要加入页码信息
			if("1".equals(ifPage)){
				String startIndex = str("startIndex");
				String endIndex = str("endIndex");
				params.put("startIndex", startIndex);
				params.put("endIndex", endIndex);
				//前端页面查询条件
				List<Map<String, Object>> cdtValList = list("cdtValList");
//				ListUtils.listToString(cdtValList);
				//根据前端页面查询条件查询查询条件
				List<Object> whereSqlList = buildQryWhereSql(cdtValList);
				//将条件拼接成字符串
				String whereSql = "";
				Iterator<Object> whereSqlItr = whereSqlList.iterator();
				while(whereSqlItr.hasNext()){
					whereSql += " AND "+whereSqlItr.next().toString();
				}
				//查询出模板对应的SQL变量列表
				List<Map<String, Object>> varList = reportConfigJsonService.qryVarListService(params);
				Iterator<Map<String, Object>> varItr = varList.iterator();
				//总的记录数
				int dataCount = 0;
				while(varItr.hasNext()){
					Map<String, Object> var = varItr.next();
					String varSql = var.get("VAR_SQL")==null?"SELECT * FROM DUAL":var.get("VAR_SQL").toString();
					//检查SQL看最后是否带where条件，即最后一个where的后面是否有)，约定最外层的where条件必须以where 1=1 开头 在需要插入前台传入的where 条件位上有标记位 ${where}
					int whereIndex = varSql.lastIndexOf("${where}");
					if(whereIndex != -1){
						varSql = varSql.replace("${where}", whereSql);
					}
					params.put("sql", varSql);
					//查询每个变量对应的数据量
					dataCount = dataCount >= reportConfigJsonService.qryDataBySqlCountService(params) ? dataCount : reportConfigJsonService.qryDataBySqlCountService(params);
				}
				result.put("dataCount", dataCount);
			}
		}
		return "success";
	}
	/**
	 * 下载报表数据
	 * @return
	 */
	public String exportData(){
		String rptId = str("rptId");
		String rptName = str("rptName");
		String rptType = str("rptType");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rptId", rptId);
		params.put("rptName", rptName);
		params.put("rptType", rptType);
		double dataCount = Double.parseDouble(str("dataCount"));
		//生成的文件名称及路径
		String filePath = "";
		//统计的筛选条件描述用于插入的下载数据的描述
		String cdtDesc = "";
		if("1".equals(rptType)){
			String rptFieldIdList = str("rptFieldIdList");
			
			//根据下载的字段ID列表，查询出表头
			List<Map<String, Object>> rptFieldList = reportConfigJsonService.qryReportFieldListService(rptId, rptFieldIdList);
			Iterator<Map<String, Object>> rptFiledItr = rptFieldList.iterator();
			//表头数组
			String[] dataTitle = new String[rptFieldList.size()];
			String[] dataCode = new String[rptFieldList.size()];
			int dataTitleIndex = 0;
			while(rptFiledItr.hasNext()){
				Map<String, Object> field = rptFiledItr.next();
				dataTitle[dataTitleIndex] = field.get("FIELD_NAME")==null?"":field.get("FIELD_NAME").toString();
				dataCode[dataTitleIndex] = field.get("FIELD_CODE")==null?"":field.get("FIELD_CODE").toString();
				dataTitleIndex++;
			}
			
			//根据报表信息拼接查询的表信息
			String tableName = buildQryTableName(rptId);
			
			//前端页面查询条件
			List<Map<String, Object>> cdtValList = list("cdtValList");
			//根据前端页面查询条件查询查询条件
			List<Object> whereSqlList = buildQryWhereSql(cdtValList);
			//构建查询的控件说明
			cdtDesc = buildCdtDesc(cdtValList);
			
			//根据字段ID列表及报表ID构建查询的字段列表，包括select,group by,order by
			params = buildQryFieldList(rptId, rptFieldIdList);
			params.put("tableName", tableName);
			
			params.put("whereSqlList", whereSqlList);
			
			//生成的文件名称及路径
			filePath = PropertiesUtils.getInstance().getProperty("web.download.filepath") + this.getTimeStamp() + "/" + rptName + ".xlsx";
			String rootPath = this.getWebRootPath();
			if(!filePath.startsWith("/Users")){
				rootPath = rootPath+filePath;
			}else{
				rootPath = filePath;
			}
			//需要下载的总批次
			int batchCnt = (int) Math.ceil(dataCount/MAX_ONETIME_COUNT);
			
			//创建ExcelUtils对象用以生成文件
			ExcelUtils excelUtils = new ExcelUtils(rootPath, dataTitle, dataCode);
			
			//根据批次循环下载
			for(int i = 0; i < batchCnt; i++){
				//当前下载的开始记录数及结束记录数
				int startIndex = i*MAX_ONETIME_COUNT+1;
				int endIndex = (i+1)*MAX_ONETIME_COUNT;
				params.put("startIndex", startIndex);
				params.put("endIndex", endIndex);
				
				//根据构建查询的要素查询报表数据记录
				List<Map<String, Object>> dataList = reportConfigJsonService.qryReportDataListService(params);
				
				excelUtils.tableToExcel(i, startIndex, dataList);
			}
			excelUtils.writeWorkbook();
			excelUtils.cleanResource();
		}else if("2".equals(rptType)){
			//是否翻页
			String ifPage = str("ifPage");
			params.put("ifPage", ifPage);
			//前端页面查询条件
			List<Map<String, Object>> cdtValList = list("cdtValList");
//			ListUtils.listToString(cdtValList);
			//根据前端页面查询条件查询查询条件
			List<Object> whereSqlList = buildQryWhereSql(cdtValList);
			//构建查询的控件说明
			cdtDesc = buildCdtDesc(cdtValList);
			
			//将条件拼接成字符串
			String whereSql = "";
			Iterator<Object> whereSqlItr = whereSqlList.iterator();
			while(whereSqlItr.hasNext()){
				whereSql += " AND "+whereSqlItr.next().toString();
			}

			//生成的文件名称及路径
			filePath = PropertiesUtils.getInstance().getProperty("web.download.filepath") + this.getTimeStamp() + "/" + rptName + ".xlsx";
			String rootPath = this.getWebRootPath();
			if(!filePath.startsWith("/Users")){
				rootPath = rootPath+filePath;
			}else{
				rootPath = filePath;
			}
			logger.info("===================================rootPath================="+rootPath);
			
			//获取模板路径
			Map<String, Object> modelInfo = reportConfigJsonService.qryRptModelInfoService(params);
			String modelPath = this.getWebRootPath()+modelInfo.get("MODEL_PATH").toString();
			logger.info("===================================modelPath================="+modelPath);
			File modelFile = new File(modelPath);
			
			//创建ExcelUtils工具类
			ExcelUtils excelUtils = new ExcelUtils(modelFile, rootPath, ifPage);
			//需要下载的总批次
			int batchCnt = (int) Math.ceil(dataCount/MAX_ONETIME_COUNT);
			
			//查询出模板对应的SQL变量列表
			List<Map<String, Object>> varList = reportConfigJsonService.qryVarListService(params);
			Iterator<Map<String, Object>> varItr = varList.iterator();
			
			//根据批次循环下载
			for(int i = 0; i < batchCnt; i++){
				//当前下载的开始记录数及结束记录数
				int startIndex = i*MAX_ONETIME_COUNT+1;
				int endIndex = (i+1)*MAX_ONETIME_COUNT;
				params.put("startIndex", startIndex);
				params.put("endIndex", endIndex);
				//得到查询语句
				while(varItr.hasNext()){
					Map<String, Object> var = varItr.next();
					String varSql = var.get("VAR_SQL")==null?"SELECT * FROM DUAL":var.get("VAR_SQL").toString();
					int rowIndex = var.get("ROWINDEX")==null?1:Integer.parseInt(var.get("ROWINDEX").toString());
					int colIndex = var.get("COLINDEX")==null?1:Integer.parseInt(var.get("COLINDEX").toString());
					//检查SQL看最后是否带where条件，即最后一个where的后面是否有)，约定最外层的where条件必须以where 1=1 开头 在需要插入前台传入的where 条件位上有标记位 ${where}
					int whereIndex = varSql.lastIndexOf("${where}");
					if(whereIndex != -1){
						varSql = varSql.replace("${where}", whereSql);
					}
					params.put("sql", varSql);
					//查询每个变量对应的数据
					List<LinkedHashMap<String, Object>> dataList = reportConfigJsonService.qryDataBySqlService(params);
					
					//表头顺序
					List<String> varKey = new ArrayList<String>();
					Set<String> varKeySet = null;
					if(dataList.size()!=0){
						varKeySet = dataList.get(0).keySet();
						Iterator<String> keyItr = varKeySet.iterator();
						while(keyItr.hasNext()){
							String key = keyItr.next();
							if(!"RN".equals(key)){
								varKey.add(key);
							}
						}
					}
					String[] dataCode = new String[varKey.size()];
					dataCode = varKey.toArray(dataCode);
					//如果翻页，则查询出来的记录数是有上限的，如果没有翻页，则一次性全部查出来
					if("1".equals(ifPage)){
						excelUtils.tableToExcel(i, MAX_ONETIME_COUNT, rowIndex, colIndex, dataList, dataCode);
					}else{
						excelUtils.tableToExcel(rowIndex, colIndex, dataList, dataCode);
					}
				}
			}
			excelUtils.writeWorkbook();
			excelUtils.cleanResource();
		}
		
		//插入下载记录表
		params.put("filePath", filePath);
		params.put("cdtDesc", cdtDesc);
		params.put("id", this.getTimeStamp());
		params.put("fileStatus", "1");

		rptId = str("rptId");
		params.put("rptId", rptId);
		params.put("rptName", rptName);
		String createrName = "admin";
		params.put("createrName", createrName);
		reportConfigJsonService.insertDownloadInfoService(params);
		return "success";
	}
	/**
	 * 构建查询的控件描述用于下载时的条件说明
	 * @param cdtValList
	 * @return
	 */
	public String buildCdtDesc(List<Map<String, Object>> cdtValList){
		String cdtDesc = "";
		//拼接条件
		Iterator<Map<String, Object>> cdtValItr = cdtValList.iterator();
		while(cdtValItr.hasNext()){
			Map<String, Object> cdtVal = cdtValItr.next();
			//如果值为空，则不需要写入筛选条件直接继续下一步
			if(StringUtils.empty(cdtVal.get("cdtValue")))
				continue;
			
			String cdtName = cdtVal.get("cdtName")==null?"":cdtVal.get("cdtName").toString();
			int calType = Integer.parseInt(cdtVal.get("calType").toString());
			String calDesc = cdtVal.get("calDesc").toString();
			String cdtValue = cdtVal.get("cdtValue").toString();
			
			//保存对筛选条件的值拆分后的字符串
			String cdtValStr = "";
			String[] cdtValArray = cdtValue.split(",");
			int showType = Integer.parseInt(cdtVal.get("showType").toString());
			//单选或者多选项取其中文值
			if(showType==5||showType==6){
				String cdtValueDesc = cdtVal.get("cdtValueDesc").toString();
				cdtValArray = cdtValueDesc.split(",");
				cdtValue = cdtValueDesc;
			}
			switch (calType) {
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
				cdtValStr = cdtName+" "+calDesc+" '"+cdtValue+"'";
				break;
			case 7:
			case 8:
				cdtValStr = cdtName+"模糊查询："+calDesc+" '%"+cdtValue+"%'";
				break;
			case 9:
			case 10:
				cdtValStr = cdtName+" "+calDesc+" (";
				for(int i=0; i<cdtValArray.length; i++){
					if(i >0){
						cdtValStr += ",";
					}
					cdtValStr += "'"+cdtValArray[i]+"'";
				}
				cdtValStr += ")";
				break;
			case 11:
				cdtValStr = cdtName+" "+calDesc;
				cdtValStr += " '" +cdtValArray[0] + "' AND '" + cdtValArray[1] + "'";
					break;
				default:
					break;
			}
			if(cdtValItr.hasNext()){
				cdtDesc += cdtValStr + "\n";
			}else{
				cdtDesc += cdtValStr;
			}
			logger.info(cdtDesc);
		}
		return cdtDesc;
	}
	
	/**
	 * 导入模板
	 * @return
	 */
	public String importRptModel(){
		String filePath = getParam("filePath");
		String fileExt = getParam("fileExt");
		
		logger.info("filePath==="+filePath+",fileExt===="+fileExt);
		logger.info(this.modelFileFileName+"========"+this.modelFileContentType);
		
		//生成模板信息
		String modelId = this.getTimeStamp(); //生成惟一序列 模板ID
		String modelName = this.modelFileFileName; //模板名称
		
		String modelPath = PropertiesUtils.getInstance().getProperty("web.report.model.filepath") + modelId + "/" + modelName;
		String rootPath = this.getWebRootPath();
		if(!modelPath.startsWith("/Users")){
			logger.info("===================================rootPath================="+rootPath);
			rootPath = rootPath+modelPath;
		}else{
			rootPath = modelPath;
		}
		
		String createrName = "admin";
		logger.info(modelPath);
		
		//从临时文件复制文件到模板存储目录
		String uploadStatus = copyFile(modelFile, rootPath);
		logger.info("uploadStatus============"+uploadStatus);
		//存储模板信息
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("modelId", modelId);
		params.put("modelName", modelName);
		params.put("modelPath", modelPath);
		params.put("createrName", createrName);
		
		//将报表模板解析成html
		ExcelUtils excelUtils = new ExcelUtils(rootPath);
		ToHtml toHtml = excelUtils.excelToHtml();
		String modelCss = toHtml.getCss();
		String modelHtml = toHtml.getHtml();
		params.put("modelCss", modelCss);
		params.put("modelHtml", modelHtml);
		
		//存储模板信息
		reportConfigJsonService.insertModelInfoService(params);
		
		List<Map<String, Object>> varList = toHtml.getVarList();
		//把sql变量信息插入到数据库
		params.put("varList", varList);
		reportConfigJsonService.insertModelSqlService(params);
		
		result.put("uploadStatus", uploadStatus);
		result.put("modelId", modelId);
		result.put("modelName", modelName);
		result.put("modelPath", modelPath);
		result.put("varList", varList);
		return "success";
	}
	/**
	 * 将文件复制到目标位置
	 * @param oldFile
	 * @param newPath
	 * @return
	 */
	public String copyFile(File oldFile, String newPath){

		String uploadStatus = "0";
		
		//文件的输入流
		InputStream inStream = null;
		//得到文件的输入流
		FileOutputStream fOutputStream = null;
		try {
			inStream = new FileInputStream(modelFile);
			
			try {
				File newFile = new File(newPath);
				if(!newFile.getParentFile().exists()){
					logger.info("如果文件所在目录不存在，则创建他的上层目录");
					newFile.getParentFile().mkdirs();
				}
				fOutputStream = new FileOutputStream(newFile);
			} catch (FileNotFoundException e) {
				uploadStatus = "-2";
				logger.info("无法创建模板目录及文件！");
				e.printStackTrace();
			}
			
			//把原文件写入到目标文件
			int byteRead = 0;
			byte[] buffer = new byte[1444]; 
			while((byteRead = inStream.read(buffer)) != -1){
				fOutputStream.write(buffer, 0, byteRead);
			}
			uploadStatus = "0";
		} catch (FileNotFoundException e) {
			uploadStatus = "-1";
			logger.info("文件不存在，请重新上传模板！");
			e.printStackTrace();
		} catch (IOException e) {
			uploadStatus = "-3";
			logger.info("从临时文件复制到目标文件时报错！");
			e.printStackTrace();
		} finally {
			try {
				inStream.close();
			} catch (IOException e) {
				logger.info("无法关闭原文件输入流");
				e.printStackTrace();
			}
			try {
				fOutputStream.close();
			} catch (IOException e) {
				logger.info("无法关闭目标文件输出流");
				e.printStackTrace();
			}

		}

		return uploadStatus;
	}
	/**
	 * 查询下载清单
	 * @return
	 */
	public String qryDownloadInfoList(){
		String rptName = str("rptName");
		String createrName = str("createrName");
		String startIndex = str("startIndex");
		String endIndex = str("endIndex");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rptName", rptName);
		params.put("createrName", createrName);
		params.put("startIndex", startIndex);
		params.put("endIndex", endIndex);
		
		//获取下载清单
		List<Map<String, Object>> downloadInfoList = reportConfigJsonService.qryDownloadInfoListService(params);
		
		result.put("downloadInfoList", downloadInfoList);
		return "success";
	}
	/**
	 * 查询下载清单记录数
	 * @return
	 */
	public String qryDownloadInfoCount(){
		String rptName = str("rptName");
		String createrName = str("createrName");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rptName", rptName);
		params.put("createrName", createrName);
		//获取下载清单
		int downloadInfoCount = reportConfigJsonService.qryDownloadInfoCountService(params);
		
		result.put("downloadInfoCount", downloadInfoCount);
		return "success";
	}
	
}
