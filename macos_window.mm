#import <AppKit/AppKit.h>
#include <QWindow>

// Disable macOS native fullscreen on the given QWindow.
// Must be called after the window is shown so the NSWindow exists.
// This makes the green button zoom/maximize instead of triggering the
// native fullscreen transition (which crashes the OpenGL context on ARM64).
void disableNativeFullscreen(QWindow *window) {
    NSView *nsView = (NSView *)window->winId();
    if (!nsView) return;
    NSWindow *nsWindow = [nsView window];
    if (!nsWindow) return;
    NSWindowCollectionBehavior behavior = [nsWindow collectionBehavior];
    behavior &= ~NSWindowCollectionBehaviorFullScreenPrimary;
    behavior &= ~NSWindowCollectionBehaviorFullScreenAuxiliary;
    [nsWindow setCollectionBehavior:behavior];
}
