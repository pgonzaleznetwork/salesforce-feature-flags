public with sharing class FeatureFlags implements IFeatureFlags {
    
    private static Map<String,FeatureFlag__mdt> features = FeatureFlag__mdt.getAll();
    private static Set<String> customPermissions = new Set<String>();
    private static Map<String,Boolean> mockValues = new Map<String,Boolean>();

    static{
        
        for (CustomPermission permission : [SELECT Id, DeveloperName FROM CustomPermission]) {
            customPermissions.add(permission.DeveloperName);
        }
    }
    
    @AuraEnabled
    public static FeatureEvaluationResult evaluate(String featureName) {

        if(Test.isRunningTest() && mockValues.containsKey(featureName)){
            return new FeatureEvaluationResult(mockValues.get(featureName), featureName, FeatureReason.MOCK_VALUE);
        }

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


    @TestVisible
    private static void setMockValue(String featureName, Boolean value){
        mockValues.put(featureName, value);
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
        FLAG_NOT_FOUND,
        MOCK_VALUE
    }

}