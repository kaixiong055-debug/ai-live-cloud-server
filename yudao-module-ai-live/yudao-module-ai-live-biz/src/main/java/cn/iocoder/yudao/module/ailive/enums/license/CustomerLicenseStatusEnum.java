package cn.iocoder.yudao.module.ailive.enums.license;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CustomerLicenseStatusEnum {
    PENDING(0, "待激活"),
    ACTIVE(1, "已启用"),
    PAUSED(2, "已暂停"),
    REVOKED(3, "已吊销"),
    EXPIRED(4, "已过期");

    private final Integer value;
    private final String name;
}
