//
//  NetConfig.h
//  iSoccer
//
//  Created by pfg on 15/12/18.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import <Foundation/Foundation.h>


//外网http://apps.51ishare.com/football\
//外网IPhttp://120.24.44.190:8080/football\
//外网测试IPhttp://172.31.1.50:8519/football\
//内网http://172.31.1.40:8080/football\
//机器http://172.31.1.50:9527/football\
//POST

//登陆;
static NSString *const LOGIN_URL = @"http://120.24.44.190:8080/football/login.jhtml";
//注册;
static NSString *const REGISTER_URL = @"http://apps.51ishare.com/football/regist.jhtml";
//修改用户资料;
static NSString *const CHANGE_USER_DATA = @"http://apps.51ishare.com/football/updateUser.jhtml";

//上传头像;
static NSString *const UP_AVATAR_ICON = @"http://apps.51ishare.com/football/uploadPhoto.jhtml";


//GET
//获取比赛记录;
static NSString *const GET_RECORD = @"http://apps.51ishare.com/football/match.jhtml";

//更新比赛记录;
static NSString *const UPDATE_RECORD = @"http://apps.51ishare.com/football/updateMatch.jhtml";

//上传比赛记录照片;
static NSString *const UP_RECORD_PHOTO = @"http://apps.51ishare.com/football/recordImgUpload.jhtml";
//删除图片;
static NSString *const DELETE_RECORD_PHOTO = @"http://apps.51ishare.com/football/deleteImage.jhtml";

//获取进球信息;
static NSString *const GET_RECORD_SCORE = @"http://apps.51ishare.com/football/selectGoals.jhtml";

//更新进球信息;
static NSString *const UPDATE_RECORED_SCORE = @"http://apps.51ishare.com/football/updateGoal.jhtml";

//删除进球信息;
static NSString *const DELETE_RECORED_SCORE = @"http://apps.51ishare.com/football/deleteGoal.jhtml";
//增加进球信息;
static NSString *const ADD_RECORED_SCORE = @"http://apps.51ishare.com/football/addGoal.jhtml";
//更新比分;
static NSString *const UPDATE_SCORE = @"http://apps.51ishare.com/football/recoredMatch.jhtml";

//获取队伍信息;
static NSString *const GET_TEAM = @"http://apps.51ishare.com/football/userteam.jhtml";

//获取球队信息;
static NSString *const GET_TEAM_INFO = @"http://apps.51ishare.com/football/teamInfo.jhtml";

//球队详细;
static NSString *const GET_TEAM_DETAIL = @"http://apps.51ishare.com/football/teamById.jhtml";

//上传球队头像;
static NSString *const UP_TEAM_LOGO = @"http://apps.51ishare.com/football/uploadLogo.jhtml";

//更新球队信息;
static NSString *const UP_TEAM_DETAIL = @"http://apps.51ishare.com/football/updateTeam.jhtml";

//创建球队;
static NSString *const CREATE_TEAM = @"http://apps.51ishare.com/football/createTeam.jhtml";
//创建比赛;
static NSString *const CREATE_MATCH = @"http://apps.51ishare.com/football/createMatch.jhtml";

//刷新当前队伍信息主页;
static NSString *const REFRESH_TEAM_MAIN_INFO = @"http://apps.51ishare.com/football/matchList.jhtml";
//刷新所有队伍;
static NSString *const REFRESH_TEAM_ALL_INFO = @"http://apps.51ishare.com/football/allTeam.jhtml";

static NSString *const SEND_DIVICE_TOKEN = @"http://apps.51ishare.com/football/deviceToken.jhtml";

static NSString *const GET_NOTIFICENTER = @"http://apps.51ishare.com/football/noticeList.jhtml";

static NSString *const GET_NOTICE_DETAIL = @"http://apps.51ishare.com/football/noticeDetail.jhtml";

//退出登陆;
static NSString *const EXIT_LOGIN = @"http://apps.51ishare.com/football/loginOut.jhtml";
//获取验证码
static NSString *const GET_VERIFY_CODE = @"http://apps.51ishare.com/football/verifyCode.jhtml";


static NSString *const FORGET_PASSWORD = @"http://apps.51ishare.com/football/resetPassword.jhtml";

static NSString *const GET_FORGET_VERIFY_CODE = @"http://apps.51ishare.com/football/mobileCode.jhtml";

//加入球队;
static NSString *const JOIN_TEAM = @"http://apps.51ishare.com/football/joinTeam.jhtml";

//账户查询;
static NSString *const GET_PAY_ACCOUNT = @"http://apps.51ishare.com/football/userAcount.jhtml";

//支付宝支付结构GET
static NSString *const PAY_BY_ZFB = @"http://apps.51ishare.com/football/pay.jhtml";

static NSString *const UPLOAD_PAGE = @"http://apps.51ishare.com/football/allMatch.jhtml";

static NSString *const GET_ACCOUNT_RECORD = @"http://apps.51ishare.com/football/account.jhtml";
//充值GET
static NSString *const RECHARGE_MONEY = @"http://apps.51ishare.com/football/deposit.jhtml";
//提现
static NSString *const WITHDRAW_MONEY = @"http://apps.51ishare.com/football/addCash.jhtml";
//获取提现验证码
static NSString *const GET_WITHDRAW_SAFE_CODE = @"http://apps.51ishare.com/football/cashCode.jhtml";
//获取支付订单详情
static NSString *const GET_PAY_DETAIL = @"http://apps.51ishare.com/football/createPay.jhtml";

