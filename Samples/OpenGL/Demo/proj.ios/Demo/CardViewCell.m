//
//  CardViewCell.m
//  Demo
//
//  Created by hgf on 2018/12/5.
//  Copyright © 2018 live2d. All rights reserved.
//

#import "CardViewCell.h"
#import "ViewController.h"

@interface CardViewCell ()
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic ,strong) UIButton *douBtn;
@property (nonatomic ,strong) UIImageView *imgView;
@property (nonatomic ,strong) ViewController *vc;

@end

@implementation CardViewCell

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"态度题";
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.layer.cornerRadius = 4;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = RGB(244, 59, 86);
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    }
    return _titleLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"12 : 08 : 24";
        _timeLabel.textColor = RGB(128, 128, 128);
        _timeLabel.layer.cornerRadius = 4;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = RGB(236, 236, 236);
        _timeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    }
    return _timeLabel;
}

-(UIButton *)douBtn{
    if (!_douBtn){
        _douBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _douBtn.backgroundColor = RGB(127, 127, 127);
        [_douBtn setFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:12]];
        [_douBtn setTitle:@"30 嗨豆" forState:(UIControlStateNormal)];
        [_douBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        [_douBtn setImage:[UIImage imageNamed:@"gold"] forState:(UIControlStateNormal)];
        _douBtn.layer.cornerRadius = 4;
    }
    return _douBtn;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg2.jpeg"]];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}




-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 5;
        self.layer.shadowColor = RGBA(0, 0, 0, 0.3).CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.5;
        
        self.vc = [[ViewController alloc]init];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.douBtn];
        [self.contentView addSubview:self.imgView];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(10, 20, 60, 20);
    self.timeLabel.frame = CGRectMake(80, 20, 80, 20);
    self.douBtn.frame = CGRectMake(335 - 75, 20, 65, 20);
    self.imgView.frame = CGRectMake(10, 50, 315, 315);
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.vc touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.vc touchesEnded:touches withEvent:event];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.vc touchesMoved:touches withEvent:event];
}

@end
