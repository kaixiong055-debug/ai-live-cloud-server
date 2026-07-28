package cn.iocoder.yudao.module.ailive.service.dashboard;

import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.ailive.controller.admin.dashboard.vo.AiLiveDashboardSummaryRespVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseRespVO;
import cn.iocoder.yudao.module.ailive.dal.mysql.device.EdgeDeviceMapper;
import cn.iocoder.yudao.module.ailive.dal.mysql.license.CustomerLicenseMapper;
import cn.iocoder.yudao.module.ailive.dal.mysql.license.LicensePlanMapper;
import cn.iocoder.yudao.module.ailive.enums.license.CustomerLicenseStatusEnum;
import org.springframework.data.redis.connection.RedisConnection;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.sql.DataSource;
import java.sql.Connection;

@Service
public class AiLiveDashboardServiceImpl implements AiLiveDashboardService {

    @Resource
    private LicensePlanMapper licensePlanMapper;
    @Resource
    private CustomerLicenseMapper customerLicenseMapper;
    @Resource
    private EdgeDeviceMapper edgeDeviceMapper;
    @Resource
    private DataSource dataSource;
    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Override
    public AiLiveDashboardSummaryRespVO getSummary() {
        AiLiveDashboardSummaryRespVO summary = new AiLiveDashboardSummaryRespVO();
        summary.setServiceStatus("UP");
        summary.setVersion("V1");
        summary.setDatabaseStatus(checkDatabase());
        summary.setRedisStatus(checkRedis());
        summary.setLicensePlanCount(licensePlanMapper.selectCount());
        summary.setCustomerLicenseCount(customerLicenseMapper.selectCount());
        summary.setActiveLicenseCount(customerLicenseMapper.selectCountByStatus(CustomerLicenseStatusEnum.ACTIVE.getValue()));
        summary.setPendingLicenseCount(customerLicenseMapper.selectCountByStatus(CustomerLicenseStatusEnum.PENDING.getValue()));
        summary.setSuspendedLicenseCount(customerLicenseMapper.selectCountByStatus(CustomerLicenseStatusEnum.SUSPENDED.getValue()));
        summary.setRevokedLicenseCount(customerLicenseMapper.selectCountByStatus(CustomerLicenseStatusEnum.REVOKED.getValue()));
        summary.setRegisteredDeviceCount(edgeDeviceMapper.selectCount());
        summary.setOnlineDeviceCount(edgeDeviceMapper.selectOnlineCount());
        summary.setRecentLicenses(BeanUtils.toBean(customerLicenseMapper.selectLatest(5), CustomerLicenseRespVO.class));
        summary.setExpiringLicenses(BeanUtils.toBean(customerLicenseMapper.selectExpiring(5), CustomerLicenseRespVO.class));
        return summary;
    }

    private String checkDatabase() {
        try (Connection ignored = dataSource.getConnection()) {
            return "UP";
        } catch (Exception e) {
            return "DOWN";
        }
    }

    private String checkRedis() {
        try (RedisConnection connection = stringRedisTemplate.getConnectionFactory().getConnection()) {
            return Boolean.TRUE.equals(connection.ping() != null) ? "UP" : "DOWN";
        } catch (Exception e) {
            return "DOWN";
        }
    }
}
