//
//  OSItemTableViewCell.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSItemTableViewCell.h"
#import "OSNetworking.h"
@implementation OSItemTableViewCell


- (id)populateCellWithItem:(OSItem *)item{
    if (self) {
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        int photoIndex = arc4random_uniform(4);
        NSURL *url = [NSURL URLWithString: item.imageUrls[photoIndex]];
        [[OSNetworking sharedInstance] downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                self.itemImageView.image = image;
            }
        }];
        self.itemImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleLabel.text = item.title;
        self.priceLabel.text = @"$10";
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

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
