package cn.iocoder.yudao.module.ailive.enums.license;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CustomerLicenseStatusEnum {
    PENDING(0, "待激活"), ACTIVE(1, "有效"), EXPIRED(2, "已过期"), SUSPENDED(3, "已禁用");
    private final Integer value;
    private final String name;
}
