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

#import "BoardViewController.h"
#import "GameController.h"
#import "GameDetailsTableController.h"
#import "LevelViewController.h"
#import "LoadFileListController.h"
#import "MoveListView.h"
#import "Options.h"
#import "OptionsViewController.h"
#import "PGN.h"
#import "SetupViewController.h"

@implementation BoardViewController

@synthesize analysisView, boardView, whiteClockView, blackClockView, moveListView, gameController, searchStatsView;

/// init

- (id)init {
  if (self = [super init]) {
    [self setTitle: [[[NSBundle mainBundle] infoDictionary]
                      objectForKey: @"CFBundleName"]];
  }
  return self;
}


/// loadView creates and lays out all the subviews of the main window: The
/// board, the toolbar, the move list, and the small UILabels used to display
/// the engine analysis and the clocks.

- (void)loadView {
  // Content view
  CGRect appRect = [[UIScreen mainScreen] applicationFrame];
  rootView = [[RootView alloc] initWithFrame: appRect];
  appRect.origin = CGPointMake(0.0f, 0.0f);
  contentView = [[UIView alloc] initWithFrame: appRect];
  [rootView addSubview: contentView];
  [self setView: rootView];

  // Board
  boardView =
    [[BoardView alloc] initWithFrame: CGRectMake(0.0f, 18.0f, 320.0f, 320.0f)];
  [contentView addSubview: boardView];

  // Search stats
  searchStatsView =
    [[UILabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 18.0f)];
  [searchStatsView setFont: [UIFont systemFontOfSize: 14.0]];
  //[searchStatsView setTextAlignment: UITextAlignmentCenter];
  [searchStatsView setBackgroundColor: [UIColor lightGrayColor]];
  [contentView addSubview: searchStatsView];

  // Clocks
  whiteClockView =
    [[UILabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 160.0f, 18.0f)];
  [whiteClockView setFont: [UIFont systemFontOfSize: 14.0]];
  [whiteClockView setTextAlignment: NSTextAlignmentCenter];
  [whiteClockView setText: @"White: 5:00"];
  [whiteClockView setBackgroundColor: [UIColor lightGrayColor]];

  blackClockView =
    [[UILabel alloc] initWithFrame: CGRectMake(160.0f, 0.0f, 160.0f, 18.0f)];
  [blackClockView setFont: [UIFont systemFontOfSize: 14.0]];
  [blackClockView setTextAlignment: NSTextAlignmentCenter];
  [blackClockView setText: @"Black: 5:00"];
  [blackClockView setBackgroundColor: [UIColor lightGrayColor]];

  [contentView addSubview: whiteClockView];
  [contentView addSubview: blackClockView];

  // Analysis
  analysisView =
    [[UILabel alloc] initWithFrame: CGRectMake(0.0f, 338.0f, 320.0f, 18.0f)];
  [analysisView setFont: [UIFont systemFontOfSize: 13.0]];
  [analysisView setBackgroundColor: [UIColor lightGrayColor]];
  [contentView addSubview: analysisView];

  // Move list
  moveListView =
    [[MoveListView alloc] initWithFrame:
                            CGRectMake(0.0f, 356.0f, 320.0f, 60.0f)];
  [moveListView setFont: [UIFont systemFontOfSize: 14.0]];
  [moveListView setEditable: NO];
  [contentView addSubview: moveListView];

  // Toolbar
  UIToolbar *toolbar =
    [[UIToolbar alloc]
      initWithFrame: CGRectMake(0.0f, 480.0f-64.0f, 320.0f, 64.0f)];
  [contentView addSubview: toolbar];

  NSMutableArray *buttons = [[NSMutableArray alloc] init];
  UIBarButtonItem *button;

  button = [[UIBarButtonItem alloc] initWithTitle: @"Game"
                                            style: UIBarButtonItemStylePlain
                                           target: self
                                           action: @selector(toolbarButtonPressed:)];
  [button setWidth: 58.0f];
  [buttons addObject: button];
  button = [[UIBarButtonItem alloc] initWithTitle: @"Options"
                                            style: UIBarButtonItemStylePlain
                                           target: self
                                           action: @selector(toolbarButtonPressed:)];
  //[button setWidth: 60.0f];
  [buttons addObject: button];
  button = [[UIBarButtonItem alloc] initWithTitle: @"Flip"
                                            style: UIBarButtonItemStylePlain
                                           target: self
                                           action: @selector(toolbarButtonPressed:)];
  [buttons addObject: button];
  button = [[UIBarButtonItem alloc] initWithTitle: @"Move"
                                            style: UIBarButtonItemStylePlain
                                           target: self
                                           action: @selector(toolbarButtonPressed:)];
  [button setWidth: 53.0f];
  [buttons addObject: button];
  button = [[UIBarButtonItem alloc] initWithTitle: @"Hint"
                                            style: UIBarButtonItemStylePlain
                                           target: self
                                           action: @selector(toolbarButtonPressed:)];
  [button setWidth: 49.0f];
  [buttons addObject: button];

  [toolbar setItems: buttons animated: YES];
  [toolbar sizeToFit];

  [contentView bringSubviewToFront: boardView];

  // Activity indicator
  activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0,0,30,30)];
  [activityIndicator setCenter: CGPointMake(160.0f, 180.0f)];
  [activityIndicator
    setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite];
  [contentView addSubview: activityIndicator];
  [activityIndicator startAnimating];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
