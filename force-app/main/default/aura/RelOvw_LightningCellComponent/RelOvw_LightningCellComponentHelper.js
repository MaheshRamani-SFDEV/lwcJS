({
    doInit : function(component, event, helper) {

        component.set("v.isCustomUrl",false);
        var record = component.get("v.record");
        //we need to call a  function --and send the below logic make this record call generic
        var fieldSetMember = JSON.parse(JSON.stringify(component.get("v.field")));
         
        var field= fieldSetMember.fieldPath;
  
        if(fieldSetMember.type==='boolean'){
           component.set('v.isCheckboxField',true);
        }
        var sObjectName = component.get('v.sObjectName');    
        var linkId='';
        var owner = record.Owner;
        console.log('## JSON Record in cell component-->');
        console.log(JSON.stringify(record));
        console.log('## sObjectName-->'+sObjectName+'# field:-->'+field);

        // Version 1.3 : US-103 : Add Start
        if(sObjectName === 'Contact'){ 
            var account = record.Account; 
            var name = record.Name;
            if(fieldSetMember.type ==='reference'){
                console.log('inside reference');
                component.set('v.isReferenceField',true);
                if(field==='AccountId'){
                    if(account !=null || account != undefined ){
                        linkId=account.Id;
                        console.log('##-->'+record['AccountId']);
                        record['AccountId'] = account.Name ; 
                    }
                }                
                if(linkId){
                    component.set('v.linkId',linkId);
                }
            }
            if(field ==='Name'){
                    component.set('v.isReferenceField',true);
                    if(linkId !=null || linkId !=undefined){
                        linkId=record.Id;   
                    }
                    
                    record['Name'] = record[field] ; 
                    if(linkId){
                        component.set('v.linkId',linkId);
                    }
                } 
         // Version 1.3 : US-103 : Add End
        }else if(sObjectName === 'Opportunity'){ 
            if(field!=null || field != undefined || record !=null || record !=undefined ){
                var account = record.Account; 
                var subProduct = record.Sub_ProductLU__r;
                
                if(fieldSetMember.type ==='reference'){
                    console.log('inside reference');
                    component.set('v.isReferenceField',true);
                    if(field==='AccountId'){
                        if(account !=null || account != undefined ){
                            linkId=account.Id;
                            record['AccountId'] = account.Name ; 
                        }
                    }else if (field==='Sub_ProductLU__c'){
                        if(subProduct!=null || subProduct != undefined){
                            linkId = subProduct.Id;
                            record['Sub_ProductLU__c']=subProduct.Name;
                        }
                    }else if(field==='OwnerId'){
                        if(owner !=null || owner != undefined ){
                            linkId = owner.Id;
                            record['OwnerId'] = owner.Name ;
                        }
                    }                
                    if(linkId){
                        component.set('v.linkId',linkId);
                    }
                }else if (fieldSetMember.type ==='currency'){
                    
                    component.set("v.isCurrencyField", true);
                }
                if(field ==='Name'){
                    component.set('v.isReferenceField',true);
                    if(linkId !=null || linkId !=undefined){
                        linkId=record.Id;   
                    }
                    
                    record['Name'] = record[field] ; 
                    if(linkId){
                        component.set('v.linkId',linkId);
                    }
                } 
                
                record['Account.ParentSubsidiary__c'] = account.ParentSubsidiary__c ;
            }
        }else if(sObjectName === 'Call_Report__c'){ 
            if(field!=null || field != undefined || record !=null || record !=undefined ){
                var client = record.Client__r;           
                if(fieldSetMember.type ==='reference'){
                    //component.set('v.isReferenceField',true);//Commneted for ST001377
                    if(field==='Client__c'&& record['Client__c']){
                        component.set('v.isReferenceField',true);//Added for ST001377
                        if(client !=null || client !=undefined){
                            linkId=client.Id;
                            record['Client__c'] = client.Name ; 
                        }
                    }else if(field==='OwnerId'&& record['OwnerId']){
                        component.set('v.isReferenceField',true);//Added for ST001377
                        if(owner !=null || owner !=undefined){
                            linkId = owner.Id;
                            record['OwnerId'] = owner.Name ;
                        }
                    }else if (field==='Deal__c' && record['Deal__c'] ){
                        component.set('v.isReferenceField',true);//Added for ST001377
                        var deal = record.Deal__r;
                        if(deal !=null || deal !=undefined){
                            linkId = deal.Id;
                            record['Deal__c']=deal.Name;
                        }
                    }

                    if(linkId){
                        component.set('v.linkId',linkId);
                    } 
                } 
                
                if(fieldSetMember.type ==='datetime'){
                    
                    component.set('v.isDateTimeField',true);
                }
                
                if(field ==='Name'){
                    component.set('v.isReferenceField',true);
                    linkId=record.Id;
                    record['Name'] = record[field] ; 
                    if(linkId){
                        component.set('v.linkId',linkId);
                    }
                }
                record['Client__r.ParentSubsidiary__c']= client.ParentSubsidiary__c;
            }
        }else if(sObjectName != 'Relationship_Profile__c'){
            
            var parentAccount = record.Account__r;
            var afterDot = field.substr(field.indexOf('.')+1);  
            record[field]=parentAccount[afterDot]; 
            
        }else if(sObjectName === 'Relationship_Profile__c'){ 
            if(field!=null || field != undefined){
                if(field.includes("Account__r") ){
                    var parentAccount = record.Account__r;
                    var afterDot = field.substr(field.indexOf('.')+1);  
                    
                    record[field]=parentAccount[afterDot]; 
                }
            }
            if (fieldSetMember.type ==='currency'){
                
                component.set("v.isCurrencyField", true);
            }
            if (fieldSetMember.type ==='percent'){
                
                component.set("v.isPercent", true);
                record[field]=record[field]/100;
            }
            
            if(fieldSetMember.type ==='string'){
                var recVar=(record[field]);
                if(recVar!=null || recVar != undefined){
                    if(recVar.includes("href")){
                       // alert(recVar);
                        
                        var linkValue = (recVar.substring(
                            recVar.indexOf(">") + 1, 
                            recVar.lastIndexOf("<")));
                       
                         var linkUrl = ((recVar.substring(
                            recVar.indexOf("=") + 2, 
                            recVar.indexOf("target")-2)).replace(/&amp;/g,"&")); 
                        component.set("v.isCustomUrl",true);
                        component.set("v.customUrlLink", linkValue);
                        component.set("v.customUrlValue", linkUrl);
                        
                        return ;
                    }
                }
            }
            
        } 
        
        if(record[field]){
            component.set("v.cellValue", record[field]);
            
        }
        
        
    },
    
    
})