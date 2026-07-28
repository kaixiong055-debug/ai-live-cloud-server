package cn.iocoder.yudao.module.ailive.enums.license;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CustomerLicenseStatusEnum {
    PENDING(0, "待生效"),
    ACTIVE(1, "正常"),
    SUSPENDED(2, "已暂停"),
    REVOKED(3, "已吊销"),
    EXPIRED(4, "已到期");

    private final Integer value;
    private final String name;
}
