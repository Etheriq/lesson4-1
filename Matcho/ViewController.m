//
//  ViewController.m
//  Matcho
//
//  Created by Anton Lookin on 10/19/15.
//  Copyright © 2015 geekub. All rights reserved.
//

#import "Game.h"
#import "PlayingCardDeck.h"

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) Game *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameLogLabel;
@property (weak, nonatomic) PlayingCard *currentPlayCard;

@end

@implementation ViewController

- (Game *)game {
	if (!_game) {
		_game = [[Game alloc] initWithCardCount:[self.cardButtons count]
									  usingDeck:[[PlayingCardDeck alloc] init]];
	}
	return _game;
}

- (IBAction)resetButtonTapped:(UIButton *)sender {
    
    self.game = nil;
    [self updateUI];
    self.gameLogLabel.text = @"Log is empty.";
}

- (IBAction)cardButtonTapped:(UIButton *)sender {
	NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
	[self.game chooseCardAtIndex:cardIndex];
    
    self.currentPlayCard = [self.game playCardAtIndex:cardIndex];
	[self updateUI];
}

-(void) updateUI {
	for (UIButton *cardButton in self.cardButtons) {
		NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
		Card *card = [self.game cardAtIndex:cardIndex];
		
		[cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
		[cardButton setBackgroundImage:[self backgroundImageForCard:card]
							  forState:UIControlStateNormal];
		cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Total score: %li", self.game.score];
        self.gameLogLabel.text = [NSString stringWithFormat:@"Opened %@, current score: %li", self.currentPlayCard.contents, self.game.currentScore];
	}
}

-(NSString *) titleForCard:(Card *)card {
	return (card.isChosen) ? card.contents : @"";
}

-(UIImage *) backgroundImageForCard:(Card *)card {
	return [UIImage imageNamed:(card.isChosen) ? @"cardfront" : @"cardback"];
}

- (void)viewDidLoad {
    self.scoreLabel.text = [NSString stringWithFormat:@"Total score: %li", self.game.score];
    self.gameLogLabel.text = @"Log is empty.";
}



@end