[super viewDidLoad];
}
*/

 /*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}




- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
  if ([[alertView title] isEqualToString: @"Start new game?"]) {
    if (buttonIndex == 1)
      [gameController startNewGame];
  }
  else if ([[alertView title] isEqualToString:
                                @"Exit Glaurung and send e-mail?"]) {
    if (buttonIndex == 1)
      [[UIApplication sharedApplication]
        openURL: [[NSURL alloc] initWithString:
                                  [gameController emailPgnString]]];
  }
}


- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSString *title = [actionSheet title];

  NSLog(@"Menu: %@ selection: %ld", title, ( long )buttonIndex);
  if ([title isEqualToString: @"Game"]) {
    UIActionSheet *menu;
    switch(buttonIndex) {
    case 0:
      /*
        [[[[UIAlertView alloc] initWithTitle: @"Start new game?"
        message: @"Your current game will be lost"
        delegate: self
        cancelButtonTitle: @"Cancel"
        otherButtonTitles: @"OK", nil] autorelease]
        show];
      */
      menu =
        [[UIActionSheet alloc] initWithTitle: @"New game"
                                    delegate: self
                           cancelButtonTitle: @"Cancel"
                      destructiveButtonTitle: nil
                           otherButtonTitles:
                                 @"Play white", @"Play black", @"Play both",
                               @"Analysis", nil];
      [menu showInView: contentView];
      break;
    case 1:
      [self showSaveGameMenu];
      break;
    case 2:
      [self showLoadGameMenu];
      break;
    case 3:
      [self showEmailGameMenu];
      break;
    case 4:
      [self editPosition];
      break;
    case 5:
      [self showLevelsMenu];
      break;
    case 6:
      break;
    default:
      NSLog(@"Not implemented yet");
    }
  }
  else if ([title isEqualToString: @"Move"]) {
    switch(buttonIndex) {
    case 0: // Take back
      if ([[Options sharedOptions] displayMoveGestureTakebackHint])
        [[[UIAlertView alloc] initWithTitle: @"Hint:"
                                     message: @"You can also take back moves by swiping your finger from right to left in the move list area below the board."
                                    delegate: self
                           cancelButtonTitle: nil
                           otherButtonTitles: @"OK", nil]
          show];
      [gameController takeBackMove];
      break;
    case 1: // Step forward
      if ([[Options sharedOptions] displayMoveGestureStepForwardHint])
        [[[UIAlertView alloc] initWithTitle: @"Hint:"
                                     message: @"You can also step forward in the game by swiping your finger from left to right in the move list area below the board."
                                    delegate: self
                           cancelButtonTitle: nil
                           otherButtonTitles: @"OK", nil]
          show];
      [gameController replayMove];
      break;
    case 2: // Take back all
      [gameController takeBackAllMoves];
      break;
    case 3: // Step forward all
      [gameController replayAllMoves];
      break;
    case 4: // Move now
      if ([gameController computersTurnToMove]) {
        if ([gameController engineIsThinking])
          [gameController engineMoveNow];
        else
          [gameController engineGo];
      }
      else
        [gameController startThinking];
      break;
    case 5:
      break;
    default:
      NSLog(@"Not implemented yet");
    }
  }
  else if ([title isEqualToString: @"New game"]) {
    switch (buttonIndex) {
    case 0:
      NSLog(@"new game with white");
      [[Options sharedOptions] setGameMode: GAME_MODE_COMPUTER_BLACK];
      [gameController setGameMode: GAME_MODE_COMPUTER_BLACK];
      [gameController startNewGame];
      break;
    case 1:
      NSLog(@"new game with black");
      [[Options sharedOptions] setGameMode: GAME_MODE_COMPUTER_WHITE];
      [gameController setGameMode: GAME_MODE_COMPUTER_WHITE];
      [gameController startNewGame];
      break;
    case 2:
      NSLog(@"new game (both)");
      [[Options sharedOptions] setGameMode: GAME_MODE_TWO_PLAYER];
      [gameController setGameMode: GAME_MODE_TWO_PLAYER];
      [gameController startNewGame];
      break;
    case 3:
      NSLog(@"new game (analysis)");
      [[Options sharedOptions] setGameMode: GAME_MODE_ANALYSE];
      [gameController setGameMode: GAME_MODE_ANALYSE];
      [gameController startNewGame];
      break;
    default:
      NSLog(@"not implemented yet");
    }
  }
}


