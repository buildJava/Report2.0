package com.aiutil.report.utils;

import static org.apache.poi.ss.usermodel.CellStyle.ALIGN_CENTER;
import static org.apache.poi.ss.usermodel.CellStyle.ALIGN_CENTER_SELECTION;
import static org.apache.poi.ss.usermodel.CellStyle.ALIGN_FILL;
import static org.apache.poi.ss.usermodel.CellStyle.ALIGN_GENERAL;
import static org.apache.poi.ss.usermodel.CellStyle.ALIGN_JUSTIFY;
import static org.apache.poi.ss.usermodel.CellStyle.ALIGN_LEFT;
import static org.apache.poi.ss.usermodel.CellStyle.ALIGN_RIGHT;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_DASHED;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_DASH_DOT;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_DASH_DOT_DOT;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_DOTTED;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_DOUBLE;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_HAIR;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_MEDIUM;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_MEDIUM_DASHED;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_MEDIUM_DASH_DOT;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_MEDIUM_DASH_DOT_DOT;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_NONE;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_SLANTED_DASH_DOT;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_THICK;
import static org.apache.poi.ss.usermodel.CellStyle.BORDER_THIN;
import static org.apache.poi.ss.usermodel.CellStyle.VERTICAL_BOTTOM;
import static org.apache.poi.ss.usermodel.CellStyle.VERTICAL_CENTER;
import static org.apache.poi.ss.usermodel.CellStyle.VERTICAL_TOP;

import java.io.Closeable;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Formatter;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.format.CellFormat;
import org.apache.poi.ss.format.CellFormatResult;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;


//定义个excel转换成html的内部类
public class ToHtml{
	private Workbook wb;
	private Appendable output;
	private boolean completeHTML;
	private Formatter outHtml;
	private Formatter outCss;
	private boolean gotBounds;
	private int firstColumn;
	private int endColumn;
	private HtmlHelper helper;
	private String _html;
	private String _css;
	private List<Map<String, Object>> varList = new ArrayList<Map<String, Object>>();
	
	private final String DEFAULTS_CLASS = "excelDefaults";
	private final String COL_HEAD_CLASS = "colHeader";
	@SuppressWarnings("unused")
	private final String ROW_HEAD_CLASS = "rowHeader";

	private final Map<Short, String> ALIGN = mapFor(ALIGN_LEFT, "left", ALIGN_CENTER, "center", ALIGN_RIGHT,
			"right", ALIGN_FILL, "left", ALIGN_JUSTIFY, "left", ALIGN_CENTER_SELECTION, "center");

	private final Map<Short, String> VERTICAL_ALIGN = mapFor(VERTICAL_BOTTOM, "middle", VERTICAL_CENTER,
			"middle", VERTICAL_TOP, "middle");

	private final Map<Short, String> BORDER = mapFor(BORDER_DASH_DOT, "solid 1pt", BORDER_DASH_DOT_DOT,
			"solid 1pt", BORDER_DASHED, "solid 1pt", BORDER_DOTTED, "solid 1pt", BORDER_DOUBLE, "double 3pt",
			BORDER_HAIR, "solid 1px", BORDER_MEDIUM, "solid 2pt", BORDER_MEDIUM_DASH_DOT, "solid 2pt",
			BORDER_MEDIUM_DASH_DOT_DOT, "solid 2pt", BORDER_MEDIUM_DASHED, "solid 2pt", BORDER_NONE, "none",
			BORDER_SLANTED_DASH_DOT, "solid 2pt", BORDER_THICK, "solid 3pt", BORDER_THIN, "solid 1pt");

	public void setCompleteHTML(boolean completeHTML) {
		this.completeHTML = completeHTML;
	}

