//
//  NewsCellTableViewCell.h
//  News
//
//  Created by Norayr Harutyunyan on 10/5/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewNews;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;

@end

NS_ASSUME_NONNULL_END
