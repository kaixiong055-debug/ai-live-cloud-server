-- ============================================================================
-- AI 伴播云平台完整基础数据库 V3（独立建库版）
-- 兼容：Amazon Aurora MySQL 5.7.44 / MySQL 5.7
-- 目标库：ai_live
-- 生成日期：2026-07-27
--
-- 本版本说明：
-- 1. 每一张表均使用显式 CREATE TABLE，包含完整字段、类型、默认值、索引和注释。
-- 2. 不使用 CREATE TABLE ... LIKE，不依赖 admin_portal 或其他源数据库。
-- 3. 包含 system、infra、Quartz 和 AI Live 业务共 67 张表。
-- 4. 不包含 Delta、陪玩、俱乐部、商城、支付、会员、公众号等旧业务表。
-- 5. 本脚本会重建 ai_live 中同名表；请勿在已有正式数据的数据库直接运行。
-- ============================================================================

CREATE DATABASE IF NOT EXISTS `ai_live`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `ai_live`;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ==================== SYSTEM 模块：32 张表 ====================
DROP TABLE IF EXISTS `system_tenant_package`;
CREATE TABLE `system_tenant_package` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '套餐编号',
  `name` varchar(30) NOT NULL COMMENT '套餐名',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '租户状态（0正常 1停用）',
  `remark` varchar(256) NULL DEFAULT '' COMMENT '备注',
  `menu_ids` varchar(4096) NOT NULL COMMENT '关联的菜单编号',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户套餐表';

DROP TABLE IF EXISTS `system_tenant`;
CREATE TABLE `system_tenant` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '租户编号',
  `name` varchar(30) NOT NULL COMMENT '租户名',
  `contact_user_id` bigint NULL DEFAULT NULL COMMENT '联系人的用户编号',
  `contact_name` varchar(30) NOT NULL COMMENT '联系人',
  `contact_mobile` varchar(500) NULL DEFAULT NULL COMMENT '联系手机',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '租户状态',
  `websites` varchar(1024) NULL DEFAULT '' COMMENT '绑定域名数组',
  `package_id` bigint NOT NULL COMMENT '租户套餐编号',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `account_count` int NOT NULL COMMENT '账号数量',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户表';

DROP TABLE IF EXISTS `system_sms_channel`;
CREATE TABLE `system_sms_channel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `signature` varchar(12) NOT NULL COMMENT '短信签名',
  `code` varchar(63) NOT NULL COMMENT '渠道编码',
  `status` tinyint NOT NULL COMMENT '开启状态',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `api_key` varchar(128) NOT NULL COMMENT '短信 API 的账号',
  `api_secret` varchar(128) NULL DEFAULT NULL COMMENT '短信 API 的秘钥',
  `callback_url` varchar(255) NULL DEFAULT NULL COMMENT '短信发送回调 URL',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='短信渠道';

DROP TABLE IF EXISTS `system_sms_template`;
CREATE TABLE `system_sms_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` tinyint NOT NULL COMMENT '模板类型',
  `status` tinyint NOT NULL COMMENT '开启状态',
  `code` varchar(63) NOT NULL COMMENT '模板编码',
  `name` varchar(63) NOT NULL COMMENT '模板名称',
  `content` varchar(255) NOT NULL COMMENT '模板内容',
  `params` varchar(255) NOT NULL COMMENT '参数数组',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `api_template_id` varchar(63) NOT NULL COMMENT '短信 API 的模板编号',
  `channel_id` bigint NOT NULL COMMENT '短信渠道编号',
  `channel_code` varchar(63) NOT NULL COMMENT '短信渠道编码',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='短信模板';

DROP TABLE IF EXISTS `system_mail_account`;
CREATE TABLE `system_mail_account` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mail` varchar(255) NOT NULL COMMENT '邮箱',
  `username` varchar(255) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `host` varchar(255) NOT NULL COMMENT 'SMTP 服务器域名',
  `port` int NOT NULL COMMENT 'SMTP 服务器端口',
  `ssl_enable` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否开启 SSL',
  `starttls_enable` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否开启 STARTTLS',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邮箱账号表';

DROP TABLE IF EXISTS `system_mail_template`;
CREATE TABLE `system_mail_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(63) NOT NULL COMMENT '模板名称',
  `code` varchar(63) NOT NULL COMMENT '模板编码',
  `account_id` bigint NOT NULL COMMENT '发送的邮箱账号编号',
  `nickname` varchar(255) NULL DEFAULT NULL COMMENT '发送人名称',
  `title` varchar(255) NOT NULL COMMENT '模板标题',
  `content` varchar(10240) NOT NULL COMMENT '模板内容',
  `params` varchar(255) NOT NULL COMMENT '参数数组',
  `status` tinyint NOT NULL COMMENT '开启状态',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邮件模版表';

DROP TABLE IF EXISTS `system_notice`;
CREATE TABLE `system_notice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(50) NOT NULL COMMENT '公告标题',
  `content` text NOT NULL COMMENT '公告内容',
  `type` tinyint NOT NULL COMMENT '公告类型（1通知 2公告）',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '公告状态（0正常 1关闭）',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知公告表';

DROP TABLE IF EXISTS `system_notify_template`;
CREATE TABLE `system_notify_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(63) NOT NULL COMMENT '模板名称',
  `code` varchar(64) NOT NULL COMMENT '模版编码',
  `nickname` varchar(255) NOT NULL COMMENT '发送人名称',
  `content` varchar(1024) NOT NULL COMMENT '模版内容',
  `type` tinyint NOT NULL COMMENT '类型',
  `params` varchar(255) NULL DEFAULT NULL COMMENT '参数数组',
  `status` tinyint NOT NULL COMMENT '状态',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='站内信模板表';

DROP TABLE IF EXISTS `system_social_client`;
CREATE TABLE `system_social_client` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NOT NULL COMMENT '应用名',
  `social_type` tinyint NOT NULL COMMENT '社交平台的类型',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `client_id` varchar(255) NOT NULL COMMENT '客户端编号',
  `client_secret` varchar(255) NOT NULL COMMENT '客户端密钥',
  `agent_id` varchar(255) NULL DEFAULT NULL COMMENT '代理编号',
  `public_key` varchar(2048) NULL DEFAULT NULL COMMENT 'publicKey 公钥',
  `status` tinyint NOT NULL COMMENT '状态',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社交客户端表';

DROP TABLE IF EXISTS `system_oauth2_client`;
CREATE TABLE `system_oauth2_client` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `client_id` varchar(255) NOT NULL COMMENT '客户端编号',
  `secret` varchar(255) NOT NULL COMMENT '客户端密钥',
  `name` varchar(255) NOT NULL COMMENT '应用名',
  `logo` varchar(255) NOT NULL COMMENT '应用图标',
  `description` varchar(255) NULL DEFAULT NULL COMMENT '应用描述',
  `status` tinyint NOT NULL COMMENT '状态',
  `access_token_validity_seconds` int NOT NULL COMMENT '访问令牌的有效期',
  `refresh_token_validity_seconds` int NOT NULL COMMENT '刷新令牌的有效期',
  `redirect_uris` varchar(255) NOT NULL COMMENT '可重定向的 URI 地址',
  `authorized_grant_types` varchar(255) NOT NULL COMMENT '授权类型',
  `scopes` varchar(255) NULL DEFAULT NULL COMMENT '授权范围',
  `auto_approve_scopes` varchar(255) NULL DEFAULT NULL COMMENT '自动通过的授权范围',
  `authorities` varchar(255) NULL DEFAULT NULL COMMENT '权限',
  `resource_ids` varchar(255) NULL DEFAULT NULL COMMENT '资源',
  `additional_information` varchar(4096) NULL DEFAULT NULL COMMENT '附加信息',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_client_id` (`client_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 客户端表';

DROP TABLE IF EXISTS `system_dict_type`;
CREATE TABLE `system_dict_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '字典名称',
  `type` varchar(100) NOT NULL DEFAULT '' COMMENT '字典类型',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态（0正常 1停用）',
  `remark` varchar(500) NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典类型表';

DROP TABLE IF EXISTS `system_dict_data`;
CREATE TABLE `system_dict_data` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `sort` int NOT NULL DEFAULT 0 COMMENT '字典排序',
  `label` varchar(100) NOT NULL DEFAULT '' COMMENT '字典标签',
  `value` varchar(100) NOT NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) NOT NULL DEFAULT '' COMMENT '字典类型',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态（0正常 1停用）',
  `color_type` varchar(100) NULL DEFAULT '' COMMENT '颜色类型',
  `css_class` varchar(100) NULL DEFAULT '' COMMENT 'css 样式',
  `remark` varchar(500) NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典数据表';

