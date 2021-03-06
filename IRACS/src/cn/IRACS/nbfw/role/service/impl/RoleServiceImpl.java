package cn.IRACS.nbfw.role.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.IRACS.core.service.impl.BaseServiceImpl;
import cn.IRACS.nbfw.role.dao.RoleDao;
import cn.IRACS.nbfw.role.entity.Role;
import cn.IRACS.nbfw.role.service.RoleService;

@Service("roleService")
public class RoleServiceImpl extends BaseServiceImpl<Role> implements RoleService {
	
	private RoleDao roleDao;
	@Resource
	public void setRoleDao(RoleDao roleDao) {
		super.setBaseDao(roleDao);
		this.roleDao = roleDao;
	}

	@Override
	public void update(Role role) {
		//1、删除该角色对于的所有权限
		roleDao.deleteRolePrivilegeByRoleId(role.getRoleId());
		//2、更新角色及其权限
		roleDao.update(role);
	}

}
