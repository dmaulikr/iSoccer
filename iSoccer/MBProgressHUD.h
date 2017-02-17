////
//MBProgressHUD.h
//0.9 版
//在 2.4.09 上创建由马特伊 Bukovinski。
////
//
//此代码分布下的 MIT 许可协议的条款。
//
//版权所有 (c) 2013年马特伊 Bukovinski
////
//权限授予现，免费，向任何人索取这份
//这个软件和相关的文档文件 （"软件"） 来处理
//在软件中不受限制，包括但不限于权利
//若要使用，复制、 修改、 合并、 发布、 分发、 再许可和/或出售
//将复制的软件，并允许该软件是谁的人
//装备来做到这一点，但须符合以下条件：
////
//上面的版权声明和本许可声明应包括在
//所有的副本或实质性部分的软件。
////
//该软件按"原样"提供，没有任何善良、 快递或保修
//暗示保证，包括但不限于对适销性、 担保
//适合特定用途和非侵害性。不在任何情况
//作者或者版权持有者将承担责任的任何索赔、 损害赔偿或其他
//责任，无论是在合同、 侵权行为或以其他方式，而引起，
//出的或与本软件或使用或其他交易
//本软件。

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol MBProgressHUDDelegate;


typedef enum {
	/** 使用 UIActivityIndicatorView 显示进度。这是默认值。 */
	MBProgressHUDModeIndeterminate,
	/**  使用轮，如饼图、 进展视图显示进度 */
	MBProgressHUDModeDeterminate,
	/** 使用水平进度栏显示进度 */
	MBProgressHUDModeDeterminateHorizontalBar,
	/** 使用环形进展视图显示进度. */
	MBProgressHUDModeAnnularDeterminate,
	/**  显示自定义视图 */
	MBProgressHUDModeCustomView,
	/** 显示只有标签*/
	MBProgressHUDModeText
} MBProgressHUDMode;

typedef enum {
	/** 不透明度动画*/
	MBProgressHUDAnimationFade,
	/** 不透明度 + 缩放动画 */
	MBProgressHUDAnimationZoom,
	MBProgressHUDAnimationZoomOut = MBProgressHUDAnimationZoom,
	MBProgressHUDAnimationZoomIn
} MBProgressHUDAnimation;


#ifndef MB_INSTANCETYPE
#if __has_feature(objc_instancetype)
	#define MB_INSTANCETYPE instancetype
#else
	#define MB_INSTANCETYPE id
#endif
#endif

#ifndef MB_STRONG
#if __has_feature(objc_arc)
	#define MB_STRONG strong
#else
	#define MB_STRONG retain
#endif
#endif

#ifndef MB_WEAK
#if __has_feature(objc_arc_weak)
	#define MB_WEAK weak
#elif __has_feature(objc_arc)
	#define MB_WEAK unsafe_unretained
#else
	#define MB_WEAK assign
#endif
#endif

#if NS_BLOCKS_AVAILABLE
typedef void (^MBProgressHUDCompletionBlock)();
#endif


/**
 * 显示一个简单的平视显示器窗口包含一个进度指示器和短消息两个可选标签。
 *
 * 这是一个简单的投递类用于显示进度 HUD 视图类似于苹果公司的私有的 UIProgressHUD 类。
 * MBProgressHUD 窗口跨越整个空间给它由 initWithFrame 构造函数并捕获了所有
 * 用户输入在这一地区，从而防止对视图下方组件的用户操作。平视显示器本身是
 * 绘制圆形的半透明视图，哪些调整根据用户指定的内容作为居中。
 *
 * 此视图支持四种操作模式：
 *-MBProgressHUDModeIndeterminate-显示 UIActivityIndicatorView
 *-MBProgressHUDModeDeterminate-显示自定义进度指示器圆
 *-MBProgressHUDModeAnnularDeterminate-显示一个自定义的环形进度指示器
 *-MBProgressHUDModeCustomView-显示任意用户指定的视图 （@see 自定义视图）
 *
 * 所有三种模式可以具有可选的标签分配：
 *-如果设置 labelText 属性和非空然后包含提供的内容的标签位于下方
 * 指示视图。
 *-如果还设置 detailsLabelText 属性，然后另一个标签放置在第一个标签的下面。
 */
@interface MBProgressHUD : UIView

