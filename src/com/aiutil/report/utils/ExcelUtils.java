package com.aiutil.report.utils;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.EncryptedDocumentException;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;


public class ExcelUtils {

	protected String filePath; //文件路径
	protected Workbook inWorkbook = null; //输入的参数可以是String filePath, 或者是workbook，或者是输入流inputStream
	protected Workbook workbook = null; //工具类的workbook
	protected Sheet sheet = null; //工具类的sheet页
	protected CellStyle cellStyle = null; //单元格样式
	protected InputStream inputStream = null; //输入流inputStream
	protected OutputStream outputStream = null; //workbook输出流
	protected ToHtml toHtml; //用于excel转换成html的内部类
	protected String fileName; //文件名
	protected File excelFile; //excel文件
	protected int sheetIndex; //excel文件读取哪个sheet页
	protected String[] dataTitle; //导出数据表头
	protected String[] dataCode; //导出数据的字段列表
	protected List<Map<String, Object>> dataList; //需要导出的数据
	protected File modelFile; //需要导出报表的模板
	protected final int rowAccessWindowSize = 1000; //内存中的最大记录数
	//构造方法-导入方法
	public ExcelUtils(String filePath, String fileName, File excelFile, int sheetIndex) {
		this.filePath = filePath;
		this.fileName = fileName;
		this.excelFile = excelFile;
		this.sheetIndex = sheetIndex;
	}
	//构造方法-导出数据
	public ExcelUtils(String filePath, String[] dataTitle, String[] dataCode){
		this.filePath = filePath;
		this.dataTitle = dataTitle;
		this.dataCode = dataCode;

		//创建文件workbench
		workbook = new SXSSFWorkbook(new XSSFWorkbook(), rowAccessWindowSize);
	}
	//构造方法-多表头数据导出
	public ExcelUtils(File modelFile, String filePath, String ifPage){
		this.modelFile = modelFile;
		this.filePath = filePath;
		try {
			inputStream = new FileInputStream(modelFile);
			//是否分页，如果分页，则采用SXSSFWorkbook，防止内存问题，如果不分页，则为小数据使用workbook，SXSSFWorkbook类型对于已经存在的行和单元格无法进行修改
			if("1".equals(ifPage)){
				workbook = new SXSSFWorkbook(new XSSFWorkbook(inputStream), rowAccessWindowSize);
			}else{
				workbook = WorkbookFactory.create(inputStream);
			}
		} catch (FileNotFoundException e) {
			msgLogger("未找到相应的文件！");
			e.printStackTrace();
		} catch (EncryptedDocumentException e) {
			msgLogger("加密文件出错！");
			e.printStackTrace();
		} catch (IOException e) {
			msgLogger("IO错误！");
			e.printStackTrace();
		} catch (InvalidFormatException e) {
			msgLogger("生成workbook报错！");
			e.printStackTrace();
		}
	}
	//构造方法-excel转换成html
	public ExcelUtils(String filePath){
		this.filePath = filePath;
		try {
			inputStream = new FileInputStream(filePath);
			inWorkbook = WorkbookFactory.create(inputStream);
			this.toHtml = new ToHtml(inWorkbook);
		} catch (FileNotFoundException e) {
			msgLogger("未找到相应的文件！");
			e.printStackTrace();
		} catch (EncryptedDocumentException e) {
			msgLogger("加密文件出错！");
			e.printStackTrace();
		} catch (InvalidFormatException e) {
			msgLogger("未找到相应的文件！");
			e.printStackTrace();
		} catch (IOException e) {
			msgLogger("IO错误！");
			e.printStackTrace();
		}
	}
	
