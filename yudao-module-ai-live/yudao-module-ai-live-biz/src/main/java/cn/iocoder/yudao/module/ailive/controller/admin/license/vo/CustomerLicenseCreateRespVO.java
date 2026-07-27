package cn.iocoder.yudao.module.ailive.controller.admin.license.vo;

import lombok.Data;

/** Plaintext key is returned here once only; persistent objects store a hash. */
@Data
public class CustomerLicenseCreateRespVO {
    private Long id;
    private String licenseKey;
}