//加入球队
static NSString *const JOIN_MATCH = @"http://apps.51ishare.com/football/joinMatch.jhtml";
//请假;
static NSString *const LEAVE_MATCH = @"http://apps.51ishare.com/football/leave.jhtml";
//更改密码;
static NSString *const CHANGE_PASSWORD = @"http://apps.51ishare.com/football/updatePassword.jhtml";

//微信登陆;
static NSString *const WX_LOGIN = @"http://apps.51ishare.com/football/wechat/login.jhtml?code=";
static NSString *const AUTO_LOGIN = @"http://120.24.44.190:8080/football/auto/login.jhtml?openId=";
//天气获取;
static NSString *const WEATHER_GET = @"http://apps.51ishare.com/football/weather.jhtml";

//余额支付;
static NSString *const PAY_BY_ACCOUNT = @"http://apps.51ishare.com/football/payByAccount.jhtml";

//微信支付;
static NSString *const PAY_BY_WX = @"http://apps.51ishare.com/football/wechatPay/createPay.jhtml";

//微信充值;
static NSString *const RECHARGE_BY_WX = @"http://apps.51ishare.com/football/wechatPay/recharge.jhtml";
//一键阅读
static NSString *const ONE_KEY_READING = @"http://apps.51ishare.com/football/oneKeyReading.jhtml";
//获取绑定手机验证码
static NSString *const GET_CODE = @"http://apps.51ishare.com/football/getCode.jhtml";

//绑定手机号码;
static NSString *const BINDING_CODE = @"http://apps.51ishare.com/football/binding.jhtml";

//新通知;
static NSString *const ALL_NOTICE = @"http://apps.51ishare.com/football/allNotice.jhtml";


//踢出比赛
static NSString *const DELETE_MATCH_MEMBER = @"http://apps.51ishare.com/football/deleteMember.jhtml";

//取消比赛
static NSString *const CANCEL_MATCH = @"http://apps.51ishare.com/football/cancel.jhtml";

//赛事列表;
static NSString *const ALL_COMPETITION = @"http://apps.51ishare.com/football/event/findAll.jhtml";

//获取赛事队伍;
static NSString *const GET_TEAM_BY_TYPE = @"http://apps.51ishare.com/football/findTeamByUserId.jhtml";

//上传身份证;
static NSString *const UPLOAD_IDCARD = @"http://apps.51ishare.com/football/event/uploadIdentityCard.jhtml";

//检查是否参赛
static NSString *const CHECK_IS_JOIN = @"http://apps.51ishare.com/football/event/check.jhtml";

//申请参赛
static NSString *const JOIN_EVENT = @"http://apps.51ishare.com/football/event/join.jhtml";


//删除通知;
static NSString *const DELETE_NOTICE = @"http://apps.51ishare.com/football/deleteNotice.jhtml";

//判断支付;
static NSString *const JUDGE_UN_CHARGE = @"http://apps.51ishare.com/football/unCharge.jhtml";

//删除队员;
static NSString *const DELETE_MEMBER = @"http://apps.51ishare.com/football/deleteTeamMember.jhtml";

//判断更新；
static NSString *const JUDGE_VERSION_UPDATE = @"http://apps.51ishare.com/football/getVersion.jhtml";

//获取预订球场;
static NSString *const GET_ALL_RESERVATION = @"http://apps.51ishare.com/football/field/getShopFieldAll.jhtml";
//获取球场场地详情 参数fieldId
static NSString *const GET_FIELD_DETAIL = @"http://apps.51ishare.com/football/field/findShopFieldImgAll.jhtml";

//获取球场订单 String fieldId, String shopId,String userId, String uuid
static NSString *const GET_FIELD_ORDER = @"http://apps.51ishare.com/football/field/getFieldReserve.jhtml";

//获取球场订单号 String mobiel, String fieldPriceId,String footballGoodsIdStr
static NSString *const CREAGE_ORDER_PAY = @"http://apps.51ishare.com/football/order/createOrderPay.jhtml";

//获取已预订订单list  String userId,String uuid,
static NSString *const GET_ORDER_LIST = @"http://apps.51ishare.com/football/order/getOrderList.jhtml";

//获取已预订订单list  String userId,String uuid,
static NSString *const DELETE_ORDER_ONE= @"http://apps.51ishare.com/football/order/deleteOrder.jhtml";


//单独获取某球场信息; String shopId
static NSString *const GET_SHOP_DETAIL_BY_SHOPID = @"http://apps.51ishare.com/football/field/getShopField.jhtml";

//单独获取某场地信息; String fieldId

static NSString *const GET_FIELD_DETAIL_BY_FIELDID = @"http://apps.51ishare.com/football/field/findShopFieldAndImg.jhtml";

//取消预订
static NSString *const CANCEL_RESERVATION_ORDER = @"http://apps.51ishare.com/football/order/cancelOrderPay.jhtml";

//qq登录;
static NSString *const QQ_LOGIN = @"http://apps.51ishare.com/football/qq/login.jhtml";

//weibo登录;
static NSString *const WEIBO_LOGIN = @"http://apps.51ishare.com/football/weibo/login.jhtml";