	public ExcelUtils(InputStream inputStream){
		this.inputStream = inputStream;
		try {
			inWorkbook = WorkbookFactory.create(inputStream);
			this.toHtml = new ToHtml(inWorkbook);
		} catch (EncryptedDocumentException e) {
			msgLogger("加密文件出错！");
			e.printStackTrace();
		} catch (InvalidFormatException e) {
			msgLogger("未找到相应的文件！");
			e.printStackTrace();
		} catch (IOException e) {
			msgLogger("IO错误！");
			e.printStackTrace();
		}
	}
	public ExcelUtils(Workbook inWorkbook){
		this.inWorkbook = inWorkbook;
		this.toHtml = new ToHtml(inWorkbook);
	}
	
	//记录日志
	public void msgLogger(String msg){
		System.out.println(msg);
	}
	

	//ExcelUtils清理资源
	public void cleanResource(){
		if(inWorkbook != null){
			inWorkbook = null;
		}
		if(workbook != null){
			workbook = null;
		}
		if(inputStream != null){
			try {
				inputStream.close();
			} catch (IOException e) {
				msgLogger("ExcelUtils清理输入流资源失败！");
				e.printStackTrace();
			}
		}
		if(outputStream != null){
			try {
				outputStream.close();
			} catch (IOException e) {
				msgLogger("ExcelUtils清理输出流资源失败！");
				e.printStackTrace();
			}
		}
		
	}
	
	//把excelFile里的数据导入到数据表中
	public Map<String, Object> excelToTable(){
		String impMsg = "导入提示：！";
		//定义导入过程的变量，行列均从0开始
		String sheetName = ""; //sheet页名称
		int rowCnt = 0; //总行数
		int rowNum = 0; //当前循环行数
		int colCnt = 0; //总列数
		int colNum = 0; //当前循环列数
		//当前行的结果集
		String[] cellArray = null;
		//最终数据结果集
		List<String[]> dataList = new ArrayList<String[]>();
		try {
			//拿到文件后缀名
			String fileExt = fileName.lastIndexOf(".")==-1?".xlsx":fileName.substring(fileName.lastIndexOf("."));
			//拿到文件输入流
			FileInputStream  fileInputStream = new FileInputStream(excelFile);
			//创建文件workbench
			
			if(".xls".equals(fileExt)){
				workbook = new HSSFWorkbook(fileInputStream);
			}else{
				//2007版excel之后选用支持更大的类，SXSSFWorkbook是动态的把数据放入内存，但是getSheetAt得到的结果不对
				workbook = new XSSFWorkbook(fileInputStream);
			}
			
			//获取Excel文档中的第一个表单
			Sheet sheet = workbook.getSheetAt(sheetIndex);
			//获取Sheet页相关信息
			sheetName = sheet.getSheetName();
			rowCnt = sheet.getPhysicalNumberOfRows();
			//拿到行的集合
			Iterator<Row> rowItr = sheet.iterator();
			while(rowItr.hasNext()){
				
				Row row = rowItr.next();
				
				//获取当前列的列数及构建数据集,保存当前最大的列数
				colCnt = row.getPhysicalNumberOfCells()>colCnt?row.getPhysicalNumberOfCells():colCnt;
				cellArray = new String[colCnt];
				//获取列集合
				Iterator<Cell> cellItr = row.iterator();
				colNum = 0; //初始化列号
				while(cellItr.hasNext()){
					Cell cell = cellItr.next();
					String cellValue = "";
					//如果得到的cell是空值，则置为空串
					if(cell == null){
						cellValue = "";
					}else{
						int cellType = cell.getCellType();
						switch (cellType) {
						case Cell.CELL_TYPE_BLANK:
							cellValue = "";
							break;
						case Cell.CELL_TYPE_BOOLEAN:
							cellValue = String.valueOf(cell.getBooleanCellValue());
							break;
						case Cell.CELL_TYPE_ERROR:
							cellValue = "";
							break;
						case Cell.CELL_TYPE_FORMULA:
							cellValue = String.valueOf(cell.getNumericCellValue());
							break;
						case Cell.CELL_TYPE_NUMERIC:
							cell.setCellType(Cell.CELL_TYPE_STRING);
							cellValue = cell.getStringCellValue().trim();
							break;
						case Cell.CELL_TYPE_STRING:
							cellValue = cell.getStringCellValue().trim();
							break;
						default:
							cellValue = "";
							break;
						}
					}
					cellArray[colNum] = cellValue;
					colNum++;
				}
				dataList.add(cellArray);
				rowNum++;
			}
		} catch (FileNotFoundException e) {
			impMsg = "错误信息：文件不存在！";
			e.printStackTrace();
		} catch (IOException e) {
			impMsg = "错误信息：读取文件出错！";
			e.printStackTrace();
		} catch (Exception e) {
			impMsg = "错误信息：表格名称："+sheetName+"第"+(rowNum+1)+"行，第"+(colNum+1)+"列数据异常，请核查后重新导入！";
			e.printStackTrace();
		}
		
		impMsg = "导入完成";
		
		Map<String, Object> impResult = new HashMap<String, Object>();
		impResult.put("impMsg", impMsg);
		impResult.put("dataList", dataList);
		impResult.put("rowCnt", rowCnt);
		impResult.put("colCnt", colCnt);
		
		return impResult;
	}
	
