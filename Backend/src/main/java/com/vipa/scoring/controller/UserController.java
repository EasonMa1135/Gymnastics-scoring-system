package com.vipa.scoring.controller;

import com.vipa.scoring.entity.EvaluationBean;
import com.vipa.scoring.entity.UserBean;
import com.vipa.scoring.entity.VerifyBean;
import com.vipa.scoring.service.UserService;

import org.apache.commons.logging.Log;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.vipa.scoring.utils.Result;
import com.vipa.scoring.utils.ResultResponse;
import com.vipa.scoring.utils.ResultCode;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.*;
import java.math.BigInteger;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/users")
public class UserController {
    //将Service注入Web层
    @Resource
    UserService userService;

    //登录
    @GetMapping("/{telephone}/{password}")
    public Result loginByTel(@PathVariable String telephone, @PathVariable String password) {//@RequestBody，前端请以application/json格式上传JSON字符串，若要application/x-www-form-urlencoded上传JSON对象，请使用@RequestParam 或者Servlet 获取参数
        UserBean userQueried = userService.getInfoByTel(telephone);
        // 后续使用shiro拦截(未写)
        if (userQueried != null) {
            String pwd2 = userQueried.getUser_password();
            if (pwd2.equals(password)) {
                return ResultResponse.success(userQueried);
            } else {
                return ResultResponse.failure(ResultCode.PASSWORD_ERROR);
            }
        } else {
            return ResultResponse.failure(ResultCode.USER_NOT_FOUND);
        }
    }


    @GetMapping("/loginById/{user_id}")
    public Result loginById(@PathVariable("user_id") Long user_id) {
        UserBean userQueried = userService.getInfoById(user_id);
        //System.out.println(user_id);
        //System.out.println(userQueried);
        // 后续使用shiro拦截(未写)
        if (userQueried != null) {
            return ResultResponse.success(userQueried);
        } else {
            return ResultResponse.failure(ResultCode.USER_NOT_FOUND);
        }
    }

    @GetMapping("/show/{user_id}")
    public Result queryUserById(@PathVariable("user_id") Long user_id) {
        //System.out.println(user_id);
        UserBean userQueried = userService.getInfoById(user_id);
        // 后续使用shiro拦截(未写)
        if (userQueried != null) {
            userQueried.setUser_password("");
            userQueried.setWallet(0.0);
            return ResultResponse.success(userQueried);
        } else {
            return ResultResponse.failure(ResultCode.USER_NOT_FOUND);
        }
    }

    @PostMapping("/avatar")
    public Result changeAvatar(@RequestParam("file") MultipartFile file, @RequestParam("user_id") Long user_id, @RequestParam("avatar") String avatar) throws IOException{

        UserBean userQueried = userService.getInfoById(user_id);
        // 后续使用shiro拦截(未写)
        if (userQueried != null) {
            String path = avatar;
            File f = new File(path);
            FileOutputStream fos = new FileOutputStream(f);
            byte[] fileBytes = file.getBytes();
            fos.write(fileBytes);
            fos.close();
            userService.updateAvatarById(user_id, avatar);
            System.out.println(userQueried.getUser_avatar());

            return ResultResponse.success(userQueried);
        } else {
            return ResultResponse.failure(ResultCode.USER_NOT_FOUND);
        }
    }

    @GetMapping("/downloadAvatar/{user_id}")
    public byte[] avatarDownload(@PathVariable("user_id") Long user_id) throws IOException {
        UserBean userQueried = userService.getInfoById(user_id);

        File file = new File(userQueried.getUser_avatar());
        byte[] fileBytes = new byte[(int) file.length()];

        FileInputStream inputStream = new FileInputStream(file);
        inputStream.read(fileBytes);
        inputStream.close();

        return fileBytes;
    }

    @GetMapping("/downloadAvatarByTel/{user_telephone}")
    public byte[] avatarDownloadByTel(@PathVariable("user_telephone") String user_telephone) throws IOException {
        UserBean userQueried = userService.getInfoByTel(user_telephone);

        File file = new File(userQueried.getUser_avatar());
        byte[] fileBytes = new byte[(int) file.length()];

        FileInputStream inputStream = new FileInputStream(file);
        inputStream.read(fileBytes);
        inputStream.close();

        return fileBytes;
    }

    //更改用户昵称
    @PutMapping("/name/{user_id}/{user_name}")
    public Result changeName(@PathVariable("user_id") Long user_id, @PathVariable("user_name") String user_name) {
        UserBean userQueried = userService.getInfoById(user_id);
        if (userQueried != null) {
            userService.updateNameById(user_id, user_name);
            return ResultResponse.success();
        }
        else {
            return ResultResponse.failure(ResultCode.USER_NOT_FOUND);
        }
    }

