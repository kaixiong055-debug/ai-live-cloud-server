package cn.iocoder.yudao.module.ailive.controller.admin.license.vo;

import lombok.Data;
import java.time.LocalDateTime;

/** Intentionally excludes the persistent key hash. */
@Data
public class CustomerLicenseRespVO {
    private Long id;
    private Long planId;
    private String customerName;
    private String customerCode;
    private Integer licenseType;
    private Integer sdkCredentialMode;
    private Integer status;
    private Integer maxDevices;
    private Integer offlineGraceDays;
    private LocalDateTime issuedAt;
    private LocalDateTime activatedAt;
    private LocalDateTime expireAt;
    private String remark;
}
