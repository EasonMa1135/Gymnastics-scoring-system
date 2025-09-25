package com.vipa.scoring.entity;
import lombok.Data;
import org.springframework.stereotype.Repository;

@Repository
@Data  //lombok的注解，自动帮我们生成get/set方法的。
public class VerifyBean {
    private int verify_id;
    private Long user_id;
    private String verify_name;
    private String file_person;
    private String file_emblem;
    private Long admin_id;
    private int state;
}
