//
//  CertificatesTableCell.m
//  pairearch_WLY
//
//  Created by Jean on 2017/11/29.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "CertificatesTableCell.h"

@implementation CertificatesTableCell

+ (instancetype)getCellWithTable:(UITableView *)table indexPath:(NSIndexPath *)indexPath tapImgBlock:(TapImgViewBlock)tapBlock {
    CertificatesTableCell *cell = [table dequeueReusableCellWithIdentifier:@"CertificatesTableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CertificatesTableCell" owner:self options:nil] firstObject];
    }
    cell.indexPath = indexPath;
    cell.tapBlock = tapBlock;
    return cell;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    _imgUrlStr = imgUrlStr;
    [self.certificatesImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] completed:nil];
}

- (IBAction)tapImgViewAction:(UITapGestureRecognizer *)sender {
    if (self.tapBlock) {
        self.tapBlock(self, self.indexPath.row);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
