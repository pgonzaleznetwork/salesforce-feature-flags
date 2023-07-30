public with sharing class FeatureFlags {
    
    private static Map<String,FeatureFlag__mdt> features = FeatureFlag__mdt.getAll();

    private static Set<String> customPermissions = new Set<String>();

    static{
        
        for (CustomPermission permission : [SELECT Id, DeveloperName FROM CustomPermission]) {
            customPermissions.add(permission.DeveloperName);
        }
    }
    
    public static FeatureEvaluationResult isActive(String featureName) {

        if(customPermissions.contains(featureName)){

            if(FeatureManagement.checkPermission(featureName)){
                return new FeatureEvaluationResult(true, featureName, FeatureReason.HAS_CUSTOM_PERMISSION);
            }
            else{
                return new FeatureEvaluationResult(false, featureName, FeatureReason.MISSING_CUSTOM_PERMISSION);
            }

        }

        else{

            if(features.containsKey(featureName)){
                
                if(features.get(featureName).Is_Active__c){
                    return new FeatureEvaluationResult(true, featureName, FeatureReason.CUSTOM_METADATA_TYPE_ENABLED);
                }
                else{
                    return new FeatureEvaluationResult(false, featureName, FeatureReason.CUSTOM_METADATA_TYPE_DISABLED);
                }

            }
        }
        
        return new FeatureEvaluationResult(false, featureName, FeatureReason.FLAG_NOT_FOUND);
    }

    public class FeatureEvaluationResult{

        private Boolean isActive;
        private String featureName;
        private FeatureReason reason;

        public Boolean isActive(){
            return isActive;
        }

        public String getFeatureName(){
            return featureName;
        }

        public FeatureReason getReason(){
            return reason;
        }


        public FeatureEvaluationResult(Boolean isActive, String featureName, FeatureReason reason){
            this.isActive = isActive;
            this.featureName = featureName;
            this.reason = reason;
        }
    }

    public enum FeatureReason {
        HAS_CUSTOM_PERMISSION,
        MISSING_CUSTOM_PERMISSION, 
        CUSTOM_METADATA_TYPE_ENABLED,
        CUSTOM_METADATA_TYPE_DISABLED,
        FLAG_NOT_FOUND
    }

}