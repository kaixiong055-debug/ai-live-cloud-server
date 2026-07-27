package cn.iocoder.yudao.module.ailive.enums.license;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum LicenseTypeEnum {
    PERPETUAL(1),
    SUBSCRIPTION(2);

    private final Integer value;

    public static boolean isValid(Integer value) {
        for (LicenseTypeEnum type : values()) {
            if (type.value.equals(value)) {
                return true;
            }
        }
        return false;
    }
}
