prompt PL/SQL Developer import file
prompt Created on 2016年8月23日 by wangjian
set feedback off
set define off
prompt Dropping CD_CHANNEL_TYPE...
drop table CD_CHANNEL_TYPE cascade constraints;
prompt Dropping CD_LOC_CITY...
drop table CD_LOC_CITY cascade constraints;
prompt Dropping CD_LOC_REGION...
drop table CD_LOC_REGION cascade constraints;
prompt Dropping RPT_MODEL_INFO...
drop table RPT_MODEL_INFO cascade constraints;
prompt Dropping RPT_CONDITION_INFO...
drop table RPT_CONDITION_INFO cascade constraints;
prompt Dropping RPT_DB_USERS...
drop table RPT_DB_USERS cascade constraints;
prompt Dropping RPT_DOWNLOAD_INFO...
drop table RPT_DOWNLOAD_INFO cascade constraints;
prompt Dropping RPT_MODEL_SQL...
drop table RPT_MODEL_SQL cascade constraints;
prompt Dropping RPT_REPORT_CONDITION...
drop table RPT_REPORT_CONDITION cascade constraints;
prompt Dropping RPT_REPORT_FIELD...
drop table RPT_REPORT_FIELD cascade constraints;
prompt Dropping RPT_REPORT_INFO...
drop table RPT_REPORT_INFO cascade constraints;
prompt Dropping RPT_REPORT_MODEL...
drop table RPT_REPORT_MODEL cascade constraints;
prompt Dropping RPT_SYS_CODE...
drop table RPT_SYS_CODE cascade constraints;
prompt Dropping RPT_SYS_VAR...
drop table RPT_SYS_VAR cascade constraints;
prompt Dropping RPT_TABLE_FIELD...
drop table RPT_TABLE_FIELD cascade constraints;
prompt Dropping RPT_TABLE_INFO...
drop table RPT_TABLE_INFO cascade constraints;
prompt Creating CD_CHANNEL_TYPE...
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

prompt Creating CD_LOC_CITY...
create table CD_LOC_CITY
(
  city_code   VARCHAR2(6),
  city_desc   VARCHAR2(20),
  region_code VARCHAR2(3),
  region_desc VARCHAR2(10)
)
;

prompt Creating CD_LOC_REGION...
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

-- Create table
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
);
-- Add comments to the table 
comment on table RPT_MODEL_INFO
  is '模版信息表';
