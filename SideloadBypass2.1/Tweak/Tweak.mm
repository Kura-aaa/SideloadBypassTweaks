#import <CaptainHook/CaptainHook.h>
#import <objc/runtime.h>
#import <sys/stat.h>

CHDeclareClass(SCUser);

CHMethod(0, BOOL, SCUser, isSubscriptionGranted) {
    @try {
        NSLog(@"[Bypass v2.1] Granting premium access");
        return YES;
    } @catch (NSException *e) {
        NSLog(@"[Bypass v2.1] Exception caught: %@", e);
        return CHSuper(0, SCUser, isSubscriptionGranted);
    }
}

CHConstructor {
    CHLoadClass(SCUser);
    CHHook(0, SCUser, isSubscriptionGranted);
}

// Anti-detection: stat override
int (*orig_stat)(const char *, struct stat *);
int stat(const char *path, struct stat *buf) {
    if (strstr(path, "Cydia") || strstr(path, "Substrate")) {
        NSLog(@"[Bypass v2.1] Hiding jailbreak traces from %s", path);
        errno = ENOENT;
        return -1;
    }
    return orig_stat(path, buf);
}

__attribute__((constructor)) static void init() {
    rebind_symbols((struct rebinding[1]){{"stat", stat, (void *)&orig_stat}}, 1);
}