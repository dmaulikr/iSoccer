//
//  MapViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/19.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "Global.h"
@interface MapViewController ()<MAMapViewDelegate,AMapSearchDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    MAPointAnnotation *pointAnnotation;
    MAPinAnnotationView*annotationView;
    BOOL isSetUserLocation;
    IBOutlet UISearchBar *_searchBar;
    NSString *locationCity;
    
    UITableView * addressTabelView;
    
    NSMutableArray * dataSource;
    NSString * city;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSetUserLocation = NO;
    
    dataSource = [NSMutableArray array];
    
    NSArray * nameArray = @[@"成都足球公园",@"成都足球广场",@"皇家贝里斯足球俱乐部",@"FF体育公园",@"007足球俱乐部",@"经天320足球公园",@"三联万科小步足球公园",@"沸腾足球俱乐部",@"仕爱康足球公园",@"腾翼足球公园",@"绿洲足球公园",@"金牛足球公园",@"99号球会",@"锐博足球公园",@"88号足球训练会馆",@"仁德足球公园",@"绿茵天下足球俱乐部",@"光华足球俱乐部",@"909足球俱乐部",@"跳跳体育足球运动公园"];
    
    NSArray * latitudeArray = @[@30.574468f,@30.602005f,@30.670520f,@30.663603,@30.720661f,@30.596542f,@30.666550f,@30.608650f,@30.662192f,@30.496010f,@30.547380f,@30.706344f,@30.705607f,@30.501375f,@30.591591f,@30.706845f,@30.659197f,@30.669099f,@30.629092f,@30.647406f];
    NSArray * longitudeArray = @[@104.035566f,@104.024847f,@104.003026f,@103.958397,@103.984061f,@104.103096f,@104.122514f,@104.114560f,@104.122479f,@104.083797f,@104.045000,@103.989114f,@103.947388f,@104.068251f,@104.136714f,@104.144679f,@104.167042,@103.943936f,@104.018612f,@103.966844f];
    
    
    for(NSInteger i = 0;i < nameArray.count;i++)
    {
        AMapTip * costAddress = [[AMapTip alloc]init];
        costAddress.name = nameArray[i];
        
        AMapGeoPoint * point = [[AMapGeoPoint alloc]init];
        
        NSNumber * numberX = latitudeArray[i];
        NSNumber * numberY = longitudeArray[i];
        point.latitude = numberX.doubleValue;
        point.longitude = numberY.doubleValue;
        costAddress.location = point;
        [dataSource addObject:costAddress];
    }
    
    
    
    [MAMapServices sharedServices].apiKey = @"d8d256064d8f502d8e209102074ea045";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, (_searchBar.frame.size.height + _searchBar.frame.origin.y), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - (_searchBar.frame.size.height + _searchBar.frame.origin.y))];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;
    
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    
    //添加当前位置的大头针
    pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.title = @"选择位置";
    pointAnnotation.subtitle = @"长按可以拖动大头针";
    
    [_mapView addAnnotation:pointAnnotation];
    
    
    [AMapSearchServices sharedServices].apiKey = @"d8d256064d8f502d8e209102074ea045";
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    addressTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/2) style:UITableViewStylePlain];
    
    addressTabelView.delegate = self;
    addressTabelView.dataSource = self;
    
    addressTabelView.rowHeight = 40;
    
    [self.view addSubview:addressTabelView];
    
}

#pragma mark -- AMapSearchDelegate;

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %zd",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    
    //[dataSource removeAllObjects];
    
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.address];
        locationCity = p.city;
        //[dataSource addObject:p];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
    
    //[addressTabelView reloadData];
    
    [self showAddressTableView];
    [[Global getInstance].HUD hide:YES];
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    
    [dataSource removeAllObjects];
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %zd", response.count];
    NSString *strtips = @"";
    for (AMapTip *p in response.tips) {
        strtips = [NSString stringWithFormat:@"%@\nTip: %@", strtips, p.name];
        [dataSource addObject:p];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strtips];
    NSLog(@"InputTips: %@", result);
    
    [addressTabelView reloadData];
    
    [self showAddressTableView];
    
    [[Global getInstance].HUD hide:YES];
    
}

