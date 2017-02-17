//
//  NetDataNameConfig.h
//  iSoccer
//
//  Created by pfg on 15/12/24.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import <Foundation/Foundation.h>

//上传图片事件;
static NSString *const EVENT_UPLOAD_PHOTO = @"event_upload_photo";

static NSString *const EVENT_DELETE_PHOTO = @"event_delete_photo";

static NSString *const EVENT_DELETE_SCORE = @"event_delete_score";

//点击球场;
static NSString *const EVENT_SHOW_FIELD_DETAIL = @"event_show_field_detail";

//点击进入订单;
static NSString *const EVENT_SHOW_FIELD_ORDER = @"event_show_field_order";

//显示主页;
static NSString *const EVENT_SHOW_FIELD_INDEX = @"event_show_field_index";

//从订单到主页;
static NSString * const EVENT_SHOW_FIELD_INDEX_BY_ORDER = @"event_show_field_by_order";

//从订单到主页;
static NSString * const EVENT_SHOW_FIELD_DETAIL_BY_ORDER = @"event_show_detail_by_order";

//订单详情;
static NSString *const EVENT_SHOW_ORDER_DETAIL = @"event_show_order_detail";


//删除成功刷新订单;
static NSString *const EVENT_REFRESH_ORDER = @"event_refresh_order";

//上传身份证;

//正面;
static NSString *const EVENT_UPLOAD_IDCARD_FRONT = @"event_upload_idcard_front";

//背面;
static NSString *const EVENT_UPLOAD_IDCARD_BACK = @"event_upload_idcard_back";

//删除通知;
static NSString *const EVENT_DELETE_NOTICE = @"event_delete_notice";

//比赛标题图片;
static NSString *const GAME_TITLE_IMAGE_KEY = @"pic";

//比赛标题;
static NSString *const GAME_TITLE_KEY = @"matchName";

//比分
static NSString *const GAME_SOURCE = @"score";

//队伍AB key
static NSString *const GAME_TEAM_A = @"teamName";
static NSString *const GAME_TEAM_B = @"matchOpponent";

//比赛类型;
static NSString *const GAME_TYPE = @"matchType";
//友谊赛;
static NSString *const FRIEND_GAME = @"friendly";
//正式比赛;
static NSString *const REGULATION_GAME = @"regulation";
//比赛时间
static NSString *const MATCH_TIME = @"matchTime";
//比赛照片;
static NSString *const MATCH_PIC_LIST = @"picList";
//比赛照片地址;
static NSString *const PIC_URL = @"pictureName";

//赛制;
static NSString *const GAME_FORMAT = @"formatName";
//队服
static NSString *const GAME_JERSEY = @"matchJersey";
//比赛信息;
static NSString *const MATCH_LIST = @"matchList";

//比赛费用;
static NSString *const MATCH_FEE = @"matchFee";
//比赛信息ID;
static NSString *const MATCH_ID = @"matchId";
//比赛地址;
static NSString *const MATCH_ADDRESS = @"matchAddress";
//比赛描述;
static NSString *const MATCH_DETAIL = @"matchDetail";
//用户列表;
static NSString *const USER_LIST = @"userList";

static NSString *const MATCH_SCORE = @"matchScore";


//用户ID
static NSString *const USER_ID = @"userId";

static NSString *const USER_TEAM_ID = @"userTeamId";

//用户设备唯一标识
static NSString *const UUID = @"uuid";

static NSString *const USER_TYPE = @"userType";

//电话;
static NSString *const PHONE_NUMBER = @"mobile";
//真是姓名;
static NSString *const REAL_NAME = @"realName";
//性别;
static NSString *const SEX = @"sex";
//年龄;
static NSString *const AGE = @"age";
//身高;
static NSString *const HEIGHT = @"height";
//体重;
static NSString *const WEIGHT = @"weight";
//国籍;
static NSString *const NATIONLITY = @"nationality";
//自我简介;
static NSString *const REMARK = @"remark";
//用户名字;
static NSString *const USER_NAME = @"nickName";
//邮箱;
static NSString *const EMAIL = @"email";
//位置;
static NSString *const POSITION = @"position";

//进球id
static NSString *const GOAL_ID = @"goalId";

//进球数量;
static NSString *const GOAL_COUNT = @"goalCount";

//队员id;
static NSString *const MEMBER_ID = @"memberId";

//进球信息;
static NSString *const GOAL_LIST = @"goalList";

//队伍列表;
static NSString *const TEAM_LIST = @"teamList";

static NSString *const NOTICE_LIST = @"noticeList";

static NSString *const TEAM_LABEL = @"teamLabel";

static NSString *const USER_PHOTO = @"photo";

static NSString *const MATCH_COUNT = @"matchCount";

static NSString *const GOAL_NUM = @"goal";

static NSString *const TEAM_FORMAT = @"teamFormat";

static NSString *const REGIST_TIME = @"registTime";

static NSString *const TEAM_REMARK = @"teamRemark";

static NSString *const TEAM_NAME = @"teamName";

static NSString *const TEAM_LOGO = @"teamLogo";

static NSString *const TEAM_ID = @"teamId";

static NSString *const FORMAT_FIVE = @"F011";
static NSString *const FORMAT_SEVEN = @"F012";
static NSString *const FORMAT_ELEVEN = @"F013";

static NSString *const FORMAT_ID = @"formatId";

static NSString *const MATCH_X = @"matchX";//经度
static NSString *const MATCH_Y = @"matchY";//纬度