/**
 * 创建新的平视显示器，将它添加到提供的视图并显示它。这种方法的对应是 hideHUDForView: 动画：。
 *
 * @param 视图平视显示器将被添加到视图
 * @param 动画的如果设置为 YES 平视显示器将显示使用当前的 animationType。如果设置不会往平视显示器将不会使用
 * 同时出现的动画。
 * @return 创建的 HUD 的引用。
 *
 * @see hideHUDForView: 动画：
 * @see animationType
 */
+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

/**
 * 发现最顶端 HUD 子视图，并隐藏它。这种方法的对应是 showHUDAddedTo: 动画：。
 *
 * @param 查看要寻找 HUD 子视图的视图。
 动画的如果设置为 YES HUD 的 * @param 将会消失，使用当前的 animationType。如果设置不会往平视显示器将不会使用
 * 动画而消失。
 * @return 是如果平视显示器被发现和清除，否则。
 *
 * @see showHUDAddedTo: 动画：
 * @see animationType
 */
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/**
 * 发现所有 HUD subviews 和隐藏它们。
 *
 * @param 查看要寻找 HUD 子视图的视图。
 使用当前的 animationType * @param 动画的如果设置为 YES 平视显示器就会消失。如果设置不会往平视显示器将不会使用
 * 动画而消失。
 * @return 的 Hud 数发现并删除。
 *
 * @see hideHUDForView: 动画：
 * @see animationType
 */
+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

/**
 * 查找最顶端 HUD 子视图并返回它。
 *
 * @param 查看要搜索的人。
 * @return A 到最后一个引用发现的 HUD 子视图。
 */
+ (MB_INSTANCETYPE)HUDForView:(UIView *)view;

/**
 * 发现所有 HUD subviews，并将其返回。
 *
 * @param 查看要搜索的人。
 * @return 所有找到的 HUD 意见 （MBProgressHUD 对象数组）。
 */
+ (NSArray *)allHUDsForView:(UIView *)view;

/**
 * 初始化与窗口的边界 HUD 方便构造函数。调用带有指定的构造函数
 * window.bounds 作为参数。
 *
 * @param 窗口将提供 HUD 的界限的窗口实例。应该是相同的实例
 * 上海华盈 HUD （即 HUD 将添加到的窗口）。
 */
- (id)initWithWindow:(UIWindow *)window;

/**
 * 初始化视图的边界与 HUD 方便构造函数。调用带有指定的构造函数
 * view.bounds 作为参数
 *
 * @param 视图将提供 HUD 的界限的视图实例。应该是相同的实例
 * 上海华盈 HUD （即 HUD 将添加到的视图）。
 */
- (id)initWithView:(UIView *)view;

/**
 * 显示平视显示器。您需要确保主线程此方法调用后不久完成其运行的循环所以
 * 用户界面可以进行更新。调用此方法，当你的任务已经是建立在一个新的线程中执行
 * （例如，当使用类似于 NSOperation 或调用异步调用像 NSURLRequest）。
 *
 * @param 动画的如果设置为 YES 平视显示器将显示使用当前的 animationType。如果设置不会往平视显示器将不会使用
 * 同时出现的动画。
 *
 * @see animationType
 */
- (void)show:(BOOL)animated;

/**
 * 隐藏 HUD。这还要求 hudWasHidden： 委托。这是表演的对应： 方法。使用它可以
 * 当你的任务完成时，隐藏 HUD。
 *
 动画的如果设置为 YES HUD 的 * @param 将会消失，使用当前的 animationType。如果设置不会往平视显示器将不会使用
 * 动画而消失。
 *
 * @see animationType
 */
- (void)hide:(BOOL)animated;

/**
 * 在延迟后隐藏 HUD。这还要求 hudWasHidden： 委托。这是表演的对应： 方法。使用它可以
 * 当你的任务完成时，隐藏 HUD。
 *
 动画的如果设置为 YES HUD 的 * @param 将会消失，使用当前的 animationType。如果设置不会往平视显示器将不会使用
 * 动画而消失。
 * @param 延迟延迟秒，直到平显处于隐藏状态。
 *
 * @see animationType
 */
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

