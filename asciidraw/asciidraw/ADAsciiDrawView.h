#import <UIKit/UIKit.h>
#import "ADCharMatrix.h"

@interface ADAsciiDrawView : UIView <ADCharMatrixChangeObserver> {
@private
    ADCharMatrix *charMatrix;
    NSMutableArray *charLabels;
    CGPoint dragStart;
}

@end
