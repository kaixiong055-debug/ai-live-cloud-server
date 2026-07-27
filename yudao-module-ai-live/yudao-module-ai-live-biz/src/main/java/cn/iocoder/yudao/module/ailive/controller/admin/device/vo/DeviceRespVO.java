package cn.iocoder.yudao.module.ailive.controller.admin.device.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class DeviceRespVO {
    private Long id; private String deviceCode; private Long licenseId; private String deviceName;
    private String machineFingerprintHash; private String osName; private String osVersion; private String agentVersion;
    private Integer status; private Integer bindingStatus; private LocalDateTime lastHeartbeatTime;
    private String lastIp; private LocalDateTime activatedAt; private String disabledReason; private LocalDateTime createTime;
}
