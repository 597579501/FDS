//
//  FDSAdressBookViewController.m
//  FDS
//
//  Created by zhuozhong on 14-2-11.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSAdressBookViewController.h"
#import "FDSChatViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSDBManager.h"
#import "FDSMessageCenter.h"
#import "AddressBookTableViewCell.h"
#import "FDSAddFriendViewController.h"
#import "FDSSearchFriendViewController.h"
#import "FDSComAccountViewController.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface FDSAdressBookViewController ()

@end

@implementation FDSAdressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contactsArr = nil;
        self.contentList = [NSMutableArray arrayWithCapacity:0];
        self.filteredListContent = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
    [self loadSortData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    
    [self.searchDisplayController setActive:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_mySearchDisplayController release];
    
    [self.contactsArr removeAllObjects];
    self.contactsArr = nil;
    [self.contentList removeAllObjects];
    self.contentList = nil;
    [self.filteredListContent removeAllObjects];
    self.filteredListContent = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self homeNavbarWithTitle:@"联系人" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];

    _contactTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _contactTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contactTableView.delegate = self;
    _contactTableView.dataSource = self;
    [self.view addSubview:_contactTableView];
    [_contactTableView release];
    
    [self loadSearchBarView];

    // Do any additional setup after loading the view.
}

- (void)loadSortData
{
    self.contactsArr = [[FDSDBManager sharedManager]getUserFriendsWithUserID];
    
    if (self.contactsArr == nil || [self.contactsArr count] == 0)
    {
        return;
    }
    else
    {
        // Sort data
        if (self.contentList)
        {
            [_contentList removeAllObjects];
        }
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
        for (FDSUser *user in self.contactsArr)
        {
            if (![user.m_remarkName isEqualToString:@"(null)"] && user.m_remarkName.length > 0)
            {
                user.m_displayName = user.m_remarkName;
            }
            else
            {
                user.m_displayName = user.m_name;
            }
            NSInteger sect = [theCollation sectionForObject:user collationStringSelector:@selector(m_displayName)];
            user.m_sectionNumber = sect;
        }
        NSInteger highSection = [[theCollation sectionTitles] count];
        NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
        for (int i=0; i<=highSection; i++)
        {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
            [sectionArrays addObject:sectionArray];
        }
        for (FDSUser *user in self.contactsArr)
        {
            [(NSMutableArray *)[sectionArrays objectAtIndex:user.m_sectionNumber] addObject:user];
        }
        
        for (NSMutableArray *sectionArray in sectionArrays)
        {
            NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(m_displayName)];
            NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:sortedSection] autorelease];
            [_contentList addObject:tempArray];
        }
        [self.contactTableView reloadData];
    }
}

#pragma mark -
#pragma mark -----------Load SearchBarView--------------------
-(void)loadSearchBarView
{
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (!IOS_7)
    {
        searchBar.backgroundColor=COLOR(229, 229, 229, 1);
        [[searchBar.subviews objectAtIndex:0]removeFromSuperview];
    }

    [searchBar setPlaceholder:@"搜索联系人"];
    [searchBar setDelegate:self];
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [searchBar sizeToFit];
    self.contactTableView.tableHeaderView = searchBar;
    [searchBar release];
    
    _mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    _mySearchDisplayController.active = NO;
    _mySearchDisplayController.searchResultsTableView.dataSource=self;
    _mySearchDisplayController.searchResultsTableView.delegate=self;
    [_mySearchDisplayController setDelegate:self];
    [_mySearchDisplayController setSearchResultsDataSource:self];
    [_mySearchDisplayController setSearchResultsDelegate:self];
}

