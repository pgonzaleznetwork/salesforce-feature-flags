public with sharing class FeatureFlagProvider implements IFeatureFlagProvider {
    
    public Set<String> getCustomPermissionNames(){
        Set<String> customPermissionNames = new Set<String>();
        List<CustomPermission> perms = [SELECT Id, DeveloperName FROM CustomPermission];
        for(CustomPermission perm : perms){
            customPermissionNames.add(perm.DeveloperName);
        }
        return customPermissionNames;
    }

    public Map<String,FeatureFlag__mdt> getFeatureFlags(){
        return FeatureFlag__mdt.getAll();
    }

}