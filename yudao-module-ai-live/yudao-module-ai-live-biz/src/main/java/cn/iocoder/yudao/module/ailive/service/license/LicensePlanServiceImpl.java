package cn.iocoder.yudao.module.ailive.service.license;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.LicensePlanPageReqVO;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.LicensePlanSaveReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.LicensePlanDO;
import cn.iocoder.yudao.module.ailive.dal.mysql.license.LicensePlanMapper;
import cn.iocoder.yudao.module.ailive.enums.license.LicenseTypeEnum;
import cn.iocoder.yudao.module.ailive.enums.license.SdkCredentialModeEnum;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import javax.annotation.Resource;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.ailive.enums.ErrorCodeConstants.*;

@Service
@Validated
public class LicensePlanServiceImpl implements LicensePlanService {

    @Resource
    private LicensePlanMapper mapper;

    @Override
    public Long createLicensePlan(LicensePlanSaveReqVO reqVO) {
        normalize(reqVO);
        validateForSave(null, reqVO);
        LicensePlanDO plan = BeanUtils.toBean(reqVO, LicensePlanDO.class);
        mapper.insert(plan);
        return plan.getId();
    }

    @Override
    public void updateLicensePlan(LicensePlanSaveReqVO reqVO) {
        normalize(reqVO);
        validateForSave(reqVO.getId(), reqVO);
        mapper.updateById(BeanUtils.toBean(reqVO, LicensePlanDO.class));
    }

    @Override
    public void deleteLicensePlan(Long id) {
        validateExists(id);
        mapper.deleteById(id);
    }

    @Override
    public PageResult<LicensePlanDO> getLicensePlanPage(LicensePlanPageReqVO reqVO) {
        return mapper.selectPage(reqVO);
    }

    @Override
    public LicensePlanDO getLicensePlan(Long id) {
        return mapper.selectById(id);
    }

    @Override
    public List<LicensePlanDO> getLicensePlanList(Collection<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyList();
        }
        return mapper.selectBatchIds(ids);
    }

    @Override
    public void changeStatus(Long id, Integer status) {
        validateExists(id);
        LicensePlanDO update = new LicensePlanDO();
        update.setId(id);
        update.setStatus(status);
        mapper.updateById(update);
    }

    @Override
    public LicensePlanDO validateEnabledLicensePlan(Long id) {
        LicensePlanDO plan = getLicensePlan(id);
        if (plan == null) {
            throw exception(LICENSE_PLAN_NOT_EXISTS);
        }
        if (!CommonStatusEnum.ENABLE.getStatus().equals(plan.getStatus())) {
            throw exception(LICENSE_PLAN_DISABLED);
        }
        return plan;
    }

    private void normalize(LicensePlanSaveReqVO reqVO) {
        if (LicenseTypeEnum.PERPETUAL.getValue().equals(reqVO.getLicenseType())) {
            reqVO.setDurationDays(0);
        }
    }

    private void validateForSave(Long id, LicensePlanSaveReqVO reqVO) {
        if (id != null) {
            validateExists(id);
        }
        LicensePlanDO duplicate = mapper.selectByCode(reqVO.getCode());
        if (duplicate != null && !duplicate.getId().equals(id)) {
            throw exception(LICENSE_PLAN_CODE_DUPLICATE);
        }
        if (!LicenseTypeEnum.isValid(reqVO.getLicenseType())
                || !SdkCredentialModeEnum.isValid(reqVO.getDefaultSdkCredentialMode())) {
            throw exception(LICENSE_PLAN_INVALID_DURATION);
        }
        boolean perpetual = LicenseTypeEnum.PERPETUAL.getValue().equals(reqVO.getLicenseType());
        if ((perpetual && reqVO.getDurationDays() != 0) || (!perpetual && reqVO.getDurationDays() <= 0)) {
            throw exception(LICENSE_PLAN_INVALID_DURATION);
        }
    }

    private void validateExists(Long id) {
        if (mapper.selectById(id) == null) {
            throw exception(LICENSE_PLAN_NOT_EXISTS);
        }
    }
}
