package com.vipa.scoring.mapper;

import com.vipa.scoring.entity.EvaluationBean;
import org.apache.ibatis.annotations.*;


import java.math.BigInteger;
import java.util.List;
@Mapper
public interface EvaluationMapper {

    @Select("SELECT * FROM evaluation WHERE user_id = #{user_id}")
    List<EvaluationBean> getEvaluationById(@Param("user_id")Integer userid);

    @Select("SELECT * FROM evaluation WHERE user_id = #{user_id} ORDER BY eval_time DESC LIMIT #{PageSize} OFFSET ${(PageIndex - 1) * PageSize}")
    List<EvaluationBean> getEvaluationPage(@Param("user_id") BigInteger userid, @Param("PageSize") Integer PageSize, @Param("PageIndex") Integer PageIndex);
    //SELECT * FROM evaluation WHERE user_id = 1091458850529214500 and manual_score = -99 LIMIT 8 OFFSET 0 ;

    @Select("SELECT * FROM evaluation WHERE manual_total_score<0 ORDER BY eval_time DESC LIMIT #{PageSize} OFFSET ${(PageIndex - 1) * PageSize}")
    List<EvaluationBean> getNotEvaluationById(@Param("PageSize") Integer PageSize, @Param("PageIndex") Integer PageIndex);

    @Select("SELECT * FROM evaluation ORDER BY eval_time DESC LIMIT 1")
    EvaluationBean getLatestgEvaluation();

    @Select("SELECT * FROM evaluation WHERE eval_id = #{eval_id}")
    EvaluationBean getEvauationByKey(@Param("eval_id")Integer evalid);

    @Insert("INSERT into evaluation(user_id, manual_total_score, manual_head_neck," +
            "    manual_left_arm," +
            "    manual_right_arm," +
            "    manual_chest_belly," +
            "    manual_waist_hip," +
            "    manual_left_leg," +
            "    manual_right_leg," +
            "    manual_rhythm, eval_path)values(#{user_id}, #{manual_score[0]}, #{manual_score[1]},#{manual_score[2]},#{manual_score[3]}" +
            ",#{manual_score[4]},#{manual_score[5]},#{manual_score[6]},#{manual_score[7]},#{manual_score[8]}, #{eval_path})")
    @SelectKey(statement="SELECT LAST_INSERT_ID()", keyProperty="eval_id", resultType=Integer.class, before = false)
    void uploaditem(@Param("user_id") BigInteger userid, @Param("manual_score") Integer[] manual_score, @Param("eval_path") String path);

    @Select("SELECT COUNT(*) FROM evaluation WHERE manual_total_score<0")
    Integer getNotEvaluationNum();

    @Select("SELECT COUNT(*) FROM evaluation WHERE user_id = #{user_id}")
    Integer getEvaluationNumById(@Param("user_id") BigInteger userid);

    @Update("UPDATE evaluation SET manual_total_score = #{manual_score[0]}, manual_head_neck = #{manual_score[1]},manual_left_arm = #{manual_score[2]}" +
            ",manual_right_arm= #{manual_score[3]},manual_chest_belly= #{manual_score[4]},manual_waist_hip = #{manual_score[5]},manual_left_leg = #{manual_score[6]}, manual_right_leg = #{manual_score[7]}" +
            ",manual_rhythm= #{manual_score[8]} WHERE eval_id = #{eval_id}")
    void updateScoreById(@Param("manual_score")int[] manual_score, int eval_id);
}
