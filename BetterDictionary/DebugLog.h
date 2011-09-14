/*
 *  DebugLog.h
 *  DebugLog
 *
 *  Created by Karl Kraft on 3/22/09.
 *  Copyright 2009 Karl Kraft. All rights reserved.
 *
 */

#ifdef DEBUG
	#define DebugLog(args...) _DebugLog(__FILE__,__LINE__,args);
#else
	#define DebugLog(x...)
#endif

void _DebugLog(const char *file, int lineNumber, NSString *format,...);
