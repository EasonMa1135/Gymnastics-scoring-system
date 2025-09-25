package com.vipa.scoring.service;

import com.vipa.scoring.entity.EvaluationBean;
import com.vipa.scoring.entity.UserBean;
import com.vipa.scoring.entity.VerifyBean;
import com.vipa.scoring.mapper.UserMapper;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;

import java.math.BigInteger;
import java.util.List;
import com.vipa.scoring.utils.SnowFlakeGenerateIdWorker;

@Service
public class UserService {
    //将dao层属性注入service层
    @Resource
    private UserMapper userMapper;
    private SnowFlakeGenerateIdWorker snowflakeGenerator = new SnowFlakeGenerateIdWorker(0L, 0L);

    public UserBean getInfoById(Long user_id){
        return userMapper.getInfoById(user_id);
    }

    public UserBean getInfoByTel(String telephone){
        return userMapper.getInfoByTel(telephone);
    }

    public Long saveInfo(UserBean user){
        user.setUser_id(Long.parseLong(snowflakeGenerator.generateNextId()));
        userMapper.saveInfo(user);
        return user.getUser_id();
    }

    public void updateNameById(Long user_id, String user_name){
        userMapper.updateNameById(user_id, user_name);
    }

    public void updateSexById(Long user_id, String user_sex){
        userMapper.updateSexById(user_id, user_sex);
    }

    public void updateAreaById(Long user_id, String user_province, String user_city, String user_town){
        userMapper.updateAreaById(user_id, user_province, user_city, user_town);
    }

    public void updatePwdById(Long user_id, String user_password){
        userMapper.updatePwdById(user_id, user_password);
    }

    public void updateVerifyNameByID(Long user_id, String verify_name){
        userMapper.updateVerifyNameByID(user_id, verify_name);
    };

    public void updateAvatarById(Long user_id, String user_avatar){
        userMapper.updateAvatarById(user_id, user_avatar);
    }

    public void updateIdentityByTel(String telephone, int identity){
        userMapper.updateIdentityByTel(telephone, identity);
    }

    public void updateIdentityByID(Long user_id, int identity){
        userMapper.updateIdentityByID(user_id, identity);
    };

    public void createVerify(VerifyBean verify){
        userMapper.createVerify(verify);
    }

    public VerifyBean selectVerifyByUserId(Long user_id){
        return userMapper.selectVerifyByUserId(user_id);
    }

    public List<VerifyBean> getNotVerifyPage(Integer PageSize, Integer PageIndex){return userMapper.getNotVerifyPage(PageSize, PageIndex);}

    public Integer getNotVerifyNum() {return userMapper.getNotVerifyNum(); }

    public VerifyBean selectVerifyById(int verify_id) { return userMapper.selectVerifyByID(verify_id); }

    public void updateVerifyByID(Long admin_id, int verify_id, int choose) { userMapper.updateVerifyByID(admin_id, verify_id, choose); };

    public List<UserBean> getStarPage(Integer PageSize, Integer PageIndex){return userMapper.getStarPage(PageSize, PageIndex);}

    public Integer getStarNum() {return userMapper.getStarNum(); }

    public List<UserBean> getAreaStarPage(Integer PageSize, Integer PageIndex, String province){return userMapper.getAreaStarPage(PageSize, PageIndex, province);}

    public Integer getAreaStarNum(String province) {return userMapper.getAreaStarNum(province); }

    public List<UserBean> selectStarByName(String name){return userMapper.selectStarByName(name);}

}
