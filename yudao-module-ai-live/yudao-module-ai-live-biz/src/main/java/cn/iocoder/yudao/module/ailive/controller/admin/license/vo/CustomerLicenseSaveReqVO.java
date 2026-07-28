package cn.iocoder.yudao.module.ailive.controller.admin.license.vo;

import lombok.Data;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;

@Data
public class CustomerLicenseSaveReqVO {
    private Long id;
    @NotNull private Long planId;
    @NotBlank @Size(max = 100) private String customerName;
    @NotBlank @Size(max = 64) private String customerCode;
    @Size(max = 100) private String customerContact;
    @NotNull private LocalDateTime effectiveAt;
    @NotNull @Min(1) private Integer maxDevices;
    private Boolean allowOffline;
    @NotNull @Min(0) private Integer offlineGraceDays;
    @Size(max = 500) private String remark;
}
