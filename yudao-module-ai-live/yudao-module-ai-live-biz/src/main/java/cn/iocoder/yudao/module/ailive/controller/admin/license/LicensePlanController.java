package cn.iocoder.yudao.module.ailive.controller.admin.license;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.LicensePlanPageReqVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.LicensePlanRespVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.LicensePlanSaveReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.LicensePlanDO;
import cn.iocoder.yudao.module.ailive.service.license.LicensePlanService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - AI 伴播授权套餐")
@RestController
@RequestMapping("/ai-live/license-plan")
@Validated
public class LicensePlanController {

    @Resource
    private LicensePlanService licensePlanService;

    @PostMapping("/create")
    @Operation(summary = "创建授权套餐")
    @PreAuthorize("@ss.hasPermission('ai-live:license-plan:create')")
    public CommonResult<Long> create(@Valid @RequestBody LicensePlanSaveReqVO reqVO) {
        return success(licensePlanService.createLicensePlan(reqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "修改授权套餐")
    @PreAuthorize("@ss.hasPermission('ai-live:license-plan:update')")
    public CommonResult<Boolean> update(@Valid @RequestBody LicensePlanSaveReqVO reqVO) {
        licensePlanService.updateLicensePlan(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除授权套餐")
    @PreAuthorize("@ss.hasPermission('ai-live:license-plan:delete')")
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        licensePlanService.deleteLicensePlan(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得授权套餐")
    @PreAuthorize("@ss.hasPermission('ai-live:license-plan:query')")
    public CommonResult<LicensePlanRespVO> get(@RequestParam("id") Long id) {
        return success(BeanUtils.toBean(licensePlanService.getLicensePlan(id), LicensePlanRespVO.class));
    }

    @GetMapping("/page")
    @Operation(summary = "获得授权套餐分页")
    @PreAuthorize("@ss.hasPermission('ai-live:license-plan:query')")
    public CommonResult<PageResult<LicensePlanRespVO>> page(@Validated LicensePlanPageReqVO reqVO) {
        PageResult<LicensePlanDO> page = licensePlanService.getLicensePlanPage(reqVO);
        return success(BeanUtils.toBean(page, LicensePlanRespVO.class));
    }
}
