package cn.iocoder.yudao.module.ailive.service.license;

import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseSaveReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.CustomerLicenseDO;

public interface CustomerLicenseService {
    Long create(CustomerLicenseSaveReqVO req);

    void update(CustomerLicenseSaveReqVO req);

    void delete(Long id);

    CustomerLicenseDO get(Long id);
}
