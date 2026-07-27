package cn.iocoder.yudao.module.ailive.controller.admin.device;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.ailive.controller.admin.device.vo.DevicePageReqVO;
import cn.iocoder.yudao.module.ailive.controller.admin.device.vo.DeviceRespVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.device.EdgeDeviceDO;
import cn.iocoder.yudao.module.ailive.service.device.EdgeDeviceService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@RestController
@RequestMapping("/ai-live/device")
public class EdgeDeviceController {
    @Resource private EdgeDeviceService service;
    @GetMapping("/get") @PreAuthorize("@ss.hasPermission('ai-live:device:query')") public CommonResult<DeviceRespVO> get(@RequestParam Long id) { return success(BeanUtils.toBean(service.get(id), DeviceRespVO.class)); }
    @GetMapping("/page") @PreAuthorize("@ss.hasPermission('ai-live:device:query')") public CommonResult<PageResult<DeviceRespVO>> page(DevicePageReqVO req) { PageResult<EdgeDeviceDO> page = service.getPage(req); return success(BeanUtils.toBean(page, DeviceRespVO.class)); }
    @PutMapping("/enable") @PreAuthorize("@ss.hasPermission('ai-live:device:change-status')") public CommonResult<Boolean> enable(@RequestParam Long id) { service.enable(id); return success(true); }
    @PutMapping("/disable") @PreAuthorize("@ss.hasPermission('ai-live:device:change-status')") public CommonResult<Boolean> disable(@RequestParam Long id, @RequestParam(required = false) String reason) { service.disable(id, reason); return success(true); }
    @PutMapping("/unbind") @PreAuthorize("@ss.hasPermission('ai-live:device:unbind')") public CommonResult<Boolean> unbind(@RequestParam Long id) { service.unbind(id); return success(true); }
}
