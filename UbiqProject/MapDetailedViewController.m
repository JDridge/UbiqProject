
#import "MapDetailedViewController.h"
#import "YPAPISample.h"


@interface MapDetailedViewController ()

@end

@implementation MapDetailedViewController

@synthesize nameLabel, phoneLabel, addressLabel, reviewCountLabel, urlImage, ratingImage, category, pinLocation, yelpURL;

- (void)viewDidLoad {
    /*
     "display_phone" = "+1-415-777-1413";
     "image_url" = "http://s3-media4.fl.yelpcdn.com/bphoto/uweSiOf0XBB4BPk_ibHVyg/ms.jpg";
     location =     {
     coordinate =         {
     latitude = "37.7783200510611";
     longitude = "-122.396771288052";
     };
     "display_address" =         (
     "500 Brannan St",
     SoMa,
     "San Francisco, CA 94107"
     );
     };
     name = Marlowe;
     rating = 4;
     "rating_img_url_large" = "http://s3-media2.fl.yelpcdn.com/assets/2/www/img/ccf2b76faa2c/ico/stars/v1/stars_large_4.png";
     "review_count" = 1682;
     url = "http://www.yelp.com/biz/marlowe-san-francisco-2";
     */
    @autoreleasepool {
        NSString *defaultTerm = category;
        NSString *defaultCoordinates = [NSString stringWithFormat:@"%f,%f", pinLocation.coordinate.latitude, pinLocation.coordinate.longitude];
        
        //Get the term and location from the command line if there were any, otherwise assign default values.
        NSString *term = [[NSUserDefaults standardUserDefaults] valueForKey:@"term"] ?: defaultTerm;
        NSString *ll = [[NSUserDefaults standardUserDefaults] valueForKey:@"ll"] ?: defaultCoordinates;
        
        
        YPAPISample *APISample = [[YPAPISample alloc] init];
        
        dispatch_group_t requestGroup = dispatch_group_create();
        
        dispatch_group_enter(requestGroup);
        [APISample queryTopBusinessInfoForTerm:term ll:ll completionHandler:^(NSDictionary *topBusinessJSON, NSError *error) {
            
            if (error) {
                NSLog(@"An error happened during the request: %@", error);
            } else if (topBusinessJSON) {
                //TODO - assign yelpURL
                //TODO - set labels for result
                
                NSLog(@"Top business info: \n %@", topBusinessJSON);
                nameLabel.text = [topBusinessJSON objectForKey:@"name"];
                phoneLabel.text = [NSString stringWithFormat:@"%@%@", @"Phone Number: ", [topBusinessJSON objectForKey:@"phone"]];
                
                NSArray *addressObject = [[topBusinessJSON objectForKey:@"location"] objectForKey:@"display_address"];
                
                NSString *stringAddress = @"";
                for(int i = 0; i < [addressObject count]; i++) {
                    stringAddress = [stringAddress stringByAppendingString:[NSString stringWithFormat:@"%@\n", addressObject[i]]];
                }
                
                addressLabel.text = stringAddress;
                
                reviewCountLabel.text = [NSString stringWithFormat:@"%@%i", @"Reviews: ",[[topBusinessJSON objectForKey:@"review_count"] intValue]];
                
                
                yelpURL =[topBusinessJSON objectForKey:@"url"];
                //po [topBusinessJSON objectForKey:@"url"]
                
                
                
                
                
                
            } else {
                NSLog(@"No business was found");
            }
            
            dispatch_group_leave(requestGroup);
        }];
        dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTouched:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)openInYelpButtonTouched:(id)sender {
    [self maybeDoSomethingWithYelp];
}

- (BOOL)isYelpInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"yelp5.3:"]];
}

- (void)maybeDoSomethingWithYelp {
    if ([self isYelpInstalled]) {
        NSString *yelpStringFormat = @"yelp5.3://";
        yelpStringFormat = [NSString stringWithFormat:@"%@%@", yelpStringFormat, [yelpURL substringFromIndex:18]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:yelpStringFormat]];
        
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:yelpURL]];
    }
}


@end