    @PutMapping("/sex/{user_id}/{user_sex}")
    public Result changeSex(@PathVariable("user_id") Long user_id, @PathVariable("user_sex") String user_sex) {
        UserBean userQueried = userService.getInfoById(user_id);
        if (userQueried != null) {
            userService.updateSexById(user_id, user_sex);
            return ResultResponse.success();
        }
        else {
            return ResultResponse.failure(ResultCode.USER_NOT_FOUND);
        }
    }

    @PutMapping("/identity/{telephone}/{identity}")
    public Result changeIdentity(@PathVariable("telephone") String telephone, @PathVariable("identity") int identity){
        UserBean userQueried = userService.getInfoByTel(telephone);
        if (userQueried != null) {
            int idt2 = userQueried.getUser_identity();
            if (idt2 == identity) {
                return ResultResponse.failure(ResultCode.IDENTITY_SAME);
            } else {
                userService.updateIdentityByTel(telephone, identity);
                return ResultResponse.success();
            }
        } else {
            return ResultResponse.failure(ResultCode.USER_NOT_FOUND);
        }
    }

    @PutMapping("/identityStar/{telephone}/{verify_name}")
    public Result changeIdentityToStar(@PathVariable("telephone") String telephone, @PathVariable("verify_name") String verify_name){
        UserBean userQueried = userService.getInfoByTel(telephone);
        if (userQueried != null) {
            int idt2 = userQueried.getUser_identity();
            if (idt2 == 3) {
                return ResultResponse.failure(ResultCode.IDENTITY_SAME);
            } else {
                userService.updateIdentityByTel(telephone, 3);
                userService.updateVerifyNameByID(userQueried.getUser_id(), verify_name);
                return ResultResponse.success();
            }
        } else {
            return ResultResponse.failure(ResultCode.USER_NOT_FOUND);
        }
    }

    //更改用户所在地区
    @PutMapping("/area/{user_id}/{province}/{city}/{town}")
    public Result changeArea(@PathVariable("user_id") Long user_id,
                             @PathVariable("province") String province,
                             @PathVariable("city") String city,
                             @PathVariable("town") String town)
    {
        UserBean userQueried = userService.getInfoById(user_id);
        if (userQueried != null) {
            userService.updateAreaById(user_id, province, city, town);
            return ResultResponse.success();
        }
        else {
            return ResultResponse.failure(ResultCode.USER_NOT_FOUND);
        }
    }

    @PutMapping("/password/{user_id}/{password_new}")
    public Result changePassword(@PathVariable("user_id") Long user_id,
                                 @PathVariable("password_new") String password_new){
        UserBean userQueried = userService.getInfoById(user_id);
        if (userQueried != null) {
            userService.updatePwdById(user_id, password_new);
            return ResultResponse.success();
        }
        else {
            return ResultResponse.failure(ResultCode.USER_NOT_FOUND);
        }
    }

    //注册
    @PostMapping
    public Result register(@RequestParam("name") String name, @RequestParam("telephone") String telephone, @RequestParam("password") String password){
        UserBean userQueried = userService.getInfoByTel(telephone);
        if (userQueried != null) {
            return ResultResponse.failure(ResultCode.USER_EXISTED);
        }
        UserBean user = new UserBean();
        user.setUser_identity(0);
        user.setUser_telephone(telephone);
        user.setUser_name(name);
        user.setUser_password(password);
        user.setUser_qq("");
        user.setUser_wechat("");
        user.setUser_avatar("");
        user.setUser_sex("男");
        user.setUser_province("未知");
        user.setUser_city("");
        user.setUser_town("");
        user.setUser_level(2);
        user.setUser_exp(5);
        user.setVerify_name("");
        user.setLearn_times(5);
        user.setEval_times(2);
        user.setShare_times(4);
        user.setWallet(10.0);

        Long reId = userService.saveInfo(user);

        return ResultResponse.success(user);//返回系统为用户新建的id
    }

    //To do: register by QQ/wechat

    @PostMapping("/verify")
    public Result starVerify(@RequestParam("file_person") MultipartFile file_person,
                             @RequestParam("file_emblem") MultipartFile file_emblem,
                             @RequestParam("user_id") Long user_id,
                             @RequestParam("verify_name") String verify_name) throws IOException{
        UserBean userQueried = userService.getInfoById(user_id);
        // 后续使用shiro拦截(未写)
        if (userQueried != null) {
            VerifyBean verifyQueried = userService.selectVerifyByUserId(user_id);
            if(verifyQueried == null)
            {
                String path_person = file_person.getOriginalFilename();
                File f_person = new File(path_person);
                FileOutputStream fos_person = new FileOutputStream(f_person);
                byte[] fileBytes_person = file_person.getBytes();
                fos_person.write(fileBytes_person);
                fos_person.close();

                String path_emblem = file_emblem.getOriginalFilename();
                File f_emblem = new File(path_emblem);
                FileOutputStream fos_emblem = new FileOutputStream(f_emblem);
                byte[] fileBytes_emblem = file_emblem.getBytes();
                fos_emblem.write(fileBytes_emblem);
                fos_emblem.close();

                VerifyBean verify = new VerifyBean();
                verify.setUser_id(user_id);
                verify.setVerify_name(verify_name);
                verify.setFile_person(path_person);
                verify.setFile_emblem(path_emblem);
                verify.setState(0);
                userService.createVerify(verify);
                return ResultResponse.success();
            }
            else
            {
                return ResultResponse.failure(ResultCode.VERIFY_EXISTED);
            }

        } else {
            return ResultResponse.failure(ResultCode.USER_NOT_FOUND);
        }
    }

