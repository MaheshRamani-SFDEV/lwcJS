import { LightningElement, api, wire, track } from 'lwc';
import getStepDetails from '@salesforce/apex/CustomProgressIndicator.getStepDetails';
export default class CustomProgresIndicator extends LightningElement {
    @api setTheProcessName;
    @api setCurrentStep;
    @track steps;
    @wire(getStepDetails, {ProcessName : '$setTheProcessName'}) steps
}