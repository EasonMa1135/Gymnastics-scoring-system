package com.vipa.scoring.mapper;

import com.vipa.scoring.entity.DanceBean;

import com.vipa.scoring.entity.UserBean;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface DanceMapper {

    //Select
    @Select("SELECT * FROM Dance")
    List<DanceBean> getAllDance();

    @Select("SELECT * FROM Dance WHERE dance_id = #{dance_id}")
    DanceBean getDanceById(Long dance_id);

    @Select("SELECT * FROM Dance WHERE dance_name = #{dance_name}")
    DanceBean getDanceByName(String dance_name);

    //Insert
    @Insert("INSERT into Dance(dance_id, dance_name, dance_info) values (#{dance_id}, #{dance_name}, #{dance_info})")
    int addDance(DanceBean dance);

    //Update
    @Update("UPDATE Dance SET dance_name = #{dance_name} WHERE dance_id = #{dance_id}")
    int updateNameById(DanceBean dance);

    @Update("UPDATE Dance SET dance_info = #{dance_info} WHERE dance_id = #{dance_id}")
    int updateInfoById(DanceBean dance);

    //delete
    @Delete("DELETE FROM Dance WHERE dance_id = #{dance_id}")
    int deleteById(DanceBean dance);

}
