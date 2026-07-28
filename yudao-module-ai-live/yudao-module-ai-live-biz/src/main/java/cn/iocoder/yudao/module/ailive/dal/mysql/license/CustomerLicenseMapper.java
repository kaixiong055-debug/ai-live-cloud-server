package cn.iocoder.yudao.module.ailive.dal.mysql.license;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicensePageReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.CustomerLicenseDO;
import cn.iocoder.yudao.module.ailive.enums.license.CustomerLicenseStatusEnum;
import org.apache.ibatis.annotations.Mapper;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface CustomerLicenseMapper extends BaseMapperX<CustomerLicenseDO> {

    default PageResult<CustomerLicenseDO> selectPage(CustomerLicensePageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<CustomerLicenseDO>()
                .likeIfPresent(CustomerLicenseDO::getLicenseNo, reqVO.getLicenseNo())
                .likeIfPresent(CustomerLicenseDO::getCustomerName, reqVO.getCustomerName())
                .likeIfPresent(CustomerLicenseDO::getCustomerCode, reqVO.getCustomerCode())
                .eqIfPresent(CustomerLicenseDO::getPlanId, reqVO.getPlanId())
                .eqIfPresent(CustomerLicenseDO::getStatus, reqVO.getStatus())
                .orderByDesc(CustomerLicenseDO::getId));
    }

    default List<CustomerLicenseDO> selectLatest(Integer limit) {
        return selectList(new LambdaQueryWrapperX<CustomerLicenseDO>()
                .orderByDesc(CustomerLicenseDO::getId)
                .last("LIMIT " + limit));
    }

    default Long selectCountByStatus(Integer status) {
        return selectCount(new LambdaQueryWrapperX<CustomerLicenseDO>().eq(CustomerLicenseDO::getStatus, status));
    }

    default List<CustomerLicenseDO> selectExpiring(Integer limit) {
        return selectList(new LambdaQueryWrapperX<CustomerLicenseDO>()
                .eq(CustomerLicenseDO::getStatus, CustomerLicenseStatusEnum.ACTIVE.getValue())
                .between(CustomerLicenseDO::getExpireAt, LocalDateTime.now(), LocalDateTime.now().plusDays(30))
                .orderByAsc(CustomerLicenseDO::getExpireAt)
                .last("LIMIT " + limit));
    }
}
