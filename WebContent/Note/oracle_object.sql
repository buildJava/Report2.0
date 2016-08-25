----------------------------------------------
-- Export file for user AIUTIL              --
-- Created by wangjian on 16/8/23, 14:45:58 --
----------------------------------------------

set define off
spool object.log

prompt
prompt Creating table AP_CHL_ORG_INCOME_ANL_M
prompt ======================================
prompt
create table AP_CHL_ORG_INCOME_ANL_M
(
  deal_mon               VARCHAR2(8),
  region_id              VARCHAR2(5),
  region_name            VARCHAR2(10),
  county_code            VARCHAR2(10),
  county_name            VARCHAR2(20),
  channel_type           NUMBER(8),
  channel_type_name      VARCHAR2(100),
  channel_type_dtl       NUMBER(8),
  channel_type_dtl_name  VARCHAR2(100),
  channel_type_dtl3      NUMBER,
  channel_type_dtl3_name VARCHAR2(100),
  manager_id             NUMBER(12),
  org_id                 VARCHAR2(20),
  org_name               VARCHAR2(100),
  income_fee             NUMBER,
  rent_fee               NUMBER,
  bs_fee                 NUMBER
)
partition by list (DEAL_MON)
(
  partition P201604 values ('201604')
    tablespace USERS,
  partition P201605 values ('201605')
    tablespace USERS,
  partition P201606 values ('201606')
    tablespace USERS,
  partition P201607 values ('201607')
    tablespace USERS
);
comment on table AP_CHL_ORG_INCOME_ANL_M
  is '渠道收入分析';
comment on column AP_CHL_ORG_INCOME_ANL_M.deal_mon
  is '月份';
comment on column AP_CHL_ORG_INCOME_ANL_M.region_id
  is '地市编码';
comment on column AP_CHL_ORG_INCOME_ANL_M.region_name
  is '地市';
comment on column AP_CHL_ORG_INCOME_ANL_M.county_code
  is '区县编码';
comment on column AP_CHL_ORG_INCOME_ANL_M.county_name
  is '区县';
comment on column AP_CHL_ORG_INCOME_ANL_M.channel_type
  is '一级类型编码';
comment on column AP_CHL_ORG_INCOME_ANL_M.channel_type_name
  is '一级类型';
comment on column AP_CHL_ORG_INCOME_ANL_M.channel_type_dtl
  is '二级类型编码';
comment on column AP_CHL_ORG_INCOME_ANL_M.channel_type_dtl_name
  is '二级类型';
comment on column AP_CHL_ORG_INCOME_ANL_M.channel_type_dtl3
  is '三级类型编码';
comment on column AP_CHL_ORG_INCOME_ANL_M.channel_type_dtl3_name
  is '三级类型';
comment on column AP_CHL_ORG_INCOME_ANL_M.manager_id
  is '店长编码';
comment on column AP_CHL_ORG_INCOME_ANL_M.org_id
  is '营业厅编码';
comment on column AP_CHL_ORG_INCOME_ANL_M.org_name
  is '营业厅名称';
comment on column AP_CHL_ORG_INCOME_ANL_M.income_fee
  is '总收入（元）';
comment on column AP_CHL_ORG_INCOME_ANL_M.rent_fee
  is '租金';
comment on column AP_CHL_ORG_INCOME_ANL_M.bs_fee
  is '业务收入（元）';