-- Add comments to the columns 
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
-- Create/Recreate indexes 
create index IDX_MODEL_ID on RPT_MODEL_INFO (MODEL_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
prompt Creating RPT_CONDITION_INFO...
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

prompt Creating RPT_DB_USERS...
create table RPT_DB_USERS
(
  user_id   NUMBER not null,
  username  VARCHAR2(30) not null,
  user_code VARCHAR2(30) not null
)
;

prompt Creating RPT_DOWNLOAD_INFO...
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

prompt Creating RPT_MODEL_SQL...
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

prompt Creating RPT_REPORT_CONDITION...
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

prompt Creating RPT_REPORT_FIELD...
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

prompt Creating RPT_REPORT_INFO...
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

prompt Creating RPT_REPORT_MODEL...
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

prompt Creating RPT_SYS_CODE...
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

prompt Creating RPT_SYS_VAR...
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

prompt Creating RPT_TABLE_FIELD...
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

prompt Creating RPT_TABLE_INFO...
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

prompt Loading CD_CHANNEL_TYPE...
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 1, '省公司部门', 1, '省公司部门');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 2, '地市公司部门', 2, '地市公司部门');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 3, '县公司部门', 3, '县公司部门');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 4, '网上放号', 4, '网上放号');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 5, '卡品超市', 5, '卡品超市');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 6, '终端合作伙伴', 1, '服务平台');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 6, '终端合作伙伴', 2, '厂商');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 6, '终端合作伙伴', 3, '终端物流');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 6, '终端合作伙伴', 4, '售后服务商');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 7, '积分实物供应商', 1, '积分实物供应商');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 8, '电子商务虚拟组织', 1, '电子商务虚拟组织');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 9, '自助终端放号', 9, '自助终端放号');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (1, '部门', 10, '实物供应商', 1, '实物供应商');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (2, '区域市场/营销中心', 1, '区域营销中心', 1, '省公司部门');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80001, '直营店', 800011, '自营营业厅', 8000111, '地市主厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80001, '直营店', 800011, '自营营业厅', 8000112, '县区主厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80001, '直营店', 800012, '合作厅', 8000121, '业务合作厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80001, '直营店', 800011, '自营营业厅', 8000113, '县区辅厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80001, '直营店', 800011, '自营营业厅', 8000114, '重点乡镇厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80001, '直营店', 800011, '自营营业厅', 8000115, '基本乡镇厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80002, '授权店', 800021, '签约渠道', 8000211, '手机卖场');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80002, '授权店', 800021, '签约渠道', 8000212, '手机专卖店');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80002, '授权店', 800021, '签约渠道', 8000214, '直管渠道');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80002, '授权店', 800021, '签约渠道', 8000213, '指定专营店');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80002, '授权店', 800022, '直供渠道', 8000221, '放号直供渠道');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80002, '授权店', 800022, '直供渠道', 8000222, '无放号直供渠道');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80003, '加盟店', 69628, '自建自管他营', 69628, '自建自管他营');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80003, '加盟店', 800032, '社区服务厅', 8000321, '铁通营业厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80003, '加盟店', 800032, '社区服务厅', 8000322, '其它社区厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80003, '加盟店', 800033, '合作营业厅', 800033, '合作营业厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80003, '加盟店', 800034, '加盟厅', 8000341, '普通加盟厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80003, '加盟店', 800034, '加盟厅', 8000342, '铁通加盟厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80003, '加盟店', 800034, '加盟厅', 8000343, '社区加盟厅');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80004, '自有直销', 800041, '个人客户经理', 800041, '个人客户经理');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80004, '自有直销', 800042, '集团客户经理', 800042, '集团客户经理');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80004, '自有直销', 800043, '片区经理', 800043, '片区经理');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80004, '自有直销', 800044, '客服团队', 800044, '客服团队');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80004, '自有直销', 800045, '综合支撑团队', 800045, '综合支撑团队');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80004, '自有直销', 800046, '营业支撑团队', 800046, '营业支撑团队');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80004, '自有直销', 800047, '渠道支撑团队', 800047, '渠道支撑团队');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80004, '自有直销', 800048, '政企支撑团队', 800048, '政企支撑团队');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80005, '社会直销', 800051, '代理人', 8000511, '社区代理人');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80005, '社会直销', 800051, '代理人', 8000513, '校园代理人');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80005, '社会直销', 800051, '代理人', 8000512, '农村代理人');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80005, '社会直销', 800054, '代理商', 8000541, '直销代理商');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80005, '社会直销', 800054, '代理商', 8000542, '虚拟组织');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80006, '自有电子渠道', 800061, '互联网渠道', 8000611, 'WWW门户');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80006, '自有电子渠道', 800061, '互联网渠道', 8000612, '手机上网门户');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80006, '自有电子渠道', 800061, '互联网渠道', 8000613, '客户端');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80006, '自有电子渠道', 800061, '互联网渠道', 8000614, '自营网店');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80006, '自有电子渠道', 800061, '互联网渠道', 8000615, '互联网应用');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80006, '自有电子渠道', 800062, '电话渠道', 800062, '电话渠道');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80006, '自有电子渠道', 800063, '短信渠道', 800063, '短信渠道');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80007, '社会电子渠道', 800071, 'B2C电商', 800071, 'B2C电商');
insert into CD_CHANNEL_TYPE (channel_type1_code, channel_type1_desc, channel_type2_code, channel_type2_desc, channel_type3_code, channel_type3_desc)
values (80007, '社会电子渠道', 800072, '互联网分销', 800072, '互联网分销');
commit;
prompt 55 records loaded
prompt Loading CD_LOC_CITY...
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5701', '柯城', '570', '衢州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5711', '武林', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5721', '吴兴', '572', '湖州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5731', '嘉兴', '573', '嘉兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5741', '海曙', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5751', '越城', '575', '绍兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5761', '椒江', '576', '台州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5771', '鹿城', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5781', '丽水', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5791', '婺城', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5801', '定海', '580', '舟山');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5702', '江山', '570', '衢州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5712', '萧山', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5722', '长兴', '572', '湖州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5732', '桐乡', '573', '嘉兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5742', '余姚', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5752', '诸暨', '575', '绍兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5762', '黄岩', '576', '台州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5772', '乐清', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5782', '缙云', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5792', '义乌', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5802', '普陀', '580', '舟山');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5703', '常山', '570', '衢州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5713', '富阳', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5723', '德清', '572', '湖州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5733', '海宁', '573', '嘉兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5743', '慈溪', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5753', '上虞', '575', '绍兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5763', '路桥', '576', '台州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5773', '瑞安', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5783', '青田', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5793', '磐安', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5803', '岱山', '580', '舟山');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5704', '开化', '570', '衢州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5714', '余杭', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5724', '安吉', '572', '湖州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5734', '嘉善', '573', '嘉兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5744', '象山', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5754', '嵊州', '575', '绍兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5764', '临海', '576', '台州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5774', '平阳', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5796', '永康', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5717', '桐庐', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5747', '奉化', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5767', '天台', '576', '台州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5777', '文成', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5787', '遂昌', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5797', '浦江', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5718', '临安', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5748', '镇海', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5768', '三门', '576', '台州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5778', '泰顺', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5788', '松阳', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5798', '武义', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5719', '滨江', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5749', '鄞州', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5769', '玉环', '576', '台州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5779', '苍南', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5789', '景宁', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5799', '金东', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('571A', '下沙', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('574A', '科技园区', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('577A', '瓯海', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('571B', '西湖', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('574B', '江东', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('577B', '龙湾', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('571C', '江干', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('574C', '江北', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('571D', '拱墅', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('571E', '集团客户中心', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5784', '云和', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5794', '兰溪', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5804', '嵊泗', '580', '舟山');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5705', '龙游', '570', '衢州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5715', '建德', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5725', '南浔', '572', '湖州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5735', '平湖', '573', '嘉兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5745', '北仑', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5755', '新昌', '575', '绍兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5765', '温岭', '576', '台州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5775', '永嘉', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5785', '庆元', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5795', '东阳', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5716', '淳安', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5736', '海盐', '573', '嘉兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5746', '宁海', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5756', '绍兴县', '575', '绍兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5766', '仙居', '576', '台州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5776', '洞头', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5786', '龙泉', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('579A', '重客中心', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('578B', '南城', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('5706', '衢江', '570', '衢州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('571F', '销售部', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('570Z', '电子商务中心', '570', '衢州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('571Z', '电子商务中心', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('572Z', '电子商务中心', '572', '湖州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('573Z', '电子商务中心', '573', '嘉兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('574Z', '电子商务中心', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('575Z', '电子商务中心', '575', '绍兴');
commit;
prompt 100 records committed...
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('576Z', '电子商务中心', '576', '台州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('577Z', '电子商务中心', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('578Z', '电子商务中心', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('579Z', '电子商务中心', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('580Z', '电子商务中心', '580', '舟山');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('570X', '衢州政企行业组', '570', '衢州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('571X', '杭州政企行业组', '571', '杭州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('572X', '湖州政企行业组', '572', '湖州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('573X', '嘉兴政企行业组', '573', '嘉兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('574X', '宁波政企行业组', '574', '宁波');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('575X', '绍兴政企行业组', '575', '绍兴');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('576X', '台州政企行业组', '576', '台州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('577X', '温州政企行业组', '577', '温州');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('578X', '丽水政企行业组', '578', '丽水');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('579X', '金华政企行业组', '579', '金华');
insert into CD_LOC_CITY (city_code, city_desc, region_code, region_desc)
values ('580X', '舟山政企行业组', '580', '舟山');
commit;
prompt 116 records loaded
prompt Loading CD_LOC_REGION...
insert into CD_LOC_REGION (prov_code, prov_desc, region_code, region_desc, region_abbr, long_code, prov_dist_id, region_dist_id, eff_flag_code, bak_fld1, bak_fld2, bak_fld3)
values ('0', '浙江省', '570', '衢州', 'QZ', '0570', 2, 21800, 1, 2, null, null);
insert into CD_LOC_REGION (prov_code, prov_desc, region_code, region_desc, region_abbr, long_code, prov_dist_id, region_dist_id, eff_flag_code, bak_fld1, bak_fld2, bak_fld3)
values ('0', '浙江省', '571', '杭州', 'HZ', '0571', 2, 21100, 1, 11, null, null);
insert into CD_LOC_REGION (prov_code, prov_desc, region_code, region_desc, region_abbr, long_code, prov_dist_id, region_dist_id, eff_flag_code, bak_fld1, bak_fld2, bak_fld3)
values ('0', '浙江省', '572', '湖州', 'HU', '0572', 2, 21500, 1, 7, null, null);
insert into CD_LOC_REGION (prov_code, prov_desc, region_code, region_desc, region_abbr, long_code, prov_dist_id, region_dist_id, eff_flag_code, bak_fld1, bak_fld2, bak_fld3)
values ('0', '浙江省', '573', '嘉兴', 'JX', '0573', 2, 21400, 1, 8, null, null);
insert into CD_LOC_REGION (prov_code, prov_desc, region_code, region_desc, region_abbr, long_code, prov_dist_id, region_dist_id, eff_flag_code, bak_fld1, bak_fld2, bak_fld3)
values ('0', '浙江省', '574', '宁波', 'NB', '0574', 2, 21200, 1, 4, null, null);
insert into CD_LOC_REGION (prov_code, prov_desc, region_code, region_desc, region_abbr, long_code, prov_dist_id, region_dist_id, eff_flag_code, bak_fld1, bak_fld2, bak_fld3)
values ('0', '浙江省', '575', '绍兴', 'SX', '0575', 2, 21600, 1, 10, null, null);
insert into CD_LOC_REGION (prov_code, prov_desc, region_code, region_desc, region_abbr, long_code, prov_dist_id, region_dist_id, eff_flag_code, bak_fld1, bak_fld2, bak_fld3)
values ('0', '浙江省', '576', '台州', 'TZ', '0576', 2, 22000, 1, 5, null, null);
insert into CD_LOC_REGION (prov_code, prov_desc, region_code, region_desc, region_abbr, long_code, prov_dist_id, region_dist_id, eff_flag_code, bak_fld1, bak_fld2, bak_fld3)
values ('0', '浙江省', '577', '温州', 'WZ', '0577', 2, 21300, 1, 6, null, null);
insert into CD_LOC_REGION (prov_code, prov_desc, region_code, region_desc, region_abbr, long_code, prov_dist_id, region_dist_id, eff_flag_code, bak_fld1, bak_fld2, bak_fld3)
values ('0', '浙江省', '578', '丽水', 'LS', '0578', 2, 22100, 1, 9, null, null);
insert into CD_LOC_REGION (prov_code, prov_desc, region_code, region_desc, region_abbr, long_code, prov_dist_id, region_dist_id, eff_flag_code, bak_fld1, bak_fld2, bak_fld3)
values ('0', '浙江省', '579', '金华', 'JH', '0579', 2, 21700, 1, 3, null, null);
insert into CD_LOC_REGION (prov_code, prov_desc, region_code, region_desc, region_abbr, long_code, prov_dist_id, region_dist_id, eff_flag_code, bak_fld1, bak_fld2, bak_fld3)
values ('0', '浙江省', '580', '舟山', 'ZS', '0580', 2, 21900, 1, 1, null, null);
commit;
prompt 11 records loaded
prompt Loading RPT_CONDITION_INFO...
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526102105976', 'DEAL_DATE', '统计日期', '日期弹出框', '1', null, '0', '—', '1', '1');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526102205977', 'DEAL_DATE', '统计日期', '日期(开始-结束)', '2', null, '0', '—', '1', '11');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526102305116', 'DEAL_MON', '统计月份', '月份弹出框', '3', null, '0', '—', '1', '1');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526102405972', 'DEAL_MON', '统计月份', '月份(开始-结束)', '4', null, '0', '—', '1', '11');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526102605913', 'REGION_CODE', '地市', '地市多选下拉框', '5', 'SELECT T.REGION_CODE KEY_, T.REGION_DESC VALUE_ FROM CD_LOC_REGION T', '0', '—', '1', '9');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526102705998', 'CITY_CODE', '区县', '区县多选下拉框', '5', 'SELECT T.CITY_CODE KEY_, T.CITY_DESC VALUE_ FROM CD_LOC_CITY T', '160526102605913', 'REGION_CODE', '1', '9');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526102805977', 'CHANNEL_TYPE1_CODE', '渠道一级类型', '渠道类型下拉框', '6', 'SELECT DISTINCT T.CHANNEL_TYPE1_CODE KEY_, T.CHANNEL_TYPE1_DESC VALUE_ FROM CD_CHANNEL_TYPE T', '0', '—', '1', '1');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526102905955', 'CHANNEL_TYPE2_CODE', '渠道二级类型', '渠道类型下拉框', '6', 'SELECT DISTINCT T.CHANNEL_TYPE2_CODE KEY_, T.CHANNEL_TYPE2_DESC VALUE_ FROM CD_CHANNEL_TYPE T', '160526102805977', 'CHANNEL_TYPE1_CODE', '1', '1');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526103005976', 'CHANNEL_TYPE3_CODE', '渠道三级类型', '渠道类型下拉框', '6', 'SELECT DISTINCT T.CHANNEL_TYPE3_CODE KEY_, T.CHANNEL_TYPE3_DESC VALUE_ FROM CD_CHANNEL_TYPE T', '160526102905955', 'CHANNEL_TYPE2_CODE', '1', '1');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526103105212', 'TOP_BS_CODE', '业务大类', '业务大类', '6', 'SELECT DISTINCT T.TOP_BUS_CODE KEY_, T.TOP_BUS_DESC VALUE_ FROM CD_BUS_LIST T', '0', '—', '1', '1');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526103205010', 'BS_CODE', '科目名称', '科目名称', '6', 'SELECT DISTINCT T.BUS_CODE KEY_, T.BUS_DESC VALUE_ FROM CD_BUS_LIST T', '160526103105212', 'TOP_BS_CODE', '1', '1');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526103305521', 'CHANNEL_NAME', '营业厅名称', '营业厅模糊查询', '7', null, '0', '—', '1', '7');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160526103401230', 'IF_BIND', '是否合约', '是否合约', '8', '1@是,0@否', '0', '—', '1', '1');
insert into RPT_CONDITION_INFO (cdt_id, cdt_code, cdt_name, cdt_desc, cdt_show_type, cdt_sql, pat_cdt_id, pat_col_code, cdt_status, cdt_cal_type)
values ('160601162400501', 'TEST_CDT', '测试控件', '测试控件', '6', 'SELECT 1 KEY_, ''是'' VALUE_ FROM DUAL', '160526102605913', 'REGION_CODE', '0', '1');
commit;
prompt 14 records loaded
prompt Loading RPT_DB_USERS...
insert into RPT_DB_USERS (user_id, username, user_code)
values (30, 'SCOTT', 'SCOTT');
insert into RPT_DB_USERS (user_id, username, user_code)
values (10, 'AIUTIL', 'AIUTIL');
insert into RPT_DB_USERS (user_id, username, user_code)
values (20, 'CODER', 'CODER');
commit;
prompt 3 records loaded
prompt Loading RPT_DOWNLOAD_INFO...
prompt Table is empty
prompt Loading RPT_MODEL_SQL...
insert into RPT_MODEL_SQL (model_id, var_id, var_code, var_sql, order_id, rowindex, colindex)
values ('160802133506631', '1608021335066310', '${sql1}', 'SELECT THIS_MON_REV' || chr(10) || '      ,THIS_MON_HB' || chr(10) || '      ,THIS_MON_TB' || chr(10) || '      ,THIS_YEAR_REV' || chr(10) || '      ,THIS_YEAR_TB' || chr(10) || '      ,THIS_YEAR_PRESENT_REV' || chr(10) || '      ,THIS_YEAR_PRESENT_HKL' || chr(10) || '      ,THIS_YEAR_PRESENT_ZB' || chr(10) || '      ,THIS_YEAR_UNPAY_FEE' || chr(10) || '      ,THIS_YEAR_UNPAY_BL' || chr(10) || '      ,THIS_YEAR_UNPAY_ZB' || chr(10) || '      ,THIS_YEAR_REV_SH' || chr(10) || '      ,THIS_YEAR_REV_SHTB' || chr(10) || '  FROM E3_AP_RPT_GRP_FEE_P_M' || chr(10) || ' WHERE ROW_NUM < 22 ${where}' || chr(10) || ' ORDER BY ROW_NUM', 0, 2, 3);
insert into RPT_MODEL_SQL (model_id, var_id, var_code, var_sql, order_id, rowindex, colindex)
values ('160802133506631', '1608021335066311', '${sql2}', 'SELECT THIS_MON_REV' || chr(10) || '      ,THIS_MON_HB' || chr(10) || '      ,THIS_MON_TB' || chr(10) || '      ,THIS_YEAR_REV' || chr(10) || '      ,THIS_YEAR_TB' || chr(10) || '      ,THIS_YEAR_PRESENT_REV' || chr(10) || '      ,THIS_YEAR_PRESENT_HKL' || chr(10) || '      ,THIS_YEAR_PRESENT_ZB' || chr(10) || '      ,THIS_YEAR_UNPAY_FEE' || chr(10) || '      ,THIS_YEAR_UNPAY_BL' || chr(10) || '      ,THIS_YEAR_UNPAY_ZB' || chr(10) || '      ,THIS_YEAR_REV_SH' || chr(10) || '      ,THIS_YEAR_REV_SHTB' || chr(10) || '  FROM E3_AP_RPT_GRP_FEE_P_M' || chr(10) || ' WHERE ROW_NUM >= 22 ${where}' || chr(10) || ' ORDER BY ROW_NUM', 1, 23, 3);
insert into RPT_MODEL_SQL (model_id, var_id, var_code, var_sql, order_id, rowindex, colindex)
values ('160803100355252', '1608031003552520', '${sql1}', 'SELECT ROW_NUM,' || chr(10) || '       DEAL_MON,' || chr(10) || '       PROD_TYPE,' || chr(10) || '       PROD_SUB_TYPE,' || chr(10) || '       THIS_MON_REV,' || chr(10) || '       THIS_MON_HB,' || chr(10) || '       THIS_MON_TB,' || chr(10) || '       THIS_YEAR_REV,' || chr(10) || '       THIS_YEAR_TB,' || chr(10) || '       THIS_YEAR_PRESENT_REV,' || chr(10) || '       THIS_YEAR_PRESENT_HKL,' || chr(10) || '       THIS_YEAR_PRESENT_ZB,' || chr(10) || '       THIS_YEAR_UNPAY_FEE,' || chr(10) || '       THIS_YEAR_UNPAY_BL,' || chr(10) || '       THIS_YEAR_UNPAY_ZB,' || chr(10) || '       THIS_YEAR_REV_SH,' || chr(10) || '       THIS_YEAR_REV_SHTB' || chr(10) || '  FROM E3_AP_RPT_GRP_FEE_P_M' || chr(10) || ' WHERE 1=1 ${where}' || chr(10) || '  ORDER BY DEAL_MON, ROW_NUM', 0, 2, 0);
insert into RPT_MODEL_SQL (model_id, var_id, var_code, var_sql, order_id, rowindex, colindex)
values ('160805155158736', '1608051551587360', '${sql1}', 'SELECT THIS_MON_REV,' || chr(10) || '       THIS_MON_HB,' || chr(10) || '       THIS_MON_TB,' || chr(10) || '       THIS_YEAR_REV,' || chr(10) || '       THIS_YEAR_TB,' || chr(10) || '       THIS_YEAR_PRESENT_REV,' || chr(10) || '       THIS_YEAR_PRESENT_HKL,' || chr(10) || '       THIS_YEAR_PRESENT_ZB,' || chr(10) || '       THIS_YEAR_UNPAY_FEE,' || chr(10) || '       THIS_YEAR_UNPAY_BL,' || chr(10) || '       THIS_YEAR_UNPAY_ZB,' || chr(10) || '       THIS_YEAR_REV_SH,' || chr(10) || '       THIS_YEAR_REV_SHTB' || chr(10) || '  FROM E3_AP_RPT_GRP_FEE_P_M' || chr(10) || ' WHERE 1 = 1 ${where}' || chr(10) || ' ORDER BY DEAL_MON, ROW_NUM', 0, 2, 3);
insert into RPT_MODEL_SQL (model_id, var_id, var_code, var_sql, order_id, rowindex, colindex)
values ('160805155158736', '1608051551587361', '${sql2}', 'SELECT T.INCOME_FEE' || chr(10) || '  FROM E3_AP_RPT_GRP_FEE_P_M_2 T' || chr(10) || ' WHERE 1 = 1 ${where}' || chr(10) || ' ORDER BY T.ORDER_ID', 1, 2, 17);
commit;
prompt 5 records loaded
prompt Loading RPT_REPORT_CONDITION...
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160612125942609', 'DEAL_DATE', '统计日期', 2, '160526102205977', '2', '11', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160612125942609', 'CITY_CODE', '区县', 6, '160526102705998', '5', '9', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160805143225265', 'COUNTY_CODE', '区县', 6, '160526102705998', '5', '9', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160805143225265', 'CHANNEL_TYPE', '渠道一级类型', 7, '160526102805977', '6', '1', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160805143225265', 'CHANNEL_TYPE_DTL', '渠道二级类型', 8, '160526102905955', '6', '1', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160805143225265', 'CHANNEL_TYPE_DTL3', '渠道三级类型', 9, '160526103005976', '6', '1', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160805143225265', 'DEAL_MON', '统计月份', 4, '160526102405972', '4', '11', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160805143225265', 'REGION_ID', '地市', 5, '160526102605913', '5', '9', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160802133530400', 'CITY_CODE', '区县', 6, '160526102705998', '5', '9', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160805155248185', 'DEAL_MON', '统计月份', 3, '160526102305116', '3', '1', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160802133530400', 'DEAL_MON', '统计月份', 3, '160526102305116', '3', '1', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160802133530400', 'REGION_CODE', '地市', 5, '160526102605913', '5', '9', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160803100453510', 'DEAL_MON', '统计月份', 3, '160526102305116', '3', '1', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160612125942609', 'REGION_CODE', '地市', 5, '160526102605913', '5', '9', null);
insert into RPT_REPORT_CONDITION (rpt_id, field_code, filed_name, cdt_order, cdt_id, cdt_show_type, cdt_cal_type, default_val)
values ('160612125942609', 'ORG_NAME', '营业厅名称', 12, '160526103305521', '7', '7', null);
commit;
prompt 15 records loaded
prompt Loading RPT_REPORT_FIELD...
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '1605261021059761', 'DEAL_DATE', '处理日期', 1, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '1605261021059762', 'REGION_CODE', '地市编码', 2, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '1605261021059763', 'REGION_DESC', '地市描述', 3, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '1605261021059764', 'CITY_CODE', '县市编码', 4, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '1605261021059765', 'CITY_DESC', '县市描述', 5, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '1605261021059766', 'ORG_ID', '区域', 6, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '1605261021059767', 'ORG_NAME', '区域描述', 7, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '1605261021059768', 'CHANNEL_TYPE', '渠道类型', 8, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '1605261021059769', 'AREA_CODE', '营业厅编号', 9, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597610', 'AREA_NAME', '营业厅', 10, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597611', 'OWNER_NAME', '店长', 11, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597612', 'OWNER_PHONE', '店长号码', 12, '0', '1', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597613', 'DAY_CRM_USERCNT', '当日接触用户数', 13, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597614', 'DAY_CNTCT_USERCNT', '当日营销接触用户数', 14, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597615', 'DAY_RECM_USERCNT', '当日查看推荐详情用户数', 15, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597616', 'DAY_RECM_USERRATE', '当日政策详情查看率', 16, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597617', 'AVG_DAY_RECM_USERRATE', '当日平均推荐率', 17, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597618', 'DAY_SUC_USERCNT', '当日营销成功用户数', 18, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597619', 'DAY_SUC_USERRATE', '当日推荐成功率', 19, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597620', 'DAY_CHG_USERRATE', '当日推荐转化率', 20, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597621', 'AVG_DAY_SUC_USERRATE', '当日平均成功率', 21, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597622', 'DAY_MAINCNTCT_USERCNT', '当日主推营销接触用户数', 22, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597623', 'DAY_MAINSUC_USERCNT', '当日主推营销成功用户数', 23, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160612125942609', '16052610210597624', 'DAY_SUBCNTCT_USERCNT', '当日辅推营销接触用户数', 24, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '1608051028314161', 'DEAL_MON', '月份', 1, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '1608051028314162', 'REGION_ID', '地市编码', 2, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '1608051028314163', 'REGION_NAME', '地市', 3, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '1608051028314164', 'COUNTY_CODE', '区县编码', 4, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '1608051028314165', 'COUNTY_NAME', '区县', 5, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '1608051028314166', 'CHANNEL_TYPE', '一级类型编码', 6, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '1608051028314167', 'CHANNEL_TYPE_NAME', '一级类型', 7, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '1608051028314168', 'CHANNEL_TYPE_DTL', '二级类型编码', 8, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '1608051028314169', 'CHANNEL_TYPE_DTL_NAME', '二级类型', 9, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '16080510283141610', 'CHANNEL_TYPE_DTL3', '三级类型编码', 10, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '16080510283141611', 'CHANNEL_TYPE_DTL3_NAME', '三级类型', 11, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '16080510283141612', 'MANAGER_ID', '店长编码', 12, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '16080510283141613', 'ORG_ID', '营业厅编码', 13, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '16080510283141614', 'ORG_NAME', '营业厅名称', 14, '0', '1', '1', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '16080510283141615', 'INCOME_FEE', '总收入（元）', 15, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '16080510283141616', 'RENT_FEE', '租金', 16, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '16080510283141617', 'BS_FEE', '业务收入（元）', 17, '0', '0', '0', null, '1');
insert into RPT_REPORT_FIELD (rpt_id, field_id, field_code, field_name, display_order, is_fixed, is_dim, is_order_col, group_value, is_show)
values ('160805143225265', '16080510283141618', 'BS_INCOME_RATE', '业务收入占比', 18, '1', '0', '0', 'DECODE(SUM(RENT_FEE)+SUM(BS_FEE), 0, ''0'', ROUND(SUM(BS_FEE)/(SUM(RENT_FEE)+SUM(BS_FEE))*100, 2)||''%'')', '1');
commit;
prompt 42 records loaded
prompt Loading RPT_REPORT_INFO...
insert into RPT_REPORT_INFO (rpt_id, rpt_name, rpt_desc, tb_id, rpt_status, creater_name, create_date, update_date, rpt_type, if_download, rpt_cycle)
values ('160612125942609', '营业厅渠道推荐受理统计数据', '营业厅渠道推荐受理统计数据,可以按地市区县，渠道一二三级类型进行查询', '160526102105976', '1', 'admin', to_date('27-07-2016 16:22:36', 'dd-mm-yyyy hh24:mi:ss'), null, '1', '1', '1');
insert into RPT_REPORT_INFO (rpt_id, rpt_name, rpt_desc, tb_id, rpt_status, creater_name, create_date, update_date, rpt_type, if_download, rpt_cycle)
values ('160805143225265', '厅建效益收入分析', '厅建效益收入分析', '160805102831416', '1', 'admin', to_date('05-08-2016 14:39:14', 'dd-mm-yyyy hh24:mi:ss'), null, '1', '0', '2');
insert into RPT_REPORT_INFO (rpt_id, rpt_name, rpt_desc, tb_id, rpt_status, creater_name, create_date, update_date, rpt_type, if_download, rpt_cycle)
values ('160802133530400', '集团产品信息化收入', '集团产品信息化收入', null, '1', 'admin', to_date('02-08-2016 13:35:30', 'dd-mm-yyyy hh24:mi:ss'), null, '2', '1', '2');
insert into RPT_REPORT_INFO (rpt_id, rpt_name, rpt_desc, tb_id, rpt_status, creater_name, create_date, update_date, rpt_type, if_download, rpt_cycle)
values ('160805155248185', '集团产品信息化收入模板合并列的数据写入', '集团产品信息化收入模板合并列的数据写入', null, '1', 'admin', to_date('05-08-2016 16:23:02', 'dd-mm-yyyy hh24:mi:ss'), null, '2', '1', '2');
insert into RPT_REPORT_INFO (rpt_id, rpt_name, rpt_desc, tb_id, rpt_status, creater_name, create_date, update_date, rpt_type, if_download, rpt_cycle)
values ('160803100453510', '集团产品信息化收入多行数据', '集团产品信息化收入多行数据', null, '1', 'admin', to_date('05-08-2016 14:17:36', 'dd-mm-yyyy hh24:mi:ss'), null, '2', '1', '2');
commit;
prompt 5 records loaded
prompt Loading RPT_REPORT_MODEL...
insert into RPT_REPORT_MODEL (rpt_id, model_id, status)
values ('160805155248185', '160805155158736', '0');
insert into RPT_REPORT_MODEL (rpt_id, model_id, status)
values ('160802133530400', '160802133506631', '1');
insert into RPT_REPORT_MODEL (rpt_id, model_id, status)
values ('160803100453510', '160803100355252', '0');
insert into RPT_REPORT_MODEL (rpt_id, model_id, status)
values ('160805155248185', '160805155158736', '0');
insert into RPT_REPORT_MODEL (rpt_id, model_id, status)
values ('160805155248185', '160805155158736', '0');
insert into RPT_REPORT_MODEL (rpt_id, model_id, status)
values ('160805155248185', '160805155158736', '1');
insert into RPT_REPORT_MODEL (rpt_id, model_id, status)
values ('160803100453510', '160803100355252', '1');
insert into RPT_REPORT_MODEL (rpt_id, model_id, status)
values ('160805155248185', '160805155158736', '0');
insert into RPT_REPORT_MODEL (rpt_id, model_id, status)
values ('160805155248185', '160805155158736', '0');
commit;
prompt 9 records loaded
prompt Loading RPT_SYS_CODE...
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('4', '图表', 4, 'RPT_TYPE', '报表类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('1', '单表头', 1, 'RPT_TYPE', '报表类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('2', '多表头', 2, 'RPT_TYPE', '报表类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('3', '智能查询', 3, 'RPT_TYPE', '报表类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('1', '日期', 1, 'CDT_SHOW_TYPE', '控件展现类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('2', '日期(开始-结束)', 2, 'CDT_SHOW_TYPE', '控件展现类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('3', '月份', 3, 'CDT_SHOW_TYPE', '控件展现类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('4', '月份(开始-结束)', 4, 'CDT_SHOW_TYPE', '控件展现类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('5', '多选框', 5, 'CDT_SHOW_TYPE', '控件展现类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('6', '单选框', 6, 'CDT_SHOW_TYPE', '控件展现类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('7', '文本框', 7, 'CDT_SHOW_TYPE', '控件展现类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('8', '固定值列表', 8, 'CDT_SHOW_TYPE', '控件展现类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('1', '=', 1, 'CDT_CAL_TYPE', '控件计算类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('2', '!=', 2, 'CDT_CAL_TYPE', '控件计算类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('3', '>', 3, 'CDT_CAL_TYPE', '控件计算类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('4', '>=', 4, 'CDT_CAL_TYPE', '控件计算类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('5', '<', 5, 'CDT_CAL_TYPE', '控件计算类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('6', '<=', 6, 'CDT_CAL_TYPE', '控件计算类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('7', 'LIKE', 7, 'CDT_CAL_TYPE', '控件计算类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('8', 'NOT LIKE', 8, 'CDT_CAL_TYPE', '控件计算类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('9', 'IN', 9, 'CDT_CAL_TYPE', '控件计算类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('10', 'NOT IN', 10, 'CDT_CAL_TYPE', '控件计算类型');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('1', '日', 1, 'RPT_CYCLE', '报表周期');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('2', '月', 2, 'RPT_CYCLE', '报表周期');
insert into RPT_SYS_CODE (code_id, code_name, code_order, code_type_id, code_type_name)
values ('11', 'BETWEEN', 11, 'CDT_CAL_TYPE', '控件计算类型');
commit;
prompt 25 records loaded
prompt Loading RPT_SYS_VAR...
insert into RPT_SYS_VAR (var_id, var_code, var_value, var_desc)
values ('160559172401', 'REGION_CODE', '570,571,572,573,574,575,576,577,578,579,580', '按照地市编码分表');
commit;
prompt 1 records loaded
prompt Loading RPT_TABLE_FIELD...
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605311310052241', '160531131005224', 'RPT_ID', '报表ID', 'VARCHAR2', 30, 1, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605311310052242', '160531131005224', 'FIELD_ID', '报表字段ID', 'VARCHAR2', 30, 2, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605311310052243', '160531131005224', 'FIELD_CODE', '报表字段编码', 'VARCHAR2', 100, 3, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605311310052244', '160531131005224', 'FILED_NAME', '报表字段名称', 'VARCHAR2', 1000, 4, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605311310052245', '160531131005224', 'CDT_ORDER', '控件顺序', 'NUMBER', 22, 5, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605311310052246', '160531131005224', 'CDT_ID', '控件ID', 'VARCHAR2', 30, 6, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605311310052247', '160531131005224', 'CDT_SHOW_TYPE', '控件展现类型', 'CHAR', 1, 7, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605311310052248', '160531131005224', 'CDT_CAL_TYPE', '控件计算类型', 'CHAR', 1, 8, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605311310052249', '160531131005224', 'DEFAULT_VAL', '控件默认值', 'VARCHAR2', 1000, 9, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597635', '160526102105976', 'MON_MAINCNTCT_USERCNT', '当月累计主推营销接触用户数', 'NUMBER', 22, 35, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597636', '160526102105976', 'MON_MAINSUC_USERCNT', '当月累计主推营销成功用户数', 'NUMBER', 22, 36, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597637', '160526102105976', 'MON_SUBCNTCT_USERCNT', '当月累计辅推营销接触用户数', 'NUMBER', 22, 37, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597638', '160526102105976', 'MON_SUBSUC_USERCNT', '当月累计辅推营销成功用户数', 'NUMBER', 22, 38, '0', '0', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605261021059761', '160526102105976', 'DEAL_DATE', '处理日期', 'VARCHAR2', 8, 1, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605261021059762', '160526102105976', 'REGION_CODE', '地市编码', 'VARCHAR2', 3, 2, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605261021059763', '160526102105976', 'REGION_DESC', '地市描述', 'VARCHAR2', 20, 3, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605261021059764', '160526102105976', 'CITY_CODE', '县市编码', 'VARCHAR2', 5, 4, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605261021059765', '160526102105976', 'CITY_DESC', '县市描述', 'VARCHAR2', 30, 5, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605261021059766', '160526102105976', 'ORG_ID', '区域', 'NUMBER', 22, 6, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605261021059767', '160526102105976', 'ORG_NAME', '区域描述', 'VARCHAR2', 200, 7, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605261021059768', '160526102105976', 'CHANNEL_TYPE', '渠道类型', 'VARCHAR2', 20, 8, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1605261021059769', '160526102105976', 'AREA_CODE', '营业厅编号', 'NUMBER', 22, 9, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597610', '160526102105976', 'AREA_NAME', '营业厅', 'VARCHAR2', 200, 10, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597611', '160526102105976', 'OWNER_NAME', '店长', 'VARCHAR2', 40, 11, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597612', '160526102105976', 'OWNER_PHONE', '店长号码', 'NUMBER', 22, 12, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597613', '160526102105976', 'DAY_CRM_USERCNT', '当日接触用户数', 'NUMBER', 22, 13, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597614', '160526102105976', 'DAY_CNTCT_USERCNT', '当日营销接触用户数', 'NUMBER', 22, 14, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597615', '160526102105976', 'DAY_RECM_USERCNT', '当日查看推荐详情用户数', 'NUMBER', 22, 15, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597616', '160526102105976', 'DAY_RECM_USERRATE', '当日政策详情查看率', 'NUMBER', 22, 16, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597617', '160526102105976', 'AVG_DAY_RECM_USERRATE', '当日平均推荐率', 'NUMBER', 22, 17, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597618', '160526102105976', 'DAY_SUC_USERCNT', '当日营销成功用户数', 'NUMBER', 22, 18, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597619', '160526102105976', 'DAY_SUC_USERRATE', '当日推荐成功率', 'NUMBER', 22, 19, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597620', '160526102105976', 'DAY_CHG_USERRATE', '当日推荐转化率', 'NUMBER', 22, 20, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597621', '160526102105976', 'AVG_DAY_SUC_USERRATE', '当日平均成功率', 'NUMBER', 22, 21, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597622', '160526102105976', 'DAY_MAINCNTCT_USERCNT', '当日主推营销接触用户数', 'NUMBER', 22, 22, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597623', '160526102105976', 'DAY_MAINSUC_USERCNT', '当日主推营销成功用户数', 'NUMBER', 22, 23, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597624', '160526102105976', 'DAY_SUBCNTCT_USERCNT', '当日辅推营销接触用户数', 'NUMBER', 22, 24, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597625', '160526102105976', 'DAY_SUBSUC_USERCNT', '当日辅推营销成功用户数', 'NUMBER', 22, 25, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597626', '160526102105976', 'MON_CRM_USERCNT', '当月累计接触用户数', 'NUMBER', 22, 26, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597627', '160526102105976', 'MON_CNTCT_USERCNT', '当月累计营销接触用户数', 'NUMBER', 22, 27, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597628', '160526102105976', 'MON_RECM_USERCNT', '当月累计查看推荐详情用户数', 'NUMBER', 22, 28, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597629', '160526102105976', 'MON_RECM_USERRATE', '当月累计政策详情查看率', 'NUMBER', 22, 29, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597630', '160526102105976', 'AVG_MON_RECM_USERRATE', '当月累计平均推荐率', 'NUMBER', 22, 30, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597631', '160526102105976', 'MON_SUC_USERCNT', '当月累计营销成功用户数', 'NUMBER', 22, 31, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597632', '160526102105976', 'MON_SUC_USERRATE', '当月累计推荐成功率', 'NUMBER', 22, 32, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597633', '160526102105976', 'MON_CHG_USERRATE', '当月累计推荐转化率', 'NUMBER', 22, 33, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16052610210597634', '160526102105976', 'AVG_MON_SUC_USERRATE', '当月累计平均成功率', 'NUMBER', 22, 34, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1606301933427361', '160630193342736', 'DEAL_DATE', '处理日期', 'VARCHAR2', 8, 1, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1606301933427362', '160630193342736', 'DEAL_DATE', '处理日期', 'VARCHAR2', 8, 2, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1606301933427363', '160630193342736', 'REGION_CODE', '地市编码', 'VARCHAR2', 4, 3, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1606301933427364', '160630193342736', 'REGION_CODE', '地市编码', 'VARCHAR2', 4, 4, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1606301933427365', '160630193342736', 'CITY_CODE', '区县编码', 'VARCHAR2', 8, 5, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1606301933427366', '160630193342736', 'CITY_CODE', '区县编码', 'VARCHAR2', 8, 6, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1606301933427367', '160630193342736', 'CITY_DESC', '区县', 'VARCHAR2', 20, 7, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1606301933427368', '160630193342736', 'CITY_DESC', '区县', 'VARCHAR2', 20, 8, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1606301933427369', '160630193342736', 'AREA_CODE', '营业厅编码', 'VARCHAR2', 10, 9, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273610', '160630193342736', 'AREA_CODE', '营业厅编码', 'VARCHAR2', 10, 10, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273611', '160630193342736', 'OP_ID', '营业员工号', 'VARCHAR2', 12, 11, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273612', '160630193342736', 'OP_ID', '营业员工号', 'VARCHAR2', 12, 12, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273613', '160630193342736', 'USER_ID', '营销接触用户编码', 'NUMBER', 22, 13, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273614', '160630193342736', 'USER_ID', '营销接触用户编码', 'NUMBER', 22, 14, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273615', '160630193342736', 'PHONE_NO', '营销接触用户号码', 'VARCHAR2', 20, 15, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273616', '160630193342736', 'PHONE_NO', '营销接触用户号码', 'VARCHAR2', 20, 16, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273617', '160630193342736', 'CNTCT_TIME', '营销接触时间', 'DATE', 7, 17, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273618', '160630193342736', 'CNTCT_TIME', '营销接触时间', 'DATE', 7, 18, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273619', '160630193342736', 'CNTCT_STRATEGY_ID', '营销接触策略编号', 'NUMBER', 22, 19, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273620', '160630193342736', 'CNTCT_STRATEGY_ID', '营销接触策略编号', 'NUMBER', 22, 20, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273621', '160630193342736', 'CNTCT_STRATEGY_NAME', '接触接触策略名称', 'VARCHAR2', 100, 21, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273622', '160630193342736', 'CNTCT_STRATEGY_NAME', '接触接触策略名称', 'VARCHAR2', 100, 22, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273623', '160630193342736', 'CNTCT_PLOY_ID', '营销接触政策ID', 'VARCHAR2', 20, 23, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273624', '160630193342736', 'CNTCT_PLOY_ID', '营销接触政策ID', 'VARCHAR2', 20, 24, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273625', '160630193342736', 'CNTCT_EXTEND_ID', '接触策划短编号', 'VARCHAR2', 20, 25, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273626', '160630193342736', 'CNTCT_EXTEND_ID', '接触策划短编号', 'VARCHAR2', 20, 26, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273627', '160630193342736', 'CNTCT_PLOY_DESC', '营销接触政策名称', 'VARCHAR2', 200, 27, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273628', '160630193342736', 'CNTCT_PLOY_DESC', '营销接触政策名称', 'VARCHAR2', 200, 28, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273629', '160630193342736', 'MRMD_ORDER', '营销接触政策优先级', 'VARCHAR2', 10, 29, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273630', '160630193342736', 'MRMD_ORDER', '营销接触政策优先级', 'VARCHAR2', 10, 30, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273631', '160630193342736', 'PER_DIS_FLAG', '是否营销查询', 'CHAR', 1, 31, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273632', '160630193342736', 'PER_DIS_FLAG', '是否营销查询', 'CHAR', 1, 32, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273633', '160630193342736', 'DEAL_PLOY_ID', '成功受理策划编号', 'VARCHAR2', 20, 33, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273634', '160630193342736', 'DEAL_PLOY_ID', '成功受理策划编号', 'VARCHAR2', 20, 34, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273635', '160630193342736', 'DEAL_EXTEND_ID', '成功受理策划短编号', 'VARCHAR2', 20, 35, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273636', '160630193342736', 'DEAL_EXTEND_ID', '成功受理策划短编号', 'VARCHAR2', 20, 36, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273637', '160630193342736', 'DEAL_PLOY_DESC', '成功受理策划名称', 'VARCHAR2', 500, 37, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273638', '160630193342736', 'DEAL_PLOY_DESC', '成功受理策划名称', 'VARCHAR2', 500, 38, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273639', '160630193342736', 'DEAL_TIME', '成功受理时间', 'DATE', 7, 39, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273640', '160630193342736', 'DEAL_TIME', '成功受理时间', 'DATE', 7, 40, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273641', '160630193342736', 'CHANNEL_TYPE', '渠道类型', 'VARCHAR2', 2, 41, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273642', '160630193342736', 'CHANNEL_TYPE', '渠道类型', 'VARCHAR2', 2, 42, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273643', '160630193342736', 'SYS_FROM', '来源系统', 'VARCHAR2', 60, 43, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273644', '160630193342736', 'SYS_FROM', '来源系统', 'VARCHAR2', 60, 44, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273645', '160630193342736', 'ITEM_TYPE', '订购类型', 'VARCHAR2', 50, 45, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273646', '160630193342736', 'ITEM_TYPE', '订购类型', 'VARCHAR2', 50, 46, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273647', '160630193342736', 'OFFER_TYPE_DESC', '订购类型', 'VARCHAR2', 30, 47, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16063019334273648', '160630193342736', 'OFFER_TYPE_DESC', '订购类型', 'VARCHAR2', 30, 48, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1608051028314161', '160805102831416', 'DEAL_MON', '月份', 'VARCHAR2', 8, 1, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1608051028314162', '160805102831416', 'REGION_ID', '地市编码', 'VARCHAR2', 5, 2, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1608051028314163', '160805102831416', 'REGION_NAME', '地市', 'VARCHAR2', 10, 3, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1608051028314164', '160805102831416', 'COUNTY_CODE', '区县编码', 'VARCHAR2', 10, 4, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1608051028314165', '160805102831416', 'COUNTY_NAME', '区县', 'VARCHAR2', 20, 5, '0', '1', '1', null);
commit;
prompt 100 records committed...
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1608051028314166', '160805102831416', 'CHANNEL_TYPE', '一级类型编码', 'NUMBER', 22, 6, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1608051028314167', '160805102831416', 'CHANNEL_TYPE_NAME', '一级类型', 'VARCHAR2', 100, 7, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1608051028314168', '160805102831416', 'CHANNEL_TYPE_DTL', '二级类型编码', 'NUMBER', 22, 8, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('1608051028314169', '160805102831416', 'CHANNEL_TYPE_DTL_NAME', '二级类型', 'VARCHAR2', 100, 9, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16080510283141610', '160805102831416', 'CHANNEL_TYPE_DTL3', '三级类型编码', 'NUMBER', 22, 10, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16080510283141611', '160805102831416', 'CHANNEL_TYPE_DTL3_NAME', '三级类型', 'VARCHAR2', 100, 11, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16080510283141612', '160805102831416', 'MANAGER_ID', '店长编码', 'NUMBER', 22, 12, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16080510283141613', '160805102831416', 'ORG_ID', '营业厅编码', 'VARCHAR2', 20, 13, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16080510283141614', '160805102831416', 'ORG_NAME', '营业厅名称', 'VARCHAR2', 100, 14, '0', '1', '1', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16080510283141615', '160805102831416', 'INCOME_FEE', '总收入（元）', 'NUMBER', 22, 15, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16080510283141616', '160805102831416', 'RENT_FEE', '租金', 'NUMBER', 22, 16, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16080510283141617', '160805102831416', 'BS_FEE', '业务收入（元）', 'NUMBER', 22, 17, '0', '1', '0', null);
insert into RPT_TABLE_FIELD (field_id, tb_id, field_code, field_name, field_type, field_length, display_order, is_fixed, field_status, is_dim, group_value)
values ('16080510283141618', '160805102831416', 'BS_INCOME_RATE', '业务收入占比', 'VARCHAR2', 22, 18, '1', '1', '0', 'DECODE(SUM(RENT_FEE)+SUM(BS_FEE), 0, ''0'', ROUND(SUM(BS_FEE)/(SUM(RENT_FEE)+SUM(BS_FEE))*100, 2)||''%'')');
commit;
prompt 113 records loaded
prompt Loading RPT_TABLE_INFO...
insert into RPT_TABLE_INFO (tb_id, tb_name, tb_desc, tb_owner, tb_code, split_flag, split_code, tb_status, creater_name, create_date, update_date)
values ('160531131005224', '报表条件配置信息表', '报表条件配置信息表，此表中配置了报表的筛选条件清单及展现方式和顺序', 'AIUTIL', 'RPT_REPORT_CONDITION', '0', null, '1', null, to_date('31-05-2016 13:10:05', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into RPT_TABLE_INFO (tb_id, tb_name, tb_desc, tb_owner, tb_code, split_flag, split_code, tb_status, creater_name, create_date, update_date)
values ('160526102105976', '营业厅渠道推荐受理统计数据', '营业厅渠道推荐受理统计数据，分为日数据及月累计数据', 'AIUTIL', 'AP_RPT_CRM_AREA_TRACE_D_ZJ', '0', null, '1', null, to_date('26-05-2016 10:21:05', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into RPT_TABLE_INFO (tb_id, tb_name, tb_desc, tb_owner, tb_code, split_flag, split_code, tb_status, creater_name, create_date, update_date)
values ('160630193342736', '营销接触数据', '营销接触数据表', 'AIUTIL', 'AP_RPT_CRM_CNTCT_DTL_D_ZJ', '0', null, '1', null, to_date('30-06-2016 19:33:42', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into RPT_TABLE_INFO (tb_id, tb_name, tb_desc, tb_owner, tb_code, split_flag, split_code, tb_status, creater_name, create_date, update_date)
values ('160805102831416', '厅建效益收入分析', '厅建效益收入分析到营业厅最细维度', 'AIUTIL', 'AP_CHL_ORG_INCOME_ANL_M', '0', null, '1', null, to_date('05-08-2016 10:28:29', 'dd-mm-yyyy hh24:mi:ss'), null);
commit;
prompt 4 records loaded
set feedback on
set define on
prompt Done.