	@SuppressWarnings({ "unchecked" })
	private <K, V> Map<K, V> mapFor(Object... mapping) {
		Map<K, V> map = new HashMap<K, V>();
		for (int i = 0; i < mapping.length; i += 2) {
			map.put((K) mapping[i], (V) mapping[i + 1]);
		}
		return map;
	}
	//ToHtml的构造方法
	public ToHtml(Workbook wb) {
		if (wb == null)
			throw new NullPointerException("wb");
		this.wb = wb;
		setupColorMap();
	}
	//返回excel解析完的html
	public void printPage() {
		if (completeHTML) {
			ensureout();
			print();
			_html = outHtml.toString();
			_css = outCss.toString();
		}
		
		if (outHtml != null)
			outHtml.close();
		if (outCss != null)
			outCss.close();
		if (output instanceof Closeable) {
			Closeable closeable = (Closeable) output;
			try {
				closeable.close();
			} catch (IOException e) {
				System.out.println("关闭closeable出错");
				e.printStackTrace();
			}
		}
	}
	//得到html内容
	public String getHtml() {
		return _html;
	}
	//得到css样式
	public String getCss() {
		return _css;
	}
	//返回excel解析出的变量列表
	public List<Map<String, Object>> getVarList(){
		return varList;
	}
	
	public void setVarList(List<Map<String, Object>> varList) {
		this.varList = varList;
	}

	//重构颜色Map
	private void setupColorMap() {
		if (wb instanceof HSSFWorkbook)
			helper = new HSSFHtmlHelper((HSSFWorkbook) wb);
		else if (wb instanceof XSSFWorkbook)
			helper = new XSSFHtmlHelper();
		else
			throw new IllegalArgumentException("未知的workBook类型: " + wb.getClass().getSimpleName());
	}

	public void print() {
		printInlineStyle();
		printSheets();
	}
	//写入样式内容
	private void printInlineStyle() {
		//头尾不需要
//		outCss.format("<style type=\"text/css\">%n");
		printStyles();
//		outCss.format("</style>%n");
	}
	//清空输出流
	private void ensureout() {
		if (outCss == null)
			outCss = new Formatter(output);
		if (outHtml == null)
			outHtml = new Formatter(output);
	}
	//将excel中的单元格样式放入set
	public void printStyles() {
		ensureout();
		
		Set<CellStyle> seen = new HashSet<CellStyle>();
		for (int i = 0; i < wb.getNumberOfSheets(); i++) {
			Sheet sheet = wb.getSheetAt(i);
			Iterator<Row> rows = sheet.rowIterator();
			while (rows.hasNext()) {
				Row row = rows.next();
				for (Cell cell : row) {
					CellStyle style = cell.getCellStyle();
					if (!seen.contains(style)) {
						printStyle(style);
						seen.add(style);
					}
				}
			}
		}
	}
	//输出单元格样式
	private void printStyle(CellStyle style) {
		outCss.format(".%s .%s {%n", DEFAULTS_CLASS, styleName(style));
		styleContents(style);
		outCss.format("}%n");
	}
	
	private void styleContents(CellStyle style) {
		styleoutHtml("text-align", style.getAlignment(), ALIGN);
		styleoutHtml("vertical-align", style.getAlignment(), VERTICAL_ALIGN);
		fontStyle(style);
		borderStyles(style);
		helper.colorStyles(style, outCss);
	}

	private void borderStyles(CellStyle style) {
		styleoutHtml("border-left", style.getBorderLeft(), BORDER);
		styleoutHtml("border-right", style.getBorderRight(), BORDER);
		styleoutHtml("border-top", style.getBorderTop(), BORDER);
		styleoutHtml("border-bottom", style.getBorderBottom(), BORDER);
	}

	private void fontStyle(CellStyle style) {
		Font font = wb.getFontAt(style.getFontIndex());

		if (font.getBoldweight() >= HSSFFont.BOLDWEIGHT_BOLD)
			outCss.format("  font-weight: bold;%n");
		if (font.getItalic())
			outCss.format("  font-style: italic;%n");

		int fontheight = font.getFontHeightInPoints();
		if (fontheight == 9) {
			// fix for stupid ol Windows
			fontheight = 10;
		}
		outCss.format("  font-size: %dpt;%n", fontheight);

		// Font color is handled with the other colors
	}

