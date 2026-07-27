package cn.iocoder.yudao.module.ailive.controller.admin.license.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Schema(description = "管理后台 - 授权套餐新增/修改 Request VO")
@Data
public class LicensePlanSaveReqVO {

    private Long id;
    @NotBlank @Size(max = 100) private String name;
    @NotBlank @Size(max = 64) private String code;
    @NotNull private Integer licenseType;
    @NotNull @Min(0) private Integer durationDays;
    @NotNull @Min(1) private Integer deviceLimit;
    @NotNull @Min(0) private Integer offlineGraceDays;
    @NotNull private Integer defaultSdkCredentialMode;
    @NotNull private Integer status;
    @Size(max = 500) private String remark;
}
