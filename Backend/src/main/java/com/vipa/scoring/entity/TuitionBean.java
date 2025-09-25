package com.vipa.scoring.entity;

import lombok.Data;
import org.springframework.stereotype.Repository;

@Repository
@Data  //lombok的注解，自动帮我们生成get/set方法的。
public class TuitionBean {
    private Long tuition_id;
    private String tuition_name;
    private String tuition_info;
    private String tuition_pic;
    private String tuition_video;
    private int tuition_num;
    private String tuition_level;
    private String tuition_duration;
    private String dance_name;
    private String recommend_url;
    private int fee;
}
