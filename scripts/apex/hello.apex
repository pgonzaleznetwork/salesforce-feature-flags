FeatureFlags.FeatureEvaluationResult result = FeatureFlags.isActive('enhancedQuoteCalculation');

System.debug('The name of the feature is: ' + result.getFeatureName());
System.debug('Feature is active: ' + result.isActive());
System.debug('The reason the result is: ' + result.getReason());
