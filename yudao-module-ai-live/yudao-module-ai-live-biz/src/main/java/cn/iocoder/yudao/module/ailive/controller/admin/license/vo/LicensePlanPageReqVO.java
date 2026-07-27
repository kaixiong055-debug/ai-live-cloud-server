package cn.iocoder.yudao.module.ailive.controller.admin.license.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class LicensePlanPageReqVO extends PageParam {
    private String name;
    private String code;
    private Integer status;
}