- (void)toolbarButtonPressed:(id)sender {
  NSString *title = [sender title];
  if ([title isEqualToString: @"Game"]) {
    UIActionSheet *menu =
      [[UIActionSheet alloc]
        initWithTitle: @"Game"
             delegate: self
        cancelButtonTitle: @"Cancel"
        destructiveButtonTitle: nil
        otherButtonTitles:
          @"New game", @"Save game", @"Load game", @"E-mail game", @"Edit position", @"Level/Game mode", nil];
    [menu showInView: contentView];
  }
  else if ([title isEqualToString: @"Options"])
    [self showOptionsMenu];
  else if ([title isEqualToString: @"Flip"])
    [gameController rotateBoard];
  else if ([title isEqualToString: @"Move"]) {
    UIActionSheet *menu =
      [[UIActionSheet alloc]
	initWithTitle: @"Move"
             delegate: self
	cancelButtonTitle: @"Cancel"
	destructiveButtonTitle: nil
	otherButtonTitles:
	  @"Take back", @"Step forward", @"Take back all", @"Step forward all", @"Move now", nil];
    [menu showInView: contentView];
  }
  else if ([title isEqualToString: @"Hint"])
    [gameController showHint];
  else if ([title isEqualToString: @"New"])
    [gameController startNewGame];
  else
    NSLog(@"%@", [sender title]);
}


- (void)showOptionsMenu {
  OptionsViewController *ovc;
  ovc = [[OptionsViewController alloc] initWithBoardViewController: self];
  navigationController =
    [[UINavigationController alloc]
      initWithRootViewController: ovc];
  CGRect r = [[navigationController view] frame];
  // Why do I suddenly have to use -20.0f for the Y coordinate below?
  // 0.0f seems right, and used to work in SDK 2.x.
  r.origin = CGPointMake(0.0f, -20.0f);
  [[navigationController view] setFrame: r];
  [rootView insertSubview: [navigationController view] atIndex: 0];
  [rootView flipSubviewsLeft];
}


- (void)optionsMenuDonePressed {
  NSLog(@"options menu done");
  if ([[Options sharedOptions] bookVarietyWasChanged])
    [gameController showBookMoves];
  [rootView flipSubviewsRight];
  [[navigationController view] removeFromSuperview];
}


- (void)showLevelsMenu {
  NSLog(@"levels menu");
  LevelViewController *lvc;
  lvc = [[LevelViewController alloc] initWithBoardViewController: self];
  navigationController =
    [[UINavigationController alloc]
      initWithRootViewController: lvc];
  CGRect r = [[navigationController view] frame];
  // Why do I suddenly have to use -20.0f for the Y coordinate below?
  // 0.0f seems right, and used to work in SDK 2.x.
  r.origin = CGPointMake(0.0f, -20.0f);
  [[navigationController view] setFrame: r];
  [rootView insertSubview: [navigationController view] atIndex: 0];
  [rootView flipSubviewsLeft];
}


- (void)levelsMenuDonePressed {
  NSLog(@"options menu done");
  if ([[Options sharedOptions] gameLevelWasChanged])
    [gameController setGameLevel: [[Options sharedOptions] gameLevel]];
  if ([[Options sharedOptions] gameModeWasChanged])
    [gameController setGameMode: [[Options sharedOptions] gameMode]];

  [rootView flipSubviewsRight];
  [[navigationController view] removeFromSuperview];
}


- (void)editPosition {
  SetupViewController *svc =
    [[SetupViewController alloc] initWithBoardViewController: self
                                                         fen: [[gameController game] currentFEN]];
  navigationController =
    [[UINavigationController alloc] initWithRootViewController: svc];
  CGRect r = [[navigationController view] frame];
  // Why do I suddenly have to use -20.0f for the Y coordinate below?
  // 0.0f seems right, and used to work in SDK 2.x.
  r.origin = CGPointMake(0.0f, -20.0f);
  [[navigationController view] setFrame: r];
  [rootView insertSubview: [navigationController view] atIndex: 0];
  [rootView flipSubviewsLeft];
}


- (void)editPositionCancelPressed {
  NSLog(@"edit position cancel");
  [rootView flipSubviewsRight];
  [[navigationController view] removeFromSuperview];
}