/**
 * 显示 HUD 而后台任务执行中一个新的线程，然后躲起来平视显示器。
 *
 * 此方法还需要照顾 autorelease 池所以你的方法并没有去关注设置
 * 池。
 *
 * @param 方法显示在平视显示器时执行的方法。此方法将在一个新的线程中执行。
 * @param 的目标目标方法所属的对象。
 * @param 对象转换成可选的对象将被传递到该方法。
 * @param 如果动画效果设置为 YES HUD 将 （迪斯） 显示使用当前的 animationType。如果设置不会往平视显示器将不会使用
 * （dis） 出现时的动画。
 */
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;

#if NS_BLOCKS_AVAILABLE

/**
 * 显示平视显示器，而块正在执行一个背景队列，然后隐藏 HUD。
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completionBlock：
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block;

/**
 * 显示平视显示器，而块正在执行一个背景队列，然后隐藏 HUD。
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completionBlock：
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 * 显示平视显示器，而块执行在指定的调度队列中，然后隐藏 HUD。
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completionBlock：
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue;

/**
 * 显示 HUD 块在指定的调度队列中，在执行时将完成块执行在主要的队列中，然后再隐藏 HUD。
 *
 * @param 如果动画效果设置为 YES HUD 将 （迪斯） 显示使用当前的 animationType。如果设置为否平视显示器将
 * （dis） 出现时使用动画。
 * @param 块要执行而 HUD 显示块。
 * @param 队列调度队列的块应该被执行。
 * @param 完成要完成后执行的块。
 *
 * @see completionBlock
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
		  completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 * 获取调用后平视显示器完全隐藏的块。
 */
@property (copy) MBProgressHUDCompletionBlock completionBlock;

#endif

/**
 * MBProgressHUD 操作模式。默认值是 MBProgressHUDModeIndeterminate。
 *
 * @see MBProgressHUDMode
 */
@property (assign) MBProgressHUDMode mode;

/**
 * 当平视显示器显示和隐藏时应使用的动画类型。
 *
 * @see MBProgressHUDAnimation
 */
@property (assign) MBProgressHUDAnimation animationType;

/**
 * UIView （例如，UIImageView） 将显示在 MBProgressHUDModeCustomView 的平视显示器时。
 * 为获得最佳效果使用 37 由 37 像素视图 （所以边界匹配内置指示器边界中）。
 */
@property (MB_STRONG) UIView *customView;

/**
 * HUD 的委托对象。
 *
 * @see MBProgressHUDDelegate
 */
@property (MB_WEAK) id<MBProgressHUDDelegate> delegate;

/**
 * 可选的短消息，下面的活动指示灯显示。平视显示器自动调整大小以适合
 * 整个案文。如果文本太长会得到剪下通过显示"......"在结束了。如果左不变或
 的设置 ； @""，然后不显示任何消息。
 */
@property (copy) NSString *labelText;

/**
 * LabelText 消息下方显示可选详细信息消息。只是如果，将显示此消息 labelText
 * 属性也设置，有别于空字符串 （@""）。详细信息文本可以跨多个行。
 */
@property (copy) NSString *detailsLabelText;

/**
 * 平视显示器窗口的不透明度。默认值为 0.8 （不透明度为 80%）。
 */
@property (assign) float opacity;

/**
 * 本的平视显示器窗口颜色。默认为黑色。如果设置了此属性，使用设置颜色
 * 不使用此 UIColor 和不透明度属性。使用保留的因为在执行复制
 * UIColor 基准颜色 （如 [UIColor 它的透明度]） 导致 copyZone 问题。
 */
@property (MB_STRONG) UIColor *color;

/**
 * X 轴偏移量相对于中心的上海华盈 HUD。
 */
@property (assign) float xOffset;

/**
 * Y 轴偏移量相对于中心的上海华盈 HUD。
 */
@property (assign) float yOffset;

/**
 * HUD 边缘和 HUD 元素 （标签、 指标或自定义视图） 之间的空间量。
 * 默认为 20.0
 */
@property (assign) float margin;

/**
 * HUD 的圆角半径
 * 默认为 10.0
 */
@property (assign) float cornerRadius;
/**
 * 覆盖 HUD 背景视图使用径向渐变。
 */
@property (assign) BOOL dimBackground;

