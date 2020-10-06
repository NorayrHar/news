//
//  NewsDetailsViewController.m
//  News
//
//  Created by Norayr Harutyunyan on 10/6/20.
//

#import "NewsDetailsViewController.h"

@interface NewsDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewNews;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;

@end

@implementation NewsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(refreshUI:)
            name:@"newsImageLoaded"
            object:nil];
    
    [self setupUI];
}

- (void) setupUI {
    if ([self.newsModel.title isEqual:[NSNull null]]) {
        self.labelTitle.text = @"";
    } else {
        self.labelTitle.text = self.newsModel.title;
    }
    
    if ([self.newsModel.description_ isEqual:[NSNull null]]) {
        self.labelDescription.text = @"";
    } else {
        self.labelDescription.text = self.newsModel.description_;
    }

    if (self.newsModel.imageData != nil) {
        UIImage *image = [UIImage imageWithData:self.newsModel.imageData];
        self.imageViewNews.image = image;
        [self.activityIndicatorView stopAnimating];
    } else {
        self.imageViewNews.image = nil;
        [self.activityIndicatorView startAnimating];
    }
}

- (void) refreshUI:(NSNotification *) notification {
    
    NewsModel *newsModel_ = notification.object;
    
    if (newsModel_ == self.newsModel) {
        [self setupUI];
    }
}

@end
