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
import java.time.format.DateTimeFormatter;
import java.util.List;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.ailive.enums.ErrorCodeConstants.CUSTOMER_LICENSE_NOT_EXISTS;
import static cn.iocoder.yudao.module.ailive.enums.ErrorCodeConstants.CUSTOMER_LICENSE_STATUS_INVALID;

@Service
public class CustomerLicenseServiceImpl implements CustomerLicenseService {

    private static final SecureRandom SECURE_RANDOM = new SecureRandom();
    private static final DateTimeFormatter LICENSE_NO_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    @Resource
    private CustomerLicenseMapper mapper;
    @Resource
    private LicensePlanService licensePlanService;

    @Override
    public CustomerLicenseCreateRespVO create(CustomerLicenseSaveReqVO req) {
        LicensePlanDO plan = licensePlanService.validateEnabledLicensePlan(req.getPlanId());
        CustomerLicenseDO license = BeanUtils.toBean(req, CustomerLicenseDO.class);
        String key = generateKey();
        applyPlanSnapshot(license, plan, req);
        license.setLicenseNo(generateLicenseNo());
        license.setLicenseKeyHash(hash(key));
        license.setStatus(CustomerLicenseStatusEnum.PENDING.getValue());
        license.setBoundDeviceCount(0);
        license.setIssuedAt(LocalDateTime.now());
        mapper.insert(license);

        CustomerLicenseCreateRespVO response = new CustomerLicenseCreateRespVO();
        response.setId(license.getId());
        response.setLicenseKey(key);
        return response;
    }

    @Override
    public void update(CustomerLicenseSaveReqVO req) {
        CustomerLicenseDO old = required(req.getId());
        if (CustomerLicenseStatusEnum.REVOKED.getValue().equals(old.getStatus())) {
            throw exception(CUSTOMER_LICENSE_STATUS_INVALID);
        }
        LicensePlanDO plan = licensePlanService.validateEnabledLicensePlan(req.getPlanId());
        CustomerLicenseDO update = BeanUtils.toBean(req, CustomerLicenseDO.class);
        applyPlanSnapshot(update, plan, req);
        update.setStatus(null);
        update.setLicenseNo(null);
        update.setLicenseKeyHash(null);
        update.setBoundDeviceCount(null);
        update.setIssuedAt(null);
        update.setActivatedAt(null);
        mapper.updateById(update);
    }

    @Override
    public void delete(Long id) {
        required(id);
        mapper.deleteById(id);
    }

    @Override
    public CustomerLicenseDO get(Long id) {
        return mapper.selectById(id);
    }

    @Override
    public PageResult<CustomerLicenseDO> getPage(CustomerLicensePageReqVO req) {
        return mapper.selectPage(req);
    }

    @Override
    public List<CustomerLicenseDO> getLatest(Integer limit) {
        return mapper.selectLatest(limit == null ? 5 : limit);
    }

    @Override
    public List<CustomerLicenseDO> getExpiring(Integer limit) {
        return mapper.selectExpiring(limit == null ? 5 : limit);
    }

    @Override
    public void activate(Long id) {
        CustomerLicenseDO license = required(id);
        if (CustomerLicenseStatusEnum.PENDING.getValue().equals(license.getStatus())
                || CustomerLicenseStatusEnum.SUSPENDED.getValue().equals(license.getStatus())) {
            license.setStatus(CustomerLicenseStatusEnum.ACTIVE.getValue());
            if (license.getActivatedAt() == null) {
                license.setActivatedAt(LocalDateTime.now());
            }
            mapper.updateById(license);
            return;
        }
        throw exception(CUSTOMER_LICENSE_STATUS_INVALID);
    }

    @Override
    public void suspend(Long id) {
        change(id, CustomerLicenseStatusEnum.SUSPENDED, CustomerLicenseStatusEnum.ACTIVE);
    }

    @Override
    public void revoke(Long id) {
        change(id, CustomerLicenseStatusEnum.REVOKED, CustomerLicenseStatusEnum.ACTIVE, CustomerLicenseStatusEnum.SUSPENDED);
    }

    private void change(Long id, CustomerLicenseStatusEnum to, CustomerLicenseStatusEnum... from) {
        CustomerLicenseDO license = required(id);
        for (CustomerLicenseStatusEnum current : from) {
            if (current.getValue().equals(license.getStatus())) {
                license.setStatus(to.getValue());
                mapper.updateById(license);
                return;
            }
        }
        throw exception(CUSTOMER_LICENSE_STATUS_INVALID);
    }

    private CustomerLicenseDO required(Long id) {
        CustomerLicenseDO value = get(id);
        if (value == null) {
            throw exception(CUSTOMER_LICENSE_NOT_EXISTS);
        }
        return value;
    }

    private void applyPlanSnapshot(CustomerLicenseDO license, LicensePlanDO plan, CustomerLicenseSaveReqVO req) {
        license.setPlanNameSnapshot(plan.getName());
        license.setPlanCodeSnapshot(plan.getCode());
        license.setDurationDaysSnapshot(plan.getDurationDays());
        license.setLicenseType(plan.getLicenseType());
        license.setSdkCredentialMode(plan.getDefaultSdkCredentialMode());
        license.setMaxDevices(req.getMaxDevices() == null ? plan.getDeviceLimit() : req.getMaxDevices());
        license.setAllowOffline(req.getAllowOffline() == null ? Boolean.TRUE : req.getAllowOffline());
        license.setOfflineGraceDays(Boolean.TRUE.equals(license.getAllowOffline()) ? req.getOfflineGraceDays() : 0);
        LocalDateTime effectiveAt = req.getEffectiveAt() == null ? LocalDateTime.now() : req.getEffectiveAt();
        license.setEffectiveAt(effectiveAt);
        license.setExpireAt(LicenseTypeEnum.SUBSCRIPTION.getValue().equals(plan.getLicenseType())
                ? effectiveAt.plusDays(plan.getDurationDays()) : null);
    }

    private String generateLicenseNo() {
        return "LIC" + LocalDateTime.now().format(LICENSE_NO_FORMATTER) + randomHex(4).toUpperCase();
    }

    private String generateKey() {
        return "ailive_" + randomHex(32);
    }

    private String randomHex(int length) {
        byte[] bytes = new byte[length];
        SECURE_RANDOM.nextBytes(bytes);
        StringBuilder b = new StringBuilder();
        for (byte v : bytes) {
            b.append(String.format("%02x", v));
        }
        return b.toString();
    }

    private String hash(String value) {
        try {
            byte[] bytes = MessageDigest.getInstance("SHA-256").digest(value.getBytes(StandardCharsets.UTF_8));
            StringBuilder b = new StringBuilder();
            for (byte v : bytes) {
                b.append(String.format("%02x", v));
            }
            return b.toString();
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
}
