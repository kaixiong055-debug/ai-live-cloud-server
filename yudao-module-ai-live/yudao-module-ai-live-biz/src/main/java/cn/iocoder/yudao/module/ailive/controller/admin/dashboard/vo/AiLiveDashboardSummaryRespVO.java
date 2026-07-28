package cn.iocoder.yudao.module.ailive.controller.admin.dashboard.vo;

import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseRespVO;
import lombok.Data;

import java.util.List;

@Data
public class AiLiveDashboardSummaryRespVO {
    private String serviceStatus;
    private String version;
    private String databaseStatus;
    private String redisStatus;
    private Long licensePlanCount;
    private Long customerLicenseCount;
    private Long activeLicenseCount;
    private Long pendingLicenseCount;
    private Long suspendedLicenseCount;
    private Long revokedLicenseCount;
    private Long registeredDeviceCount;
    private Long onlineDeviceCount;
    private List<CustomerLicenseRespVO> recentLicenses;
    private List<CustomerLicenseRespVO> expiringLicenses;
}
