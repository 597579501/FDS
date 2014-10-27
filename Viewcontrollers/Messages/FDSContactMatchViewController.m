//
//  FDSContactMatchViewController.m
//  FDS
//
//  Created by zhuozhong on 14-3-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
#import "FDSContactMatchViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSComDesigner.h"
#import <AddressBook/AddressBook.h>
#import "SVProgressHUD.h"
#import "FDSPublicManage.h"
#import "FDSStringUtility.h"
#import "FDSFriendProfileViewController.h"

@interface FDSContactMatchViewController ()

@end

@implementation FDSContactMatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        addressBookList = [[NSMutableArray alloc] init];
        
        FDSComDesigner *designer = [FDSComDesigner alloc];
        designer.m_isPlatUser = YES;//平台用户
        designer.designList = [[[NSMutableArray alloc] init] autorelease];
        designer.m_introduce = @"平台用户";
        [addressBookList addObject:designer];
        [designer release];
        
        designer = [FDSComDesigner alloc];
        designer.m_isPlatUser = NO;//非平台用户
        designer.designList = [[[NSMutableArray alloc] init] autorelease];
        designer.m_introduce = @"非平台用户";
        [addressBookList addObject:designer];
        [designer release];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
}

- (void)dealloc
{
    [addressBookList removeAllObjects];
    [addressBookList release];
    
    [allContactList release];
    
    [super dealloc];
}

/*   获取通讯录联系人    */
- (void)getAddressBookContacts
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);//读取手机通讯录
    
    CFArrayRef allPeople;
    CFIndex nPeople=0;
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL)
    { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        //        NSLog(@"%ld",ABAddressBookGetAuthorizationStatus(),kABAuthorizationStatusNotDetermined);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else
    { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted)
    {
        
        allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        nPeople = ABAddressBookGetPersonCount(addressBook);
        // Do whatever you need with thePeople...
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"您拒绝了对通讯录的访问,您可以在设置->隐私中打开"];
        return;
    }
    
    NSMutableArray *phoneNumbers = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:1];

    for (NSInteger i = 0; i < nPeople; i++)
    {
        FDSComDesigner *designerInfo = [[FDSComDesigner alloc] init];

        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        NSString *nameString = (NSString *)abName;
        NSString *lastNameString = (NSString *)abLastName;
        
        if ((id)abFullName != nil)
        {
            nameString = (NSString *)abFullName;
        }
        else
        {
            if ((id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        designerInfo.m_name = nameString;
        designerInfo.m_index = (int)ABRecordGetRecordID(person);
        
        ABPropertyID multiProperties[] = {kABPersonPhoneProperty};
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++)
        {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil)
                valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0)
            {
                CFRelease(valuesRef);
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++)
            {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j)
                {
                    case 0:
                    {
                        // Phone number
                        designerInfo.m_phone = [(NSString*)value telephoneWithReformat];
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        [tempArr addObject:designerInfo];
        [designerInfo release];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    CFRelease(allPeople);
    CFRelease(addressBook);
    
    //sort Data
    allContactList = [[tempArr sortedArrayUsingFunction:nickNameSort context:NULL] retain];
    
    int ii = 0;
    for (FDSComDesigner *designer in allContactList)
    {
        if (designer.m_phone)
        {
            [phoneNumbers addObject:@{@"phoneNumber":designer.m_phone,@"index":[NSString stringWithFormat:@"%d",ii]}];
        }
        ii++;
    }
    
    
    if (phoneNumbers.count > 0)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSUserCenterMessageManager sharedManager] checkUsersMembersByPhone:phoneNumbers];
    }
    else
    {
        FDSComDesigner *secinfo = [addressBookList objectAtIndex:1]; //非平台用户
        secinfo.designList = (NSMutableArray*)allContactList;
        [self tableViewInit];
    }
}

NSInteger nickNameSort(id user1, id user2, void *context)
{
    FDSComDesigner *u1,*u2;
    //类型转换
    u1 = (FDSComDesigner*)user1;
    u2 = (FDSComDesigner*)user2;
    return  [u1.m_name localizedCompare:u2.m_name];
}

