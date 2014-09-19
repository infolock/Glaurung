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


@implementation Options

@synthesize darkSquareColor, lightSquareColor, highlightColor;
@synthesize darkSquareImage, lightSquareImage;
@dynamic colorScheme, pieceSet, figurineNotation;
@dynamic playStyle, bookVariety, bookVarietyWasChanged, soundVolume;
@dynamic showAnalysis, showBookMoves, showLegalMoves, permanentBrain;
@dynamic gameMode, gameLevel, gameModeWasChanged, gameLevelWasChanged;
@dynamic saveGameFile, emailAddress, fullUserName;
@dynamic displayMoveGestureStepForwardHint, displayMoveGestureTakebackHint;
@dynamic playStyleWasChanged, strength, strengthWasChanged;
@dynamic serverName, serverPort;

- (id)init {
  if (self = [super init]) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (![defaults objectForKey: @"showAnalysis2"]) {
      showAnalysis = YES;
      [defaults setBool: YES forKey: @"showAnalysis2"];
    }
    else
      showAnalysis = [defaults boolForKey: @"showAnalysis2"];

    if (![defaults objectForKey: @"showBookMoves2"]) {
      showBookMoves = YES;
      [defaults setBool: YES forKey: @"showBookMoves2"];
    }
    else
      showBookMoves = [defaults boolForKey: @"showBookMoves2"];

    if (![defaults objectForKey: @"showLegalMoves2"]) {
      showLegalMoves = YES;
      [defaults setBool: YES forKey: @"showLegalMoves2"];
    }
    else
      showLegalMoves = [defaults boolForKey: @"showLegalMoves2"];

    if (![defaults objectForKey: @"permanentBrain2"]) {
      permanentBrain = NO;
      [defaults setBool: NO forKey: @"permanentBrain2"];
    }
    else
      permanentBrain = [defaults boolForKey: @"permanentBrain2"];

    pieceSet = [defaults objectForKey: @"pieceSet2"];
    if (!pieceSet) {
      pieceSet = @"Alpha";
      [defaults setObject: @"Alpha" forKey: @"pieceSet2"];
    }

    playStyle = [defaults objectForKey: @"playStyle2"];
    if (!playStyle) {
      playStyle = @"Active";
      [defaults setObject: @"Active" forKey: @"playStyle2"];
    }

    bookVariety = [defaults objectForKey: @"bookVariety2"];
    if (!bookVariety) {
      bookVariety = @"Medium";
      [defaults setObject: @"Medium" forKey: @"bookVariety2"];
    }

    soundVolume = [defaults objectForKey: @"soundVolume2"];
    if (!soundVolume) {
      soundVolume = @"Soft";
      [defaults setObject: @"Soft" forKey: @"soundVolume2"];
    }

    if (![defaults objectForKey: @"figurineNotation2"]) {
      figurineNotation = NO;
      [defaults setBool: NO forKey: @"figurineNotation2"];
    }
    else
      figurineNotation = [defaults boolForKey: @"figurineNotation2"];

    colorScheme = [defaults objectForKey: @"colorScheme2"];
    if (!colorScheme) {
      colorScheme = @"Marble";
      [defaults setObject: @"Marble" forKey: @"colorScheme2"];
    }
    darkSquareColor = lightSquareColor = highlightColor = nil;
    [self updateColors];

    gameMode = GAME_MODE_COMPUTER_BLACK;
    gameLevel = LEVEL_GAME_IN_5;
    gameModeWasChanged = NO;
    gameLevelWasChanged = NO;
    playStyleWasChanged = NO;
    strengthWasChanged = NO;

    saveGameFile = [defaults objectForKey: @"saveGameFile2"];
    if (!saveGameFile) {
      saveGameFile = @"My games.pgn";
      [defaults setObject: @"My Games.pgn" forKey: @"saveGameFile2"];
    }

    emailAddress = [defaults objectForKey: @"emailAddress2"];
    if (!emailAddress) {
      emailAddress = @"";
      [defaults setObject: @"" forKey: @"emailAddress2"];
    }
    fullUserName = [defaults objectForKey: @"fullUserName2"];
    if (!fullUserName) {
      fullUserName = @"Me";
      [defaults setObject: @"Me" forKey: @"fullUserName2"];
    }

    strength = ( int )[defaults integerForKey: @"Elo2"];
    if (!strength) {
      strength = 2450;
      [defaults setInteger: 2450 forKey: @"Elo2"];
    }

    NSString *tmp = [defaults objectForKey: @"displayMoveGestureTakebackHint2"];
    if (!tmp) {
      [defaults setObject: @"YES"
                   forKey: @"displayMoveGestureTakebackHint2"];
      displayMoveGestureTakebackHint = YES;
    }
    else if ([tmp isEqualToString: @"YES"])
      displayMoveGestureTakebackHint = YES;
    else
      displayMoveGestureTakebackHint = NO;

    tmp = [defaults objectForKey: @"displayMoveGestureStepForwardHint2"];
    if (!tmp) {
      [defaults setObject: @"YES"
                   forKey: @"displayMoveGestureStepForwardHint2"];
      displayMoveGestureStepForwardHint = YES;
    }
    else if ([tmp isEqualToString: @"YES"])
      displayMoveGestureStepForwardHint = YES;
    else
      displayMoveGestureStepForwardHint = NO;

    serverName = [defaults objectForKey: @"serverName2"];
    if (!serverName) {
      serverName = @"";
      [defaults setObject: @"" forKey: @"serverName2"];
    }

    serverPort = ( int )[defaults integerForKey: @"serverPort2"];
    if (!serverPort) {
      serverPort = 1685;
      [defaults setInteger: 1685 forKey: @"serverPort2"];
    }

    [defaults synchronize];
  }
  return self;
}


