-- AI Live Cloud Platform admin V1 incremental SQL.
-- Compatible with Aurora MySQL 5.7.44. Do not run 01_ai_live_base_v1.sql on an existing database.

ALTER TABLE `ai_live_license`
  ADD COLUMN `license_no` varchar(64) NULL COMMENT '授权编号' AFTER `id`,
  ADD COLUMN `license_key_hash` varchar(128) NULL COMMENT '授权密钥哈希' AFTER `license_key`,
  ADD COLUMN `customer_contact` varchar(100) NOT NULL DEFAULT '' COMMENT '客户联系方式' AFTER `customer_code`,
  ADD COLUMN `plan_name_snapshot` varchar(100) NOT NULL DEFAULT '' COMMENT '套餐名称快照' AFTER `plan_id`,
  ADD COLUMN `plan_code_snapshot` varchar(64) NOT NULL DEFAULT '' COMMENT '套餐编码快照' AFTER `plan_name_snapshot`,
  ADD COLUMN `duration_days_snapshot` int NOT NULL DEFAULT 0 COMMENT '套餐有效天数快照' AFTER `plan_code_snapshot`,
  ADD COLUMN `bound_device_count` int NOT NULL DEFAULT 0 COMMENT '已绑定设备数量' AFTER `max_devices`,
  ADD COLUMN `effective_at` datetime NULL DEFAULT NULL COMMENT '生效时间' AFTER `bound_device_count`,
  ADD COLUMN `allow_offline` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否允许离线' AFTER `effective_at`;

