//
//  NSAttributedString-Hyperlink.h
//  CloudPost
//
//  Created by Christian Stropp on 01.09.09.
//  Copyright 2009 Christian S. All rights reserved.
//  https://github.com/ChristianS/CloudPost/blob/master/NSAttributedString-Hyperlink.m
//

#import "NSAttributedString-Hyperlink.h"

@implementation NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL
{
	NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
	NSRange range = NSMakeRange(0, [attrString length]);
	
	[attrString beginEditing];
	[attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
	
	// make the text appear in blue
	[attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
	
	// next make the text appear with an underline
	//[attrString addAttribute:
	// NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
	
	[attrString endEditing];
	
	return [attrString autorelease];
}

@end