prompt
prompt Creating table AP_RPT_CRM_AREA_TRACE_D_ZJ
prompt =========================================
prompt
create table AP_RPT_CRM_AREA_TRACE_D_ZJ
(
  deal_date             VARCHAR2(8),
  region_code           VARCHAR2(3),
  region_desc           VARCHAR2(20),
  city_code             VARCHAR2(5),
  city_desc             VARCHAR2(30),
  org_id                NUMBER(8),
  org_name              VARCHAR2(200),
  channel_type          VARCHAR2(20),
  area_code             NUMBER(8),
  area_name             VARCHAR2(200),
  owner_name            VARCHAR2(40),
  owner_phone           NUMBER(11),
  day_crm_usercnt       NUMBER,
  day_cntct_usercnt     NUMBER,
  day_recm_usercnt      NUMBER,
  day_recm_userrate     NUMBER,
  avg_day_recm_userrate NUMBER,
  day_suc_usercnt       NUMBER,
  day_suc_userrate      NUMBER,
  day_chg_userrate      NUMBER,
  avg_day_suc_userrate  NUMBER,
  day_maincntct_usercnt NUMBER,
  day_mainsuc_usercnt   NUMBER,
  day_subcntct_usercnt  NUMBER,
  day_subsuc_usercnt    NUMBER,
  mon_crm_usercnt       NUMBER,
  mon_cntct_usercnt     NUMBER,
  mon_recm_usercnt      NUMBER,
  mon_recm_userrate     NUMBER,
  avg_mon_recm_userrate NUMBER,
  mon_suc_usercnt       NUMBER,
  mon_suc_userrate      NUMBER,
  mon_chg_userrate      NUMBER,
  avg_mon_suc_userrate  NUMBER,
  mon_maincntct_usercnt NUMBER,
  mon_mainsuc_usercnt   NUMBER,
  mon_subcntct_usercnt  NUMBER,
  mon_subsuc_usercnt    NUMBER
)
;
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.deal_date
  is '处理日期';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.region_code
  is '地市编码';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.region_desc
  is '地市描述';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.city_code
  is '县市编码';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.city_desc
  is '县市描述';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.org_id
  is '区域';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.org_name
  is '区域描述';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.channel_type
  is '渠道类型';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.area_code
  is '营业厅编号';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.area_name
  is '营业厅';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.owner_name
  is '店长';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.owner_phone
  is '店长号码';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.day_crm_usercnt
  is '当日接触用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.day_cntct_usercnt
  is '当日营销接触用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.day_recm_usercnt
  is '当日查看推荐详情用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.day_recm_userrate
  is '当日政策详情查看率';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.avg_day_recm_userrate
  is '当日平均推荐率';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.day_suc_usercnt
  is '当日营销成功用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.day_suc_userrate
  is '当日推荐成功率';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.day_chg_userrate
  is '当日推荐转化率';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.avg_day_suc_userrate
  is '当日平均成功率';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.day_maincntct_usercnt
  is '当日主推营销接触用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.day_mainsuc_usercnt
  is '当日主推营销成功用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.day_subcntct_usercnt
  is '当日辅推营销接触用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.day_subsuc_usercnt
  is '当日辅推营销成功用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.mon_crm_usercnt
  is '当月累计接触用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.mon_cntct_usercnt
  is '当月累计营销接触用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.mon_recm_usercnt
  is '当月累计查看推荐详情用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.mon_recm_userrate
  is '当月累计政策详情查看率';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.avg_mon_recm_userrate
  is '当月累计平均推荐率';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.mon_suc_usercnt
  is '当月累计营销成功用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.mon_suc_userrate
  is '当月累计推荐成功率';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.mon_chg_userrate
  is '当月累计推荐转化率';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.avg_mon_suc_userrate
  is '当月累计平均成功率';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.mon_maincntct_usercnt
  is '当月累计主推营销接触用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.mon_mainsuc_usercnt
  is '当月累计主推营销成功用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.mon_subcntct_usercnt
  is '当月累计辅推营销接触用户数';
comment on column AP_RPT_CRM_AREA_TRACE_D_ZJ.mon_subsuc_usercnt
  is '当月累计辅推营销成功用户数';