ALTER TABLE `ai_live_license`
  MODIFY COLUMN `license_key` varchar(128) NULL DEFAULT NULL COMMENT '旧授权码字段，V1不再写入明文',
  MODIFY COLUMN `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0待生效 1正常 2已暂停 3已吊销 4已到期';

ALTER TABLE `ai_live_license`
  ADD UNIQUE KEY `uk_tenant_license_no` (`tenant_id`,`license_no`),
  ADD UNIQUE KEY `uk_license_key_hash` (`license_key_hash`),
  ADD KEY `idx_license_plan_status` (`tenant_id`,`plan_id`,`status`);

UPDATE `ai_live_license`
SET `license_no` = CONCAT('LEGACY', `id`)
WHERE `license_no` IS NULL OR `license_no` = '';

UPDATE `ai_live_license` l
LEFT JOIN `ai_live_license_plan` p ON p.id = l.plan_id AND p.tenant_id = l.tenant_id
SET l.plan_name_snapshot = IFNULL(p.name, ''),
    l.plan_code_snapshot = IFNULL(p.code, ''),
    l.duration_days_snapshot = IFNULL(p.duration_days, 0),
    l.bound_device_count = IFNULL(l.bound_device_count, 0),
    l.effective_at = IFNULL(l.effective_at, l.issued_at),
    l.allow_offline = b'1'
WHERE l.plan_name_snapshot = '' OR l.effective_at IS NULL;

INSERT IGNORE INTO `system_dict_type`
(`id`,`name`,`type`,`status`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`,`tenant_id`)
VALUES
(101,'SDK凭证模式','ai_live_sdk_credential_mode',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(102,'客户授权状态','ai_live_customer_license_status',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(103,'边缘设备状态','ai_live_device_status',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL),
(104,'边缘设备绑定状态','ai_live_device_binding_status',0,NULL,'system',NOW(),'system',NOW(),b'0',NULL);

INSERT IGNORE INTO `system_dict_data`
(`id`,`sort`,`label`,`value`,`dict_type`,`status`,`color_type`,`css_class`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(17,1,'客户自有','1','ai_live_sdk_credential_mode',0,'primary','',NULL,'system',NOW(),'system',NOW(),b'0'),
(18,2,'平台托管','2','ai_live_sdk_credential_mode',0,'success','',NULL,'system',NOW(),'system',NOW(),b'0'),
(19,1,'待生效','0','ai_live_customer_license_status',0,'warning','',NULL,'system',NOW(),'system',NOW(),b'0'),
(20,2,'正常','1','ai_live_customer_license_status',0,'success','',NULL,'system',NOW(),'system',NOW(),b'0'),
(21,3,'已暂停','2','ai_live_customer_license_status',0,'warning','',NULL,'system',NOW(),'system',NOW(),b'0'),
(22,4,'已吊销','3','ai_live_customer_license_status',0,'danger','',NULL,'system',NOW(),'system',NOW(),b'0'),
(23,5,'已到期','4','ai_live_customer_license_status',0,'info','',NULL,'system',NOW(),'system',NOW(),b'0'),
(24,1,'离线','0','ai_live_device_status',0,'info','',NULL,'system',NOW(),'system',NOW(),b'0'),
(25,2,'在线','1','ai_live_device_status',0,'success','',NULL,'system',NOW(),'system',NOW(),b'0'),
(26,3,'禁用','2','ai_live_device_status',0,'danger','',NULL,'system',NOW(),'system',NOW(),b'0'),
(27,1,'未绑定','0','ai_live_device_binding_status',0,'info','',NULL,'system',NOW(),'system',NOW(),b'0'),
(28,2,'已绑定','1','ai_live_device_binding_status',0,'success','',NULL,'system',NOW(),'system',NOW(),b'0');

UPDATE `system_menu`
SET `name` = 'AI 伴播云平台', `path` = 'ai-live', `icon` = 'ep:monitor', `visible` = b'1'
WHERE `id` = 7000;

UPDATE `system_menu`
SET `permission` = 'ai-live:license-plan:query', `component` = 'ai-live/license-plan/index', `visible` = b'1'
WHERE `id` = 7001;

UPDATE `system_menu`
SET `name` = '客户授权', `permission` = 'ai-live:customer-license:query', `component` = 'ai-live/license/index', `visible` = b'1'
WHERE `id` = 7002;

UPDATE `system_menu`
SET `permission` = 'ai-live:device:query', `component` = 'ai-live/device/index', `visible` = b'1'
WHERE `id` = 7003;

UPDATE `system_menu`
SET `visible` = b'0'
WHERE `id` IN (7004,7005,7006,7007);

INSERT IGNORE INTO `system_menu`
(`id`,`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(7008,'平台概览','ai-live:dashboard:query',2,0,7000,'dashboard','ep:odometer','ai-live/dashboard/index','AiLiveDashboard',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7011,'套餐查询','ai-live:license-plan:query',3,1,7001,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7012,'套餐创建','ai-live:license-plan:create',3,2,7001,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7013,'套餐修改','ai-live:license-plan:update',3,3,7001,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7014,'套餐删除','ai-live:license-plan:delete',3,4,7001,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7015,'套餐启停','ai-live:license-plan:change-status',3,5,7001,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7021,'授权查询','ai-live:customer-license:query',3,1,7002,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7022,'授权创建','ai-live:customer-license:create',3,2,7002,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7023,'授权修改','ai-live:customer-license:update',3,3,7002,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7024,'授权删除','ai-live:customer-license:delete',3,4,7002,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7025,'授权状态变更','ai-live:customer-license:change-status',3,5,7002,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7031,'设备查询','ai-live:device:query',3,1,7003,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7032,'设备修改','ai-live:device:update',3,2,7003,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7033,'设备状态变更','ai-live:device:change-status',3,3,7003,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0'),
(7034,'设备解绑','ai-live:device:unbind',3,4,7003,'','','','',0,b'1',b'1',b'1','system',NOW(),'system',NOW(),b'0');

INSERT IGNORE INTO `system_role_menu`
(`role_id`,`menu_id`,`creator`,`create_time`,`updater`,`update_time`,`deleted`,`tenant_id`)
SELECT r.id, m.id, 'system', NOW(), 'system', NOW(), b'0', r.tenant_id
FROM `system_role` r
JOIN `system_menu` m ON m.id IN (7000,7001,7002,7003,7008,7011,7012,7013,7014,7015,7021,7022,7023,7024,7025,7031,7032,7033,7034)
WHERE r.code = 'super_admin';
