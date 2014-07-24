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

- (void)commonInit{
//    self.clipsToBounds = YES;
//    self.contentMode = UIViewContentModeScaleAspectFill;
//    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
//    self.itemImageView.contentMode = UIViewContentModeScaleAspectFill;

}

- (id)initWithFrame:(CGRect)aRect{
    if ((self = [super initWithFrame:aRect])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder{
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}
- (id)populateCellWithItem:(OSItem *)item{
    if (self) {
        self.clipsToBounds = YES;
//        self.contentMode = UIViewContentModeScaleAspectFill;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.itemImageView.contentMode = UIViewContentModeScaleAspectFill;
        NSURL *url = [NSURL URLWithString: item.primaryImage];
        [[OSNetworking sharedInstance] downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                self.itemImageView.image = image;
            }
        }];
       
        self.titleLabel.text = item.title;
        self.priceLabel.text = [item.cost stringValue];

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
