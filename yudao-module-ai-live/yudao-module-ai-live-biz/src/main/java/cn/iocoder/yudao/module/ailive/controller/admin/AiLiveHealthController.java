package cn.iocoder.yudao.module.ailive.controller.admin;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.tenant.core.aop.TenantIgnore;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.security.PermitAll;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@RestController
@RequestMapping("/ai-live")
public class AiLiveHealthController {

    @GetMapping("/health")
    @PermitAll
    @TenantIgnore
    public CommonResult<Map<String, Object>> health() {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("module", "ai-live");
        result.put("status", "UP");
        result.put("version", "V1");
        result.put("timestamp", Instant.now().toString());
        return success(result);
    }
}
