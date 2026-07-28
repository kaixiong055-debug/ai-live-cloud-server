package cn.iocoder.yudao.module.ailive.service.license;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.LicensePlanPageReqVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.LicensePlanSaveReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.LicensePlanDO;

import java.util.Collection;
import java.util.List;

public interface LicensePlanService {
    Long createLicensePlan(LicensePlanSaveReqVO reqVO);
    void updateLicensePlan(LicensePlanSaveReqVO reqVO);
    void deleteLicensePlan(Long id);
    PageResult<LicensePlanDO> getLicensePlanPage(LicensePlanPageReqVO reqVO);
    LicensePlanDO getLicensePlan(Long id);
    List<LicensePlanDO> getLicensePlanList(Collection<Long> ids);
    void changeStatus(Long id, Integer status);
    LicensePlanDO validateEnabledLicensePlan(Long id);
}
