//
//  UIView+TWTConstraintsForAutoresizingMask.m
//  Translates
//
//  Created by Andrew Hershberger on 5/27/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import "UIView+TWTConstraintsForAutoresizingMask.h"


@implementation UIView (TWTConstraintsForAutoresizingMask)

- (NSArray *)twt_constraintsEquivalentToAutoresizingMask
{
    UIViewAutoresizing mask = self.autoresizingMask;

    if (!(mask & (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin))) {
        mask = mask | UIViewAutoresizingFlexibleRightMargin;
    }

    BOOL flexibleLeftMargin = mask & UIViewAutoresizingFlexibleLeftMargin;
    BOOL flexibleWidth = mask & UIViewAutoresizingFlexibleWidth;
    BOOL flexibleRightMargin = mask & UIViewAutoresizingFlexibleRightMargin;

    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat superviewWidth = CGRectGetWidth(self.superview.bounds);
    CGFloat leftMargin = CGRectGetMinX(self.frame) - CGRectGetMinX(self.superview.bounds);
    CGFloat rightMargin = CGRectGetMaxX(self.superview.bounds) - CGRectGetMaxX(self.frame);

    // Generate a width constraint

    NSLayoutConstraint *widthConstraint = nil;
    if (flexibleWidth) {
        // Relate the width to the superview's width

        CGFloat multiplier;
        CGFloat constant;

        if (flexibleLeftMargin && flexibleRightMargin) {
            multiplier = width / superviewWidth;
            constant = 0;
        }
        else if (flexibleLeftMargin) {
            multiplier = width / (superviewWidth - rightMargin);
            constant = 0 - rightMargin * multiplier;
        }
        else if (flexibleRightMargin) {
            multiplier = width / (superviewWidth - leftMargin);
            constant = 0 - leftMargin * multiplier;
        }
        else {
            multiplier = 1;
            constant = width - superviewWidth;
        }

        widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.superview
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:multiplier
                                                        constant:constant];
    }
    else {
        // Generate a fixed-width constraint

        widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:0
                                                        constant:CGRectGetWidth(self.frame)];
    }

    // Generate a horizontal position constraint

    id toItem = self.superview;
    NSLayoutAttribute toItemAttribute;
    CGFloat multiplier;
    CGFloat constant;

    if (flexibleLeftMargin && flexibleRightMargin) {
        // works for both flexibleWidth == YES and flexibleWidth == NO

        // This differs from Apple's implementation in that their
        // implementation returns a constraint that relates the width
        // of the superview to the centerX of self
        // For some reason, the public interface raises an exception
        // if you try to create a constraint like this:

        // toItemAttribute = NSLayoutAttributeWidth;
        // multiplier = CGRectGetMidX(self.frame) / superviewWidth;
        // constant = 0;

        // *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** +[NSLayoutConstraint constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:]: Invalid pairing of layout attributes'

        // An alternative (and perhaps more semantically accurate) approach is to use the superview's NSLayoutAttributeRight

        toItemAttribute = NSLayoutAttributeRight;
        multiplier = CGRectGetMidX(self.frame) / superviewWidth;
        constant = 0;
    }
    else if (flexibleLeftMargin && flexibleWidth) {
        toItemAttribute = NSLayoutAttributeCenterX;
        multiplier = CGRectGetMidX(self.frame) / (0.5 * (superviewWidth - rightMargin));
        constant = - (rightMargin / 2) * multiplier;
    }
    else if (flexibleWidth && flexibleRightMargin) {
        toItemAttribute = NSLayoutAttributeCenterX;
        multiplier = CGRectGetMidX(self.frame) / (0.5 * (superviewWidth - leftMargin));
        constant = leftMargin - (leftMargin / 2) * multiplier;
    }
    else if (flexibleLeftMargin) {

        // This differs from Apple's implementation in that their
        // implementation returns a constraint that relates the width
        // of the superview to the centerX of self
        // For some reason, the public interface raises an exception
        // if you try to create a constraint like this:

        // toItemAttribute = NSLayoutAttributeWidth;
        // multiplier = 1;
        // constant = superviewWidth - CGRectGetMinX(self.frame);

        // *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** +[NSLayoutConstraint constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:]: Invalid pairing of layout attributes'

        // An alternative (and perhaps more semantically accurate) approach is to use the superview's NSLayoutAttributeRight

        toItemAttribute = NSLayoutAttributeRight;
        multiplier = 1;
        constant = CGRectGetMidX(self.frame) - CGRectGetMaxX(self.superview.frame);
    }
    else if (flexibleWidth) {
        toItemAttribute = NSLayoutAttributeCenterX;
        multiplier = 1;
        constant = CGRectGetMidX(self.frame) - CGRectGetMidX(self.superview.bounds);
    }
    else if (flexibleRightMargin) {

        // This differs from Apple's implementation in that their
        // implementation returns a constraint with secondItem == nil
        // and secondAttribute == NSLayoutAttributeNotAnAttribute
        // For some reason, the public interface raises an exception
        // if you try to create a constraint like this:

        // toItem = nil;
        // toItemAttribute = NSLayoutAttributeNotAnAttribute;
        // multiplier = 1;
        // constant = CGRectGetMidX(self.frame);

        // *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** +[NSLayoutConstraint constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:]: A constraint cannot be made that sets a location equal to a constant. Location attributes must be specified in pairs'

        toItemAttribute = NSLayoutAttributeLeft;
        multiplier = 1;
        constant = CGRectGetMidX(self.frame);
    }

    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:toItem
                                                                         attribute:toItemAttribute
                                                                        multiplier:multiplier
                                                                          constant:constant];
    
    // TODO: vertical equivalents
    
    return @[ widthConstraint, centerXConstraint ];
}

@end
