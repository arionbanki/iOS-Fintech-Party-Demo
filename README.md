# iOS sýnidæmi fyrir Fintech partý Arion banka hf. í júní 2016 
<Demo biðlari iOS, auðkennir og kallar á API með einfaldri virkni.
<<(Í vinnslu)

Til að geta keyrt þennan demo client þá þarf <a href="https://guides.cocoapods.org/using/getting-started.html">Cocoapods</a> að vera uppsett á vélinni. 

Svo þarf að keyra eftirfandi skipun úr rótinni á verkefninu úr terminal
<div class="highlight highlight-source-shell"><pre>pod update</pre></div>


Til að geta sótt gögn frá Fintech þjónustunum þarf að setja inn developer key. Ef þú hefur ekki fengið slíkan þarftu að skrá þig á https://arionapi-sandbox.portal.azure-api.net
<br/>
Lykilinn þarf að setja inn í constants.h
<div class="highlight highlight-source-shell"><pre>#define kArionFintechDeveloperKey @"&lt;API DEVELOPER KEY&gt;"</pre></div>
<br/>
3. Setja inn ClientID og ClientSecret í AppDelegate.m
<div class="highlight highlight-source-shell"><pre>
    [[NXOAuth2AccountStore sharedStore] setClientID:@"&lt;API CLIENT ID&gt;"
                                             secret:@"&lt;API CLIENT SECRET&gt;"
                                              scope:[NSSet setWithObjects:kArionFintechAuthorizationScopes, nil]
                                   authorizationURL:[NSURL URLWithString:kArionFintechAuthorizationUrl]
                                           tokenURL:[NSURL URLWithString:kArionFintechAuthorizationTokenUrl]
                                        redirectURL:[NSURL URLWithString:kArionFintechRedirectUrl]
                                      keyChainGroup:@"is.arionfintech.ios.demo"
                                     forAccountType:kArionFintechOAuth2AccountType];

</pre></div>

<br/>
