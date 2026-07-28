package cn.iocoder.yudao.module.ailive.service.license;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseCreateRespVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicensePageReqVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseSaveReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.CustomerLicenseDO;

import java.util.List;

public interface CustomerLicenseService {
    CustomerLicenseCreateRespVO create(CustomerLicenseSaveReqVO req);
    void update(CustomerLicenseSaveReqVO req);
    void delete(Long id);
    CustomerLicenseDO get(Long id);
    PageResult<CustomerLicenseDO> getPage(CustomerLicensePageReqVO req);
    List<CustomerLicenseDO> getLatest(Integer limit);
    List<CustomerLicenseDO> getExpiring(Integer limit);
    void activate(Long id);
    void suspend(Long id);
    void revoke(Long id);
}
