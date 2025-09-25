package com.vipa.scoring.mapper;

import com.vipa.scoring.entity.MusicBean;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface MusicMapper {
    @Select("SELECT * FROM Music WHERE name = #{name}")
    List<MusicBean> getMusicByName(@Param("name")String name);

    @Select("SELECT * FROM Music WHERE music_id = #{id}")
    MusicBean getMusicById(@Param("id")String id);

    @Select("SELECT * FROM Music WHERE category = #{category}")
    List<MusicBean> getMusicByCategory(@Param("category")String category);

    @Insert("INSERT into Music(name,path)values(#{name},#{path})")
    void saveMusic(@Param("name") String name, @Param("path") String path);
}
