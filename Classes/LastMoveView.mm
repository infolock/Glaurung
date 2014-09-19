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

#import "LastMoveView.h"
#import "Options.h"

@implementation LastMoveView


- (id)initWithFrame:(CGRect)frame fromSq:(Square)fSq toSq:(Square)tSq {
  if (self = [super initWithFrame:frame]) {
    square1 = fSq;
    square2 = tSq;
  }
  return self;
}


- (void)drawRect:(CGRect)rect {
  int f, r;

  //[[UIColor blackColor] set];
  [[[Options sharedOptions] highlightColor] set];
  CGRect frame;

  f = int(square_file(square1));
  r = 7 - int(square_rank(square1));
  frame = CGRectMake(f*40.0f, r*40.0f, 40.0f, 40.0f);
  UIRectFrame(frame);
  UIRectFrame(CGRectInset(frame, 1.0f, 1.0f));

  f = int(square_file(square2));
  r = 7 - int(square_rank(square2));
  frame = CGRectMake(f*40.0f, r*40.0f, 40.0f, 40.0f);
  UIRectFrame(frame);
  UIRectFrame(CGRectInset(frame, 1.0f, 1.0f));
}




@end
