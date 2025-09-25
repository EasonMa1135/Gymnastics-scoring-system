package com.vipa.scoring.utils;
import com.vipa.scoring.utils.ResultCode;
import lombok.Data;

import java.io.Serializable;

/**
 * @author kenx
 * @version 1.0
 * @date 2021/6/17 15:47
 * 统一API响应结果格式封装
 */
@Data
public class Result<T> implements Serializable {

    private static final long serialVersionUID = 6308315887056661996L;
    private Integer code;
    private String message;
    private T data;


    public Result setResult(ResultCode resultCode) {
        this.code = resultCode.getCode();
        this.message = resultCode.getMessage();
        return this;
    }

    public Result setResult(ResultCode resultCode,T data) {
        this.code = resultCode.getCode();
        this.message = resultCode.getMessage();
        this.setData(data);
        return this;
    }


}
