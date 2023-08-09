import { LightningElement } from 'lwc';
import lwcEvaluate from '@salesforce/apex/FeatureFlags.lwcEvaluate';

export default class FlagsInLWC extends LightningElement {


    async connectedCallback() {
        
        let featureNewUIComponents = await lwcEvaluate({ featureName: 'featureNewUIComponents' });
        
        if(featureNewUIComponents){
            console.log('featureNewUIComponents is enabled. Show the new UI components');
        }
        else{ 
            console.log('featureNewUIComponents is disabled. Show the old UI components');
        }
    }
}