	private String styleName(CellStyle style) {
		if (style == null)
			style = wb.getCellStyleAt((short) 0);
		StringBuilder sb = new StringBuilder();
		Formatter fmt = new Formatter(sb);
		try {
			fmt.format("style_%02x", style.getIndex());
			return fmt.toString();
		} finally {
			fmt.close();
		}
	}

	private <K> void styleoutHtml(String attr, K key, Map<K, String> mapping) {
		String value = mapping.get(key);
		if (value != null) {
			outCss.format("  %s: %s;%n", attr, value);
		}
	}

	private int ultimateCellType(Cell c) {
		int type = c.getCellType();
		if (type == Cell.CELL_TYPE_FORMULA)
			type = c.getCachedFormulaResultType();
		return type;
	}

	private void printSheets() {
		ensureout();
		Sheet sheet = wb.getSheetAt(0);
		printSheet(sheet);
	}

	public void printSheet(Sheet sheet) {
		ensureout();
		outHtml.format("<table class='%s' id='data-body'>%n", DEFAULTS_CLASS);
		//不生成cols组
//		printCols(sheet);
		ensureColumnBounds(sheet);
		printSheetContent(sheet);
		outHtml.format("</table>%n");
	}

	@SuppressWarnings("unused")
	private void printCols(Sheet sheet) {
		outHtml.format("<col/>%n");
		ensureColumnBounds(sheet);
		for (int i = firstColumn; i < endColumn; i++) {
			outHtml.format("<col/>%n");
		}
	}

	private void ensureColumnBounds(Sheet sheet) {
		if (gotBounds)
			return;

		Iterator<Row> iter = sheet.rowIterator();
		firstColumn = (iter.hasNext() ? Integer.MAX_VALUE : 0);
		endColumn = 0;
		while (iter.hasNext()) {
			Row row = iter.next();
			short firstCell = row.getFirstCellNum();
			if (firstCell >= 0) {
				firstColumn = Math.min(firstColumn, firstCell);
				endColumn = Math.max(endColumn, row.getLastCellNum());
			}
		}
		gotBounds = true;
	}

	@SuppressWarnings("unused")
	private void printColumnHeads() {
		outHtml.format("<thead>%n");
		outHtml.format("  <tr class='%s'>%n", COL_HEAD_CLASS);
		outHtml.format("    <th class='%s'>&#x25CA;</th>%n", COL_HEAD_CLASS);
		// noinspection UnusedDeclaration
		StringBuilder colName = new StringBuilder();
		for (int i = firstColumn; i < endColumn; i++) {
			colName.setLength(0);
			int cnum = i;
			do {
				colName.insert(0, (char) ('A' + cnum % 26));
				cnum /= 26;
			} while (cnum > 0);
			outHtml.format("    <th class='%s'>%s</th>%n", COL_HEAD_CLASS, colName);
		}
		outHtml.format("  </tr>%n");
		outHtml.format("</thead>%n");
	}

