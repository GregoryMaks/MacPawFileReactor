//
//  MacPawFileReactorXPCService.h
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacPawFileReactorXPCServiceProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface MacPawFileReactorXPCService : NSObject <MacPawFileReactorXPCServiceProtocol>
@end
