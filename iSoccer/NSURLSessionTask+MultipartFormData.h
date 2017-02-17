//
//  XTMultipartPostRequest.h
//  Forg
//
//  Created by NemoLee on 14/11/17.
//  Copyright (c) 2014年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol XTMultipartPostBuilder;

@interface NSURLSessionTask (XTMultipartPost)
+ (NSURLSessionTask *)asynAtPort:(NSString *)address withParameters:(NSDictionary *)parameters multipartBuilder:(void(^)(id<XTMultipartPostBuilder> fileBody))mutipartBuilder completion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))comlpetion;
@end

@protocol XTMultipartPostBuilder <NSObject>

- (void)appendFileData:(NSData *)data fileName:(NSString *)fileName parameterKey:(NSString *)key;

@end

