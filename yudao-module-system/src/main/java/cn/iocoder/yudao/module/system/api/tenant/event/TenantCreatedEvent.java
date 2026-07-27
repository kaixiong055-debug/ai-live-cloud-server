package cn.iocoder.yudao.module.system.api.tenant.event;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 租户创建完成事件。
 *
 * <p>由 system 模块发布，业务模块按需监听，避免 system 反向依赖业务模块。</p>
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TenantCreatedEvent {

    /**
     * 新创建的租户编号
     */
    private Long tenantId;

}
