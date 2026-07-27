package cn.iocoder.yudao.module.ailive.dal.mysql.device;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.ailive.controller.admin.device.vo.DevicePageReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.device.EdgeDeviceDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface EdgeDeviceMapper extends BaseMapperX<EdgeDeviceDO> {
    default PageResult<EdgeDeviceDO> selectPage(DevicePageReqVO req) {
        return selectPage(req, new LambdaQueryWrapperX<EdgeDeviceDO>()
                .likeIfPresent(EdgeDeviceDO::getDeviceCode, req.getDeviceCode())
                .likeIfPresent(EdgeDeviceDO::getDeviceName, req.getDeviceName())
                .eqIfPresent(EdgeDeviceDO::getLicenseId, req.getLicenseId())
                .eqIfPresent(EdgeDeviceDO::getStatus, req.getStatus()).orderByDesc(EdgeDeviceDO::getId));
    }
}
