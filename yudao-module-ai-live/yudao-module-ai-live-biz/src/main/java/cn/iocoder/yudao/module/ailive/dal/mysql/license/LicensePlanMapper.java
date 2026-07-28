package cn.iocoder.yudao.module.ailive.dal.mysql.license;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.LicensePlanPageReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.LicensePlanDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LicensePlanMapper extends BaseMapperX<LicensePlanDO> {

    default LicensePlanDO selectByCode(String code) {
        return selectOne(LicensePlanDO::getCode, code);
    }

    default PageResult<LicensePlanDO> selectPage(LicensePlanPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<LicensePlanDO>()
                .likeIfPresent(LicensePlanDO::getName, reqVO.getName())
                .likeIfPresent(LicensePlanDO::getCode, reqVO.getCode())
                .eqIfPresent(LicensePlanDO::getLicenseType, reqVO.getLicenseType())
                .eqIfPresent(LicensePlanDO::getStatus, reqVO.getStatus())
                .orderByDesc(LicensePlanDO::getId));
    }
}
