package cn.iocoder.yudao.module.ailive.service.license;

import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseSaveReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.CustomerLicenseDO;
import cn.iocoder.yudao.module.ailive.dal.mysql.license.CustomerLicenseMapper;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.LicensePlanDO;
import cn.iocoder.yudao.module.ailive.enums.license.CustomerLicenseStatusEnum;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.security.SecureRandom;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

@Service
public class CustomerLicenseServiceImpl implements CustomerLicenseService {
    @Resource
    private CustomerLicenseMapper mapper;
    @Resource
    private LicensePlanService licensePlanService;

    public Long create(CustomerLicenseSaveReqVO req) {
        LicensePlanDO plan = licensePlanService.validateEnabledLicensePlan(req.getPlanId());
        CustomerLicenseDO d = BeanUtils.toBean(req, CustomerLicenseDO.class);
        d.setLicenseType(plan.getLicenseType());
        d.setSdkCredentialMode(plan.getDefaultSdkCredentialMode());
        d.setLicenseKey(hash(generateKey()));
        d.setStatus(CustomerLicenseStatusEnum.PENDING.getValue());
        d.setIssuedAt(LocalDateTime.now());
        mapper.insert(d);
        return d.getId();
    }

    private String generateKey() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        StringBuilder b = new StringBuilder();
        for (byte v : bytes) b.append(String.format("%02x", v));
        return b.toString();
    }

    private String hash(String value) {
        try {
            byte[] bytes = MessageDigest.getInstance("SHA-256").digest(value.getBytes(StandardCharsets.UTF_8));
            StringBuilder b = new StringBuilder();
            for (byte v : bytes) b.append(String.format("%02x", v));
            return b.toString();
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }

    public void update(CustomerLicenseSaveReqVO req) {
        CustomerLicenseDO old = get(req.getId());
        if (old == null) throw new IllegalArgumentException("Customer license not found");
        mapper.updateById(BeanUtils.toBean(req, CustomerLicenseDO.class));
    }

    public void delete(Long id) {
        if (get(id) == null) throw new IllegalArgumentException("Customer license not found");
        mapper.deleteById(id);
    }

    public CustomerLicenseDO get(Long id) {
        return mapper.selectById(id);
    }
}
