//
//  OSItemTableViewCell.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSItemTableViewCell.h"
@interface OSItemTableViewCell()



@end
@implementation OSItemTableViewCell

@synthesize textLabel, priceLabel,rentButton, useButton, imageView;

- (id)initWithItem:(OSItem *)item{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCardCell"];
    if (self) {
        NSURL *url = [NSURL URLWithString:@"http://placehold.it/900x900"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
        self.titleLabel.text = item.title;
        self.priceLabel.text = @"$10";
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
