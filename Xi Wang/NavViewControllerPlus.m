//
//  NavViewController.m
//  WaHealth
//
//  Created by Ryo on 13/3/8.
//
//

#import "NavViewControllerPlus.h"
#import "BrightcoveViewController.h"
#import "LiveViewController.h"

@interface NavViewControllerPlus ()

@end

@implementation NavViewControllerPlus

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(void)youTubeVideoExit:(id)sender{
    // put this part in what sub view u want
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
    
    // show result
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    //[UIApplication sharedApplication].statusBarOrientation
    CGFloat radian = 0;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            radian = -90;
            NSLog(@"轉啦！正常直向");
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            radian = 90;
            NSLog(@"轉啦！反直向");
            break;
        case UIInterfaceOrientationLandscapeLeft:
            radian = 180;
            NSLog(@"轉啦！按鈕左邊橫向");
            break;
        case UIInterfaceOrientationLandscapeRight:
            radian = 0;
            NSLog(@"轉啦！按鈕右邊橫向");
            break;
        default:
            break;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(youTubeVideoExit:)
                                                 name:@"UIMoviePlayerControllerDidExitFullscreenNotification"
                                               object:nil];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ios 6 +
#if 1
-(BOOL)shouldAutorotate{
    
    if(([self.topViewController isKindOfClass:[BrightcoveViewController class]] ||[self.topViewController isKindOfClass:[LiveViewController class]]) && [self.topViewController respondsToSelector:@selector(shouldAutorotate)])
        return [self.topViewController shouldAutorotate];
    if([self.parentViewController respondsToSelector:@selector(shouldAutorotate)])
        return [self.topViewController shouldAutorotate];
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    if([self.topViewController respondsToSelector:@selector(supportedInterfaceOrientations)])
//        return [self.topViewController supportedInterfaceOrientations];
//    return [super supportedInterfaceOrientations];
    if (([self.topViewController isKindOfClass:[BrightcoveViewController class]] ||[self.topViewController isKindOfClass:[LiveViewController class]])&& [self.topViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [self.topViewController supportedInterfaceOrientations];
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if([self.topViewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)])
        return [self.topViewController preferredInterfaceOrientationForPresentation];
    return [super preferredInterfaceOrientationForPresentation];
}


#else
-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

#endif
// below ios 5

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}
 
@end
