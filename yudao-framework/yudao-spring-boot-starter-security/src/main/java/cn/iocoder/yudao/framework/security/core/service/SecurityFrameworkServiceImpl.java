package cn.iocoder.yudao.framework.security.core.service;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.yudao.framework.common.biz.system.permission.PermissionCommonApi;
import cn.iocoder.yudao.framework.security.core.LoginUser;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import lombok.AllArgsConstructor;

import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

import static cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils.getLoginUserId;
import static cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils.skipPermissionCheck;

/**
 * 默认的 {@link SecurityFrameworkService} 实现类
 *
 * @author 芋道源码
 */
@AllArgsConstructor
public class SecurityFrameworkServiceImpl implements SecurityFrameworkService {

    private static final String GRANTED_PERMISSION_CONTEXT_KEY =
            SecurityFrameworkServiceImpl.class.getName() + ".grantedPermissions";

    private final PermissionCommonApi permissionApi;

    @Override
    public boolean hasPermission(String permission) {
        return hasAnyPermissions(permission);
    }

    @Override
    public boolean hasAnyPermissions(String... permissions) {
        // 特殊：跨租户访问
        if (skipPermissionCheck()) {
            return true;
        }

        // 权限校验
        Long userId = getLoginUserId();
        if (userId == null) {
            return false;
        }
        return permissionApi.hasAnyPermissions(userId, permissions);
    }

    @Override
    public Set<String> getGrantedPermissions(String... permissions) {
        if (permissions == null || permissions.length == 0) {
            return Collections.emptySet();
        }
        if (skipPermissionCheck()) {
            return new LinkedHashSet<>(Arrays.asList(permissions));
        }
        LoginUser loginUser = SecurityFrameworkUtils.getLoginUser();
        if (loginUser == null) {
            return Collections.emptySet();
        }
        Map<String, Boolean> cached = getPermissionCache(loginUser);
        Set<String> missing = new LinkedHashSet<>();
        for (String permission : permissions) {
            if (!cached.containsKey(permission)) {
                missing.add(permission);
            }
        }
        if (!missing.isEmpty()) {
            Set<String> granted = permissionApi.getGrantedPermissions(loginUser.getId(), missing);
            for (String permission : missing) {
                cached.put(permission, granted.contains(permission));
            }
        }
        Set<String> result = new LinkedHashSet<>();
        for (String permission : permissions) {
            if (Boolean.TRUE.equals(cached.get(permission))) {
                result.add(permission);
            }
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    private Map<String, Boolean> getPermissionCache(LoginUser loginUser) {
        Map<String, Boolean> cached = loginUser.getContext(
                GRANTED_PERMISSION_CONTEXT_KEY, Map.class);
        if (cached == null) {
            cached = new LinkedHashMap<>();
            loginUser.setContext(GRANTED_PERMISSION_CONTEXT_KEY, cached);
        }
        return cached;
    }

    @Override
    public boolean hasRole(String role) {
        return hasAnyRoles(role);
    }

    @Override
    public boolean hasAnyRoles(String... roles) {
        // 特殊：跨租户访问
        if (skipPermissionCheck()) {
            return true;
        }

        // 权限校验
        Long userId = getLoginUserId();
        if (userId == null) {
            return false;
        }
        return permissionApi.hasAnyRoles(userId, roles);
    }

    @Override
    public boolean hasScope(String scope) {
        return hasAnyScopes(scope);
    }

    @Override
    public boolean hasAnyScopes(String... scope) {
        // 特殊：跨租户访问
        if (skipPermissionCheck()) {
            return true;
        }

        // 权限校验
        LoginUser user = SecurityFrameworkUtils.getLoginUser();
        if (user == null) {
            return false;
        }
        return CollUtil.containsAny(user.getScopes(), Arrays.asList(scope));
    }

}
