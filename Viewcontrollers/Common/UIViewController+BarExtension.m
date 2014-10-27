#import "UIViewController+BarExtension.h"
#import "SVProgressHUD.h"

@implementation UIViewController (BarExtension)


//正常显示左右button图标和title
- (void)homeNavbarWithTitle:(NSString *)titleName andLeftButtonName:(NSString *)leftImageName andRightButtonName:(NSString *)rightImageName
{
    // left button
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    UIFont *font = [UIFont systemFontOfSize:22];
    label.font = font;
    label.text = titleName;
    
    self.navigationItem.titleView = label;
    [label release];

//    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0,0,218,44)];
//    [titleView addSubview:label];

    if (leftImageName)
    {
        UIImage *leftImage = nil;
        if (IOS_7)
        {
            leftImage= [UIImage imageNamed:leftImageName];
        }
        else
        {
            leftImage= [UIImage imageNamed:[NSString stringWithFormat:@"%@1",leftImageName]];
        }
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame =  CGRectMake(0, 0, 51, 44);
        [leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(calculate) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] init];
        leftButtonItem.customView = leftButton;
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        [leftButtonItem release];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    // right button
    if (rightImageName)
    {
        UIImage *rightImage = [UIImage imageNamed:rightImageName];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0 , 0, 50, 44);
        [rightButton setImage:rightImage forState:UIControlStateNormal];
        [rightButton setTitle:rightImageName forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(handleRightEvent) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] init];
        rightButtonItem.customView = rightButton;
        self.navigationItem.rightBarButtonItem = rightButtonItem;
        [rightButtonItem release];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)calculate
{
    if ([SVProgressHUD isActivty])
    {
        [SVProgressHUD popActivity];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)handleRightEvent
{
    
}


@end


