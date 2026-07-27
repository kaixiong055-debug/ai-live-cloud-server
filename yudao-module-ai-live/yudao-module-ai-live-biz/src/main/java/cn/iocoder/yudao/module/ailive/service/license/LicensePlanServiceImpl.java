package cn.iocoder.yudao.module.ailive.service.license;

import cn.iocoder.yudao.module.ailive.dal.dataobject.license.LicensePlanDO;
import cn.iocoder.yudao.module.ailive.dal.mysql.license.LicensePlanMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class LicensePlanServiceImpl implements LicensePlanService {
    @Resource
    private LicensePlanMapper mapper;

    public LicensePlanDO getLicensePlan(Long id) {
        return mapper.selectById(id);
    }

    public LicensePlanDO validateEnabledLicensePlan(Long id) {
        LicensePlanDO plan = getLicensePlan(id);
        if (plan == null) throw new IllegalArgumentException("License plan not found");
        if (!Integer.valueOf(0).equals(plan.getStatus())) throw new IllegalArgumentException("License plan disabled");
        return plan;
    }
}
