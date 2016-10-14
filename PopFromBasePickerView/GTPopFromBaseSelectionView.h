//
//  GTPopFromBaseSelectionView.h
//  GDTaoJin
//
//  Created by Li Tingyu on 16/10/12.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTPopFromBaseSelectionView;

@protocol GTPopFromBaseSelectionDataSource <UIPickerViewDataSource>

@end

@protocol GTPopFromBaseSelectionDelegate <UIPickerViewDelegate>

@optional

- (void)confirmIsChoosed:(GTPopFromBaseSelectionView *)view;

- (void)concelIsChoosed:(GTPopFromBaseSelectionView *)view;

@end


@interface GTPopFromBaseSelectionView : UIView

@property (nonatomic, retain)UIPickerView * mPickerView;

@property (nonatomic, weak) id<GTPopFromBaseSelectionDataSource> dataSource;

@property (nonatomic, weak) id<GTPopFromBaseSelectionDelegate> delegate;

@property (nonatomic, copy) NSString * myTitle;

@property (nonatomic, retain) UIButton * cancelBtn;

@property (nonatomic, retain) UIButton * confirmBtn;

@property (nonatomic, retain) UIView * maskView;



- (void)showInView:(UIView *)view;


//这个只能显示component为1的情况
- (void)showInView:(UIView *)view shouldSelectRow:(NSInteger)row inComponent:(NSInteger)component;

- (void)cancelPickerView;

- (BOOL)pickerIsShown;

@end
