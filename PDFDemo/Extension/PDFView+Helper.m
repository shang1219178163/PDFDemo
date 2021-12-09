//
//  PDFView+Helper.m
//  PDFDemo
//
//  Created by shangbinbin on 2021/12/9.
//  Copyright © 2021 Japho. All rights reserved.
//

#import "PDFView+Helper.h"

@implementation PDFView (Helper)

- (void)resetScaleFactor {
    self.scaleFactor = self.scaleFactorForSizeToFit;
}


@end