- (void)updateColors {
   darkSquareImage = nil;
   lightSquareImage = nil;
  if ([colorScheme isEqualToString: @"Blue"]) {
    darkSquareColor = [UIColor colorWithRed: 0.20 green: 0.40 blue: 0.70
                                       alpha: 1.0];
    lightSquareColor = [UIColor colorWithRed: 0.69 green: 0.78 blue: 1.0
                                        alpha: 1.0];
    highlightColor = [UIColor brownColor];
  }
  else if ([colorScheme isEqualToString: @"Gray"]) {
    darkSquareColor = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5
                                       alpha: 1.0];
    lightSquareColor = [UIColor colorWithRed: 0.8 green: 0.8 blue: 0.8
                                        alpha: 1.0];
    highlightColor = [UIColor blueColor];
  }
  else if ([colorScheme isEqualToString: @"Green"]) {
    darkSquareColor = [UIColor colorWithRed: 0.28 green: 0.6 blue: 0.28
                                       alpha: 1.0];
    lightSquareColor = [UIColor colorWithRed: 0.7 green: 1.0 blue: 0.7
                                        alpha: 1.0];
    highlightColor = [UIColor blueColor];
  }
  else if ([colorScheme isEqualToString: @"Red"]) {
    darkSquareColor = [UIColor colorWithRed: 0.6 green: 0.28 blue: 0.28
                                       alpha: 1.0];
    lightSquareColor = [UIColor colorWithRed: 1.0 green: 0.8 blue: 0.8
                                        alpha: 1.0];
    highlightColor = [UIColor blueColor];
  }
  else if ([colorScheme isEqualToString: @"Wood"]) {
    darkSquareColor = [UIColor colorWithRed: 0.57 green: 0.40 blue: 0.35
                                       alpha: 1.0];
    lightSquareColor = [UIColor colorWithRed: 0.9 green: 0.8 blue: 0.7
                                        alpha: 1.0];
    darkSquareImage = [UIImage imageNamed: @"DarkWood.tiff"];
    lightSquareImage = [UIImage imageNamed: @"LightWood.tiff"];
    highlightColor = [UIColor blueColor];
  }
  else if ([colorScheme isEqualToString: @"Marble"]) {
    darkSquareColor = [UIColor colorWithRed: 0.57 green: 0.40 blue: 0.35
                                       alpha: 1.0];
    lightSquareColor = [UIColor colorWithRed: 0.9 green: 0.8 blue: 0.7
                                        alpha: 1.0];
    NSLog(@"reading dark square image");
    darkSquareImage = [UIImage imageNamed: @"DarkMarble.tiff"];
    NSLog(@"reading light square image");
    lightSquareImage = [UIImage imageNamed: @"LightMarble.tiff"];
    highlightColor = [UIColor blueColor];
  }  
  else { // Default brown color scheme
    darkSquareColor = [UIColor colorWithRed: 0.57 green: 0.40 blue: 0.35
                                       alpha: 1.0];
    lightSquareColor = [UIColor colorWithRed: 0.9 green: 0.8 blue: 0.7
                                        alpha: 1.0];
    highlightColor = [UIColor blueColor];
  }
  // Post a notification about the new colors, in order to make the board
  // update itself:
  [[NSNotificationCenter defaultCenter]
    postNotificationName: @"GlaurungColorSchemeChanged"
                  object: self];
}


