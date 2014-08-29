//
//  OSUser.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSUser.h"
#import "OSCreditCard.h"

@implementation OSUser

-(void)setCards:(NSDictionary *)cards{
    _cards = cards;
    NSMutableArray *cardArray = [[NSMutableArray alloc]init];
    NSArray *cardData = [_cards objectForKey:@"data"];
    for (NSDictionary *cardDataDict in cardData) {
        OSCreditCard *newStripeCard = [OSCreditCard createWithDataFromDictionary:cardDataDict];
//        [newStripeCard setValue:[cardDataDict objectForKey:@"brand"] forKeyPath:@"type"];
        [cardArray addObject:newStripeCard];
    }
    _stripeCardArray = cardArray;
}
@end
