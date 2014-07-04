//
//  OSItemTableViewCell.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSItemTableViewCell.h"

@implementation OSItemTableViewCell

@synthesize textLabel;
@synthesize priceLabel;
@synthesize rentButton;
@synthesize useButton;
@synthesize imageView;

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

-(void)awakeFromNib{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    
    return _titleLabel;
}

@end
