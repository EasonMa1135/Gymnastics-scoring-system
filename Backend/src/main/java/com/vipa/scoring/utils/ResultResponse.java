package com.vipa.scoring.utils;
import com.vipa.scoring.utils.ResultCode;
/**
 * @author kenx
 * @version 1.0
 * @date 2021/6/17 16:30
 * 响应结果返回封装
 */
public class ResultResponse {
    private static final String DEFAULT_SUCCESS_MESSAGE = "SUCCESS";

    // 只返回状态
    public static Result success() {
        return new Result()
                .setResult(ResultCode.SUCCESS);
    }

    // 成功返回数据
    public static Result success(Object data) {
        return new Result()
                .setResult(ResultCode.SUCCESS, data);
    }

    // 失败
    public static Result failure(ResultCode resultCode) {
        return new Result()
                .setResult(resultCode);
    }

    // 失败
    public static Result failure(ResultCode resultCode, Object data) {
        return new Result()
                .setResult(resultCode, data);
    }

}
