package cn.iocoder.yudao.module.ailive.dal.dataobject.device;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@TableName("ai_live_edge_device")
@Data
@EqualsAndHashCode(callSuper = true)
public class EdgeDeviceDO extends TenantBaseDO {
    @TableId private Long id;
    private String deviceCode;
    private Long licenseId;
    private String deviceName;
    private String machineFingerprintHash;
    private String osName;
    private String osVersion;
    private String agentVersion;
    private Integer status;
    private Integer bindingStatus;
    private LocalDateTime lastHeartbeatTime;
    private String lastIp;
    private LocalDateTime activatedAt;
    private String disabledReason;
}
