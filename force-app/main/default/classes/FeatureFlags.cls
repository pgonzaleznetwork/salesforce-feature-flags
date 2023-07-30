public with sharing class FeatureFlags {
    
    private static Map<String,FeatureFlag__mdt> features = FeatureFlag__mdt.getAll();

    private static Set<String> permissions = new Set<String>();

    static{
        
        for (CustomPermission permission : [SELECT Id, DeveloperName FROM CustomPermission]) {
            permissions.add(permission.DeveloperName);
        }
    }
    
    public static FeatureEvaluationResult isActive(String featureName) {

        if(permissions.contains(featureName)){

            if(FeatureManagement.checkPermission(featureName)){
                return new FeatureEvaluationResult(true, featureName, FeatureEvaluationResult.Reason.HAS_CUSTOM_PERMISSION);
            }
            else{
                return new FeatureEvaluationResult(false, featureName, FeatureEvaluationResult.Reason.MISSING_CUSTOM_PERMISSION);
            }

        }

        else{

            if(features.contains(featureName)){
                
                if(features.get(featureName).Is_Active__c){
                    return new FeatureEvaluationResult(true, featureName, FeatureEvaluationResult.Reason.CUSTOM_METADATA_TYPE_ENABLED);
                }
                else{
                    return new FeatureEvaluationResult(false, featureName, FeatureEvaluationResult.Reason.CUSTOM_METADATA_TYPE_DISABLED);
                }

            }
        }
        
        return new FeatureEvaluationResult(false, featureName, FeatureEvaluationResult.Reason.FLAG_NOT_FOUND);
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

        public String getReason(){
            return reason;
        }

        public FeatureEvaluationResult(Boolean isActive, String featureName, Reason reason){
            this.isActive = isActive;
            this.featureName = featureName;
            this.reason = reason;
        }
    }

    private enum FeatureReason {
        HAS_CUSTOM_PERMISSION,
        MISSING_CUSTOM_PERMISSION, 
        CUSTOM_METADATA_TYPE_ENABLED,
        CUSTOM_METADATA_TYPE_DISABLED,
        FLAG_NOT_FOUND
    }

}