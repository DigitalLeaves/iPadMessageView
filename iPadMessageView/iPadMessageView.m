//
//  iPadMessageView.m
//
//  Created by Ignacio Nieto Carvajal on 20/01/14.
//  Copyright (c) 2014 Ignacio Nieto Carvajal. All rights reserved.
//

#import "iPadMessageView.h"

#define kiPadMessageViewYellowColor             [UIColor colorWithRed:1.0 green:0.83 blue:0.47 alpha:1.0]
#define kiPadMessageViewGreenColor              [UIColor colorWithRed:0.35 green:0.85 blue:0.17 alpha:1.0]
#define kiPadMessageViewRedColor                [UIColor colorWithRed:1.0 green:0.32 blue:0.18 alpha:1.0]
#define kiPadMessageViewDarkenColor             [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75]

#define kiPadMessageViewWidthLandscape          1024
#define kiPadMessageViewHeightLandscape         768
#define kiPadMessageViewWidthPortrait           768
#define kiPadMessageViewHeightPortrait          1024

#define kiPadMessageViewHeightAnchor            80
#define kiPadMessageViewWidthAnchor             60
#define kiPadMessageViewMessageHeight           120

@interface iPadMessageView ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UIButton * okButton;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) ResponseBlock responseBlock;
@property (nonatomic) iPadMessageViewType messageViewType;
@property (nonatomic) UIInterfaceOrientation orientation;

@end


@implementation iPadMessageView

@synthesize title = _title;
@synthesize titleColor = _titleColor;
@synthesize titleLabel = _titleLabel;
@synthesize titleFont = _titleFont;
@synthesize messageColor = _messageColor;
@synthesize messageFont = _messageFont;
@synthesize message = _message;
@synthesize okButtonColor = _okButtonColor;
@synthesize cancelButtonColor = _cancelButtonColor;
@synthesize messageLabel = _messageLabel;
@synthesize okButton = _okButton;
@synthesize cancelButton = _cancelButton;
@synthesize messageViewType = messageViewType;
@synthesize responseBlock = _responseBlock;

- (id) initWithMessage: (NSString *) message title: (NSString *) title type: (iPadMessageViewType) type andResponseBlock: (ResponseBlock)responseBlock
{
    UIInterfaceOrientation currentInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsLandscape(currentInterfaceOrientation))
        self = [super initWithFrame:CGRectMake(0, 0, kiPadMessageViewWidthLandscape, kiPadMessageViewHeightLandscape)];
    else self = [super initWithFrame:CGRectMake(0, 0, kiPadMessageViewWidthPortrait, kiPadMessageViewHeightPortrait)];
    
    if (self) {
        self.orientation = currentInterfaceOrientation;
        self.messageViewType = type;
        self.responseBlock = responseBlock;
        self.opaque = NO;
        self.backgroundColor = kiPadMessageViewDarkenColor;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2.0, kiPadMessageViewHeightAnchor)];
        self.titleLabel.text = title;
        self.titleLabel.numberOfLines = 1;
        [self.titleLabel setFont:self.titleFont];
        self.titleLabel.textColor = self.titleColor;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.opaque = NO;
        [self.titleLabel sizeToFit];
        [self.titleLabel setCenter:CGPointMake(self.frame.size.width / 2, (self.frame.size.height / 2) - kiPadMessageViewHeightAnchor)];
        [self addSubview:self.titleLabel];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 3 / 4, kiPadMessageViewMessageHeight)];
        self.messageLabel.text = message;
        self.messageLabel.numberOfLines = 3;
        self.messageLabel.textColor = self.messageColor;
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.opaque = NO;
        self.messageLabel.font = self.messageFont;
        //[self.messageLabel sizeToFit];
        [self.messageLabel setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
        [self addSubview:self.messageLabel];
        
        CGFloat diffXPos = 0;
        if (self.messageViewType == iPadMessageViewTypeAcceptOrCancel) diffXPos = kiPadMessageViewWidthAnchor;
        
        self.okButton = [[UIButton alloc] init];
        [self.okButton setTitle:NSLocalizedString(@"Accept", @"Accept") forState:UIControlStateNormal];
        [self.okButton setTitleColor:self.okButtonColor forState:UIControlStateNormal];
        self.okButton.backgroundColor = [UIColor clearColor];
        self.okButton.opaque = NO;
        [self.okButton sizeToFit];
        [self.okButton setCenter:CGPointMake(self.frame.size.width / 2 - diffXPos, (self.frame.size.height / 2) + kiPadMessageViewHeightAnchor)];
        [self.okButton addTarget:self action:@selector(acceptButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.okButton];
        
        if (self.messageViewType == iPadMessageViewTypeAcceptOrCancel) {
            self.cancelButton = [[UIButton alloc] init];
            [self.cancelButton setTitle:NSLocalizedString(@"Cancel", @"Cancel") forState:UIControlStateNormal];
            [self.cancelButton setTitleColor:self.cancelButtonColor forState:UIControlStateNormal];
            self.cancelButton.backgroundColor = [UIColor clearColor];
            self.cancelButton.opaque = NO;
            [self.cancelButton sizeToFit];
            [self.cancelButton setCenter:CGPointMake(self.frame.size.width / 2 + diffXPos, (self.frame.size.height / 2) + kiPadMessageViewHeightAnchor)];
            [self.cancelButton addTarget:self action:@selector(cancelButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.cancelButton];
        }
        
        // add ourselves as listeners for orientation change notifications.
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(deviceOrientationDidChangeNotification:)
         name:UIDeviceOrientationDidChangeNotification
         object:nil];
    }
    return self;
}

- (void) removeFromSuperview {
    [super removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (iPadMessageView *) iPadPromptViewWithMessage:(NSString *)message title:(NSString *)title andResponseBlock:(ResponseBlock)responseBlock {
    return [[iPadMessageView alloc] initWithMessage:message title:title type:iPadMessageViewTypeAcceptOrCancel andResponseBlock:responseBlock];
}

+ (iPadMessageView *) iPadInformativeViewWithMessage:(NSString *)message title:(NSString *)title andResponseBlock:(ResponseBlock)responseBlock {
    return [[iPadMessageView alloc] initWithMessage:message title:title type:iPadMessageViewTypeAcceptOnly andResponseBlock:responseBlock];
}


#pragma mark button actions

- (IBAction) acceptButtonTouched: (id) sender {
    if (self.responseBlock) self.responseBlock(iPadMessageViewResponseAccept);
    [self removeFromSuperview];
}

- (IBAction) cancelButtonTouched: (id) sender {
    if (self.responseBlock) self.responseBlock(iPadMessageViewResponseCancel);
    [self removeFromSuperview];
}

#pragma mark properties

- (void) setMessage:(NSString *)message {
    _message = message;
    [self.messageLabel setText:message];
}

- (void) setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:title];
}

- (UIColor *) titleColor {
    if (!_titleColor) {
        _titleColor = kiPadMessageViewYellowColor;
    }
    return _titleColor;
}

- (void) setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.titleLabel setTextColor:titleColor];
}

- (UIColor *) messageColor {
    if (!_messageColor) {
        _messageColor = [UIColor whiteColor];
    }
    return _messageColor;
}

- (void) setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;
    [self.messageLabel setTextColor:messageColor];
}

- (UIColor *) okButtonColor {
    if (!_okButtonColor) {
        _okButtonColor = kiPadMessageViewGreenColor;
    }
    return _okButtonColor;
}

- (void) setOkButtonColor:(UIColor *)okButtonColor {
    _okButtonColor = okButtonColor;
    [self.okButton setTitleColor:okButtonColor forState:UIControlStateNormal];
}

- (UIColor *) cancelButtonColor {
    if (!_cancelButtonColor) {
        _cancelButtonColor = kiPadMessageViewRedColor;
    }
    return _cancelButtonColor;
}

- (void) setCancelButtonColor:(UIColor *)cancelButtonColor {
    _cancelButtonColor = cancelButtonColor;
    [self.cancelButton setTitleColor:cancelButtonColor forState:UIControlStateNormal];
}

- (void) setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self.titleLabel setFont:titleFont];
}

- (UIFont *) titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:36];
    }
    return _titleFont;
}

- (void) setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;
    [self.messageLabel setFont:messageFont];
}

- (UIFont *) messageFont {
    if (!_messageFont) {
        _messageFont = [UIFont systemFontOfSize: 20];
    }
    return _messageFont;
}

#pragma mark orientation

- (void)deviceOrientationDidChangeNotification:(NSNotification*)note {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == self.orientation) return;
    else {
        self.orientation = orientation;
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            self.frame = CGRectMake(0, 0, kiPadMessageViewWidthLandscape, kiPadMessageViewHeightLandscape);
        } else {
            self.frame = CGRectMake(0, 0, kiPadMessageViewWidthPortrait, kiPadMessageViewHeightPortrait);
        }
        
        [self.titleLabel setFrame:CGRectMake(0, 0, self.frame.size.width / 2.0, kiPadMessageViewHeightAnchor)];
        [self.titleLabel sizeToFit];
        [self.titleLabel setCenter:CGPointMake(self.frame.size.width / 2, (self.frame.size.height / 2) - kiPadMessageViewHeightAnchor)];
        [self.messageLabel setFrame:CGRectMake(0, 0, self.frame.size.width * 3 / 4, kiPadMessageViewMessageHeight)];
        [self.messageLabel setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
        
        CGFloat diffXPos = 0;
        if (self.messageViewType == iPadMessageViewTypeAcceptOrCancel) diffXPos = kiPadMessageViewWidthAnchor;
        [self.okButton setCenter:CGPointMake(self.frame.size.width / 2 - diffXPos, (self.frame.size.height / 2) + kiPadMessageViewHeightAnchor)];
        if (self.messageViewType == iPadMessageViewTypeAcceptOrCancel) {
            [self.cancelButton setCenter:CGPointMake(self.frame.size.width / 2 + diffXPos, (self.frame.size.height / 2) + kiPadMessageViewHeightAnchor)];
        }
        [self setNeedsDisplay];
    }
    
}
@end


















