package com.vipa.scoring.controller;

import com.vipa.scoring.entity.DanceBean;
import com.vipa.scoring.service.DanceService;
import com.vipa.scoring.utils.Result;
import com.vipa.scoring.utils.ResultCode;
import com.vipa.scoring.utils.ResultResponse;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/dance")
public class DanceController {
    @Resource
    DanceService danceService;

    //查询所有舞蹈种类
    @GetMapping
    public Result getAllDance() {
        List<DanceBean> danceQueried = danceService.getAllDance();
        return danceQueried == null ? ResultResponse.failure(ResultCode.INFO_NOT_FOUND) : ResultResponse.success(danceQueried);
    }

    //根据id查询舞蹈种类
    @GetMapping("/id/{dance_id}")
    public Result getDanceById(@PathVariable("dance_id") Long dance_id) {
        DanceBean danceQueried = danceService.getDanceById(dance_id);
        return danceQueried == null ? ResultResponse.failure(ResultCode.INFO_NOT_FOUND) : ResultResponse.success(danceQueried);
    }

    //根据name查询舞蹈种类
    @GetMapping("/name/{dance_name}")
    public Result getDanceByName(@PathVariable("dance_name") String dance_name) {
        DanceBean danceQueried = danceService.getDanceByName(dance_name);
        return danceQueried == null ? ResultResponse.failure(ResultCode.INFO_NOT_FOUND) : ResultResponse.success(danceQueried);
    }

    //增加舞蹈种类
    @PostMapping
    public Result addDance(@RequestBody DanceBean dance){
        if (danceService.getDanceByName(dance.getDance_name()) != null) //需要增加的舞蹈种类是否已经存在
            return ResultResponse.failure(ResultCode.INFO_EXISTED);
        Long reId = danceService.addDance(dance);
        return reId == 0L ? ResultResponse.failure(ResultCode.DB_INSERT_FAIL) : ResultResponse.success(reId);//返回系统为用户新建的id
    }

    //根据id修改舞蹈种类name
    @PutMapping("/name")
    public Result updateNameById(@RequestBody DanceBean dance){
        if (danceService.getDanceById(dance.getDance_id()) == null) //该id是否存在
            return ResultResponse.failure(ResultCode.INFO_NOT_FOUND);
        if (danceService.getDanceByName(dance.getDance_name()) != null)//要修改的舞蹈种类名称是否已经存在
            return ResultResponse.failure(ResultCode.INFO_EXISTED);
        return danceService.updateNameById(dance) == 0 ? ResultResponse.failure(ResultCode.DB_UPDATE_FAIL) : ResultResponse.success(danceService.getDanceById(dance.getDance_id()));
    }

    //根据id修改舞蹈种类info
    @PutMapping("/info")
    public Result updateInfoById(@RequestBody DanceBean dance){
        if (danceService.getDanceById(dance.getDance_id()) == null)//该id是否存在
            return ResultResponse.failure(ResultCode.INFO_NOT_FOUND);
        return danceService.updateInfoById(dance) == 0 ? ResultResponse.failure(ResultCode.DB_UPDATE_FAIL) : ResultResponse.success(danceService.getDanceById(dance.getDance_id()));
    }

    //删除
    @DeleteMapping("/id/{dance_id}")
    public Result deleteById(@RequestBody DanceBean dance){
        DanceBean danceQueried = danceService.getDanceById(dance.getDance_id());
        if (danceQueried == null)//该id是否存在
            return ResultResponse.failure(ResultCode.INFO_NOT_FOUND);
        return danceService.deleteById(dance) == 0 ? ResultResponse.failure(ResultCode.DB_DELETE_FAIL) : ResultResponse.success(danceQueried);
    }
    //删除
    @DeleteMapping("/name/{dance_name}")
    public Result deleteByName(@PathVariable("dance_name") String dance_name){
        DanceBean danceQueried = danceService.getDanceByName(dance_name);
        if (danceQueried == null)//该danceBean是否存在
            return ResultResponse.failure(ResultCode.INFO_NOT_FOUND);
        return danceService.deleteById(danceQueried) == 0 ? ResultResponse.failure(ResultCode.DB_DELETE_FAIL) : ResultResponse.success(danceQueried);
    }
}