package com.vipa.scoring.service;

import com.vipa.scoring.entity.MusicBean;
import com.vipa.scoring.mapper.MusicMapper;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;

@Service
public class MusicService {

    @Resource
    private MusicMapper musicMapper;

    public List<MusicBean> getMusicByName(String name){
        return musicMapper.getMusicByName(name);
    }

    public MusicBean getMusicById(String id){
        return musicMapper.getMusicById(id);
    }

    public List<MusicBean> getMusicByCategory(String category){
        return musicMapper.getMusicByCategory(category);
    }

    public void saveMusic(String name, String path){
        musicMapper.saveMusic(name, path);
    }

}
