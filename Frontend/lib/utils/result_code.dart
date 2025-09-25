enum ResultCode {
  SUCCESS,
  BAD_REQUEST,
  UNAUTHORIZED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  METHOD_NOT_ALLOWED,
  USER_NOT_FOUND,
  USER_EXISTED,
  PASSWORD_ERROR,
  IDENTITY_SAME,
  VERIFY_EXISTED,
  VERIFY_NOT_FOUND,
  VERIFY_DEALT,

  /*参数错误:1001-1999*/
  PARAMS_IS_INVALID,
  PARAMS_IS_BLANK;
}



int getResultCode(ResultCode result_code) {
  switch (result_code) {
    case ResultCode.SUCCESS:
      return 200;
    case ResultCode.BAD_REQUEST:
      return 400;
    case ResultCode.UNAUTHORIZED:
      return 401;
    case ResultCode.NOT_FOUND:
      return 404;
    case ResultCode.INTERNAL_SERVER_ERROR:
      return 500;
    case ResultCode.METHOD_NOT_ALLOWED:
      return 405;
    case ResultCode.USER_NOT_FOUND:
      return 101;
    case ResultCode.USER_EXISTED:
      return 102;
    case ResultCode.PASSWORD_ERROR:
      return 103;
    case ResultCode.IDENTITY_SAME:
      return 104;
    case ResultCode.VERIFY_EXISTED:
      return 105;
    case ResultCode.VERIFY_NOT_FOUND:
      return 106;
    case ResultCode.VERIFY_DEALT:
      return 107;
    case ResultCode.PARAMS_IS_INVALID:
      return 1001;
    case ResultCode.PARAMS_IS_BLANK:
      return 1002;
    default:
      return -1;
  }
}