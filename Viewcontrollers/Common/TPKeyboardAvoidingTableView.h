//
//  TPKeyboardAvoidingTableView.h
//
//  Created by Michael Tyson on 11/04/2011.
//  Copyright 2011 A Tasty Pixel. All rights reserved.
//

@protocol TouchTableViewDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface TPKeyboardAvoidingTableView : UITableView {
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
}
@property(nonatomic,assign)id<TouchTableViewDelegate> touchedDelegate;

- (void)adjustOffsetToIdealIfNeeded;
- (UIView*)findFirstResponderBeneathView:(UIView*)view;
@end
