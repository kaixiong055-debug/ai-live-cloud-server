package cn.iocoder.yudao.module.ailive.controller.admin.dashboard;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.ailive.controller.admin.dashboard.vo.AiLiveDashboardSummaryRespVO;
import cn.iocoder.yudao.module.ailive.service.dashboard.AiLiveDashboardService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - AI 伴播平台概览")
@RestController
@RequestMapping("/ai-live/dashboard")
public class AiLiveDashboardController {

    @Resource
    private AiLiveDashboardService dashboardService;

    @GetMapping("/summary")
    @Operation(summary = "获得平台概览汇总")
    @PreAuthorize("@ss.hasPermission('ai-live:dashboard:query')")
    public CommonResult<AiLiveDashboardSummaryRespVO> summary() {
        return success(dashboardService.getSummary());
    }
}