- (void)showAddressTableView{
    
    CGFloat height =  self.view.frame.size.height/2;
    
    [UIView animateWithDuration:0.4 animations:^{
        addressTabelView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - height/2);
    }];
}
-(void)hideAddressTableView:(BOOL)isSelected{
    [UIView animateWithDuration:0.4 animations:^{
        addressTabelView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height + self.view.frame.size.height/2);
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark -- MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;

        return annotationView;
    }
    return nil;
}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        if(isSetUserLocation == NO)
        {
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
            
            
            [self requestBylocation:userLocation.coordinate];
            [Global getInstance].HUD.labelText = @"搜索中..";
            
            [[Global getInstance].HUD show:YES];
            
            [self.view addSubview:[Global getInstance].HUD];
            
            isSetUserLocation = YES;
            [[Global getInstance].HUD hide:YES afterDelay:15];
        }
    }
}


- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState
{
    switch (newState) {
        case MAAnnotationViewDragStateStarting: {
            NSLog(@"拿起");
            return;
        }
        case MAAnnotationViewDragStateDragging: {
            NSLog(@"开始拖拽");
            return;
        }
        case MAAnnotationViewDragStateEnding: {
            CLLocationCoordinate2D destCoordinate=view.annotation.coordinate;
            NSLog(@"latitude : %f,longitude: %f",destCoordinate.latitude,destCoordinate.longitude);

            [self requestBylocation:destCoordinate];
            
            [Global getInstance].HUD.labelText = @"搜索中..";
            
            [[Global getInstance].HUD show:YES];
            
            [self.view addSubview:[Global getInstance].HUD];
            
            [[Global getInstance].HUD hide:YES afterDelay:15];
            
            return;
        }
        default:
            return;
    }
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [_searchBar resignFirstResponder];
}

- (void)requestBylocation:(CLLocationCoordinate2D)coordinate{
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.keywords = @"足球|学校|路|街|广场|院";
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"生活服务|地名地址信息|公共设施|商务住宅|体育休闲服务|风景名胜|医疗保健服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.radius = 1000;
    
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
}

- (void)requestByName:(NSString*)name{

    //构造AMapInputTipsSearchRequest对象，设置请求参数
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = name;
    tipsRequest.city = locationCity;
    
    //发起输入提示搜索
    [_search AMapInputTipsSearch: tipsRequest];
    
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    //点击搜索;
    [self requestByName:searchBar.text];
    
    [Global getInstance].HUD.labelText = @"搜索中..";
    
    [self.view addSubview:[Global getInstance].HUD];
    [[Global getInstance].HUD show:YES];
    [[Global getInstance].HUD hide:YES afterDelay:15];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"mapCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    
    AMapTip * aTip = (AMapTip*)dataSource[indexPath.row];
    AMapPOI * aPoi = (AMapPOI*)dataSource[indexPath.row];
    if(aTip == nil)
    {
        cell.textLabel.text = aPoi.address;
        
    }else{
        
        cell.textLabel.text = aTip.name;
    }
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar resignFirstResponder];
    [self hideAddressTableView:YES];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    AMapTip * aTip = (AMapTip*)dataSource[indexPath.row];

    AMapPOI * aPoi = (AMapPOI*)dataSource[indexPath.row];
    if(aTip == nil)
    {
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(aPoi.location.latitude, aPoi.location.longitude);
    }else{
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(aTip.location.latitude, aTip.location.longitude);

    }
    
    [_mapView setCenterCoordinate:pointAnnotation.coordinate];
    
    if(city == nil)
    {
        city = locationCity;
    }
    
    [Global getInstance].matchInfo.cityName = city;
    
    NSString * matchX = [NSString stringWithFormat:@"%lf",pointAnnotation.coordinate.latitude];
    NSString * matchY = [NSString stringWithFormat:@"%lf",pointAnnotation.coordinate.longitude];
    
    NSLog(@"matchX = %@ , matchY = %@",matchX,matchY);
    
    [Global getInstance].matchInfo.matchX = matchX;
    [Global getInstance].matchInfo.matchY = matchY;
    [Global getInstance].matchInfo.addressName = cell.textLabel.text;
}

@end