	//把数据表中的数据导出到excel-单表头
	public void tableToExcel(int batch, int startIndex, List<Map<String, Object>> dataList){
		//判断是否是第一批，如果是第一批，则创建workbook,创建表头，否则直接写入数据
		if(batch == 0){
			String[] header = null;
			//判断是否传入了表头，如果没有则以key值作业表头
			if(this.dataTitle == null || this.dataTitle.length == 0){
				Map<String, Object> data = (Map<String, Object>) dataList.get(0);
				header = data.keySet().toArray(new String[data.size()]);
				//如果表头为空，则列属性名理论上也为空
				dataCode = header;
			}else{
				header = dataTitle;
			}
			//创建Excel文档中的第一个表单
			sheet = workbook.createSheet("导出数据");
			
			//创建标题行
			Row row = sheet.createRow(0);
			Cell cell = null;
			
			for(int i=0; i<header.length; i++){
				createCellStyle(workbook, HSSFColor.SEA_GREEN.index, CellStyle.BORDER_THIN);
				cell = row.createCell(i);
				cell.setCellStyle(cellStyle);
				cell.setCellValue(header[i]);
			}
			cellStyle = null;
		}
		//不管是否是第一批次，都需要写入数据list
		//数据行
		Iterator<Map<String, Object>> dataItr = dataList.iterator();
		while(dataItr.hasNext()){
			Map<String, Object> rowData = dataItr.next();
			Row row = sheet.createRow(startIndex++);
			
			for(int i=0; i<dataCode.length; i++){
				String colCode = dataCode[i];
				if(cellStyle == null){
					createCellStyle(workbook, HSSFColor.WHITE.index, CellStyle.BORDER_THIN);
				}
				Cell cell = row.createCell(i);
				cell.setCellStyle(cellStyle);
				cell.setCellValue(rowData.get(colCode)==null?"":rowData.get(colCode).toString());
			}
		}
	}
	//把数据表中的数据导出到excel-多表头，支持翻页的大数据量
	public void tableToExcel(int batch, int MAX_ONETIME_COUNT, int rowIndex, int colIndex, List<LinkedHashMap<String, Object>> dataList, String[] dataCode){
		//如果没见有数据或者没有行表头则直接返回
		if(dataList.isEmpty() || dataCode.length == 0){
			return;
		}
		//判断是否是第一批，如果是第一批，则创建workbook,由于表头已经由模板决定因此直接写入数据
		sheet = workbook.getSheetAt(0);
		//数据行
		Iterator<LinkedHashMap<String, Object>> dataItr = dataList.iterator();
		//数据记录的行号
		int dataIndex = 0;
		while(dataItr.hasNext()){
			Map<String, Object> rowData = dataItr.next();
			//当前要写的行为当前这个SQL变量的开始行数加上当前批次的开始行号再加上当前数据中的行号
			int rowIdx = rowIndex+batch*MAX_ONETIME_COUNT+dataIndex;
			Row row = sheet.getRow(rowIdx);
			if(row == null){
				row = sheet.createRow(rowIdx);
			}else{
				//由于SXSSFWorkbook无法修改已经存在的行，因此直接把老的行直接删除
				sheet.removeRow(row);
				row = sheet.createRow(rowIdx);
				
			}
			
			for(int i=0; i<dataCode.length; i++){
				String colCode = dataCode[i];
				if(cellStyle == null){
					createCellStyle(workbook, HSSFColor.WHITE.index, CellStyle.BORDER_THIN);
				}
				int colIdx = i+colIndex;
				Cell cell = row.getCell(colIdx);
				if(cell == null){
					cell = row.createCell(colIdx);
				}
				cell.setCellStyle(cellStyle);
				Object cellValue = rowData.get(colCode)==null?"-":rowData.get(colCode);
				int cellType = cell.getCellType();
				switch (cellType) {
				case Cell.CELL_TYPE_NUMERIC:
					cell.setCellValue(Double.parseDouble(cellValue.toString()));
					break;
				default:
					cell.setCellValue(cellValue.toString());
					break;
				}
			}
			dataIndex++;
		}
	}
	//把数据表中的数据导出到excel-多表头
	public void tableToExcel(int rowIndex, int colIndex, List<LinkedHashMap<String, Object>> dataList, String[] dataCode){
		//如果没见有数据或者没有行表头则直接返回
		if(dataList.isEmpty() || dataCode.length == 0){
			return;
		}
		sheet = workbook.getSheetAt(0);
		//按照模板行和列进行数据填入
		Iterator<Row> rowItr = sheet.rowIterator();
		//得到合并的单元格
		List<CellRangeAddress> cellRegionlist = getCombineCell(sheet);
//		for (CellRangeAddress cellRegion : cellRegionlist){
//			// 记录该合并单元格的上下左右起点坐标
//			int rowFrom = cellRegion.getFirstRow();
//			int rowTo = cellRegion.getLastRow();
//			int cellFrom = cellRegion.getFirstColumn();
//			int cellTo = cellRegion.getLastColumn();
//			msgLogger("CellRegion: rowFrom="+rowFrom+",rowTo="+rowTo+",cellFrom="+cellFrom+",cellTo="+cellTo);
//		}
		//当前数据行
		int dataRow = -1;
		while(rowItr.hasNext()){
			Row row = rowItr.next();
//			msgLogger("row==========="+row.getRowNum());
			//如果当前的行数小于数据的开始行，则直接开始下次
			if(row.getRowNum()<rowIndex||dataRow >= (dataList.size()-1)){
				continue;
			}else{
				int nextRowFlag = 1;
				//当前数据列号
				int dataCol = 0;
				Iterator<Cell> cellItr = row.cellIterator();
				while(cellItr.hasNext()){
					Cell cell = cellItr.next();
//					msgLogger("row==========="+cell.getRowIndex()+"cell============="+cell.getColumnIndex()+"cellAdress====="+cell.getAddress());
					//如果当前的列数小于数据的开始列，或者大于开始列号加上则直接开始下次循环
					if(cell.getColumnIndex() < colIndex || cell.getColumnIndex() >= colIndex+dataCode.length){
						continue;
					}else{
						int cellFlag = isFirstCellOfCellRegion(cellRegionlist, cell);
						
						//如果当前单元格不存在合并，或者是合并的单元格的第一个就写入当前数据
						if(cellFlag == 0 || cellFlag == 1){
							//判断是否换行，换行行数加1否则不变
							if(nextRowFlag == 1){
								dataRow++;
								nextRowFlag = 0;
							}
							if(cellStyle == null){
								createCellStyle(workbook, HSSFColor.WHITE.index, CellStyle.BORDER_THIN);
							}
							cell.setCellStyle(cellStyle);
//							msgLogger("====================================dataRow"+dataRow+",dataCol"+dataCol+"===========rowIndex"+row.getRowNum()+",colIndex"+cell.getColumnIndex());
							
							Map<String, Object> rowData = dataList.get(dataRow);
							Object cellValue = rowData.get(dataCode[dataCol])==null?"-":rowData.get(dataCode[dataCol]);
							int cellType = cell.getCellType();
							switch (cellType) {
							case Cell.CELL_TYPE_NUMERIC:
								cell.setCellValue(Double.parseDouble(cellValue.toString()));
								break;
							default:
								cell.setCellValue(cellValue.toString());
								break;
							}
							dataCol++;
						}
					}
				}
			}
			
		}
	}
	//判断单元格是否为合并单元格的第一个，或者是否存在合并 cellType 1单元格不存在合并，0单元格存在合并且是第一个，-1单元格存在合并，但不是第一个
	public int isFirstCellOfCellRegion(List<CellRangeAddress> cellRegionlist, Cell cell){
		int cellFlag = 1;
		//获得当前的行号和列号
		int rowIndex = cell.getRowIndex();
		int colIndex = cell.getColumnIndex();
		for (CellRangeAddress cellRegion : cellRegionlist){
			// 记录该合并单元格的上下左右起点坐标
			int rowFrom = cellRegion.getFirstRow();
			int rowTo = cellRegion.getLastRow();
			int cellFrom = cellRegion.getFirstColumn();
			int cellTo = cellRegion.getLastColumn();
			if(rowIndex == rowFrom && colIndex == cellFrom){
				cellFlag = 0;
				break;
			}else if(rowIndex >= rowFrom && rowIndex <= rowTo && colIndex >= cellFrom && colIndex <= cellTo){
				cellFlag = -1;
				break;
			}else{
				cellFlag = 1;
			}
		}
		return cellFlag;
	}
	//找到当前sheet的所有合并单元格
	private List<CellRangeAddress> getCombineCell(Sheet sheet) {
		List<CellRangeAddress> regionlist = sheet.getMergedRegions();
		return regionlist;
	}

