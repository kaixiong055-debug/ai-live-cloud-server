package cn.iocoder.yudao.module.ailive.service.license;

import cn.iocoder.yudao.module.ailive.dal.dataobject.license.LicensePlanDO;

public interface LicensePlanService {
    LicensePlanDO getLicensePlan(Long id);

    LicensePlanDO validateEnabledLicensePlan(Long id);
}