prompt
prompt Creating table AP_RPT_CRM_CNTCT_DTL_D_ZJ
prompt ========================================
prompt
create table AP_RPT_CRM_CNTCT_DTL_D_ZJ
(
  deal_date           VARCHAR2(8),
  region_code         VARCHAR2(4),
  city_code           VARCHAR2(8),
  city_desc           VARCHAR2(20),
  area_code           VARCHAR2(10),
  op_id               VARCHAR2(12),
  user_id             NUMBER,
  phone_no            VARCHAR2(20),
  cntct_time          DATE,
  cntct_strategy_id   NUMBER(12),
  cntct_strategy_name VARCHAR2(100),
  cntct_ploy_id       VARCHAR2(20),
  cntct_extend_id     VARCHAR2(20),
  cntct_ploy_desc     VARCHAR2(200),
  mrmd_order          VARCHAR2(10),
  per_dis_flag        CHAR(1),
  deal_ploy_id        VARCHAR2(20),
  deal_extend_id      VARCHAR2(20),
  deal_ploy_desc      VARCHAR2(500),
  deal_time           DATE,
  channel_type        VARCHAR2(2),
  sys_from            VARCHAR2(60),
  item_type           VARCHAR2(50),
  offer_type_desc     VARCHAR2(30)
)
partition by list (DEAL_DATE)
(
  partition P20160101 values ('20160101')
    tablespace USERS,
  partition P20160102 values ('20160102')
    tablespace USERS
);
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.deal_date
  is '处理日期';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.region_code
  is '地市编码';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.city_code
  is '区县编码';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.city_desc
  is '区县';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.area_code
  is '营业厅编码';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.op_id
  is '营业员工号';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.user_id
  is '营销接触用户编码';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.phone_no
  is '营销接触用户号码';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.cntct_time
  is '营销接触时间';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.cntct_strategy_id
  is '营销接触策略编号';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.cntct_strategy_name
  is '接触接触策略名称';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.cntct_ploy_id
  is '营销接触政策ID';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.cntct_extend_id
  is '接触策划短编号';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.cntct_ploy_desc
  is '营销接触政策名称';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.mrmd_order
  is '营销接触政策优先级';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.per_dis_flag
  is '是否营销查询';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.deal_ploy_id
  is '成功受理策划编号';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.deal_extend_id
  is '成功受理策划短编号';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.deal_ploy_desc
  is '成功受理策划名称';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.deal_time
  is '成功受理时间';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.channel_type
  is '渠道类型';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.sys_from
  is '来源系统';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.item_type
  is '订购类型';
comment on column AP_RPT_CRM_CNTCT_DTL_D_ZJ.offer_type_desc
  is '订购类型';

prompt
prompt Creating table CD_CHANNEL_TYPE
prompt ==============================
prompt
create table CD_CHANNEL_TYPE
(
  channel_type1_code NUMBER(8),
  channel_type1_desc VARCHAR2(100),
  channel_type2_code NUMBER(8),
  channel_type2_desc VARCHAR2(100),
  channel_type3_code NUMBER,
  channel_type3_desc VARCHAR2(100)
)
;

prompt
prompt Creating table CD_LOC_CITY
prompt ==========================
prompt
create table CD_LOC_CITY
(
  city_code   VARCHAR2(6),
  city_desc   VARCHAR2(20),
  region_code VARCHAR2(3),
  region_desc VARCHAR2(10)
)
;

prompt
prompt Creating table CD_LOC_REGION
prompt ============================
prompt
create table CD_LOC_REGION
(
  prov_code      VARCHAR2(3),
  prov_desc      VARCHAR2(20),
  region_code    VARCHAR2(3) not null,
  region_desc    VARCHAR2(20),
  region_abbr    VARCHAR2(10) not null,
  long_code      VARCHAR2(5),
  prov_dist_id   NUMBER(8),
  region_dist_id NUMBER(8),
  eff_flag_code  INTEGER,
  bak_fld1       INTEGER,
  bak_fld2       VARCHAR2(40),
  bak_fld3       VARCHAR2(40)
)
;
comment on table CD_LOC_REGION
  is 'CDE.LOC.浙江地市维表';
comment on column CD_LOC_REGION.prov_code
  is '省份代码';
comment on column CD_LOC_REGION.prov_desc
  is '省份描述';
comment on column CD_LOC_REGION.region_code
  is '地市代码';
comment on column CD_LOC_REGION.region_desc
  is '地市描述';
comment on column CD_LOC_REGION.region_abbr
  is '地市缩写';
comment on column CD_LOC_REGION.long_code
  is '长途区号';
