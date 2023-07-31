public interface IFeatureFlagProvider {
    
    Set<String> getCustomPermissionNames();
    Map<String,FeatureFlag__mdt> getFeatureFlags();

}