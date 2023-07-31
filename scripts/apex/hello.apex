//a lot of code goes here
FeatureFlags flags = new FeatureFlags();

if(flags.evaluate('enhancedQuoteEditor').isEnabled()) {
    System.debug('enhancedQuoteEditor is isEnabled');    
}
else {
    System.debug('enhancedQuoteEditor is not enabled');
}

System.debug(flags.evaluate('enhancedQuoteEditor'));