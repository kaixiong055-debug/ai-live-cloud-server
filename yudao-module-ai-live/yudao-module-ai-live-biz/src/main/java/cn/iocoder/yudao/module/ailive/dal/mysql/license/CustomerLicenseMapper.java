package cn.iocoder.yudao.module.ailive.dal.mysql.license;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicensePageReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.CustomerLicenseDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CustomerLicenseMapper extends BaseMapperX<CustomerLicenseDO> {
    default PageResult<CustomerLicenseDO> selectPage(CustomerLicensePageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<CustomerLicenseDO>()
                .likeIfPresent(CustomerLicenseDO::getCustomerName, reqVO.getCustomerName())
                .eqIfPresent(CustomerLicenseDO::getStatus, reqVO.getStatus())
                .orderByDesc(CustomerLicenseDO::getId));
    }
}
