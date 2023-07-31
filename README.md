# Salesforce Feature Flags

Simple framework for using feature flags in apex driven by Custom Permissions and Custom Metadata Types. 

### `FeatureFlags` class

The main entry point is the `FeatureFlags` class, which is meant to be used as follows

```java
//a lot of code here, then

FeatureFlags flags = new FeatureFlags();

if(flags.evaluate('enhancedQuoteEditor').isEnabled()){
    //do something interesting
}
```

[See source code](https://github.com/pgonzaleznetwork/salesforce-feature-flags/blob/main/force-app/main/default/classes/FeatureFlags.cls)

### Custom Permissions and Metadata Types

In the above example

```java
if(flags.evaluate('enhancedQuoteEditor').isEnabled()){
    //do something interesting
}
```

The code works by evaluating (in this order) if:

- The running user has a Custom Permission with a matching name of `enhancedQuoteEditor`
- A custom metadata type record of the `FeatureFlag__mdt` type matches the name `enhancedQuoteEditor` and has `Is_Active__c` set to `true`

This allows you to configure user-based feature flags (as custom permissions) and global feature flags (as custom metadata types).

If neither a custom permission or custom metadata type record is found, the flag defaults to `false` (see more info on the next section).

### Info with `FeatureEvaluationResult`

The call to `flags.evaluate('flagName')` returns an instance of `FeatureEvaluationResult`, which can be used to determine whether the flag is active and **why**. For example

```java
FeatureFlags.FeatureEvaluationResult result = flags.evaluate('enhancedQuoteEditor');
System.debug(result);

//these are the possible permutations

[featureName=enhancedQuoteEditor, reason=HAS_CUSTOM_PERMISSION, result=true]

[featureName=enhancedQuoteEditor, reason=MISSING_CUSTOM_PERMISSION, result=false]

[featureName=enhancedQuoteEditor, reason=METADATA_TYPE_ENABLED, result=true]

[featureName=enhancedQuoteEditor, reason=METADATA_TYPE_DISABLED, result=false]

//if there are no matching custom permissions or metadata types
[featureName=enhancedQuoteEditor, reason=FLAG_NOT_FOUND, result=false]
```

This information can be useful for logging and troubleshooting. 

### Testing

#### Simple brut force approach

If you simply one to set the value of a flag to `true` or `false` at test time, without relaying on existing custom permissions or metadata types, simply use the static `FeatureFlags.setMockValue('mockedFeatureValue', true);` method, as follows

```java
@IsTest 
static void testMockValues(){

    FeatureFlags.setMockValue('mockedFeatureValue', true);


    Test.startTest();

    insert new Account(Name='Name');

    Test.stopTest();
```

In the above example, inserting the account fires the `AccountTriggerHandler`. Somewhere in that code the `FeatureFlags` class will be instantiated, and it will *remember* that `mockedFeatureValue` was set to `true`. The code will not try to find this flag in custom permissions or metadata types. 

#### With Dependency Injection

Another approach is when you have a class that takes an instance of `FeatureFlags` as a constructor parameter, for example

```java
FeatureFlags flags = new FeatureFlags();
AccountService service = new AccountService(flags)
```

In this scenario, you can pass an implementation of `IFeatureFlagsProvider`, which will allow you to mock the status of the feature flags.

This works because the default constructor of `FeatureFlags` using an instance of `FeatureFlagsProvider`, which returns the custom permissions and metadata types from the database

```java
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
```

In a test class, you can create a Mock that implements `IFeatureFlagProvider`, and pass this as a constructor for the `FeatureFlags` class. For example:

```java
public with sharing class FeatureFlagProviderMock implements IFeatureFlagProvider {
    
    public Set<String> getCustomPermissionNames(){
        Set<String> customPermissionNames = new Set<String>();
        customPermissionNames.add('permission1');
        customPermissionNames.add('permission2');
        return customPermissionNames;
    }

    public Map<String,FeatureFlag__mdt> getFeatureFlags(){
        Map<String,FeatureFlag__mdt> flags = new Map<String,FeatureFlag__mdt>();

        FeatureFlag__mdt flag1 = new FeatureFlag__mdt(DeveloperName = 'flag1', Is_Active__c = true);
        FeatureFlag__mdt flag2 = new FeatureFlag__mdt(DeveloperName = 'flag2', Is_Active__c = false);

        flags.put('flag1',flag1);
        flags.put('flag2',flag2);
        return flags;
        
    }

}
```

then in your test code

```java
FeatureFlagProviderMock mockFlags = new FeatureFlagProviderMock();
FeatureFlags flags = new FeatureFlags(mockFlags);

Test.startTest();
FeatureFlags.FeatureEvaluationResult result = flags.evaluate('flag1');
Test.stopTest();
```
You can see a complete implementation of this pattern [here](https://github.com/pgonzaleznetwork/salesforce-feature-flags/blob/main/force-app/main/default/classes/FeatureFlagsTests.cls)
