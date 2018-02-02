//
//  CertificatesTableCell.h
//  pairearch_WLY
//
//  Created by Jean on 2017/11/29.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CertificatesTableCell;

typedef void(^TapImgViewBlock)(CertificatesTableCell *cell, NSInteger row);

@interface CertificatesTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *certificatesNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *certificatesImgView;
@property (nonatomic, copy) NSString *imgUrlStr;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) TapImgViewBlock tapBlock;

+ (instancetype)getCellWithTable:(UITableView *)table indexPath:(NSIndexPath *)indexPath tapImgBlock:(TapImgViewBlock)tapBlock;

@end
