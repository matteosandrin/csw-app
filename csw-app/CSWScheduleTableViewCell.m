    //
//  CSWScheduleTableViewCell.m
//  csw-app
//
//  Created by Matteo Sandrin on 21/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWScheduleTableViewCell.h"

@implementation CSWScheduleTableViewCell

- (void)awakeFromNib {
    
    
    
    // Initialization code
}

-(void) setupWithData:(NSDictionary*)cellData {
    
//    self.blockLabel.font = [UIFont sanFranciscoFontWithSize:71];
    self.titleLabel.text = cellData[@"CourseTitle"];
//    self.titleLabel.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
//    self.titleLabel.layer.borderWidth = 4;
//    [self.titleLabel sizeToFit];
    self.baseCellView.layer.cornerRadius = 25.0f;
    
    NSString *block = cellData[@"Block"];
    if (block.length < 6) {
        if (block.length == 3) {
            self.blockLabel.text = [block substringToIndex:3];
        }else if (block.length == 2){
            self.blockLabel.text = [block substringToIndex:2];
        }else{
            self.blockLabel.text = [block substringToIndex:1];
        }
        
    }else{
        self.blockLabel.text = [block substringToIndex:3];
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",cellData[@"MyDayStartTime"],cellData[@"MyDayEndTime"]];
    
    NSString *place = [NSString stringWithFormat:@"%@, %@",cellData[@"BuildingName"],cellData[@"RoomNumber"]];
    if ([cellData[@"BuildingName"] isEqualToString:@""]) {
        place = @"--";
    }else if ([cellData[@"RoomNumber"] isEqualToString:@""]) {
        place = cellData[@"BuildingName"];
    }
    
    self.placeLabel.text = place;
    
    self.baseCellView.layer.shadowRadius = 5;
    self.baseCellView.layer.shadowOpacity = 0.5;
    self.baseCellView.layer.shadowOffset = CGSizeMake(1, 1);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
