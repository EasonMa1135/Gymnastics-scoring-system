package com.vipa.scoring.entity;

import lombok.*;
import org.springframework.stereotype.Repository;

import java.math.BigInteger;
import java.sql.Timestamp;

@Repository
@Data
public class EvaluationBean {
    private Integer eval_id;
    private BigInteger user_id;
    private Integer teach_id;
    private Integer dance_id;
    private Timestamp eval_time;
    private String eval_path;
    private Integer ai_total_score;
    private Integer ai_head_neck;
    private Integer ai_left_arm;
    private Integer ai_right_arm;
    private Integer ai_chest_belly;
    private Integer ai_waist_hip;
    private Integer ai_left_leg;
    private Integer ai_right_leg;
    private Integer ai_rhythm;
    private Integer manual_total_score;
    private Integer manual_head_neck;
    private Integer manual_left_arm;
    private Integer manual_right_arm;
    private Integer manual_chest_belly;
    private Integer manual_waist_hip;
    private Integer manual_left_leg;
    private Integer manual_right_leg;
    private Integer manual_rhythm;
}
