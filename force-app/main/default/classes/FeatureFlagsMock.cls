public class FeatureFlagsMock implements IFeatureFlags {
    
    private Map<String, Boolean> featureMap;

    public FeatureFlagsMock(Map<String, Boolean> featureMap) {
        this.featureMap = featureMap;
    }

    public FeatureFlags.FeatureEvaluationResult evaluate(String featureName) {
        Boolean isActive = featureMap.containsKey(featureName) ? featureMap.get(featureName) : false;
        return new FeatureFlags.FeatureEvaluationResult(isActive, featureName, null);
    }
}
