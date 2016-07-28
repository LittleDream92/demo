//
//  UserModule.h
//  QiChegou
//
//  Created by Meng Fan on 16/7/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"


@interface UserModule : BaseModel

/*手机号码*/
@property (nonatomic, copy) NSString *sjhm;
/*真实姓名*/
@property (nonatomic, copy) NSString *zsxm;
/*头像*/
@property (nonatomic, copy) NSString *head_img;

/* token */
@property (nonatomic, copy) NSString *token;

@end
