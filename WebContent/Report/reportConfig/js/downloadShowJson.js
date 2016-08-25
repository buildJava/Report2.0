/* *
 * 页面jquery事件响应区域
 * */
$(document).ready(function(){
	init();
})

/* *
 * 页面方法区域
 * */
//初始化数据
function init(){
	qryDownloadInfoList(0);
	qryDownloadInfoCount();
}
//设置参数
function setParams(){
	var rptName = $.trim($("#rpt_name").val());
	var createrName = $.trim($("#creater_name").val());
	//组合参数
	var params = {};
	params.rptName = rptName;
	params.createrName = createrName;
	//校验参数
	if(validateParams(params)){
		return params;
	}
}
//校验输入项
function validateParams(params){
	
	return true;
}
//查询数据
function qryDownloadData(){
	//展示正在查询并且清查现有查询
	$("#reportBody").empty();
	$("#loading-box").show();
	setTimeout("init()", 300);
}
//查询数据
function qryDownloadInfoList(curPage){
	var params = {};
	params = setParams();

	//查询页码设置
	params.pageSize = pageSize;
	params.startIndex = curPage*pageSize+1;
	params.endIndex = (curPage+1)*pageSize;
	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryDownloadInfoList.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			downloadInfoList = data.result.downloadInfoList;
			var reportBody = $("#reportBody");
			var _html = "";
			if(isEmptyObj(downloadInfoList)){
				return;
			}
			
			$.each(downloadInfoList, function(i, item){
				var cdtDesc = item.CDT_DESC;
				if(isNull(cdtDesc)){
					cdtDesc = "";
				}else{
					cdtDesc = cdtDesc.replace(/[\r\n]/g,"<br>");
				}
				if((i+1)%2){
					_html += "<tr>"
						  +  	"<td>"+item.RN+"</td>"
						  +  	"<td>"+item.RPT_ID+"</a></td>"
						  +  	"<td class='text-overflow'>"+item.RPT_NAME+"</td>"
						  +  	"<td>"+item.CREATE_DATE+"</td>"
						  +  	"<td><a class='file-download' href='"+item.FILE_PATH+"'></a></td>"
						  +  	"<td>"+item.FILE_STATUS+"</td>"
						  +  	"<td class='width-260'>"+cdtDesc+"</td>"
						  +  	"<td>"+item.CREATER_NAME+"</td>"
						  +	"</tr>";
				}else{
					_html += "<tr class='ui-table-split'>"
						  +  	"<td>"+item.RN+"</td>"
						  +  	"<td>"+item.RPT_ID+"</a></td>"
						  +  	"<td class='text-overflow'>"+item.RPT_NAME+"</td>"
						  +  	"<td>"+item.CREATE_DATE+"</td>"
						  +  	"<td><a class='file-download' href='"+item.FILE_PATH+"'></a></td>"
						  +  	"<td>"+item.FILE_STATUS+"</td>"
						  +  	"<td class='width-260'>"+cdtDesc+"</td>"
						  +  	"<td>"+item.CREATER_NAME+"</td>"
						  +	"</tr>";
				}
			})
			reportBody.empty();
			$("#loading-box").fadeOut();
			reportBody.html(_html);
		},
		error:function(e){}
	})
}
//查询数据记录数
function qryDownloadInfoCount(){
	var params = {};
	params = setParams();

	var _parStr = JSON.stringify(params);
	$.ajax({
		url:ctx+"/report/json/reportConfigJsonAction!qryDownloadInfoCount.action",
		data:{_params:_parStr},
		async:false,
		dataType:"json",
		type:"post",
		success:function(data){
			downloadInfoCount = data.result.downloadInfoCount;
			//分页
			$("#pagination").pagination(downloadInfoCount, {
			    num_edge_entries: 2,
			    num_display_entries: 4,
			    callback: qryDownloadInfoList,
				items_per_page:pageSize,
				prev_text:" ",
				next_text:" "
			});
		},
		error:function(e){}
	})
}