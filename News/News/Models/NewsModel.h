//
//  NewsModel.h
//  News
//
//  Created by Norayr Harutyunyan on 10/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject

@property (nonatomic) NSInteger cellRow;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *description_;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *urlToImage;
@property (nonatomic, nullable) NSData *imageData;

- (id) init:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