    @PostMapping("/getVerifyPage")
    public List<VerifyBean> getNotVerifyPage( @RequestParam(value = "PageSize",required = false,defaultValue = "-1") int PageSize,
                                                  @RequestParam(value = "PageIndex",required = false,defaultValue = "-1") int PageIndex)
    {
        System.out.println(PageIndex+ " "+PageSize);
        List<VerifyBean> verify=userService.getNotVerifyPage(PageSize, PageIndex);
        return verify;
    }

    @GetMapping("/getVerifyNum")
    public Integer getNotVerifyNum()
    {
        return  userService.getNotVerifyNum();
    }

    @GetMapping("/downloadVerify/{verify_id}")
    public List<List<Integer>> verifyDownload(@PathVariable("verify_id") int verify_id) throws IOException {
        VerifyBean verifyQueried = userService.selectVerifyById(verify_id);
        if(verifyQueried != null) {
            File file_person = new File(verifyQueried.getFile_person());
            byte[] fileBytes_person = new byte[(int) file_person.length()];
            FileInputStream inputStream_person = new FileInputStream(file_person);
            inputStream_person.read(fileBytes_person);
            inputStream_person.close();

            File file_emblem = new File(verifyQueried.getFile_emblem());
            byte[] fileBytes_emblem = new byte[(int) file_emblem.length()];
            FileInputStream inputStream_emblem = new FileInputStream(file_emblem);
            inputStream_emblem.read(fileBytes_emblem);
            inputStream_emblem.close();

            List<List<Integer>> resultList = new ArrayList<>();
            resultList.add(convertToIntegerList(fileBytes_person));
            resultList.add(convertToIntegerList(fileBytes_emblem));
            return resultList;
        }
        else
        {
            return new ArrayList<>();
        }
    }

    private List<Integer> convertToIntegerList(byte[] byteArray) {
        List<Integer> integerList = new ArrayList<>();
        for (byte b : byteArray) {
            integerList.add((int) b & 0xFF);
        }
        return integerList;
    }

    @PutMapping("/verifyDeal/{admin_id}/{verify_id}/{choose}")
    public Result verifyDeal(@PathVariable("admin_id") Long admin_id,
                             @PathVariable("verify_id") int verify_id,
                                 @PathVariable("choose") int choose){
        VerifyBean verifyQueried = userService.selectVerifyById(verify_id);
        if (verifyQueried != null) {
            if(verifyQueried.getState() == 0)
            {
                userService.updateVerifyByID(admin_id, verify_id, choose);
                if(choose == 1)
                {
                    userService.updateIdentityByID(verifyQueried.getUser_id(), 3);
                    userService.updateVerifyNameByID(verifyQueried.getUser_id(), verifyQueried.getVerify_name());
                }
                return ResultResponse.success();
            }
            else
            {
                return ResultResponse.failure(ResultCode.VERIFY_DEALT);
            }
        }
        else {
            return ResultResponse.failure(ResultCode.VERIFY_NOT_FOUND);
        }
    }

    @PostMapping("/getStarPage")
    public List<UserBean> getStarPage( @RequestParam(value = "PageSize",required = false,defaultValue = "-1") int PageSize,
                                              @RequestParam(value = "PageIndex",required = false,defaultValue = "-1") int PageIndex)
    {
        List<UserBean> stars=userService.getStarPage(PageSize, PageIndex);
        return stars;
    }

    @GetMapping("/getStarNum")
    public Integer getStarNum()
    {
        return  userService.getStarNum();
    }

    @PostMapping("/getAreaStarPage")
    public List<UserBean> getAreaStarPage( @RequestParam(value = "PageSize",required = false,defaultValue = "-1") int PageSize,
                                           @RequestParam(value = "PageIndex",required = false,defaultValue = "-1") int PageIndex,
                                           @RequestParam(value = "Province", required = true,defaultValue = "未知") String province)
    {
        List<UserBean> stars=userService.getAreaStarPage(PageSize, PageIndex, province);
        return stars;
    }

    @GetMapping("/getAreaStarNum/{province}")
    public Integer getAreaStarNum(@PathVariable("province") String province)
    {
        return  userService.getAreaStarNum(province);
    }

    @PostMapping("/searchStar")
    public List<UserBean> selectStarByName( @RequestParam(value = "name", required = true,defaultValue = "未知") String name)
    {
        List<UserBean> stars=userService.selectStarByName(name);
        return stars;
    }
}

