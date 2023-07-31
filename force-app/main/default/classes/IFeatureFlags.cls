public interface IFeatureFlags {
    FeatureFlags.FeatureEvaluationResult evaluate(String featureName);
}
