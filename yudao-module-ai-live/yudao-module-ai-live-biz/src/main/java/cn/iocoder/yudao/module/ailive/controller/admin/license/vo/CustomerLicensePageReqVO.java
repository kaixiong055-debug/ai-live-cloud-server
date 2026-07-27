package cn.iocoder.yudao.module.ailive.controller.admin.license.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class CustomerLicensePageReqVO extends PageParam {
    private String customerName;
    private Integer status;
}