	//把workbook写入到excel
	public void writeWorkbook(){
		FileOutputStream fileOutputStream = null;
		try {
			File file = new File(filePath);
			if(!file.getParentFile().exists()){
				msgLogger("如果文件所在目录不存在，则创建他的上层目录");
				file.getParentFile().mkdirs();
			}
			fileOutputStream = new FileOutputStream(file);
			workbook.write(fileOutputStream);
		} catch (FileNotFoundException e1) {
			msgLogger("找不到指定的文件！");
			e1.printStackTrace();
		} catch (IOException e1) {
			msgLogger("导出报错！");
			e1.printStackTrace();
		} finally {
			if(fileOutputStream != null){
				try {
					fileOutputStream.close();
				} catch (IOException e) {
					msgLogger("关闭写入excel的输出流报错！");
					e.printStackTrace();
				}
			}
		}
	}
	//创建单元格格式
	public void createCellStyle(Workbook wb, short cellBackgroundColor, short cellBorder){
		cellStyle = wb.createCellStyle();
		cellStyle.setFillForegroundColor(cellBackgroundColor);
		cellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		cellStyle.setBorderTop(cellBorder);
		cellStyle.setBorderBottom(cellBorder);
		cellStyle.setBorderLeft(cellBorder);
		cellStyle.setBorderRight(cellBorder);
	}
	/**
	 * 把Excel转换成html
	 */
	//
	public ToHtml excelToHtml(){
		toHtml.setCompleteHTML(true);
		toHtml.printPage();
		return toHtml;
	}
}
