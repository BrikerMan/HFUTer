//
//  DESEncryption.h
//  des
//
//  Created by Eliyar Eziz on 15/10/14.
//
//


#import <Foundation/Foundation.h>

@interface DESEncryption : NSObject

+(NSString *) convertDataToHexStr:(NSData *)data;

+(NSString*)  decryptUseDES:(NSString*)cipherText key:(NSString*)key;
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;

@end
