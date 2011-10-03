#import <Foundation/Foundation.h>

@protocol ADCharMatrixChangeObserver
- (void)observeCharAtColumn:(int)column
                        row:(int)row
                changedFrom:(unichar)oldChar
                         to:(unichar)newChar;
@end

@interface ADCharMatrix : NSObject {
@private
    int width, height;
    NSMutableString *chars, *overlay;
    NSMutableArray *observers;
}

@property (readonly) int width;
@property (readonly) int height;

- (void)replaceCharAtColumn:(int)column
                        row:(int)row
                   withChar:(unichar)newChar
                    overlay:(BOOL) overlay;
- (void)clearOverlay;
- (void)addObserver:(id <ADCharMatrixChangeObserver>)observer;
- (void)removeObserver:(id <ADCharMatrixChangeObserver>)observer;
- (id)initWithColumns:(int)width rows:(int)height;

@end