#pragma mark - FDSUserCenterMessageInterface Method
- (void)checkUsersMembersByPhoneCB:(NSMutableArray *)resultList
{
    [SVProgressHUD popActivity];
    FDSComDesigner *info = [addressBookList objectAtIndex:0];//平台用户
    info.designList = resultList;
    
    FDSComDesigner *secinfo = [addressBookList objectAtIndex:1]; //非平台用户
    
    BOOL isExist = NO;
    for (int i=0; i<allContactList.count; i++)
    {
        FDSComDesigner *allInfo = [allContactList objectAtIndex:i];
        
        FDSComDesigner *designer = nil;
        for (int j=0; j<info.designList.count; j++)
        {
            designer = [info.designList objectAtIndex:j];
            
            if (designer.m_index == i)
            {
                isExist = YES;
                break;
            }
        }
        if (isExist)
        {
            designer.m_name = allInfo.m_name;
        }
        else
        {
            [secinfo.designList addObject:allInfo];
        }
        isExist = NO;
    }
    
    [self tableViewInit];
}


- (void)tableViewInit
{
    contactTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    contactTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contactTableView.delegate = self;
    contactTableView.dataSource = self;
    [self.view addSubview:contactTableView];
    [contactTableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(234, 234, 234, 1);
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self homeNavbarWithTitle:@"通讯录" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    [self getAddressBookContacts];
	// Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [addressBookList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FDSComDesigner *designInfo = [addressBookList objectAtIndex:section];
    FDSComDesigner *tmpInfo = [addressBookList objectAtIndex:0];
    if (0 == section && 0 == tmpInfo.designList.count)
    {
        return 1;
    }
    return [designInfo.designList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDSComDesigner *designInfo = [addressBookList objectAtIndex:0];
    if (0 == indexPath.section && 0 == designInfo.designList.count)
    {
        return 2;
    }
    return 50.0f;
}

//
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    FDSComDesigner *designInfo = [addressBookList objectAtIndex:section];
    return designInfo.m_introduce;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  tableView.sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = COLOR(153, 153, 153, 1);
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    [header.textLabel setFont:[UIFont systemFontOfSize:15]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int se = indexPath.section;
    int ro = indexPath.row;
    FDSComDesigner *designInfo = [addressBookList objectAtIndex:0];
    if (0 == se && 0 == designInfo.designList.count)
    {
        UITableViewCell *tmpCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactTmpCell"] autorelease];
        
        tmpCell.backgroundColor = [UIColor whiteColor];
        tmpCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return tmpCell;
    }

    static NSString *cellIndentify = @"ContactMatchTableViewCell";
    ContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (nil == contactCell)
    {
        contactCell = [[[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
    }
    
    //***config cell***
    FDSComDesigner *groupInfo = [addressBookList objectAtIndex:se];
    FDSComDesigner *designer = [groupInfo.designList objectAtIndex:ro];
    contactCell.nameLab.text = designer.m_name;
    
    if (0==se)
    {
        [contactCell.operBtn setTitle:@"查看名片" forState:UIControlStateNormal];
    }
    else
    {
        [contactCell.operBtn setTitle:@"邀请" forState:UIControlStateNormal];
    }
    
    contactCell.delegate = self;
    contactCell.section = se;
    contactCell.row = ro;
    
    return contactCell;
}


#pragma mark - ContactDetailDelegate Method
- (void)didUserPressed:(NSInteger)section :(NSInteger)row
{
    FDSComDesigner *info = [addressBookList objectAtIndex:section];
    FDSComDesigner *detail = [info.designList objectAtIndex:row];

    if (section == 0)//平台用户
    {
        FDSFriendProfileViewController *fpVC = [[FDSFriendProfileViewController alloc]init];
        
        FDSUser *friendInfo = [[FDSUser alloc] init];
        friendInfo.m_friendID = detail.m_userID;
        friendInfo.m_name = detail.m_name;
        fpVC.friendInfo = friendInfo;
        [friendInfo release];
        
        fpVC.refreshNavbar = YES;
        
        [self.navigationController pushViewController:fpVC animated:YES];
        [fpVC release];
    }
    else //非平台用户
    {
        //发短信
        if (detail.m_phone && detail.m_phone.length > 0)
        {
            MFMessageComposeViewController* controller = [[[MFMessageComposeViewController alloc] init] autorelease];
            if ([MFMessageComposeViewController canSendText])
            {
                controller.body =  @"邀请你加入欧碧乐平台";//内容
                NSMutableArray *substrings = [NSMutableArray array];
                [substrings addObject:detail.m_phone];//电话号码
                controller.recipients = substrings;
                controller.messageComposeDelegate = self;
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该联系人未有号码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}


#pragma mark -
#pragma mark MFMessageComposeViewControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}


@end
