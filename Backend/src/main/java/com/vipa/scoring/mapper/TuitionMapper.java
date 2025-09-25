package com.vipa.scoring.mapper;
import com.vipa.scoring.entity.TuitionBean;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface TuitionMapper {
    // Select
    //查询所有教学，并根据人气按照order={'DESC','ASC'}排序
    @Select("SELECT * FROM Tuition ORDER BY tuition_num ${order}")
    List<TuitionBean> getAllTuition(String order);

    //查询推荐位
    @Select("SELECT * FROM Tuition WHERE recommend_url IS NOT NULL")
    List<TuitionBean> getAllRecommend();

    //查询Top人气教学，并根据人气按照order={'DESC','ASC'}排序
    @Select("SELECT * FROM Tuition ORDER BY tuition_num ${order} LIMIT #{num}")
    List<TuitionBean> getTopTuition(String order, int num);

    // 查询不同舞蹈分类所有教学，并根据人气按照order={'DESC','ASC'}排序
    @Select("SELECT * FROM Tuition WHERE dance_name = #{dance_name} ORDER BY tuition_num ${order}")
    List<TuitionBean> getTuitionByDance(String dance_name,String order);

    //模糊搜索
    @Select("SELECT * FROM Tuition WHERE tuition_name LIKE concat('%',#{name},'%')")
    List<TuitionBean> fuzzySearchByName(String name);

    //根据id精准查询
    @Select("SELECT * FROM Tuition WHERE tuition_id=#{tuition_id}")
    TuitionBean getTuitionById(Long tuition_id);

    //查询该动作的评分排行，根据分数按照按照order={'DESC','ASC'}排序，num是查询条目的数量
//    @Select("SELECT * FROM evaluation WHERE tuition_id = #{tuition_id} ORDER BY ai_total_score #{order} LIMIT #{num}")
//    EvaluationBean getEvalByTuition(Long tuition_id, String order, int num);

    //Update
    @Update("UPDATE Tuition SET recommend_url = NULL WHERE tuition_id=#{tuition_id}")
    int deleteRecommendByID(TuitionBean tuition);

    @Update("UPDATE Tuition SET recommend_url = #{recommend_url} WHERE tuition_id=#{tuition_id}")
    int updateRecommendByID(TuitionBean tuition);

    //Insert
    @Insert("INSERT into Tuition(tuition_id, tuition_name, dance_name) values (#{tuition_id}, #{tuition_name}, #{dance_name})")
    int addTuition(TuitionBean tuition);

    //Delete
    @Delete("DELETE FROM Tuition WHERE tuition_id = #{tuition_id}")
    int deleteById(TuitionBean tuition);
}
