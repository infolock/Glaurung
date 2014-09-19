/*
  Glaurung, a chess program for the Apple iPhone.
  Copyright (C) 2004-2010 Tord Romstad, Marco Costalba, Joona Kiiski

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

#import "SelectedSquareView.h"


@implementation SelectedSquareView


- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    hidden = YES;
  }
  return self;
}


- (void)drawRect:(CGRect)rect {
  // Drawing code
  if (!hidden) {
    [[UIColor blackColor] set];
    UIRectFrame(CGRectMake(1.0f, 1.0f, 99.0f, 99.0f));
    UIRectFrame(CGRectMake(2.0f, 2.0f, 97.0f, 97.0f));
  }
}


- (void)hide {
  hidden = YES;
  [self setNeedsDisplay];
  [super setNeedsDisplay];
}


- (void)moveToPoint:(CGPoint)point {
  CGRect r = [self frame];
  r.origin = point;
  hidden = NO;
  [self setFrame: r];
  [self setNeedsDisplay];
}


- (void)dealloc {
  [super dealloc];
}


@end