comment on column CD_LOC_REGION.prov_dist_id
  is '省份区域ID';
comment on column CD_LOC_REGION.region_dist_id
  is '地市区域ID';
comment on column CD_LOC_REGION.eff_flag_code
  is '有效标识';
comment on column CD_LOC_REGION.bak_fld1
  is '备份字段1';
comment on column CD_LOC_REGION.bak_fld2
  is '备份字段2';
comment on column CD_LOC_REGION.bak_fld3
  is '备份字段3';

prompt
prompt Creating table E3_AP_RPT_GRP_FEE_P_M
prompt ====================================
prompt
create table E3_AP_RPT_GRP_FEE_P_M
(
  deal_mon              VARCHAR2(6),
  region_code           VARCHAR2(3),
  region_desc           VARCHAR2(10),
  row_num               NUMBER,
  prod_type             VARCHAR2(50),
  prod_sub_type         VARCHAR2(50),
  this_mon_rev          VARCHAR2(50),
  this_mon_hb           VARCHAR2(50),
  this_year_rev         VARCHAR2(50),
  this_year_tb          VARCHAR2(50),
  this_year_present_rev VARCHAR2(50),
  this_year_present_hkl VARCHAR2(50),
  this_year_present_zb  VARCHAR2(50),
  this_year_unpay_fee   VARCHAR2(50),
  this_year_unpay_bl    VARCHAR2(50),
  this_year_unpay_zb    VARCHAR2(50),
  this_year_rev_sh      VARCHAR2(50),
  this_year_rev_shtb    VARCHAR2(50),
  last_mon_rev          VARCHAR2(50),
  last_year_rev         VARCHAR2(50),
  last_yearmon_rev      VARCHAR2(50),
  this_mon_tb           VARCHAR2(50)
)
;
comment on column E3_AP_RPT_GRP_FEE_P_M.deal_mon
  is '月份                   ';
comment on column E3_AP_RPT_GRP_FEE_P_M.region_code
  is '地市编码               ';
comment on column E3_AP_RPT_GRP_FEE_P_M.region_desc
  is '地市                   ';
comment on column E3_AP_RPT_GRP_FEE_P_M.row_num
  is '序号                   ';
comment on column E3_AP_RPT_GRP_FEE_P_M.prod_type
  is '业务种类               ';
comment on column E3_AP_RPT_GRP_FEE_P_M.prod_sub_type
  is '业务细项               ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_mon_rev
  is '本月出账收入金额       ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_mon_hb
  is '本月出账收入环比       ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_year_rev
  is '年累计出账收入金额     ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_year_tb
  is '年累计出账收入同比     ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_year_present_rev
  is '馈赠金金额             ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_year_present_hkl
  is '馈赠金回馈率           ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_year_present_zb
  is '馈赠金占比             ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_year_unpay_fee
  is '欠费金额               ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_year_unpay_bl
  is '欠费欠费率             ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_year_unpay_zb
  is '欠费占比               ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_year_rev_sh
  is '年累计税后收入金额     ';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_year_rev_shtb
  is '年累计税后收入同比     ';
comment on column E3_AP_RPT_GRP_FEE_P_M.last_mon_rev
  is '上月出账收入金额       ';
comment on column E3_AP_RPT_GRP_FEE_P_M.last_year_rev
  is '上年同期年累计出账收入 ';
comment on column E3_AP_RPT_GRP_FEE_P_M.last_yearmon_rev
  is '上年同期月出账收入';
comment on column E3_AP_RPT_GRP_FEE_P_M.this_mon_tb
  is '本月出账收入同比';

prompt
prompt Creating table E3_AP_RPT_GRP_FEE_P_M_2
prompt ======================================
prompt
create table E3_AP_RPT_GRP_FEE_P_M_2
(
  deal_mon   VARCHAR2(8),
  order_id   NUMBER,
  bus_name   VARCHAR2(20),
  income_fee NUMBER
)
;

