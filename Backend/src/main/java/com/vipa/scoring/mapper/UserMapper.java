package com.vipa.scoring.mapper;

import com.vipa.scoring.entity.EvaluationBean;
import org.apache.ibatis.annotations.*;

import com.vipa.scoring.entity.UserBean;
import com.vipa.scoring.entity.VerifyBean;

import java.util.List;

@Mapper
public interface UserMapper {
    @Select("SELECT * FROM User WHERE user_id = #{user_id}")
    UserBean getInfoById(Long user_id);

    @Select("SELECT * FROM User WHERE user_telephone = #{user_telephone}")
    UserBean getInfoByTel(String user_telephone);

    @Insert("INSERT into User(user_id, user_identity, user_name, user_avatar, user_telephone, " +
            "user_qq, user_wechat, user_password, user_sex, user_province, user_city, user_town, user_level, user_exp, " +
            "verify_name, learn_times, eval_times, share_times, wallet) values " +
            "(#{user_id}, #{user_identity}, #{user_name}, #{user_avatar}, #{user_telephone}, " +
            "#{user_qq}, #{user_wechat}, #{user_password}, #{user_sex}, #{user_province}, #{user_city}, #{user_town}, #{user_level}, " +
            "#{user_exp}, #{verify_name}, #{learn_times}, #{eval_times}, #{share_times}, #{wallet})")
    void saveInfo(UserBean user);

    @Update("UPDATE User SET user_name = #{user_name} WHERE user_id = #{user_id}")
    void updateNameById(Long user_id, String user_name);

    @Update("UPDATE User SET user_sex = #{user_sex} WHERE user_id = #{user_id}")
    void updateSexById(Long user_id, String user_sex);

    @Update("UPDATE User SET user_province = #{user_province}, user_city = #{user_city}, user_town = #{user_town} WHERE user_id = #{user_id}")
    void updateAreaById(Long user_id, String user_province, String user_city, String user_town);

    @Update("UPDATE User SET user_password = #{user_password} WHERE user_id = #{user_id}")
    void updatePwdById(Long user_id, String user_password);

    @Update("UPDATE User SET verify_name = #{verify_name} WHERE user_id = #{user_id}")
    void updateVerifyNameByID(Long user_id, String verify_name);

    @Update("UPDATE User SET user_avatar = #{user_avatar} WHERE user_id = #{user_id}")
    void updateAvatarById(Long user_id, String user_avatar);

    @Update("UPDATE User SET user_identity = #{identity} WHERE user_telephone = #{telephone}")
    void updateIdentityByTel(String telephone, int identity);

    @Update("UPDATE User SET user_identity = #{identity} WHERE user_id = #{user_id}")
    void updateIdentityByID(Long user_id, int identity);

    @Insert("INSERT into StarVerify(user_id, verify_name, file_person, file_emblem, admin_id, state) values " +
            "(#{user_id}, #{verify_name}, #{file_person}, #{file_emblem}, #{admin_id}, #{state})")
    @SelectKey(statement="SELECT LAST_INSERT_ID()", keyProperty="verify_id", resultType=Integer.class, before = false)
    void createVerify(VerifyBean verify);

    @Select("SELECT * FROM StarVerify WHERE user_id = #{user_id}")
    VerifyBean selectVerifyByUserId(Long user_id);

    @Select("SELECT * FROM StarVerify WHERE state=0 ORDER BY verify_id ASC LIMIT #{PageSize} OFFSET ${(PageIndex - 1) * PageSize}")
    List<VerifyBean> getNotVerifyPage(@Param("PageSize") Integer PageSize, @Param("PageIndex") Integer PageIndex);

    @Select("SELECT COUNT(*) FROM StarVerify WHERE state=0")
    Integer getNotVerifyNum();

    @Select("SELECT * FROM StarVerify WHERE verify_id = #{verify_id}")
    VerifyBean selectVerifyByID(int verify_id);

    @Update("UPDATE StarVerify SET admin_id = #{admin_id}, state = #{choose} WHERE verify_id = #{verify_id}")
    void updateVerifyByID(Long admin_id, int verify_id, int choose);

    @Select("SELECT * FROM User WHERE user_identity=3 ORDER BY user_name ASC LIMIT #{PageSize} OFFSET ${(PageIndex - 1) * PageSize}")
    List<UserBean> getStarPage(@Param("PageSize") Integer PageSize, @Param("PageIndex") Integer PageIndex);

    @Select("SELECT COUNT(*) FROM User WHERE user_identity=3")
    Integer getStarNum();

    @Select("SELECT * FROM User WHERE user_identity=3 and user_province = #{province} ORDER BY user_name ASC LIMIT #{PageSize} OFFSET ${(PageIndex - 1) * PageSize}")
    List<UserBean> getAreaStarPage(@Param("PageSize") Integer PageSize, @Param("PageIndex") Integer PageIndex, @Param("province") String province);

    @Select("SELECT COUNT(*) FROM User WHERE user_identity=3 and user_province = #{province}")
    Integer getAreaStarNum(@Param("province") String province);

    @Select("SELECT * FROM User WHERE user_identity=3 and verify_name like CONCAT('%', #{name}, '%')")
    List<UserBean> selectStarByName(@Param("name") String name);

}