DROP TABLE IF EXISTS `system_menu`;
CREATE TABLE `system_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `name` varchar(50) NOT NULL COMMENT '菜单名称',
  `permission` varchar(100) NOT NULL DEFAULT '' COMMENT '权限标识',
  `type` tinyint NOT NULL COMMENT '菜单类型',
  `sort` int NOT NULL DEFAULT 0 COMMENT '显示顺序',
  `parent_id` bigint NOT NULL DEFAULT 0 COMMENT '父菜单ID',
  `path` varchar(200) NULL DEFAULT '' COMMENT '路由地址',
  `icon` varchar(100) NULL DEFAULT '#' COMMENT '菜单图标',
  `component` varchar(255) NULL DEFAULT NULL COMMENT '组件路径',
  `component_name` varchar(255) NULL DEFAULT NULL COMMENT '组件名',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '菜单状态',
  `visible` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否可见',
  `keep_alive` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否缓存',
  `always_show` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否总是显示',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单权限表';

DROP TABLE IF EXISTS `system_dept`;
CREATE TABLE `system_dept` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '部门名称',
  `parent_id` bigint NOT NULL DEFAULT 0 COMMENT '父部门id',
  `sort` int NOT NULL DEFAULT 0 COMMENT '显示顺序',
  `leader_user_id` bigint NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) NULL DEFAULT NULL COMMENT '邮箱',
  `status` tinyint NOT NULL COMMENT '部门状态（0正常 1停用）',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='部门表';

DROP TABLE IF EXISTS `system_post`;
CREATE TABLE `system_post` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `code` varchar(64) NOT NULL COMMENT '岗位编码',
  `name` varchar(50) NOT NULL COMMENT '岗位名称',
  `sort` int NOT NULL COMMENT '显示顺序',
  `status` tinyint NOT NULL COMMENT '状态（0正常 1停用）',
  `remark` varchar(500) NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='岗位信息表';

DROP TABLE IF EXISTS `system_role`;
CREATE TABLE `system_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `name` varchar(30) NOT NULL COMMENT '角色名称',
  `code` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` tinyint NOT NULL DEFAULT 1 COMMENT '数据范围',
  `data_scope_dept_ids` varchar(500) NOT NULL DEFAULT '' COMMENT '数据范围(指定部门数组)',
  `status` tinyint NOT NULL COMMENT '角色状态（0正常 1停用）',
  `type` tinyint NOT NULL COMMENT '角色类型',
  `remark` varchar(500) NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色信息表';

DROP TABLE IF EXISTS `system_users`;
CREATE TABLE `system_users` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(30) NOT NULL COMMENT '用户账号',
  `password` varchar(100) NOT NULL DEFAULT '' COMMENT '密码',
  `nickname` varchar(30) NOT NULL COMMENT '用户昵称',
  `remark` varchar(500) NULL DEFAULT NULL COMMENT '备注',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `post_ids` varchar(255) NULL DEFAULT NULL COMMENT '岗位编号数组',
  `email` varchar(50) NULL DEFAULT '' COMMENT '用户邮箱',
  `mobile` varchar(11) NULL DEFAULT '' COMMENT '手机号码',
  `sex` tinyint NULL DEFAULT 0 COMMENT '用户性别',
  `avatar` varchar(512) NULL DEFAULT '' COMMENT '头像地址',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '帐号状态（0正常 1停用）',
  `login_ip` varchar(50) NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_username` (`username`) USING BTREE,
  KEY `idx_mobile` (`mobile`) USING BTREE,
  KEY `idx_email` (`email`) USING BTREE,
  KEY `idx_dept_id` (`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';

DROP TABLE IF EXISTS `system_login_log`;
CREATE TABLE `system_login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `log_type` bigint NOT NULL COMMENT '日志类型',
  `trace_id` varchar(64) NOT NULL DEFAULT '' COMMENT '链路追踪编号',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '用户类型',
  `username` varchar(50) NOT NULL DEFAULT '' COMMENT '用户账号',
  `result` tinyint NOT NULL COMMENT '登陆结果',
  `user_ip` varchar(50) NOT NULL COMMENT '用户 IP',
  `user_agent` varchar(512) NOT NULL COMMENT '浏览器 UA',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_username` (`username`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统访问记录';

DROP TABLE IF EXISTS `system_operate_log`;
CREATE TABLE `system_operate_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `trace_id` varchar(64) NOT NULL DEFAULT '' COMMENT '链路追踪编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '用户类型',
  `type` varchar(50) NOT NULL COMMENT '操作模块类型',
  `sub_type` varchar(50) NOT NULL COMMENT '操作名',
  `biz_id` bigint NOT NULL COMMENT '操作数据模块编号',
  `action` varchar(2000) NOT NULL DEFAULT '' COMMENT '操作内容',
  `success` bit(1) NOT NULL DEFAULT b'1' COMMENT '操作结果',
  `extra` varchar(2000) NOT NULL DEFAULT '' COMMENT '拓展字段',
  `request_method` varchar(16) NULL DEFAULT '' COMMENT '请求方法名',
  `request_url` varchar(255) NULL DEFAULT '' COMMENT '请求地址',
  `user_ip` varchar(50) NULL DEFAULT NULL COMMENT '用户 IP',
  `user_agent` varchar(512) NULL DEFAULT NULL COMMENT '浏览器 UA',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志记录 V2 版本';

DROP TABLE IF EXISTS `system_sms_code`;
CREATE TABLE `system_sms_code` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `mobile` varchar(11) NOT NULL COMMENT '手机号',
  `code` varchar(6) NOT NULL COMMENT '验证码',
  `create_ip` varchar(15) NOT NULL COMMENT '创建 IP',
  `scene` tinyint NOT NULL COMMENT '发送场景',
  `today_index` tinyint NOT NULL COMMENT '今日发送的第几条',
  `used` tinyint NOT NULL COMMENT '是否使用',
  `used_time` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `used_ip` varchar(255) NULL DEFAULT NULL COMMENT '使用 IP',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_mobile` (`mobile`) USING BTREE COMMENT '手机号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='手机验证码';

DROP TABLE IF EXISTS `system_sms_log`;
CREATE TABLE `system_sms_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `channel_id` bigint NOT NULL COMMENT '短信渠道编号',
  `channel_code` varchar(63) NOT NULL COMMENT '短信渠道编码',
  `template_id` bigint NOT NULL COMMENT '模板编号',
  `template_code` varchar(63) NOT NULL COMMENT '模板编码',
  `template_type` tinyint NOT NULL COMMENT '短信类型',
  `template_content` varchar(255) NOT NULL COMMENT '短信内容',
  `template_params` varchar(255) NOT NULL COMMENT '短信参数',
  `api_template_id` varchar(63) NOT NULL COMMENT '短信 API 的模板编号',
  `mobile` varchar(11) NOT NULL COMMENT '手机号',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户编号',
  `user_type` tinyint NULL DEFAULT NULL COMMENT '用户类型',
  `send_status` tinyint NOT NULL DEFAULT 0 COMMENT '发送状态',
  `send_time` datetime NULL DEFAULT NULL COMMENT '发送时间',
  `api_send_code` varchar(63) NULL DEFAULT NULL COMMENT '短信 API 发送结果的编码',
  `api_send_msg` varchar(255) NULL DEFAULT NULL COMMENT '短信 API 发送失败的提示',
  `api_request_id` varchar(255) NULL DEFAULT NULL COMMENT '短信 API 发送返回的唯一请求 ID',
  `api_serial_no` varchar(255) NULL DEFAULT NULL COMMENT '短信 API 发送返回的序号',
  `receive_status` tinyint NOT NULL DEFAULT 0 COMMENT '接收状态',
  `receive_time` datetime NULL DEFAULT NULL COMMENT '接收时间',
  `api_receive_code` varchar(63) NULL DEFAULT NULL COMMENT 'API 接收结果的编码',
  `api_receive_msg` varchar(255) NULL DEFAULT NULL COMMENT 'API 接收结果的说明',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='短信日志';

DROP TABLE IF EXISTS `system_mail_log`;
CREATE TABLE `system_mail_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户编号',
  `user_type` tinyint NULL DEFAULT NULL COMMENT '用户类型',
  `to_mails` varchar(1024) NOT NULL COMMENT '接收邮箱地址',
  `cc_mails` varchar(1024) NULL DEFAULT NULL COMMENT '抄送邮箱地址',
  `bcc_mails` varchar(1024) NULL DEFAULT NULL COMMENT '密送邮箱地址',
  `account_id` bigint NOT NULL COMMENT '邮箱账号编号',
  `from_mail` varchar(255) NOT NULL COMMENT '发送邮箱地址',
  `template_id` bigint NOT NULL COMMENT '模板编号',
  `template_code` varchar(63) NOT NULL COMMENT '模板编码',
  `template_nickname` varchar(255) NULL DEFAULT NULL COMMENT '模版发送人名称',
  `template_title` varchar(255) NOT NULL COMMENT '邮件标题',
  `template_content` text NOT NULL COMMENT '邮件内容',
  `template_params` varchar(255) NOT NULL COMMENT '邮件参数',
  `send_status` tinyint NOT NULL DEFAULT 0 COMMENT '发送状态',
  `send_time` datetime NULL DEFAULT NULL COMMENT '发送时间',
  `send_message_id` varchar(255) NULL DEFAULT NULL COMMENT '发送返回的消息 ID',
  `send_exception` varchar(4096) NULL DEFAULT NULL COMMENT '发送异常',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邮件日志表';

DROP TABLE IF EXISTS `system_notify_message`;
CREATE TABLE `system_notify_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `template_id` bigint NOT NULL COMMENT '模版编号',
  `template_code` varchar(64) NOT NULL COMMENT '模板编码',
  `template_nickname` varchar(63) NOT NULL COMMENT '模版发送人名称',
  `template_content` varchar(1024) NOT NULL COMMENT '模版内容',
  `template_type` int NOT NULL COMMENT '模版类型',
  `template_params` varchar(255) NOT NULL COMMENT '模版参数',
  `read_status` bit(1) NOT NULL COMMENT '是否已读',
  `read_time` datetime NULL DEFAULT NULL COMMENT '阅读时间',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id_user_type_read_status` (`user_id`,`user_type`,`read_status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='站内信消息表';

DROP TABLE IF EXISTS `system_social_user`;
CREATE TABLE `system_social_user` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键(自增策略)',
  `type` tinyint NOT NULL COMMENT '社交平台的类型',
  `openid` varchar(32) NOT NULL COMMENT '社交 openid',
  `token` varchar(256) NULL DEFAULT NULL COMMENT '社交 token',
  `raw_token_info` varchar(1024) NOT NULL COMMENT '原始 Token 数据，一般是 JSON 格式',
  `nickname` varchar(32) NOT NULL COMMENT '用户昵称',
  `avatar` varchar(255) NULL DEFAULT NULL COMMENT '用户头像',
  `raw_user_info` varchar(1024) NOT NULL COMMENT '原始用户数据，一般是 JSON 格式',
  `code` varchar(256) NOT NULL COMMENT '最后一次的认证 code',
  `state` varchar(256) NULL DEFAULT NULL COMMENT '最后一次的认证 state',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_type_openid` (`type`,`openid`) USING BTREE,
  KEY `idx_type_code_state` (`type`,`code`,`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社交用户表';

DROP TABLE IF EXISTS `system_social_user_bind`;
CREATE TABLE `system_social_user_bind` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键(自增策略)',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `social_type` tinyint NOT NULL COMMENT '社交平台的类型',
  `social_user_id` bigint NOT NULL COMMENT '社交用户的编号',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_type_social_user_id` (`user_type`,`social_user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社交绑定表';

DROP TABLE IF EXISTS `system_oauth2_approve`;
CREATE TABLE `system_oauth2_approve` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `client_id` varchar(255) NOT NULL COMMENT '客户端编号',
  `scope` varchar(255) NOT NULL DEFAULT '' COMMENT '授权范围',
  `approved` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否接受',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id_user_type_client_id` (`user_id`,`user_type`,`client_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 批准表';

DROP TABLE IF EXISTS `system_oauth2_code`;
CREATE TABLE `system_oauth2_code` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `code` varchar(32) NOT NULL COMMENT '授权码',
  `client_id` varchar(255) NOT NULL COMMENT '客户端编号',
  `scopes` varchar(255) NULL DEFAULT '' COMMENT '授权范围',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `redirect_uri` varchar(255) NULL DEFAULT NULL COMMENT '可重定向的 URI 地址',
  `state` varchar(255) NOT NULL DEFAULT '' COMMENT '状态',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_code` (`code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 授权码表';

DROP TABLE IF EXISTS `system_oauth2_refresh_token`;
CREATE TABLE `system_oauth2_refresh_token` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `refresh_token` varchar(32) NOT NULL COMMENT '刷新令牌',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `client_id` varchar(255) NOT NULL COMMENT '客户端编号',
  `scopes` varchar(255) NULL DEFAULT NULL COMMENT '授权范围',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_refresh_token` (`refresh_token`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 刷新令牌';

DROP TABLE IF EXISTS `system_oauth2_access_token`;
CREATE TABLE `system_oauth2_access_token` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `user_info` varchar(512) NOT NULL COMMENT '用户信息',
  `access_token` varchar(255) NOT NULL COMMENT '访问令牌',
  `refresh_token` varchar(32) NOT NULL COMMENT '刷新令牌',
  `client_id` varchar(255) NOT NULL COMMENT '客户端编号',
  `scopes` varchar(255) NULL DEFAULT NULL COMMENT '授权范围',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_access_token` (`access_token`) USING BTREE,
  KEY `idx_refresh_token` (`refresh_token`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 访问令牌';

DROP TABLE IF EXISTS `system_user_post`;
CREATE TABLE `system_user_post` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户ID',
  `post_id` bigint NOT NULL DEFAULT 0 COMMENT '岗位ID',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户岗位表';

DROP TABLE IF EXISTS `system_user_role`;
CREATE TABLE `system_user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户和角色关联表';

DROP TABLE IF EXISTS `system_role_menu`;
CREATE TABLE `system_role_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_role_id` (`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和菜单关联表';

-- ==================== INFRA 模块：11 张表 ====================
DROP TABLE IF EXISTS `infra_api_access_log`;
CREATE TABLE `infra_api_access_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `trace_id` varchar(64) NOT NULL DEFAULT '' COMMENT '链路追踪编号',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '用户类型',
  `application_name` varchar(50) NOT NULL COMMENT '应用名',
  `request_method` varchar(16) NOT NULL DEFAULT '' COMMENT '请求方法名',
  `request_url` varchar(255) NOT NULL DEFAULT '' COMMENT '请求地址',
  `request_params` text NULL COMMENT '请求参数',
  `response_body` text NULL COMMENT '响应结果',
  `user_ip` varchar(50) NOT NULL COMMENT '用户 IP',
  `user_agent` varchar(512) NOT NULL COMMENT '浏览器 UA',
  `operate_module` varchar(50) NULL DEFAULT NULL COMMENT '操作模块',
  `operate_name` varchar(50) NULL DEFAULT NULL COMMENT '操作名',
  `operate_type` tinyint NULL DEFAULT 0 COMMENT '操作分类',
  `begin_time` datetime NOT NULL COMMENT '开始请求时间',
  `end_time` datetime NOT NULL COMMENT '结束请求时间',
  `duration` int NOT NULL COMMENT '执行时长',
  `result_code` int NOT NULL DEFAULT 0 COMMENT '结果码',
  `result_msg` varchar(512) NULL DEFAULT '' COMMENT '结果提示',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='API 访问日志表';

DROP TABLE IF EXISTS `infra_api_error_log`;
CREATE TABLE `infra_api_error_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `trace_id` varchar(64) NOT NULL COMMENT '链路追踪编号',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '用户类型',
  `application_name` varchar(50) NOT NULL COMMENT '应用名',
  `request_method` varchar(16) NOT NULL COMMENT '请求方法名',
  `request_url` varchar(255) NOT NULL COMMENT '请求地址',
  `request_params` varchar(8000) NOT NULL COMMENT '请求参数',
  `user_ip` varchar(50) NOT NULL COMMENT '用户 IP',
  `user_agent` varchar(512) NOT NULL COMMENT '浏览器 UA',
  `exception_time` datetime NOT NULL COMMENT '异常发生时间',
  `exception_name` varchar(128) NOT NULL DEFAULT '' COMMENT '异常名',
  `exception_message` text NOT NULL COMMENT '异常导致的消息',
  `exception_root_cause_message` text NOT NULL COMMENT '异常导致的根消息',
  `exception_stack_trace` text NOT NULL COMMENT '异常的栈轨迹',
  `exception_class_name` varchar(512) NOT NULL COMMENT '异常发生的类全名',
  `exception_file_name` varchar(512) NOT NULL COMMENT '异常发生的类文件',
  `exception_method_name` varchar(512) NOT NULL COMMENT '异常发生的方法名',
  `exception_line_number` int NOT NULL COMMENT '异常发生的方法所在行',
  `process_status` tinyint NOT NULL COMMENT '处理状态',
  `process_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `process_user_id` int NULL DEFAULT 0 COMMENT '处理用户编号',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统异常日志';

DROP TABLE IF EXISTS `infra_codegen_column`;
CREATE TABLE `infra_codegen_column` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NOT NULL COMMENT '表编号',
  `column_name` varchar(200) NOT NULL COMMENT '字段名',
  `data_type` varchar(100) NOT NULL COMMENT '字段类型',
  `column_comment` varchar(500) NOT NULL COMMENT '字段描述',
  `nullable` bit(1) NOT NULL COMMENT '是否允许为空',
  `primary_key` bit(1) NOT NULL COMMENT '是否主键',
  `ordinal_position` int NOT NULL COMMENT '排序',
  `java_type` varchar(32) NOT NULL COMMENT 'Java 属性类型',
  `java_field` varchar(64) NOT NULL COMMENT 'Java 属性名',
  `dict_type` varchar(200) NULL DEFAULT '' COMMENT '字典类型',
  `example` varchar(64) NULL DEFAULT NULL COMMENT '数据示例',
  `create_operation` bit(1) NOT NULL COMMENT '是否为 Create 创建操作的字段',
  `update_operation` bit(1) NOT NULL COMMENT '是否为 Update 更新操作的字段',
  `list_operation` bit(1) NOT NULL COMMENT '是否为 List 查询操作的字段',
  `list_operation_condition` varchar(32) NOT NULL DEFAULT '=' COMMENT 'List 查询操作的条件类型',
  `list_operation_result` bit(1) NOT NULL COMMENT '是否为 List 查询操作的返回字段',
  `html_type` varchar(32) NOT NULL COMMENT '显示类型',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_table_id` (`table_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成表字段定义';

DROP TABLE IF EXISTS `infra_codegen_table`;
CREATE TABLE `infra_codegen_table` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `data_source_config_id` bigint NOT NULL COMMENT '数据源配置的编号',
  `scene` tinyint NOT NULL DEFAULT 1 COMMENT '生成场景',
  `table_name` varchar(200) NOT NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) NOT NULL DEFAULT '' COMMENT '表描述',
  `remark` varchar(500) NULL DEFAULT NULL COMMENT '备注',
  `module_name` varchar(30) NOT NULL COMMENT '模块名',
  `business_name` varchar(30) NOT NULL COMMENT '业务名',
  `class_name` varchar(100) NOT NULL DEFAULT '' COMMENT '类名称',
  `class_comment` varchar(50) NOT NULL COMMENT '类描述',
  `author` varchar(50) NOT NULL COMMENT '作者',
  `template_type` tinyint NOT NULL DEFAULT 1 COMMENT '模板类型',
  `front_type` tinyint NOT NULL COMMENT '前端类型',
  `parent_menu_id` bigint NULL DEFAULT NULL COMMENT '父菜单编号',
  `master_table_id` bigint NULL DEFAULT NULL COMMENT '主表的编号',
  `sub_join_column_id` bigint NULL DEFAULT NULL COMMENT '子表关联主表的字段编号',
  `sub_join_many` bit(1) NULL DEFAULT NULL COMMENT '主表与子表是否一对多',
  `tree_parent_column_id` bigint NULL DEFAULT NULL COMMENT '树表的父字段编号',
  `tree_name_column_id` bigint NULL DEFAULT NULL COMMENT '树表的名字字段编号',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成表定义';

DROP TABLE IF EXISTS `infra_config`;
CREATE TABLE `infra_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `category` varchar(50) NOT NULL COMMENT '参数分组',
  `type` tinyint NOT NULL COMMENT '参数类型',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) NOT NULL DEFAULT '' COMMENT '参数键名',
  `value` varchar(500) NOT NULL DEFAULT '' COMMENT '参数键值',
  `visible` bit(1) NOT NULL COMMENT '是否可见',
  `remark` varchar(500) NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_config_key` (`config_key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='参数配置表';

DROP TABLE IF EXISTS `infra_data_source_config`;
CREATE TABLE `infra_data_source_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '参数名称',
  `url` varchar(1024) NOT NULL COMMENT '数据源连接',
  `username` varchar(255) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '密码',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据源配置表';

DROP TABLE IF EXISTS `infra_file`;
CREATE TABLE `infra_file` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文件编号',
  `config_id` bigint NULL DEFAULT NULL COMMENT '配置编号',
  `name` varchar(256) NULL DEFAULT NULL COMMENT '文件名',
  `path` varchar(512) NOT NULL COMMENT '文件路径',
  `url` varchar(1024) NOT NULL COMMENT '文件 URL',
  `type` varchar(128) NULL DEFAULT NULL COMMENT '文件类型',
  `size` int NOT NULL COMMENT '文件大小',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件表';

DROP TABLE IF EXISTS `infra_file_config`;
CREATE TABLE `infra_file_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(63) NOT NULL COMMENT '配置名',
  `storage` tinyint NOT NULL COMMENT '存储器',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `master` bit(1) NOT NULL COMMENT '是否为主配置',
  `config` varchar(4096) NOT NULL COMMENT '存储配置',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件配置表';

DROP TABLE IF EXISTS `infra_file_content`;
CREATE TABLE `infra_file_content` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `config_id` bigint NOT NULL COMMENT '配置编号',
  `path` varchar(512) NOT NULL COMMENT '文件路径',
  `content` mediumblob NOT NULL COMMENT '文件内容',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_config_id_path` (`config_id`,`path`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件内容表';

DROP TABLE IF EXISTS `infra_job`;
CREATE TABLE `infra_job` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务编号',
  `name` varchar(32) NOT NULL COMMENT '任务名称',
  `status` tinyint NOT NULL COMMENT '任务状态',
  `handler_name` varchar(64) NOT NULL COMMENT '处理器的名字',
  `handler_param` varchar(255) NULL DEFAULT NULL COMMENT '处理器的参数',
  `cron_expression` varchar(32) NOT NULL COMMENT 'CRON 表达式',
  `retry_count` int NOT NULL DEFAULT 0 COMMENT '重试次数',
  `retry_interval` int NOT NULL DEFAULT 0 COMMENT '重试间隔',
  `monitor_timeout` int NOT NULL DEFAULT 0 COMMENT '监控超时时间',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务表';

DROP TABLE IF EXISTS `infra_job_log`;
CREATE TABLE `infra_job_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `job_id` bigint NOT NULL COMMENT '任务编号',
  `handler_name` varchar(64) NOT NULL COMMENT '处理器的名字',
  `handler_param` varchar(255) NULL DEFAULT NULL COMMENT '处理器的参数',
  `execute_index` tinyint NOT NULL DEFAULT 1 COMMENT '第几次执行',
  `begin_time` datetime NOT NULL COMMENT '开始执行时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束执行时间',
  `duration` int NULL DEFAULT NULL COMMENT '执行时长',
  `status` tinyint NOT NULL COMMENT '任务状态',
  `result` varchar(4000) NULL DEFAULT '' COMMENT '结果数据',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_job_id` (`job_id`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务日志表';

-- ==================== QUARTZ 模块：11 张表 ====================
DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
CREATE TABLE `QRTZ_JOB_DETAILS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) NULL,
  `JOB_CLASS_NAME` varchar(250) NOT NULL,
  `IS_DURABLE` varchar(1) NOT NULL,
  `IS_NONCONCURRENT` varchar(1) NOT NULL,
  `IS_UPDATE_DATA` varchar(1) NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) NOT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_J_REQ_RECOVERY` (`SCHED_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_J_GRP` (`SCHED_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quartz 任务详情';

DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
CREATE TABLE `QRTZ_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) NULL,
  `NEXT_FIRE_TIME` bigint NULL,
  `PREV_FIRE_TIME` bigint NULL,
  `PRIORITY` int NULL,
  `TRIGGER_STATE` varchar(16) NOT NULL,
  `TRIGGER_TYPE` varchar(8) NOT NULL,
  `START_TIME` bigint NOT NULL,
  `END_TIME` bigint NULL,
  `CALENDAR_NAME` varchar(200) NULL,
  `MISFIRE_INSTR` smallint NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_J` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_C` (`SCHED_NAME`,`CALENDAR_NAME`),
  KEY `IDX_QRTZ_T_G` (`SCHED_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_STATE` (`SCHED_NAME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_STATE` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_G_STATE` (`SCHED_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NEXT_FIRE_TIME` (`SCHED_NAME`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST` (`SCHED_NAME`,`TRIGGER_STATE`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  CONSTRAINT `FK_QRTZ_TRIGGER_JOB` FOREIGN KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`) REFERENCES `QRTZ_JOB_DETAILS` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quartz 触发器';

DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPLE_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `REPEAT_COUNT` bigint NOT NULL,
  `REPEAT_INTERVAL` bigint NOT NULL,
  `TIMES_TRIGGERED` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `FK_QRTZ_SIMPLE_TRIGGER` FOREIGN KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quartz 简单触发器';

DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
CREATE TABLE `QRTZ_CRON_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `CRON_EXPRESSION` varchar(120) NOT NULL,
  `TIME_ZONE_ID` varchar(80) NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `FK_QRTZ_CRON_TRIGGER` FOREIGN KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quartz Cron 触发器';

DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPROP_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `STR_PROP_1` varchar(512) NULL,
  `STR_PROP_2` varchar(512) NULL,
  `STR_PROP_3` varchar(512) NULL,
  `INT_PROP_1` int NULL,
  `INT_PROP_2` int NULL,
  `LONG_PROP_1` bigint NULL,
  `LONG_PROP_2` bigint NULL,
  `DEC_PROP_1` decimal(13,4) NULL,
  `DEC_PROP_2` decimal(13,4) NULL,
  `BOOL_PROP_1` varchar(1) NULL,
  `BOOL_PROP_2` varchar(1) NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `FK_QRTZ_SIMPROP_TRIGGER` FOREIGN KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quartz 属性触发器';

DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
CREATE TABLE `QRTZ_BLOB_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `BLOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_BT_T` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `FK_QRTZ_BLOB_TRIGGER` FOREIGN KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quartz Blob 触发器';

DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
CREATE TABLE `QRTZ_CALENDARS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `CALENDAR_NAME` varchar(200) NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quartz 日历';

DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quartz 暂停触发器组';

DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;
CREATE TABLE `QRTZ_FIRED_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `ENTRY_ID` varchar(95) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `FIRED_TIME` bigint NOT NULL,
  `SCHED_TIME` bigint NOT NULL,
  `PRIORITY` int NOT NULL,
  `STATE` varchar(16) NOT NULL,
  `JOB_NAME` varchar(200) NULL,
  `JOB_GROUP` varchar(200) NULL,
  `IS_NONCONCURRENT` varchar(1) NULL,
  `REQUESTS_RECOVERY` varchar(1) NULL,
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`),
  KEY `IDX_QRTZ_FT_TRIG_INST_NAME` (`SCHED_NAME`,`INSTANCE_NAME`),
  KEY `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY` (`SCHED_NAME`,`INSTANCE_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_FT_J_G` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_T_G` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_FT_TG` (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quartz 已触发记录';

DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
CREATE TABLE `QRTZ_SCHEDULER_STATE` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `LAST_CHECKIN_TIME` bigint NOT NULL,
  `CHECKIN_INTERVAL` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quartz 调度器状态';

DROP TABLE IF EXISTS `QRTZ_LOCKS`;
CREATE TABLE `QRTZ_LOCKS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quartz 锁';

-- ==================== AI LIVE 模块：13 张表 ====================
DROP TABLE IF EXISTS `ai_live_schema_version`;
CREATE TABLE `ai_live_schema_version` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `version` varchar(64) NOT NULL COMMENT '版本号',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `installed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '安装时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_version` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播数据库版本';

DROP TABLE IF EXISTS `ai_live_license_plan`;
CREATE TABLE `ai_live_license_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '套餐编号',
  `name` varchar(100) NOT NULL COMMENT '套餐名称',
  `code` varchar(64) NOT NULL COMMENT '套餐编码',
  `license_type` tinyint NOT NULL COMMENT '授权类型：1永久买断 2按月订阅',
  `duration_days` int NOT NULL DEFAULT 0 COMMENT '有效天数；永久授权为0',
  `device_limit` int NOT NULL DEFAULT 1 COMMENT '最大设备数',
  `offline_grace_days` int NOT NULL DEFAULT 0 COMMENT '离线宽限天数',
  `default_sdk_credential_mode` tinyint NOT NULL DEFAULT 1 COMMENT '默认SDK凭证模式：1客户自有 2平台托管',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0启用 1停用',
  `remark` varchar(500) NOT NULL DEFAULT '' COMMENT '备注',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_plan_code` (`tenant_id`,`code`),
  KEY `idx_plan_status` (`tenant_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播授权套餐';

DROP TABLE IF EXISTS `ai_live_license`;
CREATE TABLE `ai_live_license` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '授权编号',
  `license_key` varchar(128) NOT NULL COMMENT '授权码',
  `plan_id` bigint NOT NULL COMMENT '套餐编号',
  `customer_name` varchar(100) NOT NULL DEFAULT '' COMMENT '客户名称',
  `customer_code` varchar(64) NOT NULL DEFAULT '' COMMENT '客户编码',
  `license_type` tinyint NOT NULL COMMENT '授权类型：1永久买断 2按月订阅',
  `sdk_credential_mode` tinyint NOT NULL COMMENT 'SDK凭证模式：1客户自有 2平台托管',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0待激活 1有效 2过期 3禁用',
  `max_devices` int NOT NULL DEFAULT 1 COMMENT '最大设备数',
  `offline_grace_days` int NOT NULL DEFAULT 0 COMMENT '离线宽限天数',
  `issued_at` datetime NULL DEFAULT NULL COMMENT '签发时间',
  `activated_at` datetime NULL DEFAULT NULL COMMENT '首次激活时间',
  `expire_at` datetime NULL DEFAULT NULL COMMENT '过期时间；永久授权为空',
  `last_verify_time` datetime NULL DEFAULT NULL COMMENT '最近云端校验时间',
  `remark` varchar(500) NOT NULL DEFAULT '' COMMENT '备注',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_license_key` (`license_key`),
  KEY `idx_license_customer` (`tenant_id`,`customer_code`),
  KEY `idx_license_status_expire` (`tenant_id`,`status`,`expire_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播客户授权';

DROP TABLE IF EXISTS `ai_live_edge_device`;
CREATE TABLE `ai_live_edge_device` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '设备编号',
  `device_code` varchar(64) NOT NULL COMMENT '设备编码',
  `license_id` bigint NULL DEFAULT NULL COMMENT '授权编号',
  `device_name` varchar(100) NOT NULL DEFAULT '' COMMENT '设备名称',
  `machine_fingerprint_hash` varchar(128) NOT NULL COMMENT '机器指纹哈希',
  `os_name` varchar(64) NOT NULL DEFAULT '' COMMENT '操作系统',
  `os_version` varchar(64) NOT NULL DEFAULT '' COMMENT '系统版本',
  `agent_version` varchar(64) NOT NULL DEFAULT '' COMMENT '边缘端版本',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0离线 1在线 2禁用',
  `binding_status` tinyint NOT NULL DEFAULT 0 COMMENT '绑定状态：0未绑定 1已绑定',
  `last_heartbeat_time` datetime NULL DEFAULT NULL COMMENT '最近心跳时间',
  `last_ip` varchar(64) NOT NULL DEFAULT '' COMMENT '最近IP',
  `activated_at` datetime NULL DEFAULT NULL COMMENT '激活时间',
  `disabled_reason` varchar(500) NOT NULL DEFAULT '' COMMENT '禁用原因',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_device_code` (`tenant_id`,`device_code`),
  UNIQUE KEY `uk_tenant_fingerprint` (`tenant_id`,`machine_fingerprint_hash`),
  KEY `idx_device_license` (`tenant_id`,`license_id`),
  KEY `idx_device_heartbeat` (`tenant_id`,`status`,`last_heartbeat_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播边缘设备';

DROP TABLE IF EXISTS `ai_live_license_activation_log`;
CREATE TABLE `ai_live_license_activation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `license_id` bigint NULL DEFAULT NULL COMMENT '授权编号',
  `device_id` bigint NULL DEFAULT NULL COMMENT '设备编号',
  `action_type` varchar(32) NOT NULL COMMENT '动作：ACTIVATE VERIFY UNBIND DISABLE',
  `result` tinyint NOT NULL COMMENT '结果：0失败 1成功',
  `request_id` varchar(64) NOT NULL DEFAULT '' COMMENT '请求编号',
  `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '请求IP',
  `message` varchar(1000) NOT NULL DEFAULT '' COMMENT '结果说明',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_activation_license_time` (`tenant_id`,`license_id`,`create_time`),
  KEY `idx_activation_device_time` (`tenant_id`,`device_id`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播授权激活日志';

DROP TABLE IF EXISTS `ai_live_speech_provider_config`;
CREATE TABLE `ai_live_speech_provider_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置编号',
  `name` varchar(100) NOT NULL COMMENT '配置名称',
  `provider_type` varchar(32) NOT NULL COMMENT '供应商类型',
  `credential_mode` tinyint NOT NULL COMMENT '凭证模式：1客户自有 2平台托管',
  `app_id` varchar(128) NOT NULL DEFAULT '' COMMENT '应用编号',
  `access_key_ciphertext` varchar(1000) NOT NULL DEFAULT '' COMMENT '加密后的AccessKey',
  `secret_key_ciphertext` varchar(1000) NOT NULL DEFAULT '' COMMENT '加密后的SecretKey',
  `region` varchar(64) NOT NULL DEFAULT '' COMMENT '地域',
  `config_json` longtext NULL COMMENT '扩展配置JSON',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0启用 1停用',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_speech_name` (`tenant_id`,`name`),
  KEY `idx_speech_status` (`tenant_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播语音识别配置';

DROP TABLE IF EXISTS `ai_live_project`;
CREATE TABLE `ai_live_project` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '项目编号',
  `name` varchar(100) NOT NULL COMMENT '项目名称',
  `code` varchar(64) NOT NULL COMMENT '项目编码',
  `description` varchar(1000) NOT NULL DEFAULT '' COMMENT '说明',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0启用 1停用',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_project_code` (`tenant_id`,`code`),
  KEY `idx_project_status` (`tenant_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播直播项目';

DROP TABLE IF EXISTS `ai_live_scene`;
CREATE TABLE `ai_live_scene` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '场景编号',
  `project_id` bigint NOT NULL COMMENT '项目编号',
  `name` varchar(100) NOT NULL COMMENT '场景名称',
  `code` varchar(64) NOT NULL COMMENT '场景编码',
  `renderer_path` varchar(500) NOT NULL DEFAULT '' COMMENT '本地渲染页面路径',
  `width` int NOT NULL DEFAULT 1920 COMMENT '画布宽度',
  `height` int NOT NULL DEFAULT 1080 COMMENT '画布高度',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0启用 1停用',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_project_scene_code` (`tenant_id`,`project_id`,`code`),
  KEY `idx_scene_project_status` (`tenant_id`,`project_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播直播场景';

DROP TABLE IF EXISTS `ai_live_asset`;
CREATE TABLE `ai_live_asset` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '素材编号',
  `project_id` bigint NOT NULL COMMENT '项目编号',
  `name` varchar(150) NOT NULL COMMENT '素材名称',
  `asset_type` varchar(32) NOT NULL COMMENT '素材类型：IMAGE GIF WEBM',
  `file_url` varchar(1000) NOT NULL COMMENT '云端文件地址',
  `local_relative_path` varchar(500) NOT NULL DEFAULT '' COMMENT '边缘端相对路径',
  `file_size` bigint NOT NULL DEFAULT 0 COMMENT '文件字节数',
  `file_hash` varchar(128) NOT NULL DEFAULT '' COMMENT '文件哈希',
  `duration_ms` int NOT NULL DEFAULT 0 COMMENT '动画或视频时长毫秒',
  `width` int NOT NULL DEFAULT 0 COMMENT '宽度',
  `height` int NOT NULL DEFAULT 0 COMMENT '高度',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0启用 1停用',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_asset_project_type` (`tenant_id`,`project_id`,`asset_type`),
  KEY `idx_asset_hash` (`tenant_id`,`file_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播媒体素材';

DROP TABLE IF EXISTS `ai_live_voice_command`;
CREATE TABLE `ai_live_voice_command` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '指令编号',
  `project_id` bigint NOT NULL COMMENT '项目编号',
  `scene_id` bigint NULL DEFAULT NULL COMMENT '限定场景编号；为空表示项目全局',
  `name` varchar(100) NOT NULL COMMENT '指令名称',
  `command_text` varchar(500) NOT NULL COMMENT '触发文本',
  `match_type` varchar(32) NOT NULL DEFAULT 'EXACT' COMMENT '匹配方式：EXACT CONTAINS REGEX',
  `priority` int NOT NULL DEFAULT 0 COMMENT '匹配优先级',
  `cooldown_ms` int NOT NULL DEFAULT 0 COMMENT '冷却时间毫秒',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0启用 1停用',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_command_project_scene` (`tenant_id`,`project_id`,`scene_id`,`status`),
  KEY `idx_command_priority` (`tenant_id`,`project_id`,`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播语音指令';

DROP TABLE IF EXISTS `ai_live_command_action`;
CREATE TABLE `ai_live_command_action` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '动作编号',
  `command_id` bigint NOT NULL COMMENT '指令编号',
  `action_type` varchar(32) NOT NULL DEFAULT 'SWITCH_ASSET' COMMENT '动作类型',
  `asset_id` bigint NULL DEFAULT NULL COMMENT '素材编号',
  `action_param_json` longtext NULL COMMENT '动作参数JSON',
  `delay_ms` int NOT NULL DEFAULT 0 COMMENT '延迟毫秒',
  `duration_ms` int NOT NULL DEFAULT 0 COMMENT '展示时长毫秒；0表示素材默认',
  `sort` int NOT NULL DEFAULT 0 COMMENT '执行顺序',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0启用 1停用',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_action_command_sort` (`tenant_id`,`command_id`,`sort`),
  KEY `idx_action_asset` (`tenant_id`,`asset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播指令动作';

DROP TABLE IF EXISTS `ai_live_device_command`;
CREATE TABLE `ai_live_device_command` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '下发命令编号',
  `device_id` bigint NOT NULL COMMENT '设备编号',
  `command_type` varchar(64) NOT NULL COMMENT '命令类型',
  `payload_json` longtext NULL COMMENT '命令内容JSON',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0待发送 1已发送 2已确认 3失败 4取消',
  `retry_count` int NOT NULL DEFAULT 0 COMMENT '重试次数',
  `next_retry_time` datetime NULL DEFAULT NULL COMMENT '下次重试时间',
  `sent_time` datetime NULL DEFAULT NULL COMMENT '发送时间',
  `ack_time` datetime NULL DEFAULT NULL COMMENT '确认时间',
  `error_message` varchar(1000) NOT NULL DEFAULT '' COMMENT '错误信息',
  `creator` varchar(64) NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_device_command_poll` (`tenant_id`,`device_id`,`status`,`next_retry_time`),
  KEY `idx_device_command_time` (`tenant_id`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播云端设备命令';

DROP TABLE IF EXISTS `ai_live_command_execution_log`;
CREATE TABLE `ai_live_command_execution_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '执行日志编号',
  `device_id` bigint NULL DEFAULT NULL COMMENT '设备编号',
  `project_id` bigint NULL DEFAULT NULL COMMENT '项目编号',
  `scene_id` bigint NULL DEFAULT NULL COMMENT '场景编号',
  `command_id` bigint NULL DEFAULT NULL COMMENT '指令编号',
  `recognized_text` varchar(2000) NOT NULL DEFAULT '' COMMENT '识别文本',
  `matched` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否匹配',
  `action_result` tinyint NOT NULL DEFAULT 0 COMMENT '结果：0未执行 1成功 2失败',
  `latency_ms` int NOT NULL DEFAULT 0 COMMENT '总耗时毫秒',
  `error_message` varchar(2000) NOT NULL DEFAULT '' COMMENT '错误信息',
  `occurred_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发生时间',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_execution_device_time` (`tenant_id`,`device_id`,`occurred_at`),
  KEY `idx_execution_command_time` (`tenant_id`,`command_id`,`occurred_at`),
  KEY `idx_execution_result_time` (`tenant_id`,`action_result`,`occurred_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI伴播指令执行日志';

-- ==================== 最小初始化数据 ====================
-- 默认后台账号采用芋道官方初始化密码哈希，请首次登录后立即修改密码。

INSERT INTO `system_tenant_package`
(`id`,`name`,`status`,`remark`,`menu_ids`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(1,'AI伴播基础套餐',0,'AI伴播云平台默认套餐','[1,2,7000]','system',NOW(),'system',NOW(),b'0');

INSERT INTO `system_tenant`
(`id`,`name`,`contact_user_id`,`contact_name`,`contact_mobile`,`status`,`websites`,`package_id`,`expire_time`,`account_count`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(1,'AI伴播云平台',1,'管理员','',0,'127.0.0.1,localhost',1,'2099-12-31 23:59:59',9999,'system',NOW(),'system',NOW(),b'0');

INSERT INTO `system_dept`
(`id`,`name`,`parent_id`,`sort`,`leader_user_id`,`phone`,`email`,`status`,`creator`,`create_time`,`updater`,`update_time`,`deleted`,`tenant_id`)
VALUES
(1,'AI伴播云平台',0,0,1,NULL,NULL,0,'system',NOW(),'system',NOW(),b'0',1);

INSERT INTO `system_post`
(`id`,`code`,`name`,`sort`,`status`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`,`tenant_id`)
VALUES
(1,'admin','平台管理员',1,0,'系统内置岗位','system',NOW(),'system',NOW(),b'0',1);

INSERT INTO `system_role`
(`id`,`name`,`code`,`sort`,`data_scope`,`data_scope_dept_ids`,`status`,`type`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`,`tenant_id`)
VALUES
(1,'超级管理员','super_admin',1,1,'',0,1,'系统内置超级管理员','system',NOW(),'system',NOW(),b'0',1);

INSERT INTO `system_users`
(`id`,`username`,`password`,`nickname`,`remark`,`dept_id`,`post_ids`,`email`,`mobile`,`sex`,`avatar`,`status`,`login_ip`,`login_date`,`creator`,`create_time`,`updater`,`update_time`,`deleted`,`tenant_id`)
VALUES
(1,'admin','$2a$04$.vd8nPeLwxt6hnSzmAoAyul8BOLX7Cib6QhcxRe30rfvrIPQHH1OG','AI伴播管理员','首次登录后请立即修改密码',1,'[1]','','',0,'',0,'',NULL,'system',NOW(),'system',NOW(),b'0',1);

INSERT INTO `system_user_post`
(`id`,`user_id`,`post_id`,`creator`,`create_time`,`updater`,`update_time`,`deleted`,`tenant_id`)
VALUES (1,1,1,'system',NOW(),'system',NOW(),b'0',1);

INSERT INTO `system_user_role`
(`id`,`user_id`,`role_id`,`creator`,`create_time`,`updater`,`update_time`,`deleted`,`tenant_id`)
VALUES (1,1,1,'system',NOW(),'system',NOW(),b'0',1);

INSERT INTO `system_oauth2_client`
(`id`,`client_id`,`secret`,`name`,`logo`,`description`,`status`,`access_token_validity_seconds`,`refresh_token_validity_seconds`,`redirect_uris`,`authorized_grant_types`,`scopes`,`auto_approve_scopes`,`authorities`,`resource_ids`,`additional_information`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(1,'default','admin123','AI伴播管理端','','AI伴播云平台默认客户端',0,1800,2592000,'["http://127.0.0.1"]','["password","refresh_token","authorization_code"]','["user.read","user.write"]','[]','[]','[]','{}','system',NOW(),'system',NOW(),b'0');

INSERT INTO `infra_config`
(`id`,`category`,`type`,`name`,`config_key`,`value`,`visible`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(1,'biz',1,'用户管理-账号初始密码','system.user.init-password','123456',b'0','新建后台账号时使用','system',NOW(),'system',NOW(),b'0'),
(2,'biz',1,'用户管理-注册开关','system.user.register-enabled','false',b'0','AI伴播后台默认关闭公开注册','system',NOW(),'system',NOW(),b'0'),
(3,'url',2,'Swagger 接口文档地址','url.swagger','',b'1','按部署环境填写','system',NOW(),'system',NOW(),b'0');

INSERT INTO `infra_file_config`
(`id`,`name`,`storage`,`remark`,`master`,`config`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(1,'数据库存储',1,'开发期默认文件存储；生产环境建议切换对象存储',b'1','{"@class":"cn.iocoder.yudao.module.infra.framework.file.core.client.db.DBFileClientConfig","domain":"http://127.0.0.1:48080"}','system',NOW(),'system',NOW(),b'0');

INSERT INTO `system_dict_type`
(`id`,`name`,`type`,`status`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`,`deleted_time`)
VALUES
(1,'用户性别','system_user_sex',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(2,'系统状态','common_status',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(3,'菜单类型','system_menu_type',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(4,'角色类型','system_role_type',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(5,'登录类型','system_login_type',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(6,'登录结果','system_login_result',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(7,'参数类型','infra_config_type',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(8,'定时任务状态','infra_job_status',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(9,'定时任务日志状态','infra_job_log_status',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(10,'API异常处理状态','infra_api_error_log_process_status',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(11,'文件存储器','infra_file_storage',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(12,'用户类型','user_type',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(100,'授权类型','ai_live_license_type',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(101,'SDK凭证模式','ai_live_sdk_credential_mode',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(102,'素材类型','ai_live_asset_type',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(103,'指令匹配方式','ai_live_command_match_type',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL);

INSERT INTO `system_dict_data`
(`id`,`sort`,`label`,`value`,`dict_type`,`status`,`color_type`,`css_class`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(1,1,'男','1','system_user_sex',0,'primary','',NULL,'system',NOW(),'system',NOW(),b'0'),
(2,2,'女','2','system_user_sex',0,'success','',NULL,'system',NOW(),'system',NOW(),b'0'),
(3,3,'未知','0','system_user_sex',0,'info','',NULL,'system',NOW(),'system',NOW(),b'0'),
(4,1,'开启','0','common_status',0,'success','',NULL,'system',NOW(),'system',NOW(),b'0'),
(5,2,'关闭','1','common_status',0,'info','',NULL,'system',NOW(),'system',NOW(),b'0'),
(6,1,'目录','1','system_menu_type',0,'','',NULL,'system',NOW(),'system',NOW(),b'0'),
(7,2,'菜单','2','system_menu_type',0,'','',NULL,'system',NOW(),'system',NOW(),b'0'),
(8,3,'按钮','3','system_menu_type',0,'','',NULL,'system',NOW(),'system',NOW(),b'0'),
(9,1,'系统内置','1','system_role_type',0,'danger','',NULL,'system',NOW(),'system',NOW(),b'0'),
(10,2,'自定义','2','system_role_type',0,'primary','',NULL,'system',NOW(),'system',NOW(),b'0'),
(11,1,'系统内置','1','infra_config_type',0,'danger','',NULL,'system',NOW(),'system',NOW(),b'0'),
(12,2,'自定义','2','infra_config_type',0,'primary','',NULL,'system',NOW(),'system',NOW(),b'0'),
(13,1,'正常','1','infra_job_status',0,'success','',NULL,'system',NOW(),'system',NOW(),b'0'),
(14,2,'暂停','2','infra_job_status',0,'danger','',NULL,'system',NOW(),'system',NOW(),b'0'),
(15,1,'永久买断','1','ai_live_license_type',0,'success','',NULL,'system',NOW(),'system',NOW(),b'0'),
(16,2,'按月订阅','2','ai_live_license_type',0,'primary','',NULL,'system',NOW(),'system',NOW(),b'0'),
(17,1,'客户自有','1','ai_live_sdk_credential_mode',0,'info','',NULL,'system',NOW(),'system',NOW(),b'0'),
(18,2,'平台托管','2','ai_live_sdk_credential_mode',0,'warning','',NULL,'system',NOW(),'system',NOW(),b'0'),
(19,1,'图片','IMAGE','ai_live_asset_type',0,'','',NULL,'system',NOW(),'system',NOW(),b'0'),
(20,2,'GIF','GIF','ai_live_asset_type',0,'','',NULL,'system',NOW(),'system',NOW(),b'0'),
(21,3,'WebM','WEBM','ai_live_asset_type',0,'','',NULL,'system',NOW(),'system',NOW(),b'0'),
(22,1,'精确匹配','EXACT','ai_live_command_match_type',0,'success','',NULL,'system',NOW(),'system',NOW(),b'0'),
(23,2,'包含匹配','CONTAINS','ai_live_command_match_type',0,'primary','',NULL,'system',NOW(),'system',NOW(),b'0'),
(24,3,'正则匹配','REGEX','ai_live_command_match_type',0,'warning','',NULL,'system',NOW(),'system',NOW(),b'0');

-- 基础菜单：系统管理、基础设施、AI伴播。
INSERT INTO `system_menu`
(`id`,`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(1,'系统管理','',1,10,0,'/system','ep:tools',NULL,NULL,0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(2,'基础设施','',1,20,0,'/infra','ep:monitor',NULL,NULL,0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(100,'用户管理','system:user:list',2,1,1,'user','ep:avatar','system/user/index','SystemUser',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(101,'角色管理','system:role:list',2,2,1,'role','ep:user','system/role/index','SystemRole',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(102,'菜单管理','system:menu:list',2,3,1,'menu','ep:menu','system/menu/index','SystemMenu',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(103,'部门管理','system:dept:list',2,4,1,'dept','ep:office-building','system/dept/index','SystemDept',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(104,'岗位管理','system:post:list',2,5,1,'post','ep:briefcase','system/post/index','SystemPost',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(105,'字典管理','system:dict:list',2,6,1,'dict','ep:collection','system/dict/index','SystemDictType',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(106,'租户管理','system:tenant:list',2,7,1,'tenant','ep:house','system/tenant/index','SystemTenant',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(107,'审计日志','',1,8,1,'log','ep:document-copy',NULL,NULL,0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(108,'登录日志','system:login-log:list',2,1,107,'login-log','ep:promotion','system/loginlog/index','SystemLoginLog',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(109,'操作日志','system:operate-log:list',2,2,107,'operate-log','ep:position','system/operatelog/index','SystemOperateLog',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(200,'配置管理','infra:config:list',2,1,2,'config','ep:setting','infra/config/index','InfraConfig',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(201,'文件管理','infra:file:list',2,2,2,'file','ep:files','infra/file/index','InfraFile',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(202,'定时任务','infra:job:list',2,3,2,'job','ep:timer','infra/job/index','InfraJob',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(203,'API 日志','',1,4,2,'api-log','ep:document',NULL,NULL,0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(204,'访问日志','infra:api-access-log:list',2,1,203,'access-log','ep:view','infra/apiAccessLog/index','InfraApiAccessLog',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(205,'错误日志','infra:api-error-log:list',2,2,203,'error-log','ep:warning','infra/apiErrorLog/index','InfraApiErrorLog',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7000,'AI伴播','',1,5,0,'/ai-live','ep:video-camera',NULL,NULL,0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7001,'授权套餐','ai-live:license-plan:list',2,1,7000,'license-plan','ep:tickets','ai-live/license-plan/index','AiLiveLicensePlan',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7002,'客户授权','ai-live:license:list',2,2,7000,'license','ep:key','ai-live/license/index','AiLiveLicense',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7003,'边缘设备','ai-live:device:list',2,3,7000,'device','ep:monitor','ai-live/device/index','AiLiveDevice',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7004,'直播项目','ai-live:project:list',2,4,7000,'project','ep:folder','ai-live/project/index','AiLiveProject',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7005,'媒体素材','ai-live:asset:list',2,5,7000,'asset','ep:picture','ai-live/asset/index','AiLiveAsset',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7006,'语音指令','ai-live:command:list',2,6,7000,'command','ep:microphone','ai-live/command/index','AiLiveCommand',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7007,'执行日志','ai-live:execution-log:list',2,7,7000,'execution-log','ep:document','ai-live/execution-log/index','AiLiveExecutionLog',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0');

INSERT INTO `system_role_menu`
(`role_id`,`menu_id`,`creator`,`create_time`,`updater`,`update_time`,`deleted`,`tenant_id`)
SELECT 1, m.id, 'system', NOW(), 'system', NOW(), b'0', 1 FROM `system_menu` m;

INSERT INTO `ai_live_schema_version` (`version`,`description`)
VALUES ('BASE_V3_20260727','AI伴播云平台完整独立基础数据库 V3');

INSERT INTO `ai_live_license_plan`
(`id`,`name`,`code`,`license_type`,`duration_days`,`device_limit`,`offline_grace_days`,`default_sdk_credential_mode`,`status`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`,`tenant_id`)
VALUES
(1,'永久买断基础版','PERPETUAL_BASIC',1,0,1,3650,1,0,'永久授权；客户自行管理语音识别 SDK 凭证','system',NOW(),'system',NOW(),b'0',1),
(2,'按月订阅标准版','SUBSCRIPTION_STANDARD',2,30,1,7,2,0,'按月订阅；支持云端配置与设备管理','system',NOW(),'system',NOW(),b'0',1);

SET FOREIGN_KEY_CHECKS = 1;

-- ==================== 完整性校验 ====================
SELECT COUNT(*) AS actual_table_count,
       67 AS expected_table_count,
       CASE WHEN COUNT(*) = 67 THEN 'PASS' ELSE 'FAIL' END AS result
FROM information_schema.tables
WHERE table_schema = 'ai_live'
  AND table_name IN ('system_tenant_package','system_tenant','system_sms_channel','system_sms_template','system_mail_account','system_mail_template','system_notice','system_notify_template','system_social_client','system_oauth2_client','system_dict_type','system_dict_data','system_menu','system_dept','system_post','system_role','system_users','system_login_log','system_operate_log','system_sms_code','system_sms_log','system_mail_log','system_notify_message','system_social_user','system_social_user_bind','system_oauth2_approve','system_oauth2_code','system_oauth2_refresh_token','system_oauth2_access_token','system_user_post','system_user_role','system_role_menu','infra_job_log','infra_job','infra_file_content','infra_file_config','infra_file','infra_data_source_config','infra_config','infra_codegen_table','infra_codegen_column','infra_api_error_log','infra_api_access_log','QRTZ_BLOB_TRIGGERS','QRTZ_CALENDARS','QRTZ_CRON_TRIGGERS','QRTZ_FIRED_TRIGGERS','QRTZ_JOB_DETAILS','QRTZ_LOCKS','QRTZ_PAUSED_TRIGGER_GRPS','QRTZ_SCHEDULER_STATE','QRTZ_SIMPLE_TRIGGERS','QRTZ_SIMPROP_TRIGGERS','QRTZ_TRIGGERS','ai_live_schema_version','ai_live_license_plan','ai_live_license','ai_live_edge_device','ai_live_license_activation_log','ai_live_speech_provider_config','ai_live_project','ai_live_scene','ai_live_asset','ai_live_voice_command','ai_live_command_action','ai_live_device_command','ai_live_command_execution_log');

SELECT e.table_name AS missing_table
FROM (
SELECT 'system_tenant_package' AS table_name
UNION ALL
SELECT 'system_tenant' AS table_name
UNION ALL
SELECT 'system_sms_channel' AS table_name
UNION ALL
SELECT 'system_sms_template' AS table_name
UNION ALL
SELECT 'system_mail_account' AS table_name
UNION ALL
SELECT 'system_mail_template' AS table_name
UNION ALL
SELECT 'system_notice' AS table_name
UNION ALL
SELECT 'system_notify_template' AS table_name
UNION ALL
SELECT 'system_social_client' AS table_name
UNION ALL
SELECT 'system_oauth2_client' AS table_name
UNION ALL
SELECT 'system_dict_type' AS table_name
UNION ALL
SELECT 'system_dict_data' AS table_name
UNION ALL
SELECT 'system_menu' AS table_name
UNION ALL
SELECT 'system_dept' AS table_name
UNION ALL
SELECT 'system_post' AS table_name
UNION ALL
SELECT 'system_role' AS table_name
UNION ALL
SELECT 'system_users' AS table_name
UNION ALL
SELECT 'system_login_log' AS table_name
UNION ALL
SELECT 'system_operate_log' AS table_name
UNION ALL
SELECT 'system_sms_code' AS table_name
UNION ALL
SELECT 'system_sms_log' AS table_name
UNION ALL
SELECT 'system_mail_log' AS table_name
UNION ALL
SELECT 'system_notify_message' AS table_name
UNION ALL
SELECT 'system_social_user' AS table_name
UNION ALL
SELECT 'system_social_user_bind' AS table_name
UNION ALL
SELECT 'system_oauth2_approve' AS table_name
UNION ALL
SELECT 'system_oauth2_code' AS table_name
UNION ALL
SELECT 'system_oauth2_refresh_token' AS table_name
UNION ALL
SELECT 'system_oauth2_access_token' AS table_name
UNION ALL
SELECT 'system_user_post' AS table_name
UNION ALL
SELECT 'system_user_role' AS table_name
UNION ALL
SELECT 'system_role_menu' AS table_name
UNION ALL
SELECT 'infra_job_log' AS table_name
UNION ALL
SELECT 'infra_job' AS table_name
UNION ALL
SELECT 'infra_file_content' AS table_name
UNION ALL
SELECT 'infra_file_config' AS table_name
UNION ALL
SELECT 'infra_file' AS table_name
UNION ALL
SELECT 'infra_data_source_config' AS table_name
UNION ALL
SELECT 'infra_config' AS table_name
UNION ALL
SELECT 'infra_codegen_table' AS table_name
UNION ALL
SELECT 'infra_codegen_column' AS table_name
UNION ALL
SELECT 'infra_api_error_log' AS table_name
UNION ALL
SELECT 'infra_api_access_log' AS table_name
UNION ALL
SELECT 'QRTZ_BLOB_TRIGGERS' AS table_name
UNION ALL
SELECT 'QRTZ_CALENDARS' AS table_name
UNION ALL
SELECT 'QRTZ_CRON_TRIGGERS' AS table_name
UNION ALL
SELECT 'QRTZ_FIRED_TRIGGERS' AS table_name
UNION ALL
SELECT 'QRTZ_JOB_DETAILS' AS table_name
UNION ALL
SELECT 'QRTZ_LOCKS' AS table_name
UNION ALL
SELECT 'QRTZ_PAUSED_TRIGGER_GRPS' AS table_name
UNION ALL
SELECT 'QRTZ_SCHEDULER_STATE' AS table_name
UNION ALL
SELECT 'QRTZ_SIMPLE_TRIGGERS' AS table_name
UNION ALL
SELECT 'QRTZ_SIMPROP_TRIGGERS' AS table_name
UNION ALL
SELECT 'QRTZ_TRIGGERS' AS table_name
UNION ALL
SELECT 'ai_live_schema_version' AS table_name
UNION ALL
SELECT 'ai_live_license_plan' AS table_name
UNION ALL
SELECT 'ai_live_license' AS table_name
UNION ALL
SELECT 'ai_live_edge_device' AS table_name
UNION ALL
SELECT 'ai_live_license_activation_log' AS table_name
UNION ALL
SELECT 'ai_live_speech_provider_config' AS table_name
UNION ALL
SELECT 'ai_live_project' AS table_name
UNION ALL
SELECT 'ai_live_scene' AS table_name
UNION ALL
SELECT 'ai_live_asset' AS table_name
UNION ALL
SELECT 'ai_live_voice_command' AS table_name
UNION ALL
SELECT 'ai_live_command_action' AS table_name
UNION ALL
SELECT 'ai_live_device_command' AS table_name
UNION ALL
SELECT 'ai_live_command_execution_log' AS table_name
) e
LEFT JOIN information_schema.tables t
  ON t.table_schema = 'ai_live' AND t.table_name = e.table_name
WHERE t.table_name IS NULL;

-- 每张表字段数量，确认不是空壳表。
SELECT table_name, COUNT(*) AS column_count
FROM information_schema.columns
WHERE table_schema = 'ai_live'
  AND table_name IN ('system_tenant_package','system_tenant','system_sms_channel','system_sms_template','system_mail_account','system_mail_template','system_notice','system_notify_template','system_social_client','system_oauth2_client','system_dict_type','system_dict_data','system_menu','system_dept','system_post','system_role','system_users','system_login_log','system_operate_log','system_sms_code','system_sms_log','system_mail_log','system_notify_message','system_social_user','system_social_user_bind','system_oauth2_approve','system_oauth2_code','system_oauth2_refresh_token','system_oauth2_access_token','system_user_post','system_user_role','system_role_menu','infra_job_log','infra_job','infra_file_content','infra_file_config','infra_file','infra_data_source_config','infra_config','infra_codegen_table','infra_codegen_column','infra_api_error_log','infra_api_access_log','QRTZ_BLOB_TRIGGERS','QRTZ_CALENDARS','QRTZ_CRON_TRIGGERS','QRTZ_FIRED_TRIGGERS','QRTZ_JOB_DETAILS','QRTZ_LOCKS','QRTZ_PAUSED_TRIGGER_GRPS','QRTZ_SCHEDULER_STATE','QRTZ_SIMPLE_TRIGGERS','QRTZ_SIMPROP_TRIGGERS','QRTZ_TRIGGERS','ai_live_schema_version','ai_live_license_plan','ai_live_license','ai_live_edge_device','ai_live_license_activation_log','ai_live_speech_provider_config','ai_live_project','ai_live_scene','ai_live_asset','ai_live_voice_command','ai_live_command_action','ai_live_device_command','ai_live_command_execution_log')
GROUP BY table_name
ORDER BY table_name;

SELECT 'PASS：AI伴播完整独立基础数据库 V3 初始化完成，67 张表均包含显式字段定义' AS initialization_result;
