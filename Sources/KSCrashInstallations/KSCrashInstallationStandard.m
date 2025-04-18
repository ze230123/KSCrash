//
//  KSCrashInstallationStandard.m
//
//  Created by Karl Stenerud on 2013-03-02.
//
//  Copyright (c) 2012 Karl Stenerud. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall remain in place
// in this source code.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "KSCrashInstallationStandard.h"
#import "KSCrashInstallation+Private.h"
#import "KSCrashReportFilterBasic.h"
#import "KSCrashReportSinkStandard.h"
#import "KSNSErrorHelper.h"

@implementation KSCrashInstallationStandard

+ (instancetype)sharedInstance
{
    static KSCrashInstallationStandard *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[KSCrashInstallationStandard alloc] init];
    });
    return sharedInstance;
}

- (BOOL)validateSetupWithError:(NSError *__autoreleasing _Nullable *)error
{
    if ([super validateSetupWithError:error] == NO) {
        return NO;
    }

    if (self.url == nil) {
        if (error != NULL) {
            *error = [KSNSErrorHelper errorWithDomain:[[self class] description] code:0 description:@"No URL provided"];
        }
        return NO;
    }

    return YES;
}

- (id<KSCrashReportFilter>)sink
{
    KSCrashReportSinkStandard *sink = [[KSCrashReportSinkStandard alloc] initWithURL:self.url];
    return [[KSCrashReportFilterPipeline alloc] initWithFilters:@[ sink.defaultCrashReportFilterSet ]];
}

@end
