// This is sample code originally created by James Duncan Davidson and released into the public domain

#import "CloserDelegate.h"

@implementation CloserDelegate

- ( id ) init    {
	NSNotificationCenter *center = [ NSNotificationCenter defaultCenter ];
	[ center addObserver: self selector: @selector( sheetDidBegin: )
		name: NSWindowWillBeginSheetNotification object: nil ];
	return self;
}

- ( void ) sheetDidBegin: ( NSNotification * ) notification    {
	// notification is only posted to console and not actually used in DotView
	NSLog( @"Notification: %@", [ notification name ] );
}

- ( void ) dealloc    {
	[ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
	[ super dealloc ];
}

//  Delegate method implementing a close sheet. Since sheets are non-blocking,
//  responding to them is a separate process handled in
//  sheetClosed: returnCode: contextInfo: implemented below.

- ( BOOL ) windowShouldClose: ( NSWindow * ) sender    {
	NSString *msg = @"Do you want to close this window and quit?";
	SEL sel = @selector( sheetClosed: returnCode: contextInfo: );
	
// relic code for simple Alert panel follows 

//	int answer = NSRunAlertPanel( @"Close", @"Are you certain?", @"Close", @"Cancel", nil );
	
//	switch ( answer )    {
//		case NSAlertDefaultReturn:
//			return YES;
//		default:
//			return NO;
//	}

    // the substituted sheet/notification implementation is much more sophisticated
	
    NSBeginAlertSheet( @"Close",	// NSString *title,
					@"OK",			// NSString *defaultButtonLabel,
					@"Cancel",		// NSString *alternateButtonLabel,
					nil,			// NSString *otherButtonLabel,
					sender,			// NSWindow *docWindow,
					self,			// id modalDelegate,
					sel,			// SEL didEndSelector,
					NULL,			// SEL didDismissSelector,
					sender,			// void *contextInfo,
					msg,			// NSString *message (with optional printf args)
					nil );			// params for message string
	// Don't decide to close window until results of sheet interaction are known.
	return NO;
}

// Invoked by the system when the sheet has been dismissed.
// In the call to NSBeginAlertSheet, we passed a reference
// to the window in the contextInfo parameter, so we're getting
// it passed back to us here; which is how we close the window.

- ( void ) sheetClosed: ( NSWindow * ) sheet returnCode: ( int ) returnCode
	contextInfo: ( void * ) contextInfo
{
	if ( returnCode == NSAlertDefaultReturn )    {
		[ ( NSWindow * ) contextInfo close ];
		[ NSApp terminate: self ];
	}
}

@end
