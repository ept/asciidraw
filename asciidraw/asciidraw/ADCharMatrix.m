#import "ADCharMatrix.h"

@implementation ADCharMatrix

@synthesize width;
@synthesize height;

- (void)observeCharAtColumn:(int)column
                        row:(int)row
                changedFrom:(unichar)oldChar
                         to:(unichar)newChar
{
    [self->observers enumerateObjectsUsingBlock:
            ^(id <ADCharMatrixChangeObserver> observer, NSUInteger idx, BOOL *stop) {
        [observer observeCharAtColumn:column row:row changedFrom:oldChar to:newChar];
     }];
}


- (void)replaceCharAtColumn:(int)column
                        row:(int)row
                   withChar:(unichar)newChar
                    overlay:(BOOL)writeToOverlay
{
    assert(column >= 0 && column < self->width && row >= 0 && row < self->height);
    int index = column + row * (self->width + 1);
    assert(index < [self->chars length]);

    unichar oldChar = [self->chars characterAtIndex:index];
    NSString *newCharString = [NSString stringWithCharacters:&newChar length:1];
    NSMutableString *buffer = writeToOverlay ? self->overlay : self->chars;
    [buffer replaceCharactersInRange:NSMakeRange(index, 1) withString:newCharString];

    [self observeCharAtColumn:column row:row changedFrom:oldChar to:newChar];
}


- (void)clearOverlay
{
    unichar space = [@" " characterAtIndex:0];

    for (int row = 0; row < self->height; row++) {
        for (int column = 0; column < self->width; column++) {
            int index = column + row * (self->width + 1);
            unichar currentChar = [self->overlay characterAtIndex:index];

            if (currentChar != space) {
                unichar underlyingChar = [self->chars characterAtIndex:index];
                [self observeCharAtColumn:column row:row changedFrom:currentChar to:underlyingChar];
                [self->overlay replaceCharactersInRange:NSMakeRange(index, 1) withString:@" "];
            }
        }
    }
}


- (void)addObserver:(id <ADCharMatrixChangeObserver>)observer
{
    [self->observers addObject:observer];
}


- (void)removeObserver:(id <ADCharMatrixChangeObserver>)observer
{
    [self->observers removeObjectIdenticalTo:observer];
}


- (id)initWithColumns:(int)_width rows:(int)_height
{
    self = [super init];
    if (self) {
        self->width   = _width;
        self->height  = _height;

        int capacity  = (_width + 1) * _height;
        self->chars   = [[NSMutableString alloc] initWithCapacity:capacity];
        self->overlay = [[NSMutableString alloc] initWithCapacity:capacity];

        for (int row = 0; row < _height; row++) {
            for (int col = 0; col < _width; col++) {
                [self->chars   appendString:@" "];
                [self->overlay appendString:@" "];
            }
            [self->chars   appendString:@"\n"];
            [self->overlay appendString:@"\n"];
        }

        self->observers = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void) dealloc
{
    [self->observers release];
    [self->overlay release];
    [self->chars release];
    [super dealloc];
}

@end
