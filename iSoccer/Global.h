//
//  Global.h
//  iSoccer
//
//  Created by pfg on 15/12/18.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserData.h"
#import "MBProgressHUD.h"
#import "TeamData.h"
#import "MatchInfo.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "PayFastDetailViewController.h"
#import "RechargeViewController.h"
#import "PayViewController.h"
#import "IDData.h"


typedef NS_ENUM(NSInteger,LdqSex){
    LdqSexMan,
    LdqSexWuman
};

static NSString *const ACCOUNT_SAVE = @"account_save";

static NSString *const PASSWORD_SAVE = @"password_save";

@interface Global : NSObject


+ (void) alertWithTitle:(NSString *)title msg:(NSString *)msg;

+ (NSString*)getDateByTime:(NSString*)time isSimple:(BOOL)simple;

+ (NSString*)getSimpleDateByTime:(NSString*)time;

+ (instancetype)getInstance;

+ (void)loadImageFadeIn:(UIImageView*)imageView andUrl:(NSString*)imageUrl isLoadRepeat:(BOOL)repeat;

+ (id)JSONObjectWithData:(NSData *)data;

+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
//添加下划线;
+ (void)addTextBottomLineAtButton:(UIButton*)button andText:(NSString*)string andTextColor:(UIColor*)color;

-(NSString *) toHex:(long long int) num;

@property (nonatomic,assign,readwrite)LdqSex sex;

@property (nonatomic,strong)NSMutableArray *gameDatas;

@property (nonatomic,strong)NSString *diviceToken;

//是否更新主界面;
@property (nonatomic,assign)BOOL isUpdate;

@property (nonatomic,strong)UserData *userData;

@property (nonatomic,assign)BOOL isChangeUserData;

@property (nonatomic,strong)NSString * userDataType;

@property (nonatomic,strong)NSString * teamDataType;

@property (nonatomic,assign)BOOL isMeTeam;

+ (UserData*)setUserDataByDictionary:(NSMutableDictionary*)data;

- (void)setGameDataByDictionary:(NSMutableArray *)gameDatas;

@property (nonatomic,strong)UIImage * avatarImage;

@property (nonatomic,strong)UIImage * teamImage;

@property (nonatomic,strong)MainViewController * mainVC;

@property (nonatomic,strong)MBProgressHUD *HUD;

@property (nonatomic,strong)NSMutableArray *teamList;

@property (nonatomic,strong)NSMutableArray *notifiList;

@property (nonatomic,strong)NSMutableArray *payAccountList;


//是否更新球队详情;
@property (nonatomic,assign)BOOL isUpdateCreateTeamDetail;

//是否更新创建球队信息页;
@property (nonatomic,assign)BOOL isUpdateCreateTeamMessage;

@property (nonatomic,strong)NSMutableDictionary *teamMessageData;

//是否更新创建球队列表;
@property (nonatomic,assign)BOOL isUpdateCreateTeamList;

@property (nonatomic,strong)TeamData *teamData;

@property (nonatomic,strong)TeamData *createTeamData;//创建队伍信息;

@property (nonatomic,assign)BOOL isInputTeamInfo;//是否写入创建队伍信息;

@property (nonatomic,strong)MatchInfo * matchInfo;//创建比赛信息;

@property (nonatomic,assign)BOOL isInputMatchInfo;//是否写入比赛信息;


@property (nonatomic,strong)NSString * currentTeamId;//当前队伍id

@property (nonatomic,assign)CGFloat userMatchX;
@property (nonatomic,assign)CGFloat userMatchY;

@property (nonatomic,assign)BOOL isCreateMatchSuccssed;//创建比赛成功;
@property (nonatomic,assign)BOOL isCreateTeamSuccssed;//创建队伍成功;

@property (nonatomic,assign)BOOL isLogin;//是否登陆;

@property (nonatomic,strong)NSString * currentAccountId;

@property (nonatomic,assign)BOOL isPaySuccessed;//支付成功;
@property (nonatomic,assign)BOOL isWithdrawSuccessed;//提现成功;

@property (nonatomic,strong)NSString *currentMatchId;//当前比赛ID;

@property (nonatomic,strong)NSMutableDictionary* currentPayData;//当前支付信息;

@property (nonatomic,assign)BOOL isDeleting;//是否删除中 .

@property (nonatomic,assign)BOOL isOtherLogin;//是否是其他方式登录;

@property (nonatomic,strong)NSString *otherType;//其他方式登录type;

@property (nonatomic,strong)LoginViewController * loginView;

@property (nonatomic,assign)BOOL isRecharge;//是否是充值;

@property (nonatomic,strong)PayFastDetailViewController * payFastVC;
@property (nonatomic,strong)RechargeViewController * rechargeVC;

@property (nonatomic,strong)PayViewController * payVC;

@property (nonatomic,strong)NSString * currentPhoneNumber;

@property (nonatomic,strong)NSString * currentDeleteMatchId;

@property (nonatomic,strong)NSString * currentDeleteTeamId;

@property (nonatomic,assign)BOOL isDeleteMatchMemberSuccessed;

@property (nonatomic,strong)NSMutableDictionary * currentMatchData;

@property (nonatomic,strong)NSMutableArray * eventList;

@property (nonatomic,strong)IDData *currentIDdata;


@property (nonatomic,assign)BOOL isInputIdData;

@property (nonatomic,strong)NSString * currentDeleteNoticeId;

@property (nonatomic,assign)BOOL isDeleteMemberSuccessed;

@property (nonatomic,assign)BOOL isFirstLogin;

@property (nonatomic,strong)NSMutableArray * reservationDatas;

@property (nonatomic,strong)NSString * reservationPhoneNumber;

@property (nonatomic,assign)BOOL isUpdateReservationPhoneNumber;

@property (nonatomic,strong)NSString * fieldOrderCheckCode;

@property (nonatomic,strong)UIMenuController * mCtrl;

@end
