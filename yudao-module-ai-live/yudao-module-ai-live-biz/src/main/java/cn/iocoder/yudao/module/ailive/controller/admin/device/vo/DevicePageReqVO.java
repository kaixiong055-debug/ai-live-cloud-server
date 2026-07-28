package cn.iocoder.yudao.module.ailive.controller.admin.device.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class DevicePageReqVO extends PageParam {
    private String deviceCode;
    private String deviceName;
    private Long licenseId;
    private String licenseNo;
    private Integer status;
}