prompt
prompt Creating table RPT_CONDITION_INFO
prompt =================================
prompt
create table RPT_CONDITION_INFO
(
  cdt_id        VARCHAR2(30) not null,
  cdt_code      VARCHAR2(30),
  cdt_name      VARCHAR2(50),
  cdt_desc      VARCHAR2(100),
  cdt_show_type CHAR(1),
  cdt_sql       VARCHAR2(1000),
  pat_cdt_id    VARCHAR2(30),
  pat_col_code  VARCHAR2(30),
  cdt_status    CHAR(1),
  cdt_cal_type  VARCHAR2(2)
)
;
comment on table RPT_CONDITION_INFO
  is '报表查询控件表';
comment on column RPT_CONDITION_INFO.cdt_id
  is '控件ID';
comment on column RPT_CONDITION_INFO.cdt_code
  is '控件编码';
comment on column RPT_CONDITION_INFO.cdt_name
  is '控件名称';
comment on column RPT_CONDITION_INFO.cdt_desc
  is '控件描述';
comment on column RPT_CONDITION_INFO.cdt_show_type
  is '控件展现类型';
comment on column RPT_CONDITION_INFO.cdt_sql
  is '控件条件SQL';
comment on column RPT_CONDITION_INFO.pat_cdt_id
  is '父级控件ID';
comment on column RPT_CONDITION_INFO.pat_col_code
  is '级联字段编码';
comment on column RPT_CONDITION_INFO.cdt_status
  is '是否有效1是，0否';
comment on column RPT_CONDITION_INFO.cdt_cal_type
  is '控件计算类型';
alter table RPT_CONDITION_INFO
  add primary key (CDT_ID);

prompt
prompt Creating table RPT_DB_USERS
prompt ===========================
prompt
create table RPT_DB_USERS
(
  user_id   NUMBER not null,
  username  VARCHAR2(30) not null,
  user_code VARCHAR2(30) not null
)
;

prompt
prompt Creating table RPT_DOWNLOAD_INFO
prompt ================================
prompt
create table RPT_DOWNLOAD_INFO
(
  id           VARCHAR2(30),
  rpt_id       VARCHAR2(30),
  rpt_name     VARCHAR2(100),
  create_date  DATE,
  file_path    VARCHAR2(500),
  file_status  CHAR(1),
  creater_name VARCHAR2(20),
  cdt_desc     VARCHAR2(1000)
)
;
comment on column RPT_DOWNLOAD_INFO.id
  is '下载的文件ID';
comment on column RPT_DOWNLOAD_INFO.rpt_id
  is '报表ID';
comment on column RPT_DOWNLOAD_INFO.rpt_name
  is '报表名称';
comment on column RPT_DOWNLOAD_INFO.create_date
  is '文件创建时间';
comment on column RPT_DOWNLOAD_INFO.file_path
  is '文件路径';
comment on column RPT_DOWNLOAD_INFO.file_status
  is '文件状态，1：下载完成，2：已查看';
comment on column RPT_DOWNLOAD_INFO.creater_name
  is '创建人';
comment on column RPT_DOWNLOAD_INFO.cdt_desc
  is '下载条件描述';

prompt
prompt Creating table RPT_MODEL_INFO
prompt =============================
prompt
create table RPT_MODEL_INFO
(
  model_id     VARCHAR2(30),
  model_name   VARCHAR2(200),
  model_path   VARCHAR2(1000),
  create_date  DATE,
  creater_name VARCHAR2(20),
  if_page      CHAR(1),
  model_css    CLOB,
  model_html   CLOB
)
;
comment on table RPT_MODEL_INFO
  is '模版信息表';
comment on column RPT_MODEL_INFO.model_id
  is '模版ID，与模板的上层目录一致为自动生成的hashcode或者timestamp';
comment on column RPT_MODEL_INFO.model_name
  is '模版名称';
comment on column RPT_MODEL_INFO.model_path
  is '模版地址';
comment on column RPT_MODEL_INFO.create_date
  is '创建时间';
comment on column RPT_MODEL_INFO.creater_name
  is '创建人';
comment on column RPT_MODEL_INFO.if_page
  is '是否可翻页';
comment on column RPT_MODEL_INFO.model_css
  is 'CSS样式';
