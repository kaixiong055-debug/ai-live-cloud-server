package cn.iocoder.yudao.module.ailive.controller.admin.license.vo;
import lombok.Data; import javax.validation.constraints.*;
@Data public class CustomerLicenseSaveReqVO { private Long id; @NotNull private Long planId; @NotBlank @Size(max=100) private String customerName; @Size(max=64) private String customerCode; @NotNull @Min(1) private Integer maxDevices; @NotNull @Min(0) private Integer offlineGraceDays; @Size(max=500) private String remark; }
