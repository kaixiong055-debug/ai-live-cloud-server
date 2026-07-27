package cn.iocoder.yudao.module.ailive.controller.admin.license;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.ailive.controller.admin.license.vo.CustomerLicenseSaveReqVO;
import cn.iocoder.yudao.module.ailive.dal.dataobject.license.CustomerLicenseDO;
import cn.iocoder.yudao.module.ailive.service.license.CustomerLicenseService;
import org.springframework.web.bind.annotation.*; import javax.annotation.Resource; import javax.validation.Valid;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
@RestController @RequestMapping("/ai-live/customer-license") public class CustomerLicenseController {
 @Resource private CustomerLicenseService service;
 @PostMapping("/create") public CommonResult<Long> create(@Valid @RequestBody CustomerLicenseSaveReqVO req){return success(service.create(req));}
 @PutMapping("/update") public CommonResult<Boolean> update(@Valid @RequestBody CustomerLicenseSaveReqVO req){service.update(req);return success(true);}
 @DeleteMapping("/delete") public CommonResult<Boolean> delete(@RequestParam Long id){service.delete(id);return success(true);}
 @GetMapping("/get") public CommonResult<CustomerLicenseDO> get(@RequestParam Long id){return success(service.get(id));}
}
