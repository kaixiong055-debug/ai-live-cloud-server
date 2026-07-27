package cn.iocoder.yudao.module.ailive.service.license;

import cn.iocoder.yudao.module.ailive.dal.dataobject.license.LicensePlanDO;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.LicensePlanPageReqVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.LicensePlanSaveReqVO;

public interface LicensePlanService {
    Long createLicensePlan(LicensePlanSaveReqVO reqVO);
    void updateLicensePlan(LicensePlanSaveReqVO reqVO);
    void deleteLicensePlan(Long id);
    PageResult<LicensePlanDO> getLicensePlanPage(LicensePlanPageReqVO reqVO);
    LicensePlanDO getLicensePlan(Long id);
    LicensePlanDO validateEnabledLicensePlan(Long id);
}
