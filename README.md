# iOS sýnidæmi fyrir Fintech partý Arion banka hf. í júní 2016 
Demo biðlari iOS, auðkennir og kallar á API með einfaldri virkni.

Authorize endpoint:
https://arionapi-identityserver3-sandbox.azurewebsites.net/connect/authorize

Token endpoint:
https://arionapi-identityserver3-sandbox.azurewebsites.net/connect/token

Developer portall: 
https://arionapi-sandbox.portal.azure-api.net


--------------------------------------------------------------------------------------------------

01 - Til að geta sótt gögn frá Fintech þjónustunum þarf að setja inn developer key. Ef þú hefur ekki fengið slíkan þarftu að skrá þig á https://arionapi-sandbox.portal.azure-api.net<br>

02 - Sækja um OAuth2 client með því að fara inn á Management Api og velja búa til nýjan client - til þess þarf að nota developer-key'inn sem menn fengu úthlutað í skrefi 01 að ofan, og setja inn í 'Ocp-Apim-Subscription-Key' svæðið í Azure viðmótinu<br>
https://arionapi-sandbox.portal.azure-api.net/docs/services/574d5a9cdbc60f015c0a5974/operations/57507fac6aa55e0e2411340e

<br>
*<b>[clientId]</b> er nafnið sem menn vilja gefa sínum OAuth2 biðlara.<br> 
*<b>[redirectpath]</b> er slóðin sem menn vilja vera beint inn á eftir innskráningu með sínum biðlara<br>
*<b>[flowType]</b> annað hvort "codeflow" eða "implicit" - í flestum tilfellum er þetta "codeflow"<br><br>

- Muna eða skrifa niður clientSecret'ið sem menn fengu úthlutað til innskráningar, og nota þegar menn skrá sig inn. ClientSecret'ið verður ekki gefið aftur upp.<br>
<br>



Til að geta keyrt þennan demo client þá þarf <a href="https://guides.cocoapods.org/using/getting-started.html">Cocoapods</a> að vera uppsett á vélinni. 

Svo þarf að keyra eftirfandi skipun úr rótinni á verkefninu úr terminal
<div class="highlight highlight-source-shell"><pre>pod update</pre></div>


Til að geta sótt gögn frá Fintech þjónustunum þarf að setja inn developer key. Ef þú hefur ekki fengið slíkan þarftu að skrá þig á https://arionapi-sandbox.portal.azure-api.net
<br/>
Lykilinn þarf að setja inn í constants.h
<div class="highlight highlight-source-shell"><pre>#define kArionFintechDeveloperKey @"&lt;API DEVELOPER KEY&gt;"</pre></div>
<br/>
Setja inn ClientID og ClientSecret í AppDelegate.m
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
