public with sharing class FeatureFlagProvider implements IFeatureFlagProvider {
    
    public static Set<String> getCustomPermissionNames(){
        Set<String> customPermissionNames = new Set<String>();
        List<CustomPermission> perms = [SELECT Id, DeveloperName FROM CustomPermission];
        for(CustomPermission perm : perms){
            customPermissionNames.add(perm.DeveloperName);
        }
        return customPermissionNames;
    }

    public static Map<String,FeatureFlag__mdt> getFeatureFlags(){
        return FeatureFlag__mdt.getAll();
    }

}