#pragma mark --------SearchBar delegate---------------------
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    NSLog(@"here scope");
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)hsearchBar
{
    [hsearchBar setShowsCancelButton:YES animated:NO];
    if (!IOS_7)
    {
        for(id cc in [searchBar subviews])
        {
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cc;
                [btn setBackgroundImage:[UIImage imageNamed:@"system_reject_hl_bg"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"system_reject_hl_bg"] forState:UIControlStateHighlighted];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                break;
            }
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar
{
//    [self.searchDisplayController setActive:NO animated:YES];
//	[self.contactTableView reloadData];
//    [UIView animateWithDuration:0.2 animations:^{
//        _contactTableView.frame=CGRectMake(0,kMSNaviHight, self.view.bounds.size.width, kMSTableViewHeight-44);
//    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[self.contactTableView reloadData];
//    [UIView animateWithDuration:0.2 animations:^{
//        _contactTableView.frame=CGRectMake(0,kMSNaviHight, self.view.bounds.size.width, kMSTableViewHeight-44);
//    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
//	[self.searchDisplayController setActive:NO animated:YES];
//	[self.contactTableView reloadData];
}

#pragma mark -
#pragma mark ContentFiltering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [_filteredListContent removeAllObjects];
    if (searchText.length>0&&![ChineseInclude isIncludeChineseInString:searchText])
    {
        for (NSArray *section in self.contentList)
        {
            for (FDSUser *user in section)
            {
                if ([ChineseInclude isIncludeChineseInString:user.m_displayName])
                {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:user.m_displayName];
                    NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0)
                    {
                        [_filteredListContent addObject:user];
                        continue;
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:user.m_displayName];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0)
                    {
                        [_filteredListContent addObject:user];
                    }
                }
                else
                {
                    NSRange titleResult=[user.m_displayName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0)
                    {
                        [_filteredListContent addObject:user];
                    }
                }
            }
        }
    }
    else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText])
    {
        for (NSArray *section in self.contentList)
        {
            for (FDSUser *user in section)
            {
                NSRange titleResult=[user.m_displayName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0)
                {
                    [_filteredListContent addObject:user];
                }
            }
        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString)
    {
        [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
	}
    else
    {
        return [self.contentList count]+2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.filteredListContent count];
    }
    else
    {
        if (0 == section)
        {
            return 2;
        }
        else if(1 == section)
        {
            return 1;
        }
        else
        {
            return [[self.contentList objectAtIndex:section-2] count];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView || 0 == section)
    {
        return nil;
    }
    else
    {
        if (1 == section)
        {
            return @"公众号";
        }
        else
        {
            return [[self.contentList objectAtIndex:section-2] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section-2] : nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView || 0 == section)
    {
        return 0;
    }
    else if(1 == section)//!=self.searchDisplayController.searchResultsTableView
    {
        return tableView.sectionHeaderHeight;
    }
    else
    {
        return [[self.contentList objectAtIndex:section-2] count] ? tableView.sectionHeaderHeight : 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = COLOR(142, 142, 142, 1);
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView )
    {
        return nil;
    }
    else
    {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 0;
    }
    else
    {
        if (title == UITableViewIndexSearch)
        {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        }
        else
        {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int se = indexPath.section;
    int ro = indexPath.row;

    if (tableView != self.searchDisplayController.searchResultsTableView)
    {
        if (0 == se)
        {
            AddressBookTableViewCell *addFriendCell = [[[AddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addFriend" addCellIndentify:YES] autorelease];
            if (0 == ro)
            {
                [addFriendCell.headImg initWithPlaceholderImage:[UIImage imageNamed:@"add_friend_logo_bg"]];
                addFriendCell.nameLab.text = @"添加好友";
            }
            else if(1 == ro)
            {
                [addFriendCell.headImg initWithPlaceholderImage:[UIImage imageNamed:@"add_company_logo_bg"]];
                addFriendCell.nameLab.text = @"添加企业号";
            }
            return addFriendCell;
        }
        else if(1 == se)
        {
            AddressBookTableViewCell *secFriendCell = [[[AddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secFriendCell" addCellIndentify:YES] autorelease];
            [secFriendCell.headImg initWithPlaceholderImage:[UIImage imageNamed:@"company_logo_bg"]];
            secFriendCell.nameLab.text = @"企业号";
            return secFriendCell;
        }
    }

    static NSString *cellIndentify = @"adressBookTableViewCell";
    AddressBookTableViewCell *adressBookCell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (nil == adressBookCell)
    {
        adressBookCell = [[[AddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify addCellIndentify:NO] autorelease];
    }
    
    FDSUser *user = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        user = (FDSUser *)[self.filteredListContent objectAtIndex:ro];
    }
    else
    {
        user = (FDSUser*)[[self.contentList objectAtIndex:se-2] objectAtIndex:ro];
    }
    
    //***config cell***
//    [adressBookCell.headImg initWithPlaceholderImage:[UIImage imageNamed:@"headphoto_s"]];
//    adressBookCell.headImg.imageURL = [NSURL URLWithString:user.m_icon];
    [adressBookCell.headImg initWithPlaceholderImage:[UIImage imageNamed:@"headphoto_s"]];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",user.m_icon];
    if (urlStr.length >= 4)
    {
        [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
    }
    adressBookCell.headImg.imageURL = [NSURL URLWithString:urlStr];

//    adressBookCell.nameLab.text = user.m_name;
    adressBookCell.nameLab.text = user.m_displayName;
    return adressBookCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int se = indexPath.section;
    int ro = indexPath.row;
    if (tableView != self.searchDisplayController.searchResultsTableView)
    {
        if (0 == se)
        {
            if (0 == ro)//@"添加好友"
            {
                FDSAddFriendViewController *addFriendVC = [[FDSAddFriendViewController alloc] init];
                [self.navigationController pushViewController: addFriendVC animated:YES];
                [addFriendVC release];
                return;
            }
            else if(1 == ro)//@"添加企业号"
            {
                FDSSearchFriendViewController *searchCompanyVC = [[FDSSearchFriendViewController alloc] init];
                searchCompanyVC.addStyle = ADD_FRIEND_STYLE_COMPANY;
                [self.navigationController pushViewController: searchCompanyVC animated:YES];
                [searchCompanyVC release];
                return;
            }
        }
        else if(1 == se) //@"企业号"
        {
            FDSComAccountViewController *comAccVC = [[FDSComAccountViewController alloc] init];
            [self.navigationController pushViewController:comAccVC animated:YES];
            [comAccVC release];
            return;
        }
    }
    
    FDSChatViewController *chatVC = [[FDSChatViewController alloc] init];
    
    /* 针对联系人操作 */
    FDSUser *friendInfo = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
        friendInfo = (FDSUser *)[self.filteredListContent objectAtIndex:ro];
    else
        friendInfo = (FDSUser *)[[self.contentList objectAtIndex:se-2] objectAtIndex:ro];
    
    FDSMessageCenter *messageCenter = [[FDSMessageCenter alloc] init];
    messageCenter.m_messageClass = FDSMessageCenterMessage_Class_USER; //个人信息
    messageCenter.m_messageType = FDSMessageCenterMessage_Type_CHAT_PERSON;
    messageCenter.m_icon = friendInfo.m_icon; //消息中心头像都显示好友头像
    messageCenter.m_senderName = friendInfo.m_displayName;//消息中心名字都显示好友名字
    messageCenter.m_senderID = friendInfo.m_friendID;//好友ID
    messageCenter.m_param1 = @"";
    messageCenter.m_param2 = @"";
    
    messageCenter.m_newMessageCount = [[FDSDBManager sharedManager] getChatMessageUnread:messageCenter];

    chatVC.centerMessage = messageCenter;
    [messageCenter release];
    [self.navigationController pushViewController: chatVC animated:YES];
    [chatVC release];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView || 0 == indexPath.section || 1 == indexPath.section)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *friends = [_contentList objectAtIndex:indexPath.section-2];
        FDSUser *user = [friends objectAtIndex:indexPath.row];
        [[FDSUserCenterMessageManager sharedManager]subFriend:user.m_friendID];  //delete request
        [friends removeObjectAtIndex:indexPath.row]; //delete page cache
        
        int newCount = -1;
        if (indexPath.section-2 < _contentList.count)
        {
            newCount = friends.count;
        }
        [tableView beginUpdates];
        
        NSArray *indexs = [NSArray arrayWithObject:indexPath];
        [tableView deleteRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationLeft];
        
        if (newCount == 0)
        {
            [_contentList removeObjectAtIndex:indexPath.section-2];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
        }

        [tableView endUpdates];
    }
}

/*    好友修改名称 修改头像消息推送     */
- (void)cardInfoModifyCB:(NSString*)cardType :(NSString*)modifyName :(NSString*)modifyIcon :(NSString*)userID
{
    BOOL isExist = NO;
    NSInteger section = 0 ;
    NSInteger row = 0;
    NSMutableArray *friends = nil;
    FDSUser *user = nil;
    for (int i=0; i < _contentList.count; i++)
    {
        friends = [_contentList objectAtIndex:i];
        for (int j=0; j<friends.count; j++)
        {
            user = [friends objectAtIndex:j];
            if ([user.m_friendID isEqualToString:userID])
            {
                if (modifyName && modifyName.length>0)
                {
                    user.m_name = modifyName;
                    if ([user.m_remarkName isEqualToString:@"(null)"] || user.m_remarkName.length <= 0)
                    {
                        user.m_displayName = user.m_name;
                    }
                }
                row = j;
                section = i;
                isExist = YES;
                break;
            }
        }
        if (isExist)
        {
            break;
        }
    }
    if (isExist)  //匹配到了
    {
        [self performSelector:@selector(updateContactImg:) withObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",row], [NSString stringWithFormat:@"%d",section], nil] afterDelay:1];
    }
}

- (void)updateContactImg:(NSArray *)inputArray
{
    [self fooFirstInput: [inputArray objectAtIndex:0] secondInput: [inputArray objectAtIndex:1]];
}


- (void)fooFirstInput:(NSString*)first secondInput:(NSString*)second
{
    NSArray *indexs = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[first integerValue] inSection:[second integerValue]+2]];
    [_contactTableView reloadRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
}

/*   匹配当前需删除的联系人   */
- (void)handleCurDelFriend:(FDSUser*)friendInfo
{
    BOOL isExist = NO;
    NSInteger section = 0 ;
    NSInteger row = 0;
    NSMutableArray *friends = nil;
    FDSUser *user = nil;
    for (int i=0; i < _contentList.count; i++)
    {
        friends = [_contentList objectAtIndex:i];
        for (int j=0; j<friends.count; j++)
        {
            user = [friends objectAtIndex:j];
            if ([user.m_friendID isEqualToString:friendInfo.m_friendID])
            {
                row = j;
                section = i;
                isExist = YES;
                break;
            }
        }
        if (isExist)
        {
            break;
        }
    }
    
    if (isExist)  //匹配到了
    {
        [friends removeObjectAtIndex:row]; //delete page cache
        
        int newCount = -1;
        if (section < _contentList.count)
        {
            newCount = friends.count;
        }
        [_contactTableView beginUpdates];
        
        NSArray *indexs = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:section+2]];
        [_contactTableView deleteRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationLeft];
        
        if (newCount == 0)
        {
            [_contentList removeObjectAtIndex:section];
            [_contactTableView deleteSections:[NSIndexSet indexSetWithIndex:section+2] withRowAnimation:UITableViewRowAnimationLeft];
        }

        [_contactTableView endUpdates];
    }
}

#pragma mark - FDSUserCenterMessageInterface Methods
/*  主动删除好友   针对TA的资料页面删除直接跳回来 操作当前页面缓存 */
- (void)subFriendCB:(NSString*)result :(FDSUser*)friendInfo
{
    if ([result isEqualToString:@"OK"])
    {
        [self handleCurDelFriend:friendInfo];
    }
}

/*  push消息  被好友对方删除  */
- (void)subedFriend:(FDSUser*)friendInfo
{
    [self handleCurDelFriend:friendInfo];
}


@end
