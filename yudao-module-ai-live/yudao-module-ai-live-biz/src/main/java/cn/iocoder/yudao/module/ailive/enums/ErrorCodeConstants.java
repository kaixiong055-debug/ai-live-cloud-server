package cn.iocoder.yudao.module.ailive.enums;

import cn.iocoder.yudao.framework.common.exception.ErrorCode;

/** AI Live module error codes. */
public interface ErrorCodeConstants {

    ErrorCode LICENSE_PLAN_NOT_EXISTS = new ErrorCode(1_015_000_000, "授权套餐不存在");
    ErrorCode LICENSE_PLAN_DISABLED = new ErrorCode(1_015_000_001, "授权套餐已停用");
    ErrorCode LICENSE_PLAN_CODE_DUPLICATE = new ErrorCode(1_015_000_002, "授权套餐编码已存在");
    ErrorCode LICENSE_PLAN_INVALID_DURATION = new ErrorCode(1_015_000_003, "授权套餐有效期配置不合法");
    ErrorCode CUSTOMER_LICENSE_NOT_EXISTS = new ErrorCode(1_015_001_000, "客户授权不存在");
    ErrorCode CUSTOMER_LICENSE_STATUS_INVALID = new ErrorCode(1_015_001_001, "当前授权状态不允许该操作");
}
