//
//  GTPopFromBaseSelectionView.m
//  GDTaoJin
//
//  Created by Li Tingyu on 16/10/12.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "GTPopFromBaseSelectionView.h"
#import "UIFont+Gxd.h"

#define GTSelection_picker_height 250
#define GTSelection_titleView_height 40

#define GTSelection_Picker_backgroundColor [UIColor colorWithHexValue:0xd1d5da alpha:1.f]

@interface GTPopFromBaseSelectionView ()


@property (nonatomic, retain) UIView * mTitleView;

@property (nonatomic, retain) UILabel * selectionTitleLbl;

@property (nonatomic, assign) BOOL isShown;


@end

@implementation GTPopFromBaseSelectionView

- (id)init
{
    if (self = [self initWithFrame:CGRectMake(0, 0, kGT_SCREEN_WIDTH, GTSelection_picker_height)]) {
        
        self.backgroundColor = GTSelection_Picker_backgroundColor;
        
        [self addSubview:self.mTitleView];
        
        [self addSubview:self.mPickerView];
    }
    return self;
}


#pragma mark -  setter and getter


- (UIView *)mTitleView
{
    if (!_mTitleView) {
        _mTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kGT_SCREEN_WIDTH, GTSelection_titleView_height)];
        _mTitleView.backgroundColor = [UIColor colorWithHexValue:0xe0e0e0 alpha:1];
        [_mTitleView addSubview:self.cancelBtn];
        [_mTitleView addSubview:self.confirmBtn];
    }
    return _mTitleView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kGT_SCREEN_WIDTH, kGT_SCREEN_HEIGHT)];;
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPickerView)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UILabel *)selectionTitleLbl
{
    if (!_selectionTitleLbl) {
        _selectionTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kGT_SCREEN_HEIGHT, GTSelection_titleView_height)];
        _selectionTitleLbl.backgroundColor = [UIColor clearColor];
        _selectionTitleLbl.text = self.myTitle;
        _selectionTitleLbl.centerX = self.centerX;
        _selectionTitleLbl.textColor = [UIColor textBlackColor];
        _selectionTitleLbl.textAlignment = NSTextAlignmentCenter;
        _selectionTitleLbl.font = [UIFont cpFontWithSize:18.f];
    }
    return _selectionTitleLbl;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, GTSelection_titleView_height)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(tapCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(kGT_SCREEN_WIDTH - 60, 0, 60, GTSelection_titleView_height)];
        [_confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(tapConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIPickerView *)mPickerView
{
    if (!_mPickerView) {
        _mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mTitleView.frame), kGT_SCREEN_WIDTH, GTSelection_picker_height)];
        _mPickerView.backgroundColor = GTSelection_Picker_backgroundColor;
    }
    return _mPickerView;
}

- (void)setMyTitle:(NSString *)myTitle
{
    if ([myTitle hasValue]) {
        _myTitle = myTitle;
        [self.mTitleView addSubview:self.selectionTitleLbl];
    }
}

- (void)setDataSource:(id<GTPopFromBaseSelectionDataSource>)dataSource
{
    self.mPickerView.dataSource = dataSource;
    _dataSource = dataSource;
}

- (void)setDelegate:(id<GTPopFromBaseSelectionDelegate>)delegate
{
    _delegate = delegate;
    self.mPickerView.delegate = delegate;
}


#pragma mark - actions
- (void)tapConfirmBtn
{
    if ([self.delegate respondsToSelector:@selector(confirmIsChoosed:)]) {
        [self.delegate confirmIsChoosed:self];
    }
}

- (void)tapCancelBtn
{
    [self cancelPickerView];
    
    if ([self.delegate respondsToSelector:@selector(concelIsChoosed:)]) {
        [self.delegate concelIsChoosed:self];
    }
}


#pragma mark - picker view delegate and datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.dataSource numberOfComponentsInPickerView:pickerView];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataSource pickerView:pickerView numberOfRowsInComponent:component];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.delegate pickerView:pickerView titleForRow:row forComponent:component];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.delegate pickerView:pickerView didSelectRow:row inComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
{
    return [self.delegate pickerView:pickerView rowHeightForComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self.delegate pickerView:pickerView widthForComponent:component];
}

#pragma mark - public methods
- (void)showInView:(UIView *)view
{
    __weak typeof(self) weakSelf = self;
    self.frame = CGRectMake(0, view.height, self.width, self.height);
    [view addSubview:self.maskView];
    [view insertSubview:self aboveSubview:self.maskView];
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.frame = CGRectMake(0, view.height - weakSelf.height, weakSelf.width, weakSelf.height);
    }];
    self.isShown = YES;
}

- (void)showInView:(UIView *)view shouldSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self showInView:view];
    
    [self.mPickerView selectRow:row inComponent:component animated:NO];
    [self.mPickerView reloadComponent:component];
}

- (void)cancelPickerView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.frame = CGRectMake(0, weakSelf.origin.y+self.height, weakSelf.width, weakSelf.height);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.maskView removeFromSuperview];
    }];
    self.isShown = NO;
}

- (BOOL)pickerIsShown
{
    return self.isShown;
}

@end
