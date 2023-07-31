public with sharing class FeatureFlagProviderMock implements IFeatureFlagProvider {
    
    public static Set<String> getCustomPermissionNames(){
        Set<String> customPermissionNames = new Set<String>();
        customPermissionNames.add('flag1');
        customPermissionNames.add('flag2');
        return customPermissionNames;
    }

    public static Map<String,FeatureFlag__mdt> getFeatureFlags(){
        Map<String,FeatureFlag__mdt> flags = new Map<String,FeatureFlag__mdt>();

        FeatureFlag__mdt flag1 = new FeatureFlag__mdt(DeveloperName = 'flag1', Is_Active__c = true);
        FeatureFlag__mdt flag2 = new FeatureFlag__mdt(DeveloperName = 'flag2', Is_Active__c = true);

        flags.put('flag1',flag1);
        flags.put('flag2',flag2);
        return flags;
        
    }

}

