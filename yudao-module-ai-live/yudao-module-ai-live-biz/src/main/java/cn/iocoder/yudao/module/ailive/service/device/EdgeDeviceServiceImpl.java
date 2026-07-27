package cn.iocoder.yudao.module.ailive.service.device;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.ailive.controller.admin.device.vo.DevicePageReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.device.EdgeDeviceDO;
import cn.iocoder.yudao.module.ailive.dal.mysql.device.EdgeDeviceMapper;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.ailive.enums.ErrorCodeConstants.DEVICE_NOT_EXISTS;

@Service
public class EdgeDeviceServiceImpl implements EdgeDeviceService {
    private static final int OFFLINE = 0, DISABLED = 2, UNBOUND = 0;
    @Resource private EdgeDeviceMapper mapper;
    @Override public EdgeDeviceDO get(Long id) { return mapper.selectById(id); }
    @Override public PageResult<EdgeDeviceDO> getPage(DevicePageReqVO req) { return mapper.selectPage(req); }
    @Override public void enable(Long id) { EdgeDeviceDO d = required(id); d.setStatus(OFFLINE); d.setDisabledReason(""); mapper.updateById(d); }
    @Override public void disable(Long id, String reason) { EdgeDeviceDO d = required(id); d.setStatus(DISABLED); d.setDisabledReason(reason == null ? "" : reason); mapper.updateById(d); }
    @Override public void unbind(Long id) { EdgeDeviceDO d = required(id); d.setLicenseId(null); d.setBindingStatus(UNBOUND); mapper.updateById(d); }
    private EdgeDeviceDO required(Long id) { EdgeDeviceDO d = get(id); if (d == null) throw exception(DEVICE_NOT_EXISTS); return d; }
}
