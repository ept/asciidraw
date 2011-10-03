#import "ADAsciiDrawView.h"
#import "ADLine.h"

#define CHARACTER_ASPECT_RATIO (0.7) // width/height
#define FONT_SIZE (20.0)
#define CHARACTER_WIDTH (CHARACTER_ASPECT_RATIO * FONT_SIZE)
#define NUM_COLUMNS (55)
#define NUM_ROWS (50)

@implementation ADAsciiDrawView

- (void)observeCharAtColumn:(int) column
                        row:(int) row
                changedFrom:(unichar) oldChar
                         to:(unichar) newChar
{
    int labelIndex = column + row * self->charMatrix.width;
    assert(labelIndex < [self->charLabels count]);
    UILabel *label = [self->charLabels objectAtIndex:labelIndex];
    label.text = [NSString stringWithCharacters:&newChar length:1];
}

- (CGPoint)matrixCoordinates:(CGPoint)position
{
    return CGPointMake(position.x / CHARACTER_WIDTH, position.y / FONT_SIZE);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self->dragStart = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPos = [[touches anyObject] locationInView:self];
    ADLine *line = [ADLine lineWithStart:[self matrixCoordinates:self->dragStart]
                                     end:[self matrixCoordinates:currentPos]];
    [self->charMatrix clearOverlay];
    [line draw:self->charMatrix overlay:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint dragEnd = [[touches anyObject] locationInView:self];
    ADLine *line = [ADLine lineWithStart:[self matrixCoordinates:self->dragStart]
                                     end:[self matrixCoordinates:dragEnd]];
    [self->charMatrix clearOverlay];
    [line draw:self->charMatrix overlay:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self->charMatrix clearOverlay];
}

- (UILabel *)makeCharacterForColumn:(int)column row:(int)row
{
    CGRect frame = CGRectMake(column * CHARACTER_WIDTH, row * FONT_SIZE,
                              CHARACTER_WIDTH, FONT_SIZE);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = @" ";
    label.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size: FONT_SIZE];
    label.textColor = [UIColor greenColor];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    [self->charLabels addObject:label];
    return label;
}

- (void)subviewMatrix
{
    for (int row = 0; row < self->charMatrix.height; row++) {
        for (int col = 0; col < self->charMatrix.width; col++) {
            [self makeCharacterForColumn:col row:row];
        }
    }
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self->charMatrix = [[ADCharMatrix alloc] initWithColumns:NUM_COLUMNS rows:NUM_ROWS];
        [self->charMatrix addObserver:self];
        self->charLabels = [[NSMutableArray alloc] init];
        [self subviewMatrix];
        self->dragStart = CGPointMake(0, 0);
    }
    return self;
}

- (void) dealloc
{
    [self->charLabels enumerateObjectsUsingBlock:^(id label, NSUInteger idx, BOOL *stop) {
        [(UILabel *)label release];
    }];
    [self->charLabels release];
    [self->charMatrix removeObserver:self];
    [self->charMatrix release];
    [super dealloc];
}

@end
