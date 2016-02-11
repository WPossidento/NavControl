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
        
        Product *iphone = [[Product alloc] initWithName:@"iPhone" andLogo:[UIImage imageNamed:@"iphone.png"] andURL:@"https://apple.com/iphone"];
        Product *ipod = [[Product alloc] initWithName:@"iPod" andLogo:[UIImage imageNamed:@"ipod.png"] andURL:@"https://apple.com/ipod"];
        Product *ipad = [[Product alloc] initWithName:@"iPad" andLogo:[UIImage imageNamed:@"ipad.png"] andURL:@"https://apple.com/ipad"];
        
        Company *apple = [[Company alloc] initWithName:@"Apple mobile devices" andLogo:[UIImage imageNamed:@"apple_s.png"] andProducts:[NSMutableArray arrayWithObjects: iphone, ipod, ipad, nil]];
        
        Product *galaxyS4 = [[Product alloc] initWithName:@"Galaxy S4" andLogo:[UIImage imageNamed:@"s4.png"] andURL:@"http://www.samsung.com/global/microsite/galaxys4/"];
        Product *galaxyNote = [[Product alloc] initWithName:@"Galaxy Note" andLogo:[UIImage imageNamed:@"note.png"] andURL:@"http://www.samsung.com/global/microsite/galaxynote/"];
        Product *galaxyTab = [[Product alloc] initWithName:@"Galaxy Tab" andLogo:[UIImage imageNamed:@"tab.png"] andURL:@"http://www.samsung.com/global/microsite/galaxytab/"];
        
        Company *samsung = [[Company alloc] initWithName:@"Samsung mobile devices" andLogo:[UIImage imageNamed:@"samsung_s.png"] andProducts:[NSMutableArray arrayWithObjects: galaxyS4, galaxyNote, galaxyTab, nil]];
        
        Product *lumia950XL = [[Product alloc] initWithName:@"Lumia 950XL" andLogo:[UIImage imageNamed:@"lumia950xl.png"] andURL:@"https://www.microsoft.com/en-us/mobile/phone/lumia950-xl-dual-sim/"];
        Product *lumia550 = [[Product alloc] initWithName:@"Lumia 550" andLogo:[UIImage imageNamed:@"lumia550.png"] andURL:@"https://www.microsoft.com/en-us/mobile/phone/lumia550/"];
        Product *lumia1520 = [[Product alloc] initWithName:@"Lumia 1520" andLogo:[UIImage imageNamed:@"lumia1520.png"] andURL:@"https://www.microsoft.com/en-us/mobile/phone/lumia1520/"];
        
        Company *microsoft = [[Company alloc] initWithName:@"Microsoft mobile devices" andLogo:[UIImage imageNamed:@"microsoft.png"] andProducts:[NSMutableArray arrayWithObjects:lumia950XL, lumia550, lumia1520, nil]];
        
        Product *signature = [[Product alloc] initWithName:@"Signature" andLogo:[UIImage imageNamed:@"signature.png"] andURL:@"http://www.vertu.com/us/en/collections/signature/"];
        Product *stouch = [[Product alloc] initWithName:@"The New Signature Touch" andLogo:[UIImage imageNamed:@"stouch.jpeg"] andURL:@"http://www.vertu.com/us/en/collections/signature-touch/"];
        Product *aster = [[Product alloc] initWithName:@"Aster" andLogo:[UIImage imageNamed:@"aster.png"] andURL:@"http://www.vertu.com/us/en/collections/aster/"];

        Company *vertu = [[Company alloc] initWithName:@"Vertu mobile devices" andLogo:[UIImage imageNamed:@"vertu_s.png"] andProducts:[NSMutableArray arrayWithObjects: signature, stouch, aster, nil]];
        
        self.companyList = [[NSMutableArray alloc] initWithObjects: apple, samsung, microsoft, vertu, nil];
        
        
    }
    return self;
}

-(void) loadStocksTo:(id<MyManagerDelegate>) delegate {
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://finance.yahoo.com/d/quotes.csv?s=AAPL+SSU.DE+MSFT+VTU.L&f=no"]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSString *stocksStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Data: %@", stocksStr);
                
                    NSMutableArray *stocksArr = [[NSMutableArray alloc] initWithArray:[stocksStr componentsSeparatedByString:@"\n"]];
                    [stocksArr removeLastObject];
                
                    self.stocksFinal = [[NSMutableArray alloc] init];
                
                    NSArray *keys = [NSArray arrayWithObjects:@"company", @"openprice", nil];
                
                    for (NSString *stockStr in stocksArr) {
                        NSArray *tmp = [stockStr componentsSeparatedByString:@","];
                        NSDictionary *dict = [NSDictionary dictionaryWithObjects:tmp forKeys:keys];
                        [self.stocksFinal addObject:dict];
                        
                    }
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [delegate stockUpdated];
                        
                    });
                
            }] resume];
    
}


- (void)dealloc {
    // Should never be called, but just here for clarity really.
//    [self.someProperty release];
    [super dealloc];
}

@end