comment on column RPT_MODEL_INFO.model_html
  is 'HTML代码';
create index IDX_MODEL_ID on RPT_MODEL_INFO (MODEL_ID);

prompt
prompt Creating table RPT_MODEL_SQL
prompt ============================
prompt
create table RPT_MODEL_SQL
(
  model_id VARCHAR2(20),
  var_id   VARCHAR2(20),
  var_code VARCHAR2(30),
  var_sql  VARCHAR2(4000),
  order_id NUMBER,
  rowindex NUMBER,
  colindex NUMBER
)
;
comment on table RPT_MODEL_SQL
  is '报表模版与数据语句关系表';
comment on column RPT_MODEL_SQL.model_id
  is '报表模版ID';
comment on column RPT_MODEL_SQL.var_id
  is '变量ID';
comment on column RPT_MODEL_SQL.var_code
  is '模板中的变量编码${sql}';
comment on column RPT_MODEL_SQL.var_sql
  is '模板中变量的sql';
comment on column RPT_MODEL_SQL.order_id
  is '顺序';
comment on column RPT_MODEL_SQL.rowindex
  is '行号';
comment on column RPT_MODEL_SQL.colindex
  is '列号';

prompt
prompt Creating table RPT_REPORT_CONDITION
prompt ===================================
prompt
create table RPT_REPORT_CONDITION
(
  rpt_id        VARCHAR2(30),
  field_code    VARCHAR2(100),
  filed_name    VARCHAR2(1000),
  cdt_order     NUMBER,
  cdt_id        VARCHAR2(30),
  cdt_show_type CHAR(1),
  cdt_cal_type  VARCHAR2(2),
  default_val   VARCHAR2(1000)
)
;
comment on table RPT_REPORT_CONDITION
  is '报表控件';
comment on column RPT_REPORT_CONDITION.rpt_id
  is '报表ID';
comment on column RPT_REPORT_CONDITION.field_code
  is '报表字段编码';
comment on column RPT_REPORT_CONDITION.filed_name
  is '报表字段名称';
comment on column RPT_REPORT_CONDITION.cdt_order
  is '控件顺序';
comment on column RPT_REPORT_CONDITION.cdt_id
  is '控件ID';
comment on column RPT_REPORT_CONDITION.cdt_show_type
  is '控件展现类型';
comment on column RPT_REPORT_CONDITION.cdt_cal_type
  is '控件计算类型';
comment on column RPT_REPORT_CONDITION.default_val
  is '控件默认值';

prompt
prompt Creating table RPT_REPORT_FIELD
prompt ===============================
prompt
create table RPT_REPORT_FIELD
(
  rpt_id        VARCHAR2(30),
  field_id      VARCHAR2(30),
  field_code    VARCHAR2(30),
  field_name    VARCHAR2(1000),
  display_order NUMBER(5),
  is_fixed      CHAR(1),
  is_dim        CHAR(1),
  is_order_col  CHAR(1),
  group_value   VARCHAR2(1000),
  is_show       CHAR(1)
)
;
comment on table RPT_REPORT_FIELD
  is '报表表字段列表';
comment on column RPT_REPORT_FIELD.rpt_id
  is '报表ID';
comment on column RPT_REPORT_FIELD.field_id
  is '报表字段ID';
comment on column RPT_REPORT_FIELD.field_code
  is '表字段CODE';
comment on column RPT_REPORT_FIELD.field_name
  is '表字段名称';
comment on column RPT_REPORT_FIELD.display_order
  is '展示顺序';
comment on column RPT_REPORT_FIELD.is_fixed
  is '是否固定';
comment on column RPT_REPORT_FIELD.is_dim
  is '维度还是值,1维度，0值';
comment on column RPT_REPORT_FIELD.is_order_col
  is '是否排序字段,1是，0否';
comment on column RPT_REPORT_FIELD.group_value
  is '聚合计算公式';
comment on column RPT_REPORT_FIELD.is_show
  is '是否默认展示';

