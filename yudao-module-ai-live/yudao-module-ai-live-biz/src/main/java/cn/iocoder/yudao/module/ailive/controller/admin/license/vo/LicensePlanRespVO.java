package cn.iocoder.yudao.module.ailive.controller.admin.license.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 授权套餐 Response VO")
@Data
public class LicensePlanRespVO {
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
    private LocalDateTime createTime;
}
