iPadMessageView
===============

iPadMessageView is a simple and elegant message view for iPad with Accept and/or Cancel prompt options, using blocks.

The default view will present a semi-transparent dark background with a main title, a text message and optionally one or two buttons: "accept" or "cancel". iPadMessageView will use blocks for reacting to the user response to the prompt options, making it easier and more clear to use it in your code. 

![](http://digitalleaves.com/blog/wp-content/uploads/2014/01/iPadMessageView.jpg)

Integration
===========

To use it on your code, simply add the files iPadMessageView.m and iPadMessageView.h to your project, and then on your iPad ViewController, when you want to add a new message view, simply create one:

```
NSString * message = @"...";
NSString * title = @"...";

self.messageView = [[iPadMessageView alloc] initWithMessage: message title: title type: iPadMessageViewTypeAcceptOrCancel andResponseBlock: ^(iPadMessageViewResponse response) {
  if (response == iPadMessageViewResponseAccept) {
    // user pushed the 'accept' button
  } else if (response == iPadMessageViewResponseCancel) {
    // user pushed the 'cancel' button
  }
}];
    
```

The type parameter determines if the dialog will prompt the user for an accept/cancel response (iPadMessageViewTypeAcceptOrCancel) or will only present an 'accept" button (iPadMessageViewTypeAcceptOnly). 

Localization
============

iPadMessageView uses NSLocalizedString for presenting the Accept and Cancel buttons, so if you want to localize the view you just have to add in your localized.strings the following terms:

```
"Accept" = "...";
"Cancel" = "...";
```

Interface Orientation Changes
=============================

iPadMessageView registers itself for changes in orientation, and deregisters itself on being removed from the superview. The view will remove itself from its superview after returning with the responseBlock.

License
=======

iPadMessageView is under the MIT license. However, if you find it useful, let me know, and share the love!

Copyright (c) 2014 Ignacio Nieto Carvajal

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