prompt
prompt Creating table RPT_REPORT_INFO
prompt ==============================
prompt
create table RPT_REPORT_INFO
(
  rpt_id       VARCHAR2(30) not null,
  rpt_name     VARCHAR2(100),
  rpt_desc     VARCHAR2(4000),
  tb_id        VARCHAR2(30),
  rpt_status   CHAR(1),
  creater_name VARCHAR2(20),
  create_date  DATE,
  update_date  DATE,
  rpt_type     CHAR(1),
  if_download  CHAR(1),
  rpt_cycle    CHAR(1)
)
;
comment on table RPT_REPORT_INFO
  is '报表配置信息';
comment on column RPT_REPORT_INFO.rpt_id
  is '报表ID';
comment on column RPT_REPORT_INFO.rpt_name
  is '报表名称';
comment on column RPT_REPORT_INFO.rpt_desc
  is '报表口径描述';
comment on column RPT_REPORT_INFO.tb_id
  is '报表元数据ID';
comment on column RPT_REPORT_INFO.rpt_status
  is '报表状态,1有效,0失效';
comment on column RPT_REPORT_INFO.creater_name
  is '创建人帐号';
comment on column RPT_REPORT_INFO.create_date
  is '创建时间';
comment on column RPT_REPORT_INFO.update_date
  is '更新时间';
comment on column RPT_REPORT_INFO.rpt_type
  is '报表类型';
comment on column RPT_REPORT_INFO.if_download
  is '是否可下载1是0否';
comment on column RPT_REPORT_INFO.rpt_cycle
  is '报表周期';
alter table RPT_REPORT_INFO
  add primary key (RPT_ID);

prompt
prompt Creating table RPT_REPORT_MODEL
prompt ===============================
prompt
create table RPT_REPORT_MODEL
(
  rpt_id   VARCHAR2(30),
  model_id VARCHAR2(20),
  status   CHAR(1)
)
;
comment on table RPT_REPORT_MODEL
  is '报表与模版关系表';
comment on column RPT_REPORT_MODEL.rpt_id
  is '报表ID';
comment on column RPT_REPORT_MODEL.model_id
  is '模版ID，与模板的上层目录一致为自动生成的hashcode或者timestamp';
comment on column RPT_REPORT_MODEL.status
  is '模板状态：1有效，0无效';

prompt
prompt Creating table RPT_SYS_CODE
prompt ===========================
prompt
create table RPT_SYS_CODE
(
  code_id        VARCHAR2(30),
  code_name      VARCHAR2(100),
  code_order     NUMBER,
  code_type_id   VARCHAR2(30),
  code_type_name VARCHAR2(100)
)
;
comment on table RPT_SYS_CODE
  is '报表配置维值';
comment on column RPT_SYS_CODE.code_id
  is '维值类型名称';

prompt
prompt Creating table RPT_SYS_VAR
prompt ==========================
prompt
create table RPT_SYS_VAR
(
  var_id    VARCHAR2(30) not null,
  var_code  VARCHAR2(100),
  var_value VARCHAR2(1000),
  var_desc  VARCHAR2(1000)
)
;
comment on table RPT_SYS_VAR
  is '报表配置环境变量表';
comment on column RPT_SYS_VAR.var_id
  is '变量ID';
comment on column RPT_SYS_VAR.var_code
  is '变量编码';
comment on column RPT_SYS_VAR.var_value
  is '变量值';
comment on column RPT_SYS_VAR.var_desc
  is '变量描述';
alter table RPT_SYS_VAR
  add primary key (VAR_ID);

prompt
prompt Creating table RPT_TABLE_FIELD
prompt ==============================
prompt
create table RPT_TABLE_FIELD
(
  field_id      VARCHAR2(30) not null,
  tb_id         VARCHAR2(30),
  field_code    VARCHAR2(30),
  field_name    VARCHAR2(1000),
  field_type    VARCHAR2(50),
  field_length  NUMBER,
  display_order NUMBER(5),
  is_fixed      CHAR(1),
  field_status  CHAR(1),
  is_dim        CHAR(1),
  group_value   VARCHAR2(1000)
)
;
comment on table RPT_TABLE_FIELD
  is '报表表字段列表';
