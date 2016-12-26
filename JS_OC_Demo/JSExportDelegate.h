//
//  JSExportDelegate.h
//  JS_OC_Demo
//
//  Created by Nemo on 2016/11/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JSExport.h>

@protocol JSExportDelegate <JSExport>

-(void)run:(NSString *)string;

@end
