package cn.iocoder.yudao.module.ailive.enums.license;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum SdkCredentialModeEnum {
    CUSTOMER_MANAGED(1),
    PLATFORM_MANAGED(2);

    private final Integer value;

    public static boolean isValid(Integer value) {
        for (SdkCredentialModeEnum mode : values()) {
            if (mode.value.equals(value)) {
                return true;
            }
        }
        return false;
    }
}
