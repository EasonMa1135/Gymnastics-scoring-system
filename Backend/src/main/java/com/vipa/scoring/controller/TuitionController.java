package com.vipa.scoring.controller;

import com.vipa.scoring.entity.DanceBean;
import com.vipa.scoring.entity.TuitionBean;
import com.vipa.scoring.service.TuitionService;
import com.vipa.scoring.utils.Result;
import com.vipa.scoring.utils.ResultCode;
import com.vipa.scoring.utils.ResultResponse;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/tuition")
public class TuitionController {
    @Resource
    TuitionService tuitionService;

    //查询所有教学，并根据人气按照order={'DESC','ASC'}排序
    @GetMapping("/{order}")
    public Result getAllTuition(@PathVariable("order") String order) {
        List<TuitionBean> tuitionQueried = tuitionService.getAllTuition(order);
        return tuitionQueried == null ? ResultResponse.failure(ResultCode.INFO_NOT_FOUND) : ResultResponse.success(tuitionQueried);
    }

    //查询推荐位
    @GetMapping("/recommend")
    public Result getRecommend(){
        List<TuitionBean> tuitionQueried = tuitionService.getAllRecommend();
        return tuitionQueried == null ? ResultResponse.failure(ResultCode.INFO_NOT_FOUND) : ResultResponse.success(tuitionQueried);
    }

    //查询Top人气教学，并根据人气按照order={'DESC','ASC'}排序
    @GetMapping("/top/{order}/{num}")
    public Result getTopTuition(@PathVariable("order") String order,@PathVariable("num") int num){
        List<TuitionBean> tuitionQueried = tuitionService.getTopTuition(order,num);
        return tuitionQueried == null ? ResultResponse.failure(ResultCode.INFO_NOT_FOUND) : ResultResponse.success(tuitionQueried);
    }

    // 查询不同舞蹈分类所有教学，并根据人气按照order={'DESC','ASC'}排序
    @GetMapping("/dance/{dance_name}/{order}")
    public Result getTuitionByDance(@PathVariable("dance_name")String dance_name,@PathVariable("order")String order){
        List<TuitionBean> tuitionQueried = tuitionService.getTuitionByDance(dance_name, order);
        return tuitionQueried == null ? ResultResponse.failure(ResultCode.INFO_NOT_FOUND) : ResultResponse.success(tuitionQueried);
    }

    //模糊搜索
    @GetMapping("/fuzzy/{name}")
    public Result fuzzySearchByName(@PathVariable("name") String name){
        List<TuitionBean> tuitionQueried = tuitionService.fuzzySearchByName(name);
        return tuitionQueried == null ? ResultResponse.failure(ResultCode.INFO_NOT_FOUND) : ResultResponse.success(tuitionQueried);
    }

    //根据id精准查询
    @GetMapping("/id/{tuition_id}")
    public Result getTuitionById(@PathVariable("tuition_id") Long tuition_id){
        TuitionBean tuitionQueried = tuitionService.getTuitionById(tuition_id);
        return tuitionQueried == null ? ResultResponse.failure(ResultCode.INFO_NOT_FOUND) : ResultResponse.success(tuitionQueried);
    }
    //update

    //删除推荐位
    @PutMapping("/deleteRecommend")
    public Result deleteRecommendById(@RequestBody TuitionBean tuition){
        int result = tuitionService.deleteRecommendByID(tuition);
        return result == 0 ? ResultResponse.failure(ResultCode.INFO_NOT_FOUND) : ResultResponse.success();
    }

    //增加推荐位
    @PutMapping("/addRecommend")
    public Result addRecommendById(@RequestBody TuitionBean tuition){
        int result = tuitionService.updateRecommendByID(tuition);
        return result == 0 ? ResultResponse.failure(ResultCode.INFO_NOT_FOUND) : ResultResponse.success();
    }

    //insert
    @PostMapping()
    public Result addTuition(@RequestBody TuitionBean tuition){
        Long reId = tuitionService.addTuition(tuition);
        return reId == 0L ? ResultResponse.failure(ResultCode.DB_INSERT_FAIL) : ResultResponse.success(reId);//返回系统为用户新建的id
    }

    //delete
    @DeleteMapping Result deleteById(@RequestBody TuitionBean tuition){
        TuitionBean tuitionQueried = tuitionService.getTuitionById(tuition.getTuition_id());
        if (tuitionQueried == null)//该id是否存在
            return ResultResponse.failure(ResultCode.INFO_NOT_FOUND);
        return tuitionService.deleteById(tuition) == 0 ? ResultResponse.failure(ResultCode.DB_DELETE_FAIL) : ResultResponse.success(tuitionQueried);
    }
}