/*
 * 宽限期是可能运行时调用的方法都没有的时间 （以秒为单位）
 * 显示平视显示器。如果在任务完成之前的恩典时间耗尽，平视显示器将
 * 不会显示在所有。
 * 这可能用于防止平视显示器显示为很短的任务。
 * 默认值为 0 （没有恩典时间）。
 * 当已知任务状态时，仅支持恩典时间功能 ！
 * @see taskInProgress
 */
@property (assign) float graceTime;

/**
 * 最短时间 （以秒为单位） 所示的 HUD。
 * 这将避免被显示在 hud 和比立即隐藏的问题。
 * 默认值为 0 （没有最小显示时间）。
 */
@property (assign) float minShowTime;

/**
 * 指示执行的操作正在进行。正确的 graceTime 操作所需。
 * 如果你没有设置 graceTime (不同于 0.0） 这种做法无济于事。
 * 在使用 showWhileExecuting:onTarget:withObject 时，会自动设置此属性： 动画：。
 * 当线程完成在 HUD （即，当显示： 和隐藏： 方法直接使用），
 * 您需要设置此属性，您的任务的开始和完成才能有正常的 graceTime
 * 功能。
 */
@property (assign) BOOL taskInProgress;

/**
 * 从隐藏时其父视图中移除平视显示器。
 * 默认设置为否
 */
@property (assign) BOOL removeFromSuperViewOnHide;

/**
 * 用于主要标签的字体。如果默认值不是足够，请设置此属性。
 */
@property (MB_STRONG) UIFont* labelFont;

/**
 * 用于主要标签的颜色。如果默认值不是足够，请设置此属性。
 */
@property (MB_STRONG) UIColor* labelColor;

/**
 * 用于详细信息标签的字体。如果默认值不是足够，请设置此属性。
 */
@property (MB_STRONG) UIFont* detailsLabelFont;

/**
 * 用于详细信息标签的颜色。如果默认值不是足够，请设置此属性。
 */
@property (MB_STRONG) UIColor* detailsLabelColor;

/**
 * 活动指示器的颜色。默认值为 [UIColor 中微]
 * 无预 iOS 5。
 */
@property (MB_STRONG) UIColor *activityIndicatorColor;

/**
 * 进度指示器，从 0.0 到 1.0 的进展情况。默认值为 0.0。
 */
@property (assign) float progress;

/**
 * 平视显示器挡板最小大小。默认值为 CGSizeZero （无最低的大小）。
 */
@property (assign) CGSize minSize;


/**
 * 平视显示器挡板实际大小。
 * 您可以使用这个来限制触摸的挡板咏叹调只处理。
 * @see https://github.com/jdg/MBProgressHUD/pull/200
 */
@property (atomic, assign, readonly) CGSize size;


/**
 * 强制平视显示器尺寸必须平等对待，如果可能的话。
 */
@property (assign, getter = isSquare) BOOL square;

@end


@protocol MBProgressHUDDelegate <NSObject>

@optional

/**
 * 在 HUD 完全隐藏在屏幕之后调用。
 */
- (void)hudWasHidden:(MBProgressHUD *)hud;

@end


/**
 * 发展观被填满了一个圆圈 （饼图） 显示一定的进步。
 */
@interface MBRoundProgressView : UIView 

/**
 * 进展 (0.0 到 1.0)
 */
@property (nonatomic, assign) float progress;
/**
 颜色的进展。
 * 默认为白色 [UIColor 中微]
 */
@property (nonatomic, MB_STRONG) UIColor *progressTintColor;

/**
 颜色背景 （非进度）。
 * 默认为半透明白色 （alpha 0.1）
 */
@property (nonatomic, MB_STRONG) UIColor *backgroundTintColor;

/*
 * 显示模式-无 = 圆或是 = 环形。要舍入的默认值。
 */
@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@end


/**
 * 扁条发展观。
 */
@interface MBBarProgressView : UIView

/**
 * 进展 (0.0 到 1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * 条形图边框线颜色。
 * 默认为白色 [UIColor 中微]。
 */
@property (nonatomic, MB_STRONG) UIColor *lineColor;

/**
 * 栏的背景色。
 * 默认值以清除 [UIColor 背景色] ；
 */
@property (nonatomic, MB_STRONG) UIColor *progressRemainingColor;


/**
 * 酒吧进度颜色。
 * 默认为白色 [UIColor 中微]。
 */
@property (nonatomic, MB_STRONG) UIColor *progressColor;

@end