- (void)editPositionDonePressed:(NSString *)fen {
  NSLog(@"edit position done: %@", fen);
  [rootView flipSubviewsRight];
  [[navigationController view] removeFromSuperview];
  [boardView hideLastMove];
  [gameController gameFromFEN: fen];
}


- (void)showSaveGameMenu {
  GameDetailsTableController *gdtc =
    [[GameDetailsTableController alloc]
      initWithBoardViewController: self
                             game: [gameController game]
                            email: NO];
  navigationController =
    [[UINavigationController alloc] initWithRootViewController: gdtc];
  CGRect r = [[navigationController view] frame];
  // Why do I suddenly have to use -20.0f for the Y coordinate below?
  // 0.0f seems right, and used to work in SDK 2.x.
  r.origin = CGPointMake(0.0f, -20.0f);
  [[navigationController view] setFrame: r];
  [rootView insertSubview: [navigationController view] atIndex: 0];
  [rootView flipSubviewsLeft];
}


- (void)saveMenuDonePressed {
  NSLog(@"save game done");
  FILE *pgnFile =
    fopen([[PGN_DIRECTORY
             stringByAppendingPathComponent: [[Options sharedOptions]
                                               saveGameFile]] UTF8String],
          "a");
  if (pgnFile != NULL) {
    fprintf(pgnFile, "%s", [[[gameController game] pgnString] UTF8String]);
    fclose(pgnFile);
  }
  [rootView flipSubviewsRight];
  [[navigationController view] removeFromSuperview];
  NSLog(@"save game done");
}


- (void)saveMenuCancelPressed {
  NSLog(@"save game canceled");
  [rootView flipSubviewsRight];
  [[navigationController view] removeFromSuperview];
}


- (void)showLoadGameMenu {
  LoadFileListController *lflc =
    [[LoadFileListController alloc] initWithBoardViewController: self];
  navigationController =
    [[UINavigationController alloc] initWithRootViewController: lflc];
  CGRect r = [[navigationController view] frame];
  // Why do I suddenly have to use -20.0f for the Y coordinate below?
  // 0.0f seems right, and used to work in SDK 2.x.
  r.origin = CGPointMake(0.0f, -20.0f);
  [[navigationController view] setFrame: r];
  [rootView insertSubview: [navigationController view] atIndex: 0];
  [rootView flipSubviewsLeft];
}


- (void)loadMenuCancelPressed {
  NSLog(@"load game canceled");
  [rootView flipSubviewsRight];
  [[navigationController view] removeFromSuperview];
}


- (void)loadMenuDonePressedWithGame:(NSString *)gameString {
  NSLog(@"load menu done, gameString = %@", gameString);
  [rootView flipSubviewsRight];
  [[navigationController view] removeFromSuperview];
  [gameController gameFromPGNString: gameString];
  [boardView hideLastMove];
}


- (void)showEmailGameMenu {
  GameDetailsTableController *gdtc =
    [[GameDetailsTableController alloc]
      initWithBoardViewController: self
                             game: [gameController game]
                            email: YES];
  navigationController =
    [[UINavigationController alloc] initWithRootViewController: gdtc];
  CGRect r = [[navigationController view] frame];
  // Why do I suddenly have to use -20.0f for the Y coordinate below?
  // 0.0f seems right, and used to work in SDK 2.x.
  r.origin = CGPointMake(0.0f, -20.0f);
  [[navigationController view] setFrame: r];
  [rootView insertSubview: [navigationController view] atIndex: 0];
  [rootView flipSubviewsLeft];
}


- (void)emailMenuDonePressed {
  NSLog(@"email game done");
  [rootView flipSubviewsRight];
  [[navigationController view] removeFromSuperview];
  [[[UIAlertView alloc] initWithTitle: @"Exit Glaurung and send e-mail?"
                               message: @""
                              delegate: self
                     cancelButtonTitle: @"Cancel"
                     otherButtonTitles: @"OK", nil]
    show];
}


- (void)emailMenuCancelPressed {
  NSLog(@"email game canceled");
  [rootView flipSubviewsRight];
  [[navigationController view] removeFromSuperview];
}


- (void)stopActivityIndicator {
  if (activityIndicator) {
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
  }
}


- (void)hideAnalysis {
  [analysisView setText: @""];
  if ([[Options sharedOptions] showBookMoves])
    [gameController showBookMoves];
}


- (void)hideBookMoves {
  if ([[analysisView text] hasPrefix: @"  Book"])
    [analysisView setText: @""];
}


- (void)showBookMoves {
  [gameController showBookMoves];
}


- (void)connectToServer {
  [gameController connectToServer];
}


- (void)disconnectFromServer {
  [gameController disconnectFromServer];
}


- (BOOL)isConnectedToServer {
  return [gameController isConnectedToServer];
}


@end
