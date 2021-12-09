import { LightningElement, wire, track,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import fetchLeadOpportunityFieldsMapping from '@salesforce/apex/customOpportunityCreationController.fetchLeadOpportunityFieldsMapping';
import Opportunity_OBJECT from '@salesforce/schema/Opportunity';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class customOpportunityCreation extends NavigationMixin(LightningElement) {
    @api containerContext;
    @track options = []; 
    @api setTheRecordId;
    @api setTheProcessName;
    @api setTheObjectName2;
    @track recordTypeId = '';
    @track isLoadingFinish = false;
    @wire(fetchLeadOpportunityFieldsMapping,{ProcessName : '$setTheProcessName', recordId: '$setTheRecordId' , objectName2:'$setTheObjectName2'})
    wireLeadOpportunityFieldsMapping({ data, error }) {
        if (data) {
                this.leadrecord = data;
                this.error = undefined;
        }
        else if (error) {
            this.leadrecord = undefined;
            this.error = error;
            if(this.containerContext === 'Visualforce'){
                // display server exception in toast msg
                this.dispatchEvent(new CustomEvent('showToastMsg', 
                {
                    detail : {isServerError : true, msgDetail : 'This Lead could not be converted. Please contact the Help Desk for support.['+error.body.message+']'},
                    bubbles: true
                }));
            }else{
                // display server exception in toast msg 
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    mode: 'sticky',
                    message: 'This Lead could not be converted. Please contact the Help Desk for support.['+error.body.message+']'
                });
                this.dispatchEvent(event);
            }
        }
    }
    @wire(getObjectInfo, { objectApiName: Opportunity_OBJECT })
    wireOpportunity({ data, error }) {
        if (data) {
            let getData = data;
            let tempRecordTypes = [];
            // run a for-in loop and process all account record types
            for (let obj in getData.recordTypeInfos) {
                if (!getData.recordTypeInfos[obj].master && getData.recordTypeInfos[obj].available) { // skip master record type
                    // create picklist values in object formate with label and value
                    let oRecType = {
                        'label': getData.recordTypeInfos[obj].name,
                        'value': getData.recordTypeInfos[obj].recordTypeId
                    };
                    if(getData.recordTypeInfos[obj].defaultRecordTypeMapping){
                        this.recordTypeId = getData.recordTypeInfos[obj].recordTypeId;
                    }
                    tempRecordTypes.push(oRecType);
                }
            }
            // set lstRecordTypes property with record type list    
            this.options = tempRecordTypes;
            this.isLoadingFinish = true;
        }
        else if (error) {
            this.isLoadingFinish = false;
            if(this.containerContext === 'Visualforce'){
                // display server exception in toast msg
                this.dispatchEvent(new CustomEvent('showToastMsg', 
                {
                    detail : {isServerError : true, msgDetail : 'This Lead could not be converted. Please contact the Help Desk for support.['+error.body.message+']'},
                    bubbles: true
                }));
            }else{
                // display server exception in toast msg 
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    mode: 'sticky',
                    message: 'This Lead could not be converted. Please contact the Help Desk for support.['+error.body.message+']'
                });
                this.dispatchEvent(event);
            }   
        }
    }

    handleChange(event){
        this.recordTypeId = event.target.value;
        }
   
    nextHandler(){
        const defaultValues = encodeDefaultFieldValues(this.leadrecord);
        switch (this.containerContext) {
            case 'Lightning':
                this[NavigationMixin.Navigate](
                    {
                        type: 'standard__objectPage',
                        attributes: {
                            objectApiName: this.setTheObjectName2,
                            actionName: 'new',
                            nooverride: '1',
                        },
                        state: {
                            recordTypeId: this.recordTypeId,
                            defaultFieldValues:defaultValues
                        }
                });
                break;
            case 'Visualforce':
                this.dispatchEvent(new CustomEvent('createRecord', 
                {
                    detail : {objectApiName : this.setTheObjectName2, recordTypeId : this.recordTypeId , defaultFieldValues :  this.leadrecord},
                    bubbles: true
                }));
                break;
            default:
                console.error('Something went wrong');
            }
    }

    cancelHandler(){
        this.dispatchEvent(new CustomEvent('cancel'));
    }
}