- (NSString *)colorScheme {
  return colorScheme;
}


- (void)setColorScheme:(NSString *)newColorScheme {
  colorScheme = newColorScheme;
  [[NSUserDefaults standardUserDefaults] setObject: newColorScheme
                                            forKey: @"colorScheme2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter]
    postNotificationName: @"GlaurungPieceSetChanged"
                  object: self];
  [self updateColors];
}


- (BOOL)figurineNotation {
  return figurineNotation;
}


- (void)setFigurineNotation:(BOOL)newValue {
  figurineNotation = newValue;
  [[NSUserDefaults standardUserDefaults] setBool: figurineNotation
                                          forKey: @"figurineNotation2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *)pieceSet {
  return pieceSet;
}


- (void)setPieceSet:(NSString *)newPieceSet {
  pieceSet = newPieceSet;
  [[NSUserDefaults standardUserDefaults] setObject: newPieceSet
                                            forKey: @"pieceSet2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter]
    postNotificationName: @"GlaurungPieceSetChanged"
                  object: self];
}


- (NSString *)playStyle {
  return playStyle;
}


- (void)setPlayStyle:(NSString *)newPlayStyle {
  playStyle = newPlayStyle;
  playStyleWasChanged = YES;
  [[NSUserDefaults standardUserDefaults] setObject: newPlayStyle
                                            forKey: @"playStyle2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)playStyleWasChanged {
  BOOL result = playStyleWasChanged;
  playStyleWasChanged = NO;
  return result;
}


- (NSString *)bookVariety {
  return bookVariety;
}


- (void)setBookVariety:(NSString *)newBookVariety {
  bookVariety = newBookVariety;
  bookVarietyWasChanged = YES;
  [[NSUserDefaults standardUserDefaults] setObject: newBookVariety
                                            forKey: @"bookVariety2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)bookVarietyWasChanged {
  BOOL result = bookVarietyWasChanged;
  bookVarietyWasChanged = NO;
  return result;
}


- (NSString *)soundVolume {
  return soundVolume;
}


- (void)setSoundVolume:(NSString *)newSoundVolume {
  soundVolume = newSoundVolume;
  [[NSUserDefaults standardUserDefaults] setObject: newSoundVolume
                                            forKey: @"soundVolume2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)showAnalysis {
  return showAnalysis;
}


- (void)setShowAnalysis:(BOOL)shouldShowAnalysis {
  showAnalysis = shouldShowAnalysis;
  [[NSUserDefaults standardUserDefaults] setBool: showAnalysis
                                          forKey: @"showAnalysis2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)showBookMoves {
  return showBookMoves;
}


- (void)setShowBookMoves:(BOOL)shouldShowBookMoves {
  showBookMoves = shouldShowBookMoves;
  [[NSUserDefaults standardUserDefaults] setBool: showBookMoves
                                          forKey: @"showBookMoves2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)showLegalMoves {
  return showLegalMoves;
}


- (void)setShowLegalMoves:(BOOL)shouldShowLegalMoves {
  showLegalMoves = shouldShowLegalMoves;
  [[NSUserDefaults standardUserDefaults] setBool: showLegalMoves
                                          forKey: @"showLegalMoves2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)permanentBrain {
  return permanentBrain;
}


- (void)setPermanentBrain:(BOOL)shouldUsePermanentBrain {
  permanentBrain = shouldUsePermanentBrain;
  [[NSUserDefaults standardUserDefaults] setBool: permanentBrain
                                          forKey: @"permanentBrain2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}




+ (Options *)sharedOptions {
  static Options *o = nil;
  if (o == nil) {
    o = [[Options alloc] init];
  }
  return o;
}


- (GameLevel)gameLevel {
  return gameLevel;
}


- (void)setGameLevel:(GameLevel)newGameLevel {
  gameLevel = newGameLevel;
  gameLevelWasChanged = YES;
}

- (GameMode)gameMode {
  return gameMode;
}


- (void)setGameMode:(GameMode)newGameMode {
  gameMode = newGameMode;
  gameModeWasChanged = YES;
}


- (BOOL)gameModeWasChanged {
  BOOL result = gameModeWasChanged;
  gameModeWasChanged = NO;
  return result;
}


- (BOOL)gameLevelWasChanged {
  BOOL result = gameLevelWasChanged;
  gameLevelWasChanged = NO;
  return result;
}


- (NSString *)saveGameFile {
  return saveGameFile;
}


- (void)setSaveGameFile:(NSString *)newFileName {
  saveGameFile = newFileName;
  [[NSUserDefaults standardUserDefaults] setObject: saveGameFile
                                            forKey: @"saveGameFile2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *)emailAddress {
  return emailAddress;
}


- (void)setEmailAddress:(NSString *)newEmailAddress {
  emailAddress = newEmailAddress;
  [[NSUserDefaults standardUserDefaults] setObject: emailAddress
                                            forKey: @"emailAddress2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *)fullUserName {
  return fullUserName;
}


- (void)setFullUserName:(NSString *)name {
  fullUserName = name;
  [[NSUserDefaults standardUserDefaults] setObject: fullUserName
                                            forKey: @"fullUserName2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (int)strength {
  return strength;
}


- (void)setStrength:(int)newStrength {
  strength = newStrength;
  strengthWasChanged = YES;
  [[NSUserDefaults standardUserDefaults] setInteger: newStrength
                                             forKey: @"Elo2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)strengthWasChanged {
  BOOL result = strengthWasChanged;
  strengthWasChanged = NO;
  return result;
}


- (BOOL)displayMoveGestureTakebackHint {
  BOOL tmp = displayMoveGestureTakebackHint;
  displayMoveGestureTakebackHint = NO;
  [[NSUserDefaults standardUserDefaults] setObject: @"NO"
                                            forKey: @"displayMoveGestureTakebackHint2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  return tmp;
}


- (BOOL)displayMoveGestureStepForwardHint {
  BOOL tmp = displayMoveGestureStepForwardHint;
  displayMoveGestureStepForwardHint = NO;
  [[NSUserDefaults standardUserDefaults] setObject: @"NO"
                                            forKey: @"displayMoveGestureStepForwardHint2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  return tmp;
}


static const BOOL FixedTime[13] = {
  NO, NO, NO, NO, NO, NO, NO, NO, YES, YES, YES, YES, YES
};
static const int LevelTime[13] = {
  2, 2, 5, 5, 15, 15, 30, 30, 0, 0, 0, 0, 0
};
static const int LevelIncr[13] = {
  0, 1, 0, 2, 0, 5, 0, 5, 1, 2, 5, 10, 30
};

- (BOOL)isFixedTimeLevel {
  assert(gameLevel < 13);
  return FixedTime[gameLevel];
}

- (int)baseTime {
  assert(gameLevel < 13);
  return LevelTime[gameLevel] * 60000;
}

- (int)timeIncrement {
  assert(gameLevel < 13);
  return LevelIncr[gameLevel] * 1000;
}

- (NSString *)serverName {
  return serverName;
}

- (void)setServerName:(NSString *)newServerName {
  serverName = newServerName;
  [[NSUserDefaults standardUserDefaults] setObject: serverName
                                            forKey: @"serverName2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)serverPort {
  return serverPort;
}

- (void)setServerPort:(int)newPort {
  serverPort = newPort;
  [[NSUserDefaults standardUserDefaults] setInteger: serverPort
                                             forKey: @"serverPort2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
