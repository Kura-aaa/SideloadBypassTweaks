#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CaptainHook/CaptainHook.h>
#import <substrate.h>    // for MSHookFunction
#import <string.h>       // for strstr
#import <errno.h>        // for errno, ENOENT
#import <sys/stat.h>     // for struct stat

// ----- SCUser Hook -----
CHDeclareClass(SCUser);

CHOptimizedMethod0(self, BOOL, SCUser, isSubscriptionGranted) {
    @try {
        NSLog(@"[Bypass v2.1] Granting premium access");
        return YES;
    } @catch (NSException *e) {
        NSLog(@"[Bypass v2.1] Exception caught: %@", e);
        return CHSuper(0, SCUser, isSubscriptionGranted);
    }
}

CHConstructor {
    CHLoadLateClass(SCUser);
    CHHook(0, SCUser, isSubscriptionGranted);
}

// ----- stat() bypass for jailbreak detection -----
static int (*orig_stat)(const char *path, struct stat *buf);

static int replaced_stat(const char *path, struct stat *buf) {
    if (strstr(path, "Cydia.app") || strstr(path, "MobileSubstrate")) {
        NSLog(@"[Bypass v2.1] Hiding jailbreak traces from %s", path);
        errno = ENOENT;
        return -1;
    }
    return orig_stat(path, buf);
}

__attribute__((constructor))
static void install_stat_hook() {
    // Locate the real stat() symbol in libSystem
    void *handle = dlopen("/usr/lib/libSystem.B.dylib", RTLD_NOW);
    orig_stat = dlsym(handle, "stat");
    // Hook it
    MSHookFunction((void *)orig_stat, (void *)replaced_stat, (void **)&orig_stat);
}
