//
//  DESEncryption.m
//  des
//
//  Created by Eliyar Eziz on 15/10/14.
//
//

#import "DESEncryption.h"
#import "GTMBase64.h"
#include <CommonCrypto/CommonCryptor.h>

@implementation DESEncryption

+ (NSData *)convertHexStrToData:(NSString *)str {
  if (!str || [str length] == 0) {
    return nil;
  }
  
  NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
  NSRange range;
  if ([str length] % 2 == 0) {
    range = NSMakeRange(0, 2);
  } else {
    range = NSMakeRange(0, 1);
  }
  for (NSInteger i = range.location; i < [str length]; i += 2) {
    unsigned int anInt;
    NSString *hexCharStr = [str substringWithRange:range];
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
    
    [scanner scanHexInt:&anInt];
    NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
    [hexData appendData:entity];
    
    range.location += range.length;
    range.length = 2;
  }
  
  
  return hexData;
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
  if (!data || [data length] == 0) {
    return @"";
  }
  NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
  
  [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
    unsigned char *dataBytes = (unsigned char*)bytes;
    for (NSInteger i = 0; i < byteRange.length; i++) {
      NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
      if ([hexStr length] == 2) {
        [string appendString:hexStr];
      } else {
        [string appendFormat:@"0%@", hexStr];
      }
    }
  }];
  
  return string;
}

+ (NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key {
  // 利用 GTMBase64 解碼 Base64 字串
  NSData* cipherData = [self convertHexStrToData:cipherText];
  unsigned char buffer[1024];
  memset(buffer, 0, sizeof(char));
  size_t numBytesDecrypted = 0;
  
  // IV 偏移量不需使用
  CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                        kCCAlgorithmDES,
                                        kCCOptionPKCS7Padding | kCCOptionECBMode,
                                        [key UTF8String],
                                        kCCKeySizeDES,
                                        nil,
                                        [cipherData bytes],
                                        [cipherData length],
                                        buffer,
                                        1024,
                                        &numBytesDecrypted);
  NSString* plainText = nil;
  if (cryptStatus == kCCSuccess) {
    NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
    plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  }
  return plainText;
}


+ (NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
{
  NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
  unsigned char buffer[1024];
  memset(buffer, 0, sizeof(char));
  size_t numBytesEncrypted = 0;
  
  CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                        kCCAlgorithmDES,
                                        kCCOptionPKCS7Padding | kCCOptionECBMode,
                                        [key UTF8String],
                                        kCCKeySizeDES,
                                        nil,
                                        [data bytes],
                                        [data length],
                                        buffer,
                                        1024,
                                        &numBytesEncrypted);
  
  NSString* plainText = nil;
  if (cryptStatus == kCCSuccess) {
    NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
    NSLog(@"decrypt = %@", dataTemp);
    plainText = [self convertDataToHexStr:dataTemp];
    NSString *newStr = [[NSString alloc] initWithData:dataTemp encoding:NSUTF8StringEncoding];
    NSLog(@"newStr = %@", newStr);
  }else{
    NSLog(@"DES加密失败");
  }
  return plainText;
}


@end