//
//  NTESProductPriceContentView.m
//  YiShangbao
//
//  Created by simon on 2018/5/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NTESProductPriceContentView.h"

#import "NTESSendProductLinkAttachment.h"
#import "UIImage+NIMKit.h"

static  CGFloat titleTextFont = 14.f;
static  CGFloat recommandTextFont = 15.f;


@implementation NTESProductPriceContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initSessionMessageContentView
{
    self = [super initSessionMessageContentView];
    if (self) {
 
        
        [self addSubview:self.titleLab];
        [self addSubview:self.describeLab];
        [self addSubview:self.imageView];

        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"ECECEC"];
        [self addSubview:_lineView];
        
        [self addSubview:self.detailLab];

        _rowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_>_gr"]];
        [_rowImgView sizeToFit];
        [self addSubview:_rowImgView];
        
    }
    return self;
}

- (UILabel *)titleLab
{
    if (!_titleLab)
    {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = [UIFont systemFontOfSize:titleTextFont];
        _titleLab.numberOfLines = 2;
        _titleLab.textColor = [UIColor colorWithHexString:@"535353"];
    }
    return _titleLab;
}

- (UILabel *)describeLab
{
    if (!_describeLab)
    {
        _describeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _describeLab.font = [UIFont systemFontOfSize:recommandTextFont];
        _describeLab.numberOfLines = 2;
        _describeLab.textColor = [UIColor colorWithHexString:@"F58F23"];
    }
    return _describeLab;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)detailLab
{
    if (!_detailLab)
    {
        _detailLab = [[UILabel alloc] init];
        _detailLab.text = @"点击查看详情";
        _detailLab.textColor = [UIColor colorWithHexString:@"42B5FF"];
        _detailLab.font = [UIFont systemFontOfSize:14];
        [_detailLab sizeToFit];
    }
    return _detailLab;
}



- (void)refresh:(NIMMessageModel*)data
{
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    id attachment = object.attachment;
 
    if([attachment isKindOfClass:[NTESSendProductLinkAttachment class]])
    {
        NTESSendProductLinkAttachment *attach = (NTESSendProductLinkAttachment *)attachment;
        NTESSendProductLinkModel *model = attach.model;
        self.titleLab.text = model.name;
        self.describeLab.text = model.price;
        NSURL *url = [NSURL URLWithString:model.pic];
        [self.imageView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
    }
    if(self.model.message.isOutgoingMsg)
    {
        [self.bubbleImageView setImage:[self bubbleImage:UIControlStateNormal]];
        [self.bubbleImageView setHighlightedImage:[self bubbleImage:UIControlStateHighlighted]];
        [self setNeedsLayout];
    }
}

- (UIImage *)bubbleImage:(UIControlState)state;
{
    UIEdgeInsets insets = UIEdgeInsetsMake(30, 25, 10, 25);
    return [[UIImage nim_imageInKit:@"pic_duihuakuang2"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.model)
    {
        return;
    }
    CGSize contentSize = [self.model contentSize:CGRectGetWidth(self.frame)];
    
    CGFloat  padding = 12;
    CGFloat  originX = 12;
    CGFloat picWidth = 67.f;
    
    if(!self.model.message.isOutgoingMsg)
    {
        originX = originX +10;
    }
    
    CGFloat topBottomPadding = 10.f;
    
    NIMCustomObject *object = self.model.message.messageObject;
    id attachment = object.attachment;
    if([attachment isKindOfClass:[NTESSendProductLinkAttachment class]])
    {
        self.imageView.frame = CGRectMake(originX, topBottomPadding, picWidth, picWidth);
        CGFloat height = [NSString zhGetBoundingSizeOfString:self.titleLab.text WithSize:CGSizeMake(contentSize.width-2*padding-CGRectGetMaxX(self.imageView.frame)-8, self.titleLab.font.lineHeight*2+3) font:self.titleLab.font].height;
        self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+8, topBottomPadding, contentSize.width-padding-CGRectGetMaxX(self.imageView.frame)-8, height);
        
        if (![NSString zhIsBlankString:self.describeLab.text])
        {
            CGFloat height = [NSString zhGetBoundingSizeOfString:self.describeLab.text WithSize:CGSizeMake(contentSize.width-padding-CGRectGetMaxX(self.imageView.frame)-8, self.describeLab.font.lineHeight*2+3) font:self.describeLab.font].height;
            self.describeLab.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+8, CGRectGetMaxY(self.imageView.frame)-17, contentSize.width-padding-CGRectGetMaxX(self.imageView.frame)-8, height);
        }
        if (CGRectGetMaxY(self.imageView.frame)>CGRectGetMaxY(self.describeLab.frame))
        {
            self.lineView.frame = CGRectMake(originX, CGRectGetMaxY(self.imageView.frame)+10, contentSize.width-2*padding, 0.5);
        }
        else
        {
            self.lineView.frame = CGRectMake(originX, CGRectGetMaxY(self.describeLab.frame)+10, contentSize.width-2*padding, 0.5);
        }
        
        CGRect frame = self.detailLab.frame;
        frame.origin = CGPointMake(originX, CGRectGetMaxY(self.lineView.frame)+10);
        self.detailLab.frame = frame;
        
        CGRect frame2 = self.rowImgView.frame;
        frame2.origin = CGPointMake(contentSize.width-CGRectGetWidth(self.rowImgView.frame)-padding, CGRectGetMaxY(self.lineView.frame)+12);
        if (!self.model.message.isOutgoingMsg) {
            frame2.origin = CGPointMake(contentSize.width-CGRectGetWidth(self.rowImgView.frame)-padding+10, CGRectGetMaxY(self.lineView.frame)+12);
        }
        self.rowImgView.frame = frame2;
    }
}


- (void)onTouchUpInside:(id)sender
{
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapProductPicTextLink;
    event.messageModel = self.model;
    [self.delegate onCatchEvent:event];
}

@end
