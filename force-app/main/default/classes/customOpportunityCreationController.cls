public with sharing class customOpportunityCreationController {
    @AuraEnabled(cacheable=true)
    public static Map<String, String> fetchLeadOpportunityFieldsMapping(String ProcessName, Id recordId, String objectName2){
        Lead convertedLead = [Select Id,OwnerId, Owner.Name,ConvertedAccountId, ConvertedContactId,ConvertedAccount.Name, ConvertedContact.Name from lead where isConverted = true AND Id = :recordId];
        String sObjectName1 = recordId.getSObjectType().getDescribe().getName();
        List<String> fieldNamesForObject1 = new List<String>();
        List<String> fieldNamesForObject2 = new List<String>();
        Map<String, String> oppLeadFieldMap = new Map<String, String>();
        Map<String, String> fieldsWithValuesForObj2 = new Map<String, String>();
        for(CustomFieldMappingDetail__mdt param :  [SELECT Object1_FieldName__c,Object2_FieldName__c,Object1_FieldType__c,Object2_FieldType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c = :ProcessName AND ObjectName1__c = :sObjectName1 AND ObjectName2__c =:objectName2 order by Field_Order__c asc])
        {
            if(!fieldNamesForObject1.contains(param.Object1_FieldName__c)){
                fieldNamesForObject1.add(param.Object1_FieldName__c);
                if(param.Object1_FieldType__c == 'reference'){
                    String relationshipField = '';
                    if(param.Object1_FieldName__c.indexOf('__c') == -1){
                        if(param.Object1_FieldName__c =='Id'){
                            relationshipField = param.Object1_FieldName__c.substring(0,param.Object1_FieldName__c.indexOf('Id')) + 'Name';            	
                        }
                        else{
                            relationshipField = param.Object1_FieldName__c.substring(0,param.Object1_FieldName__c.indexOf('Id')) + '.Name';
                        }   
                        fieldNamesForObject1.add(relationshipField);   
                    }else{
                        relationshipField = param.Object1_FieldName__c.substring(0,param.Object1_FieldName__c.indexOf('__c')) + '__r.Name';
                        fieldNamesForObject1.add(relationshipField);
                    }
                }
            }
            if(!fieldNamesForObject2.contains(param.Object2_FieldName__c)){
                fieldNamesForObject2.add(param.Object2_FieldName__c);
                if(param.Object2_FieldType__c == 'reference'){
                    String relationshipField = '';
                    if(param.Object2_FieldName__c.indexOf('__c') == -1){
                        relationshipField = param.Object2_FieldName__c.substring(0,param.Object2_FieldName__c.indexOf('Id')) + '.Name';
                        fieldNamesForObject2.add(relationshipField);
                    }else{
                        relationshipField = param.Object2_FieldName__c.substring(0,param.Object2_FieldName__c.indexOf('__c')) + '__r.Name';
                        fieldNamesForObject2.add(relationshipField);
                    }
                }
            }
            if(!oppLeadFieldMap.containsKey(param.Object1_FieldName__c)){
                oppLeadFieldMap.put(param.Object1_FieldName__c,param.Object2_FieldName__c);
                if(param.Object1_FieldType__c == 'reference' || param.Object2_FieldType__c == 'reference'){
                    String relationshipField1 = '';
                    String relationshipField2 = '';
                    if(param.Object1_FieldName__c.indexOf('__c') == -1){
                        if(param.Object1_FieldName__c =='Id'){
                            relationshipField1 = param.Object1_FieldName__c.substring(0,param.Object1_FieldName__c.indexOf('Id')) + 'Name';
                        }
                        else{
                        	relationshipField1 = param.Object1_FieldName__c.substring(0,param.Object1_FieldName__c.indexOf('Id')) + '.Name';
                        }
                    }else{
                        relationshipField1 = param.Object1_FieldName__c.substring(0,param.Object1_FieldName__c.indexOf('__c')) + '__r.Name';
                    }
                    if(param.Object2_FieldName__c.indexOf('__c') == -1){
                        relationshipField2 = param.Object2_FieldName__c.substring(0,param.Object2_FieldName__c.indexOf('Id')) + '.Name';
                    }else{
                        relationshipField2 = param.Object2_FieldName__c.substring(0,param.Object2_FieldName__c.indexOf('__c')) + '__r.Name';
                    }
                    oppLeadFieldMap.put(relationshipField1,relationshipField2);
                }
            }
        }
        system.debug('fieldNamesForObject1==>'+fieldNamesForObject1);
        system.debug('fieldNamesForObject2==>'+fieldNamesForObject2);     
        
        String query = 'SELECT ' + String.join(fieldNamesForObject1, ',');
        query +=' FROM ' + sObjectName1+' WHERE Id =:recordId';
        lead leadRecord = Database.query(query);
        System.debug('Query===>'+query);
        system.debug('leadRecord==>'+leadRecord);
        String OwnerName;
        Boolean isOwnerQueue = false;
        Integer ownerNameIndex;
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(sObjectName1);                                   
        DescribeSObjectResult descr = objType.getDescribe();
        for(String fieldName :oppLeadFieldMap.keySet()){
            if(fieldName == 'OwnerId'){
            	fieldsWithValuesForObj2.put(oppLeadFieldMap.get(fieldName),convertedLead.OwnerId);
            }else if(fieldName == 'Owner.Name'){ 
                fieldsWithValuesForObj2.put(oppLeadFieldMap.get(fieldName),convertedLead.Owner.Name);
            }else{ 
                String fieldTypes;
                if(fieldName.indexOf('.Name') == -1){  
                	Schema.DisplayType fieldType = descr.fields.getMap().get(fieldName).getDescribe().getType();
            		fieldTypes = String.ValueOf(fieldType);	
                }else{   
                    fieldTypes = 'REFERENCE';    
                }
                if(fieldTypes == 'REFERENCE'){
                    if(fieldName.indexOf('.Name') == -1){
                        if(leadRecord.get(fieldName) != null){
                            fieldsWithValuesForObj2.put(oppLeadFieldMap.get(fieldName),(String)leadRecord.get(fieldName));
                        }
                    }else{
                        String relationshipField = fieldName.substring(0,fieldName.indexOf('.Name')) ;
                        if(leadRecord.getSObject(relationshipField) != null){
                            fieldsWithValuesForObj2.put(oppLeadFieldMap.get(fieldName),(String)leadRecord.getSObject(relationshipField).get('Name'));
                        }
                    }
                }else{
                    if(leadRecord.get(fieldName) != null){
                		fieldsWithValuesForObj2.put(oppLeadFieldMap.get(fieldName),(String)leadRecord.get(fieldName));
                    }
                }
            }
        }        
        system.debug('fieldsWithValuesForObj2==>'+fieldsWithValuesForObj2);
        return fieldsWithValuesForObj2;
    }
}