package cn.iocoder.yudao.module.ailive.controller.admin.device;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.ailive.controller.admin.device.vo.DevicePageReqVO;
import cn.iocoder.yudao.module.ailive.controller.admin.device.vo.DeviceRespVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.device.EdgeDeviceDO;
import cn.iocoder.yudao.module.ailive.service.device.EdgeDeviceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - AI 伴播边缘设备")
@RestController
@RequestMapping("/ai-live/device")
public class EdgeDeviceController {

    @Resource
    private EdgeDeviceService service;

    @GetMapping("/get")
    @Operation(summary = "获得边缘设备")
    @PreAuthorize("@ss.hasPermission('ai-live:device:query')")
    public CommonResult<DeviceRespVO> get(@RequestParam Long id) {
        return success(BeanUtils.toBean(service.get(id), DeviceRespVO.class));
    }

    @GetMapping("/page")
    @Operation(summary = "获得边缘设备分页")
    @PreAuthorize("@ss.hasPermission('ai-live:device:query')")
    public CommonResult<PageResult<DeviceRespVO>> page(DevicePageReqVO req) {
        PageResult<EdgeDeviceDO> page = service.getPage(req);
        return success(BeanUtils.toBean(page, DeviceRespVO.class));
    }

    @PutMapping("/enable")
    @Operation(summary = "启用边缘设备")
    @PreAuthorize("@ss.hasPermission('ai-live:device:change-status')")
    public CommonResult<Boolean> enable(@RequestParam Long id) {
        service.enable(id);
        return success(true);
    }

    @PutMapping("/disable")
    @Operation(summary = "禁用边缘设备")
    @PreAuthorize("@ss.hasPermission('ai-live:device:change-status')")
    public CommonResult<Boolean> disable(@RequestParam Long id, @RequestParam(required = false) String reason) {
        service.disable(id, reason);
        return success(true);
    }

    @PutMapping("/unbind")
    @Operation(summary = "解绑边缘设备")
    @PreAuthorize("@ss.hasPermission('ai-live:device:unbind')")
    public CommonResult<Boolean> unbind(@RequestParam Long id) {
        service.unbind(id);
        return success(true);
    }
}
