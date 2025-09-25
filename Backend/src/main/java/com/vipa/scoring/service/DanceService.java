package com.vipa.scoring.service;
import com.vipa.scoring.entity.DanceBean;
import com.vipa.scoring.mapper.DanceMapper;
import com.vipa.scoring.utils.SnowFlakeGenerateIdWorker;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class DanceService {
    @Resource
    private DanceMapper danceMapper;
    private SnowFlakeGenerateIdWorker snowflakeGenerator = new SnowFlakeGenerateIdWorker(0L, 0L);

    //select
    public List<DanceBean> getAllDance() { return danceMapper.getAllDance(); }
    public DanceBean getDanceById(Long dance_id) { return danceMapper.getDanceById(dance_id);}
    public DanceBean getDanceByName(String dance_name) {return danceMapper.getDanceByName(dance_name);}

    //insert
    public Long addDance(DanceBean dance){
        dance.setDance_id(Long.parseLong(snowflakeGenerator.generateNextId()));
        if(danceMapper.addDance(dance) == 0 )
            return 0L;
        return dance.getDance_id();
    }

    //update
    public int updateNameById(DanceBean dance){ return danceMapper.updateNameById(dance); }
    public int updateInfoById(DanceBean dance){ return danceMapper.updateInfoById(dance); }

    //delete
    public int deleteById(DanceBean dance){ return danceMapper.deleteById(dance);}

}