	private void printSheetContent(Sheet sheet) {
		// 不再生成表头
		//printColumnHeads();

		outHtml.format("<tbody id='reportBody'>%n");
		Iterator<Row> rows = sheet.rowIterator();
		//得到合并的单元格
		List<CellRangeAddress> cellRegionlist = getCombineCell(sheet);
		while (rows.hasNext()) {
			Row row = rows.next();

			outHtml.format("  <tr>%n");
			//去掉每行的行号
			//outHtml.format("    <td class=%s>%d</td>%n", ROW_HEAD_CLASS, row.getRowNum() + 1);
			for (int i = firstColumn; i < endColumn; i++) {
				String content = "&nbsp;";
				String attrs = "";
				CellStyle style = null;
				//合并单元格的标识
				String colSpan = "";
				String rowSpan = "";
				if (i >= row.getFirstCellNum() && i < row.getLastCellNum()) {
					Cell cell = row.getCell(i);
					
					//获取单元格的样式及值
					if (cell != null) {
						style = cell.getCellStyle();
						attrs = tagStyle(cell, style);
						// Set the value that is rendered for the cell
						// also applies the format
						CellFormat cf = CellFormat.getInstance(style.getDataFormatString());
						CellFormatResult result = cf.apply(cell);
						content = result.text;
						if (content.equals("")){
							content = "&nbsp;";
						}else if(content.startsWith("${") && content.endsWith("}")){
							//判断单元格的值是否符合SQL变量的格式
							anlCellVal(cell, content);
							content = "&nbsp;";
						}
							
					}
					
					//根据单元格是否合并生成html代码
					int rowIndex = cell.getRowIndex();
					int cellIndex = cell.getColumnIndex();
					// 标识是否该单元格是否在合并单元内
					boolean mergeFlag = false;
					for (CellRangeAddress cellRegion : cellRegionlist) {
						// 记录该合并单元格的上下左右起点坐标
						int rowFrom = cellRegion.getFirstRow();
						int rowTo = cellRegion.getLastRow();
						int cellFrom = cellRegion.getFirstColumn();
						int cellTo = cellRegion.getLastColumn();
						
						// 只对左上角的第一个做colspan和rowspan属性
						if (rowIndex == rowFrom && cellIndex == cellFrom) {
							if (cellTo > cellFrom) {
								colSpan = "colspan='"+(cellTo - cellFrom + 1)+"'";
							}
							if (rowTo > rowFrom) {
								rowSpan = "rowspan='"+(rowTo - rowFrom + 1)+"'";
							}
							outHtml.format("    <td "+rowSpan+colSpan+" class='%s' %s>%s</td>%n", styleName(style), attrs, content);
							mergeFlag = true;
							break;
						}
						if (rowIndex >= rowFrom && rowIndex <= rowTo
								&& cellIndex >= cellFrom && cellIndex <= cellTo) {
							mergeFlag = true;
							break;
						}
					}
					// 不在合并单元格内的格子
					if (!mergeFlag) {
						colSpan = "";
						rowSpan = "";
						outHtml.format("    <td "+rowSpan+colSpan+" class='%s' %s>%s</td>%n", styleName(style), attrs, content);
					}
				}
			}
			outHtml.format("  </tr>%n");
		}
		outHtml.format("</tbody>%n");
	}
	
	/**
	 * 
	 * 方法说明：找出该sheet页内所有的合并单元格
	 * 
	 * @param sheet
	 * @param list
	 * 
	 */
	private List<CellRangeAddress> getCombineCell(Sheet sheet) {
		List<CellRangeAddress> cellRegionlist = sheet.getMergedRegions();
		return cellRegionlist;
	}

	private String tagStyle(Cell cell, CellStyle style) {
		if (style.getAlignment() == ALIGN_GENERAL) {
			switch (ultimateCellType(cell)) {
			case HSSFCell.CELL_TYPE_STRING:
				return "style=\"text-align: left;\"";
			case HSSFCell.CELL_TYPE_BOOLEAN:
			case HSSFCell.CELL_TYPE_ERROR:
				return "style=\"text-align: center;\"";
			case HSSFCell.CELL_TYPE_NUMERIC:
			default:
				// "right" is the default
				break;
			}
		}
		return "";
	}
	//判断单元格的值类型
	private void anlCellVal(Cell cell, String cellText){
		//初始map
		Map<String, Object> varMap = new HashMap<String, Object>();
		if(cellText.startsWith("${") && cellText.endsWith("}")){
			int rowIndex = cell.getRowIndex();
			int colIndex = cell.getColumnIndex();
			varMap.put("varCode", cellText);
			varMap.put("rowIndex", rowIndex);
			varMap.put("colIndex", colIndex);
			varList.add(varMap);
		}
	}
}