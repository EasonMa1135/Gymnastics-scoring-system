package com.vipa.scoring.utils;
import lombok.Data;
import lombok.Getter;

/**
 * @author kenx
 * @version 1.0
 * @date 2021/6/17 15:35
 * 响应码枚举，对应HTTP状态码
 */
@Getter
public enum ResultCode {

    SUCCESS(200, "成功"),//成功
    //FAIL(400, "失败"),//失败
    BAD_REQUEST(400, "Bad Request"),
    UNAUTHORIZED(401, "认证失败"),//未认证
    NOT_FOUND(404, "接口不存在"),//接口不存在
    INTERNAL_SERVER_ERROR(500, "系统繁忙"),//服务器内部错误
    METHOD_NOT_ALLOWED(405,"方法不被允许"),
    USER_NOT_FOUND(101,"用户不存在"),
    USER_EXISTED(102,"用户已存在"),
    PASSWORD_ERROR(103,"密码不正确"),
    IDENTITY_SAME(104,"用户身份与所修改身份相同"),

    VERIFY_EXISTED(105, "请勿重复申请"),
    VERIFY_NOT_FOUND(106, "请求不存在"),
    VERIFY_DEALT(107, "请求已被处理"),
  
    INFO_NOT_FOUND(108,"查询不到符合条件的信息"),
    INFO_EXISTED(109,"增添信息已存在"),

    //数据库操作
    DB_SELECT_FALI(110,"数据库查询操作失败"),
    DB_INSERT_FAIL(111,"数据库增添操作失败"),
    DB_UPDATE_FAIL(112,"数据库更新操作失败"),
    DB_DELETE_FAIL(113,"数据库删除操作失败"),

    /*参数错误:1001-1999*/
    PARAMS_IS_INVALID(1001, "参数无效"),
    PARAMS_IS_BLANK(1002, "参数为空");
    /*用户错误2001-2999*/


    private Integer code;
    private String message;

    ResultCode(int code, String message) {
        this.code = code;
        this.message = message;
    }
}