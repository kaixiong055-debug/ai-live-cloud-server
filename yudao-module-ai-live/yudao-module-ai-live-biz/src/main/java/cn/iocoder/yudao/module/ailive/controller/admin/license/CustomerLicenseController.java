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
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@RestController
@RequestMapping("/ai-live/customer-license")
@Validated
public class CustomerLicenseController {
    @Resource private CustomerLicenseService service;
    @PostMapping("/create") @PreAuthorize("@ss.hasPermission('ai-live:license:create')") public CommonResult<CustomerLicenseCreateRespVO> create(@Valid @RequestBody CustomerLicenseSaveReqVO req){ return success(service.create(req)); }
    @PutMapping("/update") @PreAuthorize("@ss.hasPermission('ai-live:license:update')") public CommonResult<Boolean> update(@Valid @RequestBody CustomerLicenseSaveReqVO req){ service.update(req); return success(true); }
    @DeleteMapping("/delete") @PreAuthorize("@ss.hasPermission('ai-live:license:delete')") public CommonResult<Boolean> delete(@RequestParam Long id){ service.delete(id); return success(true); }
    @GetMapping("/get") @PreAuthorize("@ss.hasPermission('ai-live:license:query')") public CommonResult<CustomerLicenseRespVO> get(@RequestParam Long id){ return success(BeanUtils.toBean(service.get(id), CustomerLicenseRespVO.class)); }
    @GetMapping("/page") @PreAuthorize("@ss.hasPermission('ai-live:license:query')") public CommonResult<PageResult<CustomerLicenseRespVO>> page(CustomerLicensePageReqVO req){ PageResult<CustomerLicenseDO> page = service.getPage(req); return success(BeanUtils.toBean(page, CustomerLicenseRespVO.class)); }
    @PutMapping("/activate") @PreAuthorize("@ss.hasPermission('ai-live:license:update')") public CommonResult<Boolean> activate(@RequestParam Long id){ service.activate(id); return success(true); }
    @PutMapping("/pause") @PreAuthorize("@ss.hasPermission('ai-live:license:update')") public CommonResult<Boolean> pause(@RequestParam Long id){ service.pause(id); return success(true); }
    @PutMapping("/revoke") @PreAuthorize("@ss.hasPermission('ai-live:license:update')") public CommonResult<Boolean> revoke(@RequestParam Long id){ service.revoke(id); return success(true); }
}
