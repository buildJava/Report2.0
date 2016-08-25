package com.aiutil.report.utils;

import java.io.File;
//import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


public class MainTest {

	public static void main(String[] args) {
		//格式化日期
//		dateFormatter();
		//excel to table功能测试
//		excelToTable();
		
		//table to excel功能测试
//		tableToExcel();
		
		//excel转成html功能测试
//		excelToHtml();
		//在某个目录创建文件
//		File file = new File("/Users/wangjian/Downloads/upload/集团产品信息化收入模板.xlsx");
//		try {
//			file.createNewFile();
//		} catch (IOException e) {
//			System.out.println("无法创建文件！");
//			e.printStackTrace();
//		}
		//测试linkedhashMap的取出顺序
//		readLinkedHashMap();
		//测试多表头的数据写出
//		tableToExcelMutil();
		//路径测试
		String path = Class.class.getClass().getResource("/").getPath();
		System.out.println(path);
	}
	//table to excel
	public static void tableToExcelMutil(){
		//生成的文件名称及路径
		String filePath = PropertiesUtils.getInstance().getProperty("web.download.filepath") + "集团产品信息化收入模板合并列的数据写入" +"12345.xlsx";
		
		//获取模板路径
		String modelPath = "/Users/wangjian/Downloads/upload/集团产品信息化收入模板合并列的数据写入.xlsx";
		File modelFile = new File(modelPath);
		
		//创建ExcelUtils工具类
		ExcelUtils excelUtils = new ExcelUtils(modelFile, filePath, "1");
		excelUtils.tableToExcel(2, 3, null, null);
		
	}
	//测试linkedhashMap的取出顺序
	public static void readLinkedHashMap(){
		
		Map<String, Object> map = new LinkedHashMap<String, Object>();
		map.put("1", "aaaa");
		map.put("2", null);
		map.put("3", "cccc");
		map.put("4", "dddd");
		map.put("5", "eeee");
		map.put("6", "ffff");
		
		Iterator<String> iterator = map.keySet().iterator();
		while(iterator.hasNext()){
			String key = iterator.next();
			System.out.println("key===="+key+"val====="+map.get(key));
		}
	}
	//excel转成html功能测试
	public static void excelToHtml(){
		String filePath = "/Users/wangjian/Downloads/upload/集团产品信息化收入模板.xlsx";
		ExcelUtils excelUtils = new ExcelUtils(filePath);
		ToHtml toHtml = excelUtils.excelToHtml();
		System.out.println(toHtml.getCss());
		System.out.println("====================");
		System.out.println(toHtml.getHtml());
	}
	//excel to table功能测试
	public static void excelToTable(){
		String filePath = "/Users/wangjian/Downloads/costImport.xlsx";
		String fileName = "costImport.xlsx";
		File excelFile = new File(filePath);
		ExcelUtils excelUtils = new ExcelUtils(filePath, fileName, excelFile, 0);
		
		Map<String, Object> impResult = excelUtils.excelToTable();
		@SuppressWarnings("unchecked")
		List<String[]> dataList = (List<String[]>) impResult.get("dataList");
		Iterator<String[]> dataItr = dataList.iterator();
		while(dataItr.hasNext()){
			String[] array = dataItr.next();
			for(int i=0; i<array.length; i++){
				if(i > 0){
					System.out.print(",");
				}
				System.out.print(array[i]);
			}
			System.out.println("");
		}
		System.out.println(impResult.get("impMsg"));
	}
	//table to Excel功能测试
	public static void tableToExcel(){
		Map<String, Object> data = new HashMap<String, Object>();
		List<Map<String, Object>> dataList = new ArrayList<Map<String,Object>>();
		for(int i=0; i<1000; i++){
			data.put("月份", "月份"+i);
			data.put("地市", "地市"+i);
			data.put("区县", "区县"+i);
			data.put("营业厅编码", "营业厅编码"+i);
			data.put("营业厅名称", "营业厅名称"+i);
			data.put("营业人员数量", i);
			dataList.add(data);
		}
		String filePath = "/Users/wangjian/Downloads/测试.xlsx";
		String[] dataTitle = null;
		String[] dataCode = null;
		ExcelUtils excelUtils = new ExcelUtils(filePath, dataTitle, dataCode);
		
		excelUtils.tableToExcel(0, 1, dataList);
		
	}
	//格式化日期
	public static void dateFormatter(){
		String dateFormat = "";
		SimpleDateFormat timeFormat = null;
		String formater = "yyyyMM";
		int converter = -1;
		//得到日历
		Calendar calendar = Calendar.getInstance();
		if("yyyyMMdd".equals(formater)){
			calendar.add(Calendar.DATE, converter); //根据需要转换天
			Date date = calendar.getTime();
			timeFormat = new SimpleDateFormat(formater);
			dateFormat = timeFormat.format(date);
		}else if("yyyyMM".equals(formater)){
			calendar.add(Calendar.MONTH, converter); //根据需要转换天
			Date date = calendar.getTime();
			timeFormat = new SimpleDateFormat(formater);
			dateFormat = timeFormat.format(date);
		}
		System.out.println(dateFormat);
	}
}
