package cn.iocoder.yudao.module.ailive.controller.admin.license.vo;

import lombok.Data;

import java.time.LocalDateTime;

/** Intentionally excludes the persistent key hash. */
@Data
public class CustomerLicenseRespVO {
    private Long id;
    private String licenseNo;
    private Long planId;
    private String planNameSnapshot;
    private String planCodeSnapshot;
    private Integer durationDaysSnapshot;
    private String customerName;
    private String customerCode;
    private String customerContact;
    private Integer licenseType;
    private Integer sdkCredentialMode;
    private Integer status;
    private Integer maxDevices;
    private Integer boundDeviceCount;
    private Boolean allowOffline;
    private Integer offlineGraceDays;
    private LocalDateTime effectiveAt;
    private LocalDateTime issuedAt;
    private LocalDateTime activatedAt;
    private LocalDateTime expireAt;
    private LocalDateTime createTime;
    private String remark;
}
