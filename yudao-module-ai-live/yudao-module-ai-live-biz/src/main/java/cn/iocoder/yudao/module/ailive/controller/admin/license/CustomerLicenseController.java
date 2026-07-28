package cn.iocoder.yudao.module.ailive.controller.admin.license;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseCreateRespVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicensePageReqVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseRespVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseSaveReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.CustomerLicenseDO;
import cn.iocoder.yudao.module.ailive.service.license.CustomerLicenseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - AI 伴播客户授权")
@RestController
@RequestMapping("/ai-live/customer-license")
@Validated
public class CustomerLicenseController {

    @Resource
    private CustomerLicenseService service;

    @PostMapping("/create")
    @Operation(summary = "创建客户授权")
    @PreAuthorize("@ss.hasPermission('ai-live:customer-license:create')")
    public CommonResult<CustomerLicenseCreateRespVO> create(@Valid @RequestBody CustomerLicenseSaveReqVO req) {
        return success(service.create(req));
    }

    @PutMapping("/update")
    @Operation(summary = "修改客户授权")
    @PreAuthorize("@ss.hasPermission('ai-live:customer-license:update')")
    public CommonResult<Boolean> update(@Valid @RequestBody CustomerLicenseSaveReqVO req) {
        service.update(req);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除客户授权")
    @PreAuthorize("@ss.hasPermission('ai-live:customer-license:delete')")
    public CommonResult<Boolean> delete(@RequestParam Long id) {
        service.delete(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得客户授权")
    @PreAuthorize("@ss.hasPermission('ai-live:customer-license:query')")
    public CommonResult<CustomerLicenseRespVO> get(@RequestParam Long id) {
        return success(BeanUtils.toBean(service.get(id), CustomerLicenseRespVO.class));
    }

    @GetMapping("/page")
    @Operation(summary = "获得客户授权分页")
    @PreAuthorize("@ss.hasPermission('ai-live:customer-license:query')")
    public CommonResult<PageResult<CustomerLicenseRespVO>> page(CustomerLicensePageReqVO req) {
        PageResult<CustomerLicenseDO> page = service.getPage(req);
        return success(BeanUtils.toBean(page, CustomerLicenseRespVO.class));
    }

    @PutMapping("/activate")
    @Operation(summary = "启用或恢复客户授权")
    @PreAuthorize("@ss.hasPermission('ai-live:customer-license:change-status')")
    public CommonResult<Boolean> activate(@RequestParam Long id) {
        service.activate(id);
        return success(true);
    }

    @PutMapping("/suspend")
    @Operation(summary = "暂停客户授权")
    @PreAuthorize("@ss.hasPermission('ai-live:customer-license:change-status')")
    public CommonResult<Boolean> suspend(@RequestParam Long id) {
        service.suspend(id);
        return success(true);
    }

    @PutMapping("/revoke")
    @Operation(summary = "吊销客户授权")
    @PreAuthorize("@ss.hasPermission('ai-live:customer-license:change-status')")
    public CommonResult<Boolean> revoke(@RequestParam Long id) {
        service.revoke(id);
        return success(true);
    }
}
