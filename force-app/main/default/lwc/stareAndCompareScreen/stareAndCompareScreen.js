import { LightningElement, api,track} from 'lwc';
// import server side apex class method 
import getCompareFields from '@salesforce/apex/CustomCompareController.getCompareFields';
// import standard toast event 
import {ShowToastEvent} from 'lightning/platformShowToastEvent'

export default class customStareAndCompare extends LightningElement {
    @api setTheCompareRecord1;
    @api setTheCompareRecord2;
    @api setTheProcessName;
    @api setTheObjectName1;
    @api setTheObjectName2;
    @api containerContext;
    updatedData = {};   
    @track compareFields=[];    
    @track error;
    isRequiredFieldEmpty = false;
    @track requiredFieldsMessage='';
    @track isLoadingFinish = false;

    connectedCallback() { 
        this.getCompareField(this.setTheObjectName2, this.setTheCompareRecord2);
    }

    @api
    getCompareField(objectName2, compareRecord2Id){
        this.setTheObjectName2 = objectName2;
        this.setTheCompareRecord2 = compareRecord2Id;
        this.compareFields = [];
        this.isLoadingFinish = false;
        getCompareFields({processName : this.setTheProcessName, objectName : this.setTheObjectName2})
        .then(result => {
            this.compareFields = result;
            this.error = undefined;
            this.isLoadingFinish = true;
        })
        .catch(error => {
            this.isLoadingFinish = false;
            if(this.containerContext === 'Visualforce'){
                // display server exception in toast msg  
                this.dispatchEvent(new CustomEvent('showToastMsg', 
                {
                    detail : {isServerError : true, msgDetail : 'This Lead could not be converted. Please contact the Help Desk for support. ['+error.body.message+']'},
                    bubbles: true
                }));
            }else{
                // display server exception in toast msg 
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    mode: 'sticky',
                    message: 'This Lead could not be converted. Please contact the Help Desk for support. ['+error.body.message+']'
                });
                this.dispatchEvent(event);
            }
            this.error = error;
            this.compareFields = undefined;
        });
    } 
   
    // call apex method on button click
    handleReturn() {      
        this.dispatchEvent(new CustomEvent('previous'));       
    }

    // call apex method on button click 
    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }   

    // fire custom event : Next on 'Save and Next' button click 
    handleSave(){
        this.isRequiredFieldEmpty = false;
        this.requiredFieldsMessage = false;
        this.updatedData = {};
        var inputElement = this.template.querySelectorAll("lightning-input-field");
        for(let key in this.compareFields){ 
            if (this.compareFields.hasOwnProperty(key)) { // Filtering the data in the loop
                inputElement.forEach(function(element){
                    if(this.compareFields[key].isField1Selected && element.name === this.compareFields[key].compareRecord.Id+'#'+this.compareFields[key].compareRecord.Object1_Field_API__c+'#1'){                       
                        if(element.value === null || element.value === undefined || element.value === ''){
                            if(!this.isRequiredFieldEmpty){
                                this.isRequiredFieldEmpty = true;
                                this.requiredFieldsMessage = 'These required fields must be completed: '+this.compareFields[key].compareRecord.Label;
                            }else{
                                this.requiredFieldsMessage +=' ,'+this.compareFields[key].compareRecord.Label;
                            }
                            this.compareFields[key].className = 'error';
                        }
                        this.updatedData[this.compareFields[key].compareRecord.Object2_Field_API__c] = element.value;
                    }else if(this.compareFields[key].isField2Selected && element.name === this.compareFields[key].compareRecord.Id+'#'+this.compareFields[key].compareRecord.Object2_Field_API__c+'#2'){                        
                        this.updatedData[this.compareFields[key].compareRecord.Object2_Field_API__c] = element.value;
                    }
                    
                },this);
            }
        }
        if(!this.isRequiredFieldEmpty){
            this.updatedData.Id = this.setTheCompareRecord2; 
            this.updatedData.objectName = this.setTheObjectName2;
             this.dispatchEvent(new CustomEvent('next', { detail: { data : this.updatedData, isCreateScreen : false, isCompareScreen : true}}));
        }
    }
    
    selectAllRecord1Data(){               
        let tempCompareFields = JSON.parse(JSON.stringify(this.compareFields));      
        for(let key in tempCompareFields){   
            if (tempCompareFields.hasOwnProperty(key)) { // Filtering the data in the loop  
                if(!tempCompareFields[key].compareRecord.Is_Reference_Field__c){
                tempCompareFields[key].isField1Selected = true;
                tempCompareFields[key].isField2Selected = false; 
                } 
            }
        }
        this.compareFields = tempCompareFields;
    }

    selectAllRecord2Data(){ 
        let tempCompareFields = JSON.parse(JSON.stringify(this.compareFields));        
        for(let key in tempCompareFields){ 
            if (tempCompareFields.hasOwnProperty(key)) { // Filtering the data in the loop     
                tempCompareFields[key].isField1Selected = false;
                tempCompareFields[key].isField2Selected = true;  
            }                     
        }
        this.compareFields = tempCompareFields;
    }

    handleValue1Select(event){
        let compareFields = JSON.parse(JSON.stringify(this.compareFields));
        let tempCompareFields = compareFields;
        for(let key in tempCompareFields){ 
            if (tempCompareFields.hasOwnProperty(key)) { // Filtering the data in the loop     
                if(event.target.checked && tempCompareFields[key].compareRecord.Id === event.target.value){                   
                    tempCompareFields[key].isField1Selected = true; 
                    tempCompareFields[key].isField2Selected = false;
                    break;
                }
            }
        }
        this.compareFields = tempCompareFields;
    }

    handleValue2Select(event){
        let compareFields = JSON.parse(JSON.stringify(this.compareFields));
        let tempCompareFields = compareFields;
        for(let key in tempCompareFields){
            if (tempCompareFields.hasOwnProperty(key)) { // Filtering the data in the loop 
                if(event.target.checked && tempCompareFields[key].compareRecord.Id === event.target.value){                   
                    tempCompareFields[key].isField1Selected = false; 
                    tempCompareFields[key].isField2Selected = true;                   
                    break;
                } 
            }
        }
        this.compareFields = tempCompareFields;
    }
}