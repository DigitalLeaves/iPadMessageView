//
//  iPadMessageView.h
//
//  Created by ignacio Nieto Carvajal on 20/01/14.
//  Copyright (c) 2014 Ignacio Nieto Carvajal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    iPadMessageViewResponseAccept = 0,
    iPadMessageViewResponseCancel,
} iPadMessageViewResponse;

/**
 * iPadMessageViewTypeAcceptOrCancel: will generate a view with accept or cancel buttons. First one will cause an iPadMessageViewResponseAccept, whereas the cancel button will cause an iPadMessageViewResponseCancel.
 * iPadMessageViewTypeAcceptOnly: Will create a view with an accept button only that, when pushed, will cause an iPadMessageViewResponseAccept response.
 */
typedef enum {
    iPadMessageViewTypeAcceptOrCancel = 0,
    iPadMessageViewTypeAcceptOnly,
} iPadMessageViewType;

typedef void (^ResponseBlock) (iPadMessageViewResponse response);

@interface iPadMessageView : UIView

// properties

/** message to be displayed */
@property (nonatomic, strong) NSString * message;

/** title of the message view. If not specified, the default message is 'Message' */
@property (nonatomic, strong) NSString * title;

/** title font color. Default is light yellow */
@property (nonatomic, strong) UIColor * titleColor;

/** message font color. Default is white. */
@property (nonatomic, strong) UIColor * messageColor;

/** color for the text of the 'Ok' button */
@property (nonatomic, strong) UIColor * okButtonColor;

/** color for the text of the 'Cancel' button */
@property (nonatomic, strong) UIColor * cancelButtonColor;

/** Font for the title */
@property (nonatomic, strong) UIFont * titleFont;

/** Font for the message */
@property (nonatomic, strong) UIFont * messageFont;

// methods

/** @brief Designated initializer. Will create a new iPadMessageView.
 * This is the designated initializer for the iPadMessageView class. It will create a new view with the title, message and the response block, in the given orientation. The view will have two buttons, an "accept" button with a title set to NSLocalizedString @"Accept" and a cancel button set to NSLocalizedString @"Cancel".
 * @param title the title for the view, a short text message that will be shown in big font size.
 * @param message the message to display at the view, will be shown in a smaller font below the title.
 * @param orientation the orientation of the view to create: iPadMessageViewOrientationLandscape or iPadMessageViewOrientationPortrait
 * @param responseBlock a block that will be invoked when the user clicks any of the view's buttons. The response will be sent as the response parameter.
 */
- (id) initWithMessage: (NSString *) message title: (NSString *) title type: (iPadMessageViewType) type andResponseBlock: (ResponseBlock) responseBlock;

/** Convenience method for creating a message view prompting the user for accept/cancel options */
+ (iPadMessageView *) iPadPromptViewWithMessage: (NSString *) message title: (NSString *) title andResponseBlock: (ResponseBlock) responseBlock;

/** Convenience method for creating an informative message with only an accept option. */
+ (iPadMessageView *) iPadInformativeViewWithMessage: (NSString *) message title: (NSString *) title andResponseBlock: (ResponseBlock) responseBlock;

@end




