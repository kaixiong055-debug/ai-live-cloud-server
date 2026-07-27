package cn.iocoder.yudao.module.ailive.service.license;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseCreateRespVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicensePageReqVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseSaveReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.CustomerLicenseDO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.LicensePlanDO;
import cn.iocoder.yudao.module.ailive.dal.mysql.license.CustomerLicenseMapper;
import cn.iocoder.yudao.module.ailive.enums.license.CustomerLicenseStatusEnum;
import cn.iocoder.yudao.module.ailive.enums.license.LicenseTypeEnum;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.LocalDateTime;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.ailive.enums.ErrorCodeConstants.CUSTOMER_LICENSE_NOT_EXISTS;
import static cn.iocoder.yudao.module.ailive.enums.ErrorCodeConstants.CUSTOMER_LICENSE_STATUS_INVALID;

@Service
public class CustomerLicenseServiceImpl implements CustomerLicenseService {
    @Resource private CustomerLicenseMapper mapper;
    @Resource private LicensePlanService licensePlanService;

    @Override public CustomerLicenseCreateRespVO create(CustomerLicenseSaveReqVO req) {
        LicensePlanDO plan = licensePlanService.validateEnabledLicensePlan(req.getPlanId());
        CustomerLicenseDO license = BeanUtils.toBean(req, CustomerLicenseDO.class);
        String key = generateKey();
        applyPlanSnapshot(license, plan);
        license.setLicenseKey(hash(key));
        license.setStatus(CustomerLicenseStatusEnum.PENDING.getValue());
        license.setIssuedAt(LocalDateTime.now());
        mapper.insert(license);
        CustomerLicenseCreateRespVO response = new CustomerLicenseCreateRespVO();
        response.setId(license.getId()); response.setLicenseKey(key);
        return response;
    }
    @Override public void update(CustomerLicenseSaveReqVO req) {
        CustomerLicenseDO old = required(req.getId());
        if (CustomerLicenseStatusEnum.REVOKED.getValue().equals(old.getStatus())) throw exception(CUSTOMER_LICENSE_STATUS_INVALID);
        LicensePlanDO plan = licensePlanService.validateEnabledLicensePlan(req.getPlanId());
        CustomerLicenseDO update = BeanUtils.toBean(req, CustomerLicenseDO.class);
        applyPlanSnapshot(update, plan); update.setStatus(null); update.setLicenseKey(null); update.setIssuedAt(null);
        mapper.updateById(update);
    }
    @Override public void delete(Long id) { required(id); mapper.deleteById(id); }
    @Override public CustomerLicenseDO get(Long id) { return mapper.selectById(id); }
    @Override public PageResult<CustomerLicenseDO> getPage(CustomerLicensePageReqVO req) { return mapper.selectPage(req); }
    @Override public void activate(Long id) { change(id, CustomerLicenseStatusEnum.ACTIVE, CustomerLicenseStatusEnum.PENDING, CustomerLicenseStatusEnum.PAUSED); }
    @Override public void pause(Long id) { change(id, CustomerLicenseStatusEnum.PAUSED, CustomerLicenseStatusEnum.ACTIVE); }
    @Override public void revoke(Long id) { change(id, CustomerLicenseStatusEnum.REVOKED, CustomerLicenseStatusEnum.PENDING, CustomerLicenseStatusEnum.ACTIVE, CustomerLicenseStatusEnum.PAUSED); }
    private void change(Long id, CustomerLicenseStatusEnum to, CustomerLicenseStatusEnum... from) {
        CustomerLicenseDO license = required(id);
        for (CustomerLicenseStatusEnum current : from) if (current.getValue().equals(license.getStatus())) { license.setStatus(to.getValue()); mapper.updateById(license); return; }
        throw exception(CUSTOMER_LICENSE_STATUS_INVALID);
    }
    private CustomerLicenseDO required(Long id) { CustomerLicenseDO value = get(id); if (value == null) throw exception(CUSTOMER_LICENSE_NOT_EXISTS); return value; }
    private void applyPlanSnapshot(CustomerLicenseDO license, LicensePlanDO plan) {
        license.setLicenseType(plan.getLicenseType()); license.setSdkCredentialMode(plan.getDefaultSdkCredentialMode());
        license.setMaxDevices(plan.getDeviceLimit()); license.setOfflineGraceDays(plan.getOfflineGraceDays());
        license.setExpireAt(LicenseTypeEnum.SUBSCRIPTION.getValue().equals(plan.getLicenseType()) ? LocalDateTime.now().plusDays(plan.getDurationDays()) : null);
    }
    private String generateKey() { byte[] bytes = new byte[32]; new SecureRandom().nextBytes(bytes); StringBuilder b = new StringBuilder(); for (byte v : bytes) b.append(String.format("%02x", v)); return b.toString(); }
    private String hash(String value) { try { byte[] bytes = MessageDigest.getInstance("SHA-256").digest(value.getBytes(StandardCharsets.UTF_8)); StringBuilder b = new StringBuilder(); for (byte v : bytes) b.append(String.format("%02x", v)); return b.toString(); } catch (Exception e) { throw new IllegalStateException(e); } }
}
