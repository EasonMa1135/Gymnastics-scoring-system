package com.vipa.scoring.service;

import com.vipa.scoring.entity.TuitionBean;
import com.vipa.scoring.mapper.TuitionMapper;
import com.vipa.scoring.utils.SnowFlakeGenerateIdWorker;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Locale;

@Service
public class TuitionService {
    @Resource
    private TuitionMapper tuitionMapper;
    private SnowFlakeGenerateIdWorker snowflakeGenerator = new SnowFlakeGenerateIdWorker(0L, 0L);

    //查询
    //查询所有教学，并根据人气按照order={'DESC','ASC'}排序
    public List<TuitionBean> getAllTuition(String order){
        if (!"ASC".equalsIgnoreCase(order) && !"DESC".equalsIgnoreCase(order)) {
            throw new IllegalArgumentException("Invalid sort direction value: " + order);
        }
        return tuitionMapper.getAllTuition(order.toUpperCase());
    }

    //查询所有的推荐
    public List<TuitionBean> getAllRecommend(){
        return tuitionMapper.getAllRecommend();
    }

    public List<TuitionBean> getTopTuition(String order, int num){
        if (!"ASC".equalsIgnoreCase(order) && !"DESC".equalsIgnoreCase(order)) {
            throw new IllegalArgumentException("Invalid sort direction value: " + order);
        }
        return tuitionMapper.getTopTuition(order.toUpperCase(),num);
    }

    public List<TuitionBean> getTuitionByDance(String dance_name,String order){
        if (!"ASC".equalsIgnoreCase(order) && !"DESC".equalsIgnoreCase(order)) {
            throw new IllegalArgumentException("Invalid sort direction value: " + order);
        }
        return tuitionMapper.getTuitionByDance(dance_name,order.toUpperCase());
    }

    public List<TuitionBean> fuzzySearchByName(String name){
        return tuitionMapper.fuzzySearchByName(name);
    }

    public TuitionBean getTuitionById(Long tuition_id){
        return tuitionMapper.getTuitionById(tuition_id);
    }

    public Long addTuition(TuitionBean tuition){
        tuition.setTuition_id(Long.parseLong(snowflakeGenerator.generateNextId()));
        if(tuitionMapper.addTuition(tuition) == 0 )
            return 0L;
        return tuition.getTuition_id();
    }

    //update
    public int deleteRecommendByID(TuitionBean tuition){ return tuitionMapper.deleteRecommendByID(tuition); }

    public int updateRecommendByID(TuitionBean tuition){ return tuitionMapper.updateRecommendByID(tuition); }

    //delete
    public int deleteById(TuitionBean tuition){
        return tuitionMapper.deleteById(tuition);
    }
}
