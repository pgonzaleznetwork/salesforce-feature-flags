@IsTest
private class FeatureFlagsTests {
    @IsTest
    static void testFeatureEnabledWithCustomMetadata() {
        // Set up test data - create a FeatureFlag__mdt record with Is_Active__c = true
        FeatureFlag__mdt flag = new FeatureFlag__mdt(DeveloperName = 'MyFeature', Is_Active__c = true);
        insert flag;

        Test.startTest();
        FeatureFlags.FeatureEvaluationResult result = FeatureFlags.evaluate('MyFeature');
        Test.stopTest();

        // Assert that the feature is enabled and reason is CUSTOM_METADATA_TYPE_ENABLED
        System.assertEquals(true, result.getResult());
        System.assertEquals('MyFeature', result.getFeatureName());
        System.assertEquals(FeatureFlags.FeatureReason.CUSTOM_METADATA_TYPE_ENABLED, result.getReason());
    }

    @IsTest
    static void testFeatureDisabledWithCustomMetadata() {
        // Set up test data - create a FeatureFlag__mdt record with Is_Active__c = false
        FeatureFlag__mdt flag = new FeatureFlag__mdt(DeveloperName = 'MyFeature', Is_Active__c = false);
        insert flag;

        Test.startTest();
        FeatureFlags.FeatureEvaluationResult result = FeatureFlags.evaluate('MyFeature');
        Test.stopTest();

        // Assert that the feature is disabled and reason is CUSTOM_METADATA_TYPE_DISABLED
        System.assertEquals(false, result.getResult());
        System.assertEquals('MyFeature', result.getFeatureName());
        System.assertEquals(FeatureFlags.FeatureReason.CUSTOM_METADATA_TYPE_DISABLED, result.getReason());
    }

    @IsTest
    static void testFeatureWithMissingCustomMetadata() {
        Test.startTest();
        FeatureFlags.FeatureEvaluationResult result = FeatureFlags.evaluate('NonExistentFeature');
        Test.stopTest();

        // Assert that the feature is not found and reason is FLAG_NOT_FOUND
        System.assertEquals(false, result.getResult());
        System.assertEquals('NonExistentFeature', result.getFeatureName());
        System.assertEquals(FeatureFlags.FeatureReason.FLAG_NOT_FOUND, result.getReason());
    }

    @IsTest
    static void testFeatureWithCustomPermission() {
        // Set up test data - create a Custom Permission
        CustomPermission permission = new CustomPermission(DeveloperName = 'MyPermission');
        insert permission;

        Test.startTest();
        FeatureFlags.FeatureEvaluationResult result = FeatureFlags.evaluate('MyPermission');
        Test.stopTest();

        // Assert that the feature has the custom permission and reason is HAS_CUSTOM_PERMISSION
        System.assertEquals(true, result.getResult());
        System.assertEquals('MyPermission', result.getFeatureName());
        System.assertEquals(FeatureFlags.FeatureReason.HAS_CUSTOM_PERMISSION, result.getReason());
    }

    @IsTest
    static void testFeatureWithoutCustomPermission() {
        Test.startTest();
        FeatureFlags.FeatureEvaluationResult result = FeatureFlags.evaluate('NonExistentPermission');
        Test.stopTest();

        // Assert that the feature does not have the custom permission and reason is MISSING_CUSTOM_PERMISSION
        System.assertEquals(false, result.getResult());
        System.assertEquals('NonExistentPermission', result.getFeatureName());
        System.assertEquals(FeatureFlags.FeatureReason.MISSING_CUSTOM_PERMISSION, result.getReason());
    }

    @IsTest
    static void testMockValue() {
        // Use the setMockValue method to provide a custom mock value
        FeatureFlags.setMockValue('MyMockedFeature', true);

        Test.startTest();
        FeatureFlags.FeatureEvaluationResult result = FeatureFlags.evaluate('MyMockedFeature');
        Test.stopTest();

        // Assert that the feature has the mocked value and reason is MOCK_VALUE
        System.assertEquals(true, result.getResult());
        System.assertEquals('MyMockedFeature', result.getFeatureName());
        System.assertEquals(FeatureFlags.FeatureReason.MOCK_VALUE, result.getReason());
    }
}
