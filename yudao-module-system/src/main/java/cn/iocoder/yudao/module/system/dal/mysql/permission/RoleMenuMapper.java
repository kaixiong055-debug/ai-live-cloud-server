package cn.iocoder.yudao.module.system.dal.mysql.permission;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.system.dal.dataobject.permission.RoleMenuDO;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.Collection;
import java.util.List;
import java.util.Set;

@Mapper
public interface RoleMenuMapper extends BaseMapperX<RoleMenuDO> {

    default List<RoleMenuDO> selectListByRoleId(Long roleId) {
        return selectList(RoleMenuDO::getRoleId, roleId);
    }

    default List<RoleMenuDO> selectListByRoleId(Collection<Long> roleIds) {
        return selectList(RoleMenuDO::getRoleId, roleIds);
    }

    default List<RoleMenuDO> selectListByMenuId(Long menuId) {
        return selectList(RoleMenuDO::getMenuId, menuId);
    }

    @Select({"<script>",
            "SELECT DISTINCT menu.permission FROM system_role_menu role_menu",
            "INNER JOIN system_menu menu ON menu.id = role_menu.menu_id",
            "WHERE role_menu.tenant_id = #{tenantId} AND role_menu.deleted = 0",
            "AND menu.deleted = 0 AND menu.status = 0",
            "AND role_menu.role_id IN",
            "<foreach collection='roleIds' item='roleId' open='(' separator=',' close=')'>#{roleId}</foreach>",
            "AND menu.permission IN",
            "<foreach collection='permissions' item='permission' open='(' separator=',' close=')'>#{permission}</foreach>",
            "</script>"})
    Set<String> selectGrantedPermissions(@Param("tenantId") Long tenantId,
                                         @Param("roleIds") Collection<Long> roleIds,
                                         @Param("permissions") Collection<String> permissions);

    default void deleteListByRoleIdAndMenuIds(Long roleId, Collection<Long> menuIds) {
        delete(new LambdaQueryWrapper<RoleMenuDO>()
                .eq(RoleMenuDO::getRoleId, roleId)
                .in(RoleMenuDO::getMenuId, menuIds));
    }

    default void deleteListByMenuId(Long menuId) {
        delete(new LambdaQueryWrapper<RoleMenuDO>().eq(RoleMenuDO::getMenuId, menuId));
    }

    default void deleteListByRoleId(Long roleId) {
        delete(new LambdaQueryWrapper<RoleMenuDO>().eq(RoleMenuDO::getRoleId, roleId));
    }

}
