//
//  Game.m
//  Matcho
//
//  Created by Anton Lookin on 10/27/15.
//  Copyright © 2015 geekub. All rights reserved.
//

#import "Game.h"

@interface Game ()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;

@end


@implementation Game


- (instancetype)initWithCardCount:(NSUInteger)count
						usingDeck:(Deck *)deck {
	self = [super init];
	
	if (self) {
		for (NSUInteger i = 0; i < (count -1); i++) {
			Card *card = [deck drawRandomCard];
			
			if (card) {
				[self.cards addObject:card];
			} else {
				self = nil;
				break;
			}
		}
        Card *joker = [[Card alloc] init];
        joker.contents = @"Joker";
        [self.cards addObject:joker];
        self.matchLog = @"";
	}
	
	return self;
}


- (NSMutableArray *)cards {
	if (!_cards) _cards = [[NSMutableArray alloc] init];
	return _cards;
}


static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


- (void)chooseCardAtIndex:(NSUInteger)index {
	Card *card = [self cardAtIndex:index];
    self.currentScore = 0;
    int innerScore = 0;
	
	if (!card.isMatched) {
		if (card.isChosen) {
			card.chosen = NO;
		} else {
			NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
			
			for (Card *otherCard in self.cards) {
				if (otherCard.isChosen && !otherCard.isMatched) {
					[chosenCards addObject:otherCard];
				}
			}
			
			if ([chosenCards count]) {
				int matchScore = [card match:chosenCards];
                Card *anotherCard = [chosenCards firstObject];
				if (matchScore) {
					innerScore += (matchScore * MATCH_BONUS);
                    
					card.chosen = YES;
					card.matched = YES;
					for (Card *otherCard in chosenCards) {
						otherCard.matched = YES;
					}
                    
                    self.matchLog = [NSString stringWithFormat:@"%@ and %@ is matched, your bonus is %i", card.contents, anotherCard.contents, innerScore];
				} else {
					
					innerScore += (MISMATCH_PENALTY * -1);
					card.chosen = YES;
					for (Card *otherCard in chosenCards) {
						otherCard.chosen = NO;
					}
                    self.matchLog = [NSString stringWithFormat:@"%@ and %@ is not matched, your penalty is %i", card.contents, anotherCard.contents, innerScore];
				}
			} else {
                innerScore += (COST_TO_CHOOSE * -1);
				card.chosen = YES;
			}
		}
	}
    self.currentScore = innerScore;
    self.score += innerScore;
}


- (Card *)cardAtIndex:(NSUInteger)index {
	return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (PlayingCard *) playCardAtIndex: (NSUInteger) index {
    return  self.cards[index];
}


@end
