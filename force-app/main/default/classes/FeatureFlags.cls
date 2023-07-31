public with sharing class FeatureFlags {
    
    private static Map<String,FeatureFlag__mdt> features = FeatureFlag__mdt.getAll();

    private static Set<String> customPermissions = new Set<String>();

    static{
        
        for (CustomPermission permission : [SELECT Id, DeveloperName FROM CustomPermission]) {
            customPermissions.add(permission.DeveloperName);
        }
    }
    
    @AuraEnabled
    public static FeatureEvaluationResult evaluate(String featureName) {

        FeatureEvaluationResult result;

        if(customPermissions.contains(featureName)){

            if(FeatureManagement.checkPermission(featureName)){
                result = new FeatureEvaluationResult(true, featureName, FeatureReason.HAS_CUSTOM_PERMISSION);
            }
            else{
                result = new FeatureEvaluationResult(false, featureName, FeatureReason.MISSING_CUSTOM_PERMISSION);
            }

        }

        else{

            if(features.containsKey(featureName)){
                
                if(features.get(featureName).Is_Active__c){
                    result = new FeatureEvaluationResult(true, featureName, FeatureReason.CUSTOM_METADATA_TYPE_ENABLED);
                }
                else{
                    result = new FeatureEvaluationResult(false, featureName, FeatureReason.CUSTOM_METADATA_TYPE_DISABLED);
                }

            }
            else {
                result = new FeatureEvaluationResult(false, featureName, FeatureReason.FLAG_NOT_FOUND);
            }
        }
    
        return result;
    }

    public class FeatureEvaluationResult{

        private Boolean result;
        private String featureName;
        private FeatureReason reason;

        public Boolean getResult(){
            return result;
        }

        public String getFeatureName(){
            return featureName;
        }

        public FeatureReason getReason(){
            return reason;
        }


        public FeatureEvaluationResult(Boolean result, String featureName, FeatureReason reason){
            this.result = result;
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