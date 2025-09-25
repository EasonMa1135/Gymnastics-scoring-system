package com.vipa.scoring.entity;

import lombok.Data;
import org.springframework.stereotype.Repository;

@Repository
@Data  //lombok的注解，自动帮我们生成get/set方法的。
public class UserBean {
    private Long user_id;
    private Integer user_identity;
    private String user_name;
    private String user_avatar;
    private String user_telephone;
    private String user_qq;
    private String user_wechat;
    private String user_password;
    private String user_sex;
    private String user_province;
    private String user_city;
    private String user_town;
    private Integer user_level;
    private Integer user_exp;
    private String verify_name;
    private Integer learn_times;
    private Integer eval_times;
    private Integer share_times;
    private Double wallet;

}
