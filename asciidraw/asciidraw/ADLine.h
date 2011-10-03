#import <Foundation/Foundation.h>
#import "ADCharMatrix.h"

@interface ADLine : NSObject {
@private
    CGPoint start, end; // in units of characters
}

+ (ADLine *)lineWithStart:(CGPoint)start end:(CGPoint)end;
- (void)draw:(ADCharMatrix *)matrix overlay:(BOOL)overlay;

@end
