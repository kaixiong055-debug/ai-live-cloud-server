package cn.iocoder.yudao.module.ailive.controller.admin;

import cn.iocoder.yudao.framework.tenant.core.aop.TenantIgnore;
import javax.annotation.security.PermitAll;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/ai-live")
public class AiLiveHealthController {
    @GetMapping("/health")
    @PermitAll
    @TenantIgnore
    public Map<String, Object> health() { Map<String, Object> result = new LinkedHashMap<>(); result.put("module", "ai-live"); result.put("status", "UP"); result.put("version", "0.1.0-SNAPSHOT"); result.put("timestamp", Instant.now().toString()); return result; }
}
