//
//  DAO.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "MyManager.h"

static MyManager *sharedMyManager = nil;

@implementation MyManager


#pragma mark Singleton Methods
+ (id)sharedManager {
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager; 
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}

- (oneway void)release {
    // never release
}

- (id)autorelease {
    return self;
}

- (id)init {
    if (self = [super init]) {
        self.someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
        
        Product *iphone = [[Product alloc] initWithName:@"iPhone" andLogo:@"iphone.png" andURL:@"https://apple.com/iphone"];
        Product *ipod = [[Product alloc] initWithName:@"iPod" andLogo:@"ipod.png" andURL:@"https://apple.com/ipod"];
        Product *ipad = [[Product alloc] initWithName:@"iPad" andLogo:@"ipad.png" andURL:@"https://apple.com/ipad"];
        
        Company *apple = [[Company alloc] initWithName:@"Apple mobile devices" andLogo:@"apple_s.png" andProducts:[NSMutableArray arrayWithObjects: iphone, ipod, ipad, nil]];
        
        Product *galaxyS4 = [[Product alloc] initWithName:@"Galaxy S4" andLogo:@"s4.png" andURL:@"http://www.samsung.com/global/microsite/galaxys4/"];
        Product *galaxyNote = [[Product alloc] initWithName:@"Galaxy Note" andLogo:@"note.png" andURL:@"http://www.samsung.com/global/microsite/galaxynote/"];
        Product *galaxyTab = [[Product alloc] initWithName:@"Galaxy Tab" andLogo:@"tab.png" andURL:@"http://www.samsung.com/global/microsite/galaxytab/"];
        
        Company *samsung = [[Company alloc] initWithName:@"Samsung mobile devices" andLogo:@"samsung_s.png" andProducts:[NSMutableArray arrayWithObjects: galaxyS4, galaxyNote, galaxyTab, nil]];
        
        Product *lumia950XL = [[Product alloc] initWithName:@"Lumia 950XL" andLogo:@"lumia950xl.png" andURL:@"https://www.microsoft.com/en-us/mobile/phone/lumia950-xl-dual-sim/"];
        Product *lumia550 = [[Product alloc] initWithName:@"Lumia 550" andLogo:@"lumia550.png" andURL:@"https://www.microsoft.com/en-us/mobile/phone/lumia550/"];
        Product *lumia1520 = [[Product alloc] initWithName:@"Lumia 1520" andLogo:@"lumia1520.png" andURL:@"https://www.microsoft.com/en-us/mobile/phone/1520/"];
        
        Company *microsoft = [[Company alloc] initWithName:@"Microsoft mobile devices" andLogo:@"microsoft.png" andProducts:[NSMutableArray arrayWithObjects:lumia950XL, lumia550, lumia1520, nil]];
        
        Product *signature = [[Product alloc] initWithName:@"Signature" andLogo:@"signature.png" andURL:@"http://www.vertu.com/us/en/collections/signature/"];
        Product *stouch = [[Product alloc] initWithName:@"The New Signature Touch" andLogo:@"stouch.jpeg" andURL:@"http://www.vertu.com/us/en/collections/signature-touch/"];
        Product *aster = [[Product alloc] initWithName:@"Aster" andLogo:@"aster.png" andURL:@"http://www.vertu.com/us/en/collections/aster/"];

        Company *vertu = [[Company alloc] initWithName:@"Vertu mobile devices" andLogo:@"vertu_s.png" andProducts:[NSMutableArray arrayWithObjects: signature, stouch, aster, nil]];
        
        self.companyList = [[NSMutableArray alloc] initWithObjects: apple, samsung, microsoft, vertu, nil];
        
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
    [self.someProperty release];
    [super dealloc];
}

@end