package cn.iocoder.yudao.module.ailive.service.device;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.ailive.controller.admin.device.vo.DevicePageReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.device.EdgeDeviceDO;

public interface EdgeDeviceService {
    EdgeDeviceDO get(Long id);
    PageResult<EdgeDeviceDO> getPage(DevicePageReqVO req);
    void enable(Long id);
    void disable(Long id, String reason);
    void unbind(Long id);
}
