#import "Menufela.h"
#import <Carbon/Carbon.h>

#define ReadPref(key) [Defaults objectForKey:@"Menufela_" key]
#define WritePref(key, value) [Defaults setObject:(value) forKey:@"Menufela_" key]

@interface Menufela ()
+ (void)_updateMenubarState;
+ (void)_toggleMenubar:(id)sender;
@end

@implementation Menufela

+ (void)load
{
    [Defaults registerDefaults:@{ @"Menufela_ShouldHideMenubar": @YES }];
    
    NSMenu *windowMenu = [NSApp windowsMenu];
    NSUInteger zoomIdx = [windowMenu indexOfItemWithTitle:@"Zoom"];
    [windowMenu insertItem:[NSMenuItem separatorItem] atIndex:zoomIdx+1];
    NSMenuItem *toggleItem = [[NSMenuItem alloc] initWithTitle:@"Toggle Menubar"
                                                        action:@selector(_toggleMenubar:)
                                                 keyEquivalent:@"\n"];
    toggleItem.target = self;
    toggleItem.keyEquivalentModifierMask = NSControlKeyMask;
    [windowMenu insertItem:toggleItem atIndex:zoomIdx+2];
    
    [NotificationCenter addObserver:self
                           selector:@selector(_updateMenubarState)
                               name:NSApplicationDidBecomeActiveNotification
                             object:NSApp];
    [self _updateMenubarState];
}

+ (void)_updateMenubarState
{
    if([ReadPref(@"ShouldHideMenubar") boolValue])
        SetSystemUIMode(kUIModeAllSuppressed, kUIOptionAutoShowMenuBar);
    else
        SetSystemUIMode(kUIModeNormal, 0);
}

+ (void)_toggleMenubar:(id)sender
{
    WritePref(@"ShouldHideMenubar", @(![ReadPref(@"ShouldHideMenubar") boolValue]));
    [self _updateMenubarState];
}
@end
