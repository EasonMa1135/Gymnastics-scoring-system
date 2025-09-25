package com.vipa.scoring.entity;

import lombok.Data;
import org.springframework.stereotype.Repository;

@Repository
@Data  //lombok的注解，自动帮我们生成get/set方法的。
public class DanceBean {
    private Long dance_id;
    private String dance_name;
    private String dance_info;
}
