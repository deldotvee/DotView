// This is sample code originally created by James Duncan Davidson and released into the public domain

// DotView

#import <Cocoa/Cocoa.h>

@interface DotView: NSView
{
	IBOutlet NSColorWell *colorWell;
	IBOutlet NSSlider *slider;
	
	NSPoint center;
	NSColor *color;
	float radius;
}

- ( IBAction ) setColor: ( id ) sender;
- ( IBAction ) setRadius: ( id ) sender;

@end
