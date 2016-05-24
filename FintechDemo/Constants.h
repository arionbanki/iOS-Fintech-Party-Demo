//
//  Constants.h
//  FintechDemo
//
//  Created by Ívar Örn Helgason on 20.5.2016.
//  Copyright © 2016 Ívar Örn Helgason. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define kArionFintechDeveloperKey @"<API DEVELOPER KEY>"
#define kArionFintechOAuth2AccountType @"arionFintechApi"
#define kArionFintechRedirectUrl @"fintech:authsuccess"
#define kArionFintechAuthorizationScopes @"financial"

#define kArionFintechAuthorizationUrl @"https://arionapi-identityserver3-sandbox.azurewebsites.net/connect/authorize"
#define kArionFintechAuthorizationTokenUrl @"https://arionapi-identityserver3-sandbox.azurewebsites.net/connect/token"

#define kArionFintechAccountsUrl @"https://arionapi-sandbox.azure-api.net/accounts/v1/getall"
#define kArionFintechCurrencyUrl @"https://arionapi-sandbox.azure-api.net/currency/v1/currencyRates/CentralBankRate"
#define kArionFintechNationalRegistryPartyUrl @"https://arionapi-sandbox.azure-api.net/nationalregistry/v1/party/%@"
#define kArionFintechNationalRegistryPartiesUrl @"https://arionapi-sandbox.azure-api.net/nationalregistry/v1/parties/%@"
#endif /* Constants_h */
