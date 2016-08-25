# Report2.0
excel to html,excel to table, table to excel,poi download
1.数据库对象的编写，参见WebContent/Note/oracle*.sql
2.将表导入报表元数据管理，编写创建报表第一步，导入数据表
	功能点：
	1》所属用户的下拉菜单
	2》数据表支持模糊查询，并且所填表名必须为下拉菜单中的选项，校验时可以直接判断输入框的值是否是下拉菜单中的某一项
	3》数据表描述，必填项目
	4》是否分表，默认为是
	5》分表变量也可配置，默认是地市
	6》口径描述为必填项目，描述报表的数据口径
	7》在保存报表元数据时需要把报表的字段列表也保存下来，最终生成两张数据表 RPT_REPORT_INFO RPT_REPORT_FIELD
3.点击报表元数据名称可以进行报表元数据编辑操作
4.主要功能分为报表配置，报表查看，报表下载。
5.当前版本功能汇总：
	报表元数据配置，从数据库中直接抽取数据库表
	报表查询控件的配置，支持级别操作
	报表配置，单表头配置，支持表字段筛选数据聚合
	报表配置，多表头配置，支持模板的导入，数据源支持SQL注入
	报表下载，支持超大数据量的下载，目前测试过50万50字段左右的下载，更大的理论上支持
6.工程中的工具类主要是excelUtils.java
	支持，excel的导入到数据库表，.xls,xlsx格式均可
	excel转成html，html的样式与excel中一致
	数据库表导出到excel
	excel文件的写出使用插件apache-poi-3.14
	
IN ENGLISH
main functions:
  1.excel .xls,.xlsx Suffix file import
  2.excel Parse into html
  3.table export to excel
  4.excel file download
  5.report configuration
