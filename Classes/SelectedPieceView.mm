/*
  Glaurung, a chess program for the Apple iPhone.
  Copyright (C) 2004-2010 Tord Romstad, Marco Costalba, Joona Kiiski.

  Glaurung is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Glaurung is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "Options.h"
#import "SelectedPieceView.h"

@implementation SelectionRectangle : UIView {
}

- (void)drawRect:(CGRect)rect {
  [[[Options sharedOptions] highlightColor] set];
  UIRectFrame(CGRectMake(0.0f, 0.0f, 40.0f, 40.0f));
  UIRectFrame(CGRectMake(1.0f, 1.0f, 38.0f, 38.0f));
}


- (void)moveToPoint:(CGPoint)point {
  CGRect r = [self frame];

  CGContextRef context = UIGraphicsGetCurrentContext();
  [UIView beginAnimations: nil context: context];
  [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration: 0.2];
  r.origin = point;
  [self setFrame: r];
  [self setNeedsDisplay];
  [UIView commitAnimations];
}

@end


@implementation SelectedPieceView

@synthesize selectedPiece;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    UIImage *pieceImages[16];

    static NSString *pieceImageNames[16] = {
      nil, @"WPawn", @"WKnight", @"WBishop", @"WRook",
      @"WQueen", @"WKing", nil, nil, @"BPawn", @"BKnight",
      @"BBishop", @"BRook", @"BQueen", @"BKing", nil
    };
    NSString *pieceSet = [[Options sharedOptions] pieceSet];
    for (Piece p = WP; p <= BK; p++) {
      if (piece_is_ok(p))
        pieceImages[p] =
          [UIImage imageNamed: [NSString stringWithFormat: @"%@%@.tiff",
                                          pieceSet,
                                          pieceImageNames[p]]];
      else
        pieceImages[p] = nil;
    }
    UIImageView *iv;
    for (int i = 0; i < 6; i++)
      for (int j = 0; j < 2; j++) {
        CGRect r = CGRectMake(i*40.0f, j*40.0f, 40.0f, 40.0f);
        iv = [[UIImageView alloc] initWithFrame: r];
        [iv setImage: pieceImages[(i+1) + (1-j)*8]];
        [self addSubview: iv];
      }
    for (Piece p = WP; p <= BK; p++)
      ;
    selRect = [[SelectionRectangle alloc]
                initWithFrame: CGRectMake(0.0f, 40.0f, 40.0f, 40.0f)];
    [selRect setOpaque: NO];
    [self addSubview: selRect];

    selectedPiece = WP;
  }
  return self;
}


- (void)drawRect:(CGRect)rect {
  int i, j;
  UIColor *lightSquareColor = [[Options sharedOptions] lightSquareColor];
  UIColor *darkSquareColor = [[Options sharedOptions] darkSquareColor];
  for (i = 0; i < 6; i++)
    for (j = 0; j < 2; j++) {
      [(((i + j) & 1)? lightSquareColor : darkSquareColor) set];
      CGRect r = CGRectMake(i*40.0f, j*40.0f, 40.0f, 40.0f);
      UIRectFill(r);
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint pt = [[touches anyObject] locationInView: self];
  int row = (int)(pt.y / 40.0);
  int column = (int)(pt.x / 40.0);
  [selRect moveToPoint: CGPointMake(column*40.0f, row*40.0f)];
  selectedPiece = piece_of_color_and_type(Color(1-row), PieceType(1+column));
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint pt = [[touches anyObject] locationInView: self];
  int row = (int)(pt.y / 40.0);
  int column = (int)(pt.x / 40.0);
  [selRect moveToPoint: CGPointMake(column*40.0f, row*40.0f)];
  selectedPiece = piece_of_color_and_type(Color(1-row), PieceType(1+column));
}




@end
