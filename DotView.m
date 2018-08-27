// This is sample code originally created by James Duncan Davidson and released into the public domain

// DotView.m
// Simple NSView subclass showing how to draw, handle simple events,
// target/action, delegation, and notification methods.

#import "DotView.h"

@implementation DotView

// initWithFrame: is NSView's designated initializer (meaning it should be
// overridden in the subclass if needed, and it should call super, that is,
// NSView's implementation). In DotView we do just that, and also set the
// instance variables.

// Note that we initialize the instance variables here in the same way they are
// initialized in the nib file. This is adequate, but a better solution is to make
// sure the two places are initialized from the same place. Slightly more
// sophisticated apps which load nibs for each document or window would initialize
// UI elements at the time they're loaded from values in the program.

- ( id ) initWithFrame: ( NSRect ) frameRect    {
	self = [ super initWithFrame: frameRect ];
	center.x = frameRect.size.width / 2.0;
	center.y = frameRect.size.height / 2.0;
	radius = 30.0;
	color = [ [ NSColor darkGrayColor ] retain ];
	return self;
}

- ( void ) awakeFromNib    {
	[ colorWell setColor: color ];
	[ slider setFloatValue: radius ];
}

// dealloc is the method called when objects are being freed. (Note that "release"
// is called to release objects; when the number of release calls reduces the
// total reference count on an object to zero, dealloc is called to free
// the object. dealloc should free any memory allocated by the subclass
// and then call super to get the superclass to do additional cleanup.

- ( void ) dealloc    {
	[ color release ];
	[ super dealloc ];
}

// drawRect: should be overridden in subclasses of NSView to do necessary
// drawing in order to recreate the the look of the view. It will be called
// to draw the whole view or parts of it (pay attention the rect argument);
// it will also be called during printing if your app is set up to print.
// In DotView we first clear the view to gray, then draw the dot at its
// current location and size.

- ( void ) drawRect: ( NSRect ) rect    {
	NSRect dotRect;
	
	// Draw the background
	[ [ NSColor lightGrayColor ] set ];
	// Equiv to [ [ NSBezierPath bezierPathWithRect:[ self bounds ] ] fill ]
	NSRectFill( [ self bounds ] );
	
	// Set the location of the dot to center on click spot
	dotRect.origin.x = center.x - radius;
	dotRect.origin.y = center.y - radius;
	
	// Define the size of the dot
	dotRect.size.width = 2 * radius;
	dotRect.size.height = 2 * radius;
	
	// Set the default color
	[ color set ];
	
	// Draw the dot
	[ [ NSBezierPath bezierPathWithOvalInRect: dotRect ] fill ];
}

// Views which totally redraw their whole bounds without needing any of the
// views behind it should override isOpaque to return YES. This is a performance
// optimization hint for the display subsystem. This applies to DotView, whose
// drawRect: does fill the whole rect it is given with a solid, opaque color.

- ( BOOL ) isOpaque    {
	return YES;
}

// Recommended way to handle events is to override NSResponder (superclass
// of NSView) methods in the NSView subclass. One such method is mouseDown:.
// These methods get the event as the argument. The event has the mouse
// location in window coordinates; use convertPoint:fromView: (with "nil"
// as the view argument) to convert this point to local view coordinates.
//
// Note that once we get the new center, we call setNeedsDisplay:YES to 
// mark that the view needs to be redisplayed (which is done automatically
// by the AppKit).

- ( void ) mouseDown: ( NSEvent * ) event    {
	NSPoint eventLocation = [ event locationInWindow ];
	center = [ self convertPoint: eventLocation fromView: nil ];
	[ self setNeedsDisplay: YES ];
}

// By handling drag events, user can "reposition" the dot anywhere in the view
// with visual feedback provided from continuously redrawing the dot

- ( void ) mouseDragged: ( NSEvent * ) event    {
	NSPoint eventLocation = [ event locationInWindow ];
	center = [ self convertPoint: eventLocation fromView: nil ];
	[ self setNeedsDisplay: YES ];
}

// setColor: is an action method which lets you change the color of the dot.
// We assume the sender is a control capable of returning a color (NSColorWell
// can do this). We get the value, release the previous color, and mark the
// view as needing to be redisplayed. A possible optimization is to check to
// see if the old and new value is the same, and not do anything if so.
 
- ( IBAction ) setColor: ( id ) sender    {
	NSColor *newColor = [ sender color ];
	[ newColor retain ];
	[ color release ];
	color = newColor;
	[ self setNeedsDisplay: YES ];
}

// setRadius: is an action method which lets you change the radius of the dot.
// We assume the sender is a control capable of returning a floating point
// number; so we ask for its value, and mark the view as needing to be 
// redisplayed. An implemented optimization is to check to see if the old and
// new value is the same, and not do anything if so.

- ( IBAction ) setRadius: ( id ) sender    {
	float newRadius = [ sender floatValue ];
	
	if ( newRadius != radius )    {
		radius = newRadius;
		[ self setNeedsDisplay: YES ];
	}
}

@end
