#import <math.h>
#import "ADLine.h"

#define MIN_LINE_LENGTH (0.1)

@implementation ADLine

- (void)drawHorizontalFrom:(CGPoint)left
                        to:(CGPoint)right
                      into:(ADCharMatrix *)matrix
                   overlay:(BOOL)overlay
{
    float gradient = (right.y - left.y) / (right.x - left.x);
    unichar hash = [@"#" characterAtIndex:0];
    for (int x = (int)roundf(left.x); x <= (int)roundf(right.x); x++) {
        int y = roundf((x - left.x) * gradient + left.y);
        if (x >= 0 && x < matrix.width && y >= 0 && y < matrix.height) {
            [matrix replaceCharAtColumn:x row:y withChar:hash overlay:overlay];
        }
    }
}


- (void)drawVerticalFrom:(CGPoint)top
                      to:(CGPoint)bottom
                    into:(ADCharMatrix *)matrix
                 overlay:(BOOL)overlay
{
    float gradient = (bottom.x - top.x) / (bottom.y - top.y);
    unichar hash = [@"#" characterAtIndex:0];
    for (int y = (int)roundf(top.y); y <= (int)roundf(bottom.y); y++) {
        int x = roundf((y - top.y) * gradient + top.x);
        if (x >= 0 && x < matrix.width && y >= 0 && y < matrix.height) {
            [matrix replaceCharAtColumn:roundf(x) row:y withChar:hash overlay:overlay];
        }
    }
}


- (void)draw:(ADCharMatrix *)matrix overlay:(BOOL)overlay
{
    float horizontal = fabsf(self->start.x - self->end.x);
    float vertical   = fabsf(self->start.y - self->end.y);

    if (horizontal >= vertical && horizontal >= MIN_LINE_LENGTH) {
        if (self->start.x < self->end.x) {
            [self drawHorizontalFrom:self->start to:self->end into:matrix overlay:overlay];
        } else {
            [self drawHorizontalFrom:self->end to:self->start into:matrix overlay:overlay];
        }
    } else if (vertical >= MIN_LINE_LENGTH) {
        if (self->start.y < self->end.y) {
            [self drawVerticalFrom:self->start to:self->end into:matrix overlay:overlay];
        } else {
            [self drawVerticalFrom:self->end to:self->start into:matrix overlay:overlay];
        }
    }
}


- (id)initWithStart:(CGPoint)_start end:(CGPoint)_end
{
    self = [super init];
    if (self) {
        self->start = _start;
        self->end = _end;
    }
    return self;
}

+ (ADLine *)lineWithStart:(CGPoint)start end:(CGPoint)end
{
    return [[[ADLine alloc] initWithStart:start end:end] autorelease];
}

@end
