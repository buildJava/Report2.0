package com.aiutil.report.actions;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

import com.aiutil.report.entities.ReportModel;
import com.aiutil.report.services.ReportConfigJsonService;
import com.aiutil.report.services.ReportConfigService;

//import net.sf.json.JSONArray;

/**
 * ReportConfigAction
 * @Description: 报表配置
 * @author zhangrui
 * @date 2016年5月19日 下午5:31:29
 */
@ParentPackage("struts-default")
@Namespace("/report")
@Action("reportConfigAction")
@Results({
	@Result(name="reportConfig1", location="/Report/reportConfig/reportConfig1.jsp"),
	@Result(name="reportConfig2", location="/Report/reportConfig/reportConfig2.jsp"),
	@Result(name="reportConfig3", location="/Report/reportConfig/reportConfig3.jsp"),
	@Result(name="reportConfig4", location="/Report/reportConfig/reportConfig4.jsp"),
	@Result(name="reportConfig5", location="/Report/reportConfig/reportConfig5.jsp"),
	@Result(name="reportConfig6", location="/Report/reportConfig/reportConfig6.jsp"),
	@Result(name="reportShow", location="/Report/reportConfig/reportShow.jsp"),
	@Result(name="reportMultiShow", location="/Report/reportConfig/reportMultiShow.jsp"),
	@Result(name="downloadShow", location="/Report/reportConfig/downloadShow.jsp")
})
public class ReportConfigAction extends BaseAction {
	
	/**
	 * 记录日志
	 */
	private Logger logger = Logger.getLogger(ReportConfigAction.class);
	
	@Resource(name="reportConfigService")
	private ReportConfigService reportConfigService;
	@Resource(name="reportConfigJsonService")
	private ReportConfigJsonService reportConfigJsonService;
	
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
	 * 导向到报表配置页面-保存元数据
	 * @return
	 */
	public String reportConfig1(){
		//查询数据库用户列表
		List<Map<String, Object>> rptDbUsersList = reportConfigService.qryRptDbUsersService();
		//查询分表变量列表
		List<Map<String, Object>> splitCodeList = reportConfigService.qrySplitCodeService();
		
		result.put("rptDbUsersList", rptDbUsersList);
		result.put("splitCodeList", splitCodeList);
		return "reportConfig1";
	}
	/**
	 * 导向到报表配置页面-元数据管理
	 * @return
	 */
	public String reportConfig2(){
		//查询数据库用户列表
		List<Map<String, Object>> rptDbUsersList = reportConfigService.qryRptDbUsersService();
		result.put("rptDbUsersList", rptDbUsersList);
		return "reportConfig2";
	}
	/**
	 * 导向报表元素数据管理-元数据字段列表查看页面
	 * @return
	 */
	public String reportConfig3(){
		String tbId = getParam("tbId");
		//查询报表元数据
		Map<String, Object> tableInfo = reportConfigService.qryTableInfoByIdService(tbId);
		result.put("tableInfo", tableInfo);
		return "reportConfig3";
	}
	/**
	 * 导向报表配置-报表管理
	 * @return
	 */
	public String reportConfig4(){
		//查询报表配置信息
		List<Map<String, Object>> reportInfoList = reportConfigService.qryReportInfoService();
		result.put("reportInfoList", reportInfoList);
		return "reportConfig4";
	}
	/**
	 * 导向报表配置-报表查询控件配置
	 * @return
	 */
	public String reportConfig5(){
		//查询报表查询控件配置信息
		List<Map<String, Object>> cdtInfoList = reportConfigService.qryCdtInfoService();
		result.put("cdtInfoList", cdtInfoList);
		//查询控件的展现类型
		List<Map<String, Object>> cdtShowTypeList = reportConfigService.qrySysCodeService("CDT_SHOW_TYPE");
		result.put("cdtShowTypeList", cdtShowTypeList);
		//查询控件的计算方式
		List<Map<String, Object>> cdtCalList = reportConfigService.qrySysCodeService("CDT_CAL_TYPE");
		result.put("cdtCalList", cdtCalList);
		return "reportConfig5";
	}
	/**
	 * 导向报表配置-新增报表配置页面
	 * @return
	 */
	public String reportConfig6(){
		//获取请求中的报表id
		String rptId = getParam("rptId")==null?"":getParam("rptId");
		String addOrModify = "0";
		//0新增1修改
		if(!rptId.isEmpty()){
			addOrModify = "1";
		}
		result.put("rptId", rptId);
		result.put("addOrModify", addOrModify);
		//报表周期
		List<Map<String, Object>> rptCycleList = reportConfigService.qrySysCodeService("RPT_CYCLE");
		result.put("rptCycleList", rptCycleList);
		//查询报表类型
		List<Map<String, Object>> rptTypeList = reportConfigService.qrySysCodeService("RPT_TYPE");
		result.put("rptTypeList", rptTypeList);
		return "reportConfig6";
	}
	/**
	 * 导向报表展现页面-最终展示
	 * @return
	 */
	public String reportShow(){
		String rptId = getParam("rptId");
		//根据报表id获取报表信息
		Map<String, Object> reportInfo = reportConfigJsonService.qryReportInfoByIdService(rptId);
		//获取报表名称等信息
		String rptName = reportInfo.get("RPT_NAME")==null?"":reportInfo.get("RPT_NAME").toString();
		String rptCycle = reportInfo.get("RPT_CYCLE")==null?"1":reportInfo.get("RPT_CYCLE").toString();
		result.put("rptCycle", rptCycle);
		String cycle = "day";
		String formater = "yyyy-MM-dd";
		if("1".equals(rptCycle)){
			formater = "yyyy-MM-dd";
			cycle = "day";
		}else if("2".equals(rptCycle)){
			formater = "yyyy-MM";
			cycle = "month";
		}
		String dateFormat = getDateFormat(cycle, formater, -1);
		result.put("rptId", rptId);
		result.put("rptName", rptName);
		result.put("reportInfo", reportInfo);
		result.put("rptCycle", rptCycle);
		result.put("dateFormat", dateFormat);
		//获取报表的类型来判断按什么方式进行展现
		int rptType = reportInfo.get("RPT_TYPE")==null?1:Integer.parseInt(reportInfo.get("RPT_TYPE").toString());
		String pageRedirect = "reportShow";
		switch (rptType) {
		case 1:
			pageRedirect = "reportShow";
			break;
		case 3:
			break;
		case 2:
			//查询的报表的模板代码
			ReportModel reportModel = reportConfigJsonService.qryReportModelService(rptId);
			result.put("reportModel", reportModel);
			pageRedirect = "reportMultiShow";
			break;
		case 4:
			break;
		default:
			pageRedirect = "reportShow";
			break;
		}
		return pageRedirect;
	}
	public String downloadShow(){
		
		return "downloadShow";
	}
}
