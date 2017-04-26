![](https://github.com/bizz84/SwiftyStoreKit/raw/master/SwiftyStoreKit-logo.png)

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)
[![Platform](http://img.shields.io/badge/platform-ios%20%7C%20macos%20%7C%20tvos-lightgrey.svg?style=flat)](https://developer.apple.com/resources/)
[![Language](https://img.shields.io/badge/swift-3.0-orange.svg)](https://developer.apple.com/swift)
[![Build](https://img.shields.io/travis/bizz84/SwiftyStoreKit.svg?style=flat)](https://travis-ci.org/bizz84/SwiftyStoreKit)
[![Issues](https://img.shields.io/github/issues/bizz84/SwiftyStoreKit.svg?style=flat)](https://github.com/bizz84/SwiftyStoreKit/issues)
[![Cocoapod](http://img.shields.io/cocoapods/v/SwiftyStoreKit.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyStoreKit/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Twitter](https://img.shields.io/badge/twitter-@biz84-blue.svg?maxAge=2592000)](http://twitter.com/biz84)

SwiftyStoreKit is a lightweight In App Purchases framework for iOS 8.0+, tvOS 9.0+ and macOS 10.10+.

### Preview

<img src="https://github.com/bizz84/SwiftyStoreKit/raw/master/Screenshots/Preview.png" width="320">
<img src="https://github.com/bizz84/SwiftyStoreKit/raw/master/Screenshots/Preview2.png" width="320">

## Contributing

#### Got issues / pull requests / want to contribute? [Read here](CONTRIBUTING.md).

## App startup

### Complete Transactions

Apple recommends to register a transaction observer [as soon as the app starts](https://developer.apple.com/library/ios/technotes/tn2387/_index.html):
> Adding your app's observer at launch ensures that it will persist during all launches of your app, thus allowing your app to receive all the payment queue notifications.

SwiftyStoreKit supports this by calling `completeTransactions()` when the app starts:

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

	SwiftyStoreKit.completeTransactions(atomically: true) { products in
	
	    for product in products {
	
	        if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {
	
               if product.needsFinishTransaction {
                   // Deliver content from server, then:
                   SwiftyStoreKit.finishTransaction(product.transaction)
               }
               print("purchased: \(product)")
	        }
	    }
	}
 	return true
}
```

If there are any pending transactions at this point, these will be reported by the completion block so that the app state and UI can be updated.

If there are no pending transactions, the completion block will **not** be called.

Note that `completeTransactions()` **should only be called once** in your code, in `application(:didFinishLaunchingWithOptions:)`.

## Purchases

### Retrieve products info
```swift
SwiftyStoreKit.retrieveProductsInfo(["com.musevisions.SwiftyStoreKit.Purchase1"]) { result in
    if let product = result.retrievedProducts.first {
        let priceString = product.localizedPrice!
        print("Product: \(product.localizedDescription), price: \(priceString)")
    }
    else if let invalidProductId = result.invalidProductIDs.first {
        return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
    }
    else {
	     print("Error: \(result.error)")
    }
}
```

### Purchase a product

* **Atomic**: to be used when the content is delivered immediately.

```swift
SwiftyStoreKit.purchaseProduct("com.musevisions.SwiftyStoreKit.Purchase1", atomically: true) { result in
    switch result {
    case .success(let product):
        print("Purchase Success: \(product.productId)")
    case .error(let error):
        switch error.code {
        case .unknown: print("Unknown error. Please contact support")
        case .clientInvalid: print("Not allowed to make the payment")
        case .paymentCancelled: break
        case .paymentInvalid: print("The purchase identifier was invalid")
        case .paymentNotAllowed: print("The device is not allowed to make the payment")
        case .storeProductNotAvailable: print("The product is not available in the current storefront")
        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
        }
    }
}
```

* **Non-Atomic**: to be used when the content is delivered by the server.

```swift
SwiftyStoreKit.purchaseProduct("com.musevisions.SwiftyStoreKit.Purchase1", atomically: false) { result in
    switch result {
    case .success(let product):
        // fetch content from your server, then:
        if product.needsFinishTransaction {
            SwiftyStoreKit.finishTransaction(product.transaction)
        }
        print("Purchase Success: \(product.productId)")
    case .error(let error):
        switch error.code {
        case .unknown: print("Unknown error. Please contact support")
        case .clientInvalid: print("Not allowed to make the payment")
        case .paymentCancelled: break
        case .paymentInvalid: print("The purchase identifier was invalid")
        case .paymentNotAllowed: print("The device is not allowed to make the payment")
        case .storeProductNotAvailable: print("The product is not available in the current storefront")
        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
        }
    }
}
```

### Restore previous purchases

* **Atomic**: to be used when the content is delivered immediately.

```swift
SwiftyStoreKit.restorePurchases(atomically: true) { results in
    if results.restoreFailedProducts.count > 0 {
        print("Restore Failed: \(results.restoreFailedProducts)")
    }
    else if results.restoredProducts.count > 0 {
        print("Restore Success: \(results.restoredProducts)")
    }
    else {
        print("Nothing to Restore")
    }
}
```

* **Non-Atomic**: to be used when the content is delivered by the server.

```swift
SwiftyStoreKit.restorePurchases(atomically: false) { results in
    if results.restoreFailedProducts.count > 0 {
        print("Restore Failed: \(results.restoreFailedProducts)")
    }
    else if results.restoredProducts.count > 0 {
        for product in results.restoredProducts {
            // fetch content from your server, then:
            if product.needsFinishTransaction {
                SwiftyStoreKit.finishTransaction(product.transaction)
            }
        }
        print("Restore Success: \(results.restoredProducts)")
    }
    else {
        print("Nothing to Restore")
    }
}
```

#### What does atomic / non-atomic mean?

When you purchase a product the following things happen:

* A payment is added to the payment queue for your IAP.
* When the payment has been processed with Apple, the payment queue is updated so that the appropriate transaction can be handled.
* If the transaction state is **purchased** or **restored**, the app can unlock the functionality purchased by the user.
* The app should call `finishTransaction()` to complete the purchase.

This is what is [recommended by Apple](https://developer.apple.com/reference/storekit/skpaymentqueue/1506003-finishtransaction):

> Your application should call finishTransaction(_:) only after it has successfully processed the transaction and unlocked the functionality purchased by the user.

* A purchase is **atomic** when the app unlocks the functionality purchased by the user immediately and call `finishTransaction()` at the same time. This is desirable if you're unlocking functionality that is already inside the app.

* In cases when you need to make a request to your own server in order to unlock the functionality, you can use a **non-atomic** purchase instead.

* **Note**: SwiftyStoreKit doesn't yet support downloading content hosted by Apple for non-consumable products. See [this feature request](https://github.com/bizz84/SwiftyStoreKit/issues/128).

SwiftyStoreKit provides three operations that can be performed **atomically** or **non-atomically**:

* Making a purchase
* Restoring purchases
* Completing transactions on app launch

## Receipt verification

According to [Apple - Delivering Products](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/DeliverProduct.html#//apple_ref/doc/uid/TP40008267-CH5-SW4):

> The app receipt contains a record of the user’s purchases, cryptographically signed by Apple. For more information, see [Receipt Validation Programming Guide](https://developer.apple.com/library/content/releasenotes/General/ValidateAppStoreReceipt/Introduction.html#//apple_ref/doc/uid/TP40010573).

> Information about consumable products is added to the receipt when they’re paid for and remains in the receipt until you finish the transaction. After you finish the transaction, this information is removed the next time the receipt is updated—for example, the next time the user makes a purchase.

> Information about all other kinds of purchases is added to the receipt when they’re paid for and remains in the receipt indefinitely.


### Retrieve local receipt

```swift
let receiptData = SwiftyStoreKit.localReceiptData
let receiptString = receiptData.base64EncodedString(options: [])
// do your receipt validation here
```

### Verify Receipt

```swift
let appleValidator = AppleReceiptValidator(service: .production)
SwiftyStoreKit.verifyReceipt(using: appleValidator, password: "your-shared-secret") { result in
    if case .error(let error) = result {
        if case .noReceiptData = error {
            self.refreshReceipt()
        }
    }
}

func refreshReceipt() {
    SwiftyStoreKit.refreshReceipt { result in
        switch result {
        case .success(let receiptData):
            print("Receipt refresh success: \(receiptData.base64EncodedString)")
        case .error(let error):
            print("Receipt refresh failed: \(error)")
        }
    }
}
```

#### Notes

* If the user is not logged to iTunes when `refreshReceipt` is called, StoreKit will present a popup asking to **Sign In to the iTunes Store**.
* If the user enters valid credentials, the receipt will be refreshed.
* If the user cancels, receipt refresh will fail with a **Cannot connect to iTunes Store** error.


### Verify Purchase

```swift
let appleValidator = AppleReceiptValidator(service: .production)
SwiftyStoreKit.verifyReceipt(using: appleValidator, password: "your-shared-secret") { result in
    switch result {
    case .success(let receipt):
        // Verify the purchase of Consumable or NonConsumable
        let purchaseResult = SwiftyStoreKit.verifyPurchase(
            productId: "com.musevisions.SwiftyStoreKit.Purchase1",
            inReceipt: receipt)
            
        switch purchaseResult {
        case .purchased(let expiresDate):
            print("Product is purchased.")
        case .notPurchased:
            print("The user has never purchased this product")
        }
    case .error(let error):
        print("Receipt verification failed: \(error)")
    }
}
```

Note that for consumable products, the receipt will only include the information for a couples of minutes after the purchase.

### Verify Subscription

This can be used to check if a subscription was previously purchased, and whether it is still active or if it's expired.

If a subscription has been purchased multiple times, this method will return `.purchased` or `.expired` for the most recent one.

```swift
let appleValidator = AppleReceiptValidator(service: .production)
SwiftyStoreKit.verifyReceipt(using: appleValidator, password: "your-shared-secret") { result in
    switch result {
    case .success(let receipt):
        // Verify the purchase of a Subscription
        let purchaseResult = SwiftyStoreKit.verifySubscription(
            type: .autoRenewable, // or .nonRenewing (see below)
            productId: "com.musevisions.SwiftyStoreKit.Subscription",
            inReceipt: receipt)
            
        switch purchaseResult {
        case .purchased(let expiresDate):
            print("Product is valid until \(expiresDate)")
        case .expired(let expiresDate):
            print("Product is expired since \(expiresDate)")
        case .notPurchased:
            print("The user has never purchased this product")
        }

    case .error(let error):
        print("Receipt verification failed: \(error)")
    }
}
```

#### Auto-Renewable
```
let purchaseResult = SwiftyStoreKit.verifySubscription(
            type: .autoRenewable,
            productId: "com.musevisions.SwiftyStoreKit.Subscription",
            inReceipt: receipt)
```

#### Non-Renewing
```
// validDuration: time interval in seconds
let purchaseResult = SwiftyStoreKit.verifySubscription(
            type: .nonRenewing(validDuration: 3600 * 24 * 30),
            productId: "com.musevisions.SwiftyStoreKit.Subscription",
            inReceipt: receipt)
```

**Note**: When purchasing subscriptions in sandbox mode, the expiry dates are set just minutes after the purchase date for testing purposes.

#### Purchasing and verifying a subscription 

The `verifySubscription` method can be used together with the `purchaseProduct` method to purchase a subscription and check its expiration date, like so:

```swift
let productId = "your-product-id"
SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
    
    if case .success(let product) = result {
        // Deliver content from server, then:
        if product.needsFinishTransaction {
            SwiftyStoreKit.finishTransaction(product.transaction)
        }
        
        let appleValidator = AppleReceiptValidator(service: .production)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password: "your-shared-secret") { result in
            
            if case .success(let receipt) = result {
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    type: .autoRenewable,
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate):
                    print("Product is valid until \(expiryDate)")
                case .expired(let expiryDate):
                    print("Product is expired since \(expiryDate)")
                case .notPurchased:
                    print("This product has never been purchased")
                }

            } else {
                // receipt verification error
            }
        }
        
    } else {
        // purchase error
    }
}
```


## Notes
The framework provides a simple block based API with robust error handling on top of the existing StoreKit framework. It does **NOT** persist in app purchases data locally. It is up to clients to do this with a storage solution of choice (i.e. NSUserDefaults, CoreData, Keychain).

## Installation

### CocoaPods

SwiftyStoreKit can be installed as a [CocoaPod](https://cocoapods.org/) and builds as a Swift framework. To install, include this in your Podfile.

```ruby
use_frameworks!

pod 'SwiftyStoreKit'
```
Once installed, just ```import SwiftyStoreKit``` in your classes and you're good to go.

### Carthage

To integrate SwiftyStoreKit into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your Cartfile:

```ogdl
github "bizz84/SwiftyStoreKit"
```

**NOTE**: Please ensure that you have the [latest](https://github.com/Carthage/Carthage/releases) Carthage installed.

## Swift 2.2 / 2.3 / 3.0

| Language  | Branch | Pod version | Xcode version |
| --------- | ------ | ----------- | ------------- |
| Swift 3.0 | [master](https://github.com/bizz84/SwiftyStoreKit/tree/master) | >= 0.5.x | Xcode 8 or greater|
| Swift 2.3 | [swift-2.3](https://github.com/bizz84/SwiftyStoreKit/tree/swift-2.3) | 0.4.x | Xcode 8, Xcode 7.3.x |
| Swift 2.2 | [swift-2.2](https://github.com/bizz84/SwiftyStoreKit/tree/swift-2.2) | 0.3.x | Xcode 7.3.x |

## Change Log

See the [Releases Page](https://github.com/bizz84/SwiftyStoreKit/releases)

## Sample Code
The project includes demo apps [for iOS](https://github.com/bizz84/SwiftyStoreKit/blob/master/SwiftyStoreKit-iOS-Demo/ViewController.swift) [and macOS](https://github.com/bizz84/SwiftyStoreKit/blob/master/SwiftyStoreKit-macOS-Demo/ViewController.swift) showing how to use SwiftyStoreKit.
Note that the pre-registered in app purchases in the demo apps are for illustration purposes only and may not work as iTunes Connect may invalidate them.

#### Features

- Super easy to use block based API
- Support for consumable, non-consumable in-app purchases
- Support for free, auto renewable and non renewing subscriptions
- Receipt verification
- iOS, tvOS and macOS compatible

## Essential Reading
* [Apple - WWDC16, Session 702: Using Store Kit for In-app Purchases with Swift 3](https://developer.apple.com/videos/play/wwdc2016/702/)
* [Apple - TN2387: In-App Purchase Best Practices](https://developer.apple.com/library/content/technotes/tn2387/_index.html)
* [Apple - About Receipt Validation](https://developer.apple.com/library/content/releasenotes/General/ValidateAppStoreReceipt/Introduction.html)
* [Apple - Receipt Validation Programming Guide](https://developer.apple.com/library/content/releasenotes/General/ValidateAppStoreReceipt/Chapters/ReceiptFields.html#//apple_ref/doc/uid/TP40010573-CH106-SW1)
* [Apple - Validating Receipts Locally](https://developer.apple.com/library/content/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateLocally.html)
* [Apple - Working with Subscriptions](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/Subscriptions.html#//apple_ref/doc/uid/TP40008267-CH7-SW6)
* [Apple - Offering Subscriptions](https://developer.apple.com/app-store/subscriptions/)
* [objc.io - Receipt Validation](https://www.objc.io/issues/17-security/receipt-validation/)
* [Apple TN 2413 - Why are my product identifiers being returned in the invalidProductIdentifiers array?](https://developer.apple.com/library/content/technotes/tn2413/_index.html#//apple_ref/doc/uid/DTS40016228-CH1-TROUBLESHOOTING-WHY_ARE_MY_PRODUCT_IDENTIFIERS_BEING_RETURNED_IN_THE_INVALIDPRODUCTIDENTIFIERS_ARRAY_)
* [Invalid Product IDs](http://troybrant.net/blog/2010/01/invalid-product-ids/): Checklist of common mistakes

I have also written about building SwiftyStoreKit on Medium:

* [How I got 1000 ⭐️ on my GitHub Project](https://medium.com/ios-os-x-development/how-i-got-1000-%EF%B8%8F-on-my-github-project-654d3d394ca6#.1idp27olf)
* [Maintaining a Growing Open Source Project](https://medium.com/@biz84/maintaining-a-growing-open-source-project-1d385ca84c5#.4cv2g7tdc)

## Payment flows - implementation Details
In order to make a purchase, two operations are needed:

- Perform a `SKProductRequest` to obtain the `SKProduct` corresponding to the product identifier.

- Submit the payment and listen for updated transactions on the `SKPaymentQueue`.

The framework takes care of caching SKProducts so that future requests for the same ```SKProduct``` don't need to perform a new ```SKProductRequest```.

### Payment queue

The following list outlines how requests are processed by SwiftyStoreKit.

* `SKPaymentQueue` is used to queue payments or restore purchases requests.
* Payments are processed serially and in-order and require user interaction.
* Restore purchases requests don't require user interaction and can jump ahead of the queue.
* `SKPaymentQueue` rejects multiple restore purchases calls.
* Failed transactions only ever belong to queued payment requests.
* `restoreCompletedTransactionsFailedWithError` is always called when a restore purchases request fails.
* `paymentQueueRestoreCompletedTransactionsFinished` is always called following 0 or more update transactions when a restore purchases request succeeds.
* A complete transactions handler is require to catch any transactions that are updated when the app is not running.
* Registering a complete transactions handler when the app launches ensures that any pending transactions can be cleared.
* If a complete transactions handler is missing, pending transactions can be mis-attributed to any new incoming payments or restore purchases.

The order in which transaction updates are processed is:

1. payments (transactionState: `.purchased` and `.failed` for matching product identifiers)
2. restore purchases (transactionState: `.restored`, or `restoreCompletedTransactionsFailedWithError`, or `paymentQueueRestoreCompletedTransactionsFinished`)
3. complete transactions (transactionState: `.purchased`, `.failed`, `.restored`, `.deferred`)

Any transactions where state == `.purchasing` are ignored.

See [this pull request](https://github.com/bizz84/SwiftyStoreKit/pull/131) for full details about how the payment flows have been implemented.

## Credits
Many thanks to [phimage](https://github.com/phimage) for adding macOS support and receipt verification.

## Apps using SwiftyStoreKit

It would be great to showcase apps using SwiftyStoreKit here. Pull requests welcome :)

* [MDacne](https://itunes.apple.com/app/id1044050208) - Acne analysis and treatment
* [Pixel Picker](https://itunes.apple.com/app/id930804327) - Image Color Picker
* [KType](https://itunes.apple.com/app/id1037000234) - Space shooter game
* [iPic](https://itunes.apple.com/app/id1101244278) - Automatically upload images and save Markdown links
* [iHosts](https://itunes.apple.com/app/id1102004240) - Perfect for editing /etc/hosts
* [Arise](http://www.abnehm-app.de/) - Calorie counter
* [Truth Truth Lie](https://itunes.apple.com/app/id1130832864) - iMessage game, featured by Apple
* [Tactus Music Player](https://itunes.apple.com/app/id557446352) - Alternative music player app
* [Drops](https://itunes.apple.com/app/id939540371) - Language learning app
* [Fresh Snow](https://itunes.apple.com/app/id1063000470) - Colorado Ski Report


## License

Copyright (c) 2015-2017 Andrea Bizzotto bizz84@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
