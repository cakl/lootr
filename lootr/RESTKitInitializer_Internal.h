//
//  RESTKitInitializer_Internal.h
//  lootrapp
//
//  Created by Sebastian Bock on 17.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RESTKitInitializer : NSObject
@property (nonatomic, strong, readonly) RKObjectMapping *lootsMapping;
@property (nonatomic, strong, readonly) RKObjectMapping *userMapping;
@property (nonatomic, strong) RKObjectMapping *coordinateMapping;
@property (nonatomic, strong, readonly) RKResponseDescriptor *lootsRD;
-(id)initWithApiUrl:(NSString*)apiUrl;
@end
