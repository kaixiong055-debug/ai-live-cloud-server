package cn.iocoder.yudao.module.ailive.dal.dataobject.license;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@TableName("ai_live_license_plan")
@Data
@EqualsAndHashCode(callSuper = true)
public class LicensePlanDO extends TenantBaseDO {
    @TableId
    private Long id;
    private String name;
    private String code;
    private Integer licenseType;
    private Integer durationDays;
    private Integer deviceLimit;
    private Integer offlineGraceDays;
    private Integer defaultSdkCredentialMode;
    private Integer status;
    private String remark;
}
