package cn.iocoder.yudao.module.ailive.dal.dataobject.license;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@TableName("ai_live_license")
@Data
@EqualsAndHashCode(callSuper = true)
public class CustomerLicenseDO extends TenantBaseDO {
    @TableId
    private Long id;
    private String licenseNo;
    private String licenseKeyHash;
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
    private LocalDateTime lastVerifyTime;
    private String remark;
}