comment on column RPT_TABLE_FIELD.field_id
  is '报表元数据字段ID';
comment on column RPT_TABLE_FIELD.tb_id
  is '报表元数据ID';
comment on column RPT_TABLE_FIELD.field_code
  is '表字段CODE';
comment on column RPT_TABLE_FIELD.field_name
  is '表字段名称';
comment on column RPT_TABLE_FIELD.field_type
  is '表字段类型';
comment on column RPT_TABLE_FIELD.field_length
  is '表字段长度';
comment on column RPT_TABLE_FIELD.display_order
  is '展示顺序';
comment on column RPT_TABLE_FIELD.is_fixed
  is '是否固定';
comment on column RPT_TABLE_FIELD.field_status
  is '是否有效1有效，0无效';
comment on column RPT_TABLE_FIELD.is_dim
  is '维度还是值,1维度，0值';
comment on column RPT_TABLE_FIELD.group_value
  is '聚合计算公式';

prompt
prompt Creating table RPT_TABLE_INFO
prompt =============================
prompt
create table RPT_TABLE_INFO
(
  tb_id        VARCHAR2(30) not null,
  tb_name      VARCHAR2(100),
  tb_desc      VARCHAR2(4000),
  tb_owner     VARCHAR2(30),
  tb_code      VARCHAR2(30),
  split_flag   CHAR(1),
  split_code   VARCHAR2(30),
  tb_status    CHAR(1),
  creater_name VARCHAR2(20),
  create_date  DATE,
  update_date  DATE
)
;
comment on table RPT_TABLE_INFO
  is '报表元数据清单';
comment on column RPT_TABLE_INFO.tb_id
  is '报表元数据ID';
comment on column RPT_TABLE_INFO.tb_name
  is '报表元数据名称';
comment on column RPT_TABLE_INFO.tb_desc
  is '报表元数据口径描述';
comment on column RPT_TABLE_INFO.tb_owner
  is '报表元数据用户';
comment on column RPT_TABLE_INFO.tb_code
  is '报表元数据表名';
comment on column RPT_TABLE_INFO.split_flag
  is '是否分表,1是,0否';
comment on column RPT_TABLE_INFO.split_code
  is '分表字段';
comment on column RPT_TABLE_INFO.tb_status
  is '报表状态,1有效,0失效';
comment on column RPT_TABLE_INFO.creater_name
  is '创建人帐号';
comment on column RPT_TABLE_INFO.create_date
  is '创建时间';
comment on column RPT_TABLE_INFO.update_date
  is '更新时间';
alter table RPT_TABLE_INFO
  add primary key (TB_ID);

prompt
prompt Creating view RPT_DB_TABLES
prompt ===========================
prompt
CREATE OR REPLACE FORCE VIEW RPT_DB_TABLES AS
SELECT t.OWNER, t.TABLE_NAME, t.TABLESPACE_NAME
    FROM ALL_TABLES T, RPT_DB_USERS S
   WHERE T.OWNER = S.USERNAME
     AND T.STATUS = 'VALID';

prompt
prompt Creating view RPT_DB_TABLE_COLUMNS
prompt ==================================
prompt
CREATE OR REPLACE FORCE VIEW RPT_DB_TABLE_COLUMNS AS
SELECT T.OWNER,
       T.TABLE_NAME,
       T.COLUMN_NAME,
       NVL(S.COMMENTS, T.COLUMN_NAME) COMMENTS,
       T.DATA_TYPE,
       T.DATA_LENGTH,
       T.NULLABLE,
       ROW_NUMBER() OVER(PARTITION BY T.TABLE_NAME ORDER BY T.COLUMN_ID) COLUMN_ORDER
  FROM ALL_TAB_COLUMNS T, ALL_COL_COMMENTS S, RPT_DB_USERS A
 WHERE T.TABLE_NAME = S.TABLE_NAME
   AND T.COLUMN_NAME = S.COLUMN_NAME
   AND T.OWNER = A.USERNAME;


spool off