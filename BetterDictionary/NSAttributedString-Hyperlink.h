//
//  NSAttributedString-Hyperlink.h
//  CloudPost
//
//  Created by Christian Stropp on 01.09.09.
//  Copyright 2009 Christian S. All rights reserved.
//  https://github.com/ChristianS/CloudPost/blob/master/NSAttributedString-Hyperlink.h
//

#import <Cocoa/Cocoa.h>

@interface NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;

@end