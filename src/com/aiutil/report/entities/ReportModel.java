package com.aiutil.report.entities;

public class ReportModel {

	private String rptId; // 报表ID
	private String modelId; // 模板ID
	private String modelName; // 模板名称
	private String modelPath; // 模板路径
	private String createrName; // 创建人
	private String ifPage; // 是否支持翻页
	private String modelCss; // 模板解析CSS
	private String modelHtml; // 模板解析HTML

	public String getRptId() {
		return rptId;
	}

	public void setRptId(String rptId) {
		this.rptId = rptId;
	}

	public String getModelId() {
		return modelId;
	}

	public void setModelId(String modelId) {
		this.modelId = modelId;
	}

	public String getModelName() {
		return modelName;
	}

	public void setModelName(String modelName) {
		this.modelName = modelName;
	}

	public String getModelPath() {
		return modelPath;
	}

	public void setModelPath(String modelPath) {
		this.modelPath = modelPath;
	}

	public String getCreaterName() {
		return createrName;
	}

	public void setCreaterName(String createrName) {
		this.createrName = createrName;
	}

	public String getIfPage() {
		return ifPage;
	}

	public void setIfPage(String ifPage) {
		this.ifPage = ifPage;
	}

	public String getModelCss() {
		return modelCss;
	}

	public void setModelCss(String modelCss) {
		this.modelCss = modelCss;
	}

	public String getModelHtml() {
		return modelHtml;
	}

	public void setModelHtml(String modelHtml) {
		this.modelHtml = modelHtml;
	}

}
