public with sharing class customLeadContainerController {
	@AuraEnabled
    public static Lead fetchLeadRecord(String ProcessName, Id recordId){
		String sObjectName = recordId.getSObjectType().getDescribe().getName();
		List<String> fieldNames = new List<String>();   
        for(CustomFieldMappingDetail__mdt param :  [SELECT Object1_FieldName__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c = :ProcessName AND ObjectName1__c = :sObjectName])
        {
            if(!fieldNames.contains(param.Object1_FieldName__c)){	
            	fieldNames.add(param.Object1_FieldName__c);
            }
            System.debug('param>>>'+param.Object1_FieldName__c);
        }       
		String query = 'SELECT ' + String.join(fieldNames, ',');
        query +=' FROM ' + sObjectName+' WHERE Id =:recordId Limit 1';
        Lead leadRecord = Database.query(query);
        System.debug('Query>>>'+query);
        return leadRecord;
    }
        
    @AuraEnabled
    public static Object fetchLeadRelatedRecord(String ProcessName, Id recordId){
		String sObjectName = recordId.getSObjectType().getDescribe().getName();
        //Get the related record field list
		List<String> fieldNames = new List<String>();   
        for(CustomFieldMappingDetail__mdt param :  [SELECT Object2_FieldName__c,Field_Order__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c = :ProcessName AND ObjectName2__c = :sObjectName ANd IsCompareMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST])
        {
            if(!fieldNames.contains(param.Object2_FieldName__c)){
            	fieldNames.add(param.Object2_FieldName__c);
            }
        }        
        //Get the leadRelated record        
		String query = 'SELECT ' + String.join(fieldNames, ',');
        query +=' FROM ' + sObjectName+' WHERE Id =\'' + String.escapeSingleQuotes(recordId) + '\' Limit 1';
        Object relatedRecord = Database.query(query);
    	System.debug('Mahesh---relatedRecord>>>>>'+relatedRecord);
        return relatedRecord;
    }
    
    @AuraEnabled
    public static leadConvertWrap convertLeadRecord(String ProcessName, Id recordId, String Records){		
        String sObjectName1 = recordId.getSObjectType().getDescribe().getName();        
        String sObjectName2 = 'Account';
        String sObjectName3 = 'Contact';
        String sObjectName;
        Id accountId;
        Id contactId;
        Id OwnerId;
        sObject accountObject;
        sObject contactObject;
        Boolean isLeadConverted = true;
        leadConvertWrap response = new leadConvertWrap();
        Map<String, String> accountRecord = new Map<String, String>();
        Map<String, String> contactRecord = new Map<String, String>();
        List<String> leadFields = new List<String>();
        List<String> accountFields = new List<String>();
        List<String> contactFields = new List<String>();
        Map<String,String> accLeadFieldMap = new Map<String,String>();
        Map<String,String> conLeadFieldMap = new Map<String,String>();
        List<sObject> upsertObjectList = new List<sobject>();
        List<Map<String, String>> leadConvertRecords = (List<Map<String, String>>)JSON.deserialize(Records, List<Map<String, String>>.class);                          
        
        for(integer i=0;i<leadConvertRecords.size();i++){
        	sObjectName = (String)leadConvertRecords[i].get('objectName');
            if(sObjectName == sObjectName2){
            	accountRecord = leadConvertRecords[i];   
            }else if(sObjectName == sObjectName3){
                contactRecord =  leadConvertRecords[i];
            }
        }

        for(CustomCreateFieldDetail__mdt param :  [SELECT Object1_FieldName__c,Object2_FieldName__c,Object2_FieldValue__c,IsScreenDisplay__c FROM CustomCreateFieldDetail__mdt 
                                                    WHERE ProcessName__c = :ProcessName AND ObjectName1__c = :sObjectName1 AND ObjectName2__c = :sObjectName2 AND IsScreenDisplay__c = false])
        {
            if(!leadFields.contains(param.Object1_FieldName__c)){	
                leadFields.add(param.Object1_FieldName__c);
            }
            if(!accountFields.contains(param.Object2_FieldName__c)){	
                accountFields.add(param.Object2_FieldName__c);
                accLeadFieldMap.put(param.Object1_FieldName__c,param.Object2_FieldName__c);
            }            
        }
        
        for(CustomCreateFieldDetail__mdt param :  [SELECT Object1_FieldName__c,Object2_FieldName__c,Object2_FieldValue__c,IsScreenDisplay__c FROM CustomCreateFieldDetail__mdt 
                                                    WHERE ProcessName__c = :ProcessName AND ObjectName1__c = :sObjectName1 AND ObjectName2__c =:sObjectName3 AND IsScreenDisplay__c = false])
        {
            if(!leadFields.contains(param.Object1_FieldName__c)){	
                leadFields.add(param.Object1_FieldName__c);
            }
            if(!contactFields.contains(param.Object2_FieldName__c)){	
                contactFields.add(param.Object2_FieldName__c);
                conLeadFieldMap.put(param.Object1_FieldName__c,param.Object2_FieldName__c);
            }
        } 
        
        String query = 'SELECT OwnerId, ' + String.join(leadFields, ',');
        query +=' FROM ' + sObjectName1+' WHERE Id =\'' + String.escapeSingleQuotes(recordId) + '\'';
        lead leadRecord = Database.query(query);
        if(String.valueOf(leadRecord.get('OwnerId')).startsWith('00G')){                                  	
            OwnerId = UserInfo.getUserId(); 
        }else{
            OwnerId = (ID)leadRecord.get('OwnerId');
        }

        Schema.SObjectType objType1 = Schema.getGlobalDescribe().get(sObjectName2);              
        accountObject = objType1.newSObject(); 
        for(String fieldName :accLeadFieldMap.keySet()){                         
            DescribeSObjectResult descr = objType1.getDescribe();
            Schema.DisplayType fieldType = descr.fields.getMap().get(accLeadFieldMap.get(fieldName)).getDescribe().getType();
            String fieldTypes = String.ValueOf(fieldType);              
            if(fieldTypes == 'CURRENCY'){
                accountObject.put(accLeadFieldMap.get(fieldName),Decimal.valueOf((String)leadRecord.get(fieldName))); 
            }
            else if(fieldTypes == 'BOOLEAN'){
                accountObject.put(accLeadFieldMap.get(fieldName),Boolean.valueOf(leadRecord.get(fieldName)));                    	
            }
            else if(fieldTypes == 'DOUBLE'){
                accountObject.put(accLeadFieldMap.get(fieldName),Double.valueOf(leadRecord.get(fieldName)));                    	
            }
            else if(fieldTypes == 'LONG'){
               accountObject.put(accLeadFieldMap.get(fieldName),Long.valueOf((String)leadRecord.get(fieldName)));                   	
            }
            else if(fieldTypes == 'INTEGER'){
                accountObject.put(accLeadFieldMap.get(fieldName),Integer.valueOf(leadRecord.get(fieldName)));                    	
            }
            else if(fieldTypes == 'DATE'){
                accountObject.put(accLeadFieldMap.get(fieldName),Date.valueOf(leadRecord.get(fieldName)));                  	
            }
            else if(fieldTypes == 'DATETIME'){
                accountObject.put(accLeadFieldMap.get(fieldName),Datetime.valueOf(leadRecord.get(fieldName)));                  	
            }
            else{
               accountObject.put(accLeadFieldMap.get(fieldName),(String)leadRecord.get(fieldName));   
            }
        }
            
        for(String fieldName : accountRecord.keySet()){                
            if(fieldName != 'objectName'){
                DescribeSObjectResult descr = objType1.getDescribe();
                Schema.DisplayType fieldType = descr.fields.getMap().get(fieldName).getDescribe().getType();
                String fieldTypes = String.ValueOf(fieldType);
                if(fieldName == 'OwnerId'){
                    accountObject.put(fieldName,OwnerId);
                }else{
                    if(fieldTypes == 'CURRENCY'){
                        accountObject.put(fieldName,Decimal.valueOf((String)accountRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'BOOLEAN'){
                        accountObject.put(fieldName,Boolean.valueOf(accountRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'DOUBLE'){
                        accountObject.put(fieldName,Double.valueOf(accountRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'LONG'){
                        accountObject.put(fieldName,Long.valueOf((String)accountRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'INTEGER'){
                        accountObject.put(fieldName,Integer.valueOf(accountRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'DATE'){
                        accountObject.put(fieldName,Date.valueOf(accountRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'DATETIME'){
                        accountObject.put(fieldName,Datetime.valueOf(accountRecord.get(fieldName)));                    	
                    }
                    else{
                        accountObject.put(fieldName,(String)accountRecord.get(fieldName));    
                    }
                }
            }
       	}  
        //Contact object  
        Schema.SObjectType objType2 = Schema.getGlobalDescribe().get(sObjectName3);              
        contactObject = objType2.newSObject(); 
        for(String fieldName :conLeadFieldMap.keySet()){                         
            DescribeSObjectResult descr = objType2.getDescribe();
            Schema.DisplayType fieldType = descr.fields.getMap().get(conLeadFieldMap.get(fieldName)).getDescribe().getType();
            String fieldTypes = String.ValueOf(fieldType);              
            if(fieldTypes == 'CURRENCY'){
                contactObject.put(conLeadFieldMap.get(fieldName),Decimal.valueOf((String)leadRecord.get(fieldName))); 
            }
            else if(fieldTypes == 'BOOLEAN'){
                contactObject.put(conLeadFieldMap.get(fieldName),Boolean.valueOf(leadRecord.get(fieldName)));                    	
            }
            else if(fieldTypes == 'DOUBLE'){
                contactObject.put(conLeadFieldMap.get(fieldName),Double.valueOf(leadRecord.get(fieldName)));                    	
            }
            else if(fieldTypes == 'LONG'){
               contactObject.put(conLeadFieldMap.get(fieldName),Long.valueOf((String)leadRecord.get(fieldName)));                   	
            }
            else if(fieldTypes == 'INTEGER'){
                contactObject.put(conLeadFieldMap.get(fieldName),Integer.valueOf(leadRecord.get(fieldName)));                    	
            }
            else if(fieldTypes == 'DATE'){
                contactObject.put(conLeadFieldMap.get(fieldName),Date.valueOf(leadRecord.get(fieldName)));                  	
            }
            else if(fieldTypes == 'DATETIME'){
                contactObject.put(conLeadFieldMap.get(fieldName),Datetime.valueOf(leadRecord.get(fieldName)));                  	
            }
            else{
               contactObject.put(conLeadFieldMap.get(fieldName),(String)leadRecord.get(fieldName));   
            }
        }           
        for(String fieldName : contactRecord.keySet()){                
            if(fieldName != 'objectName'){
                DescribeSObjectResult descr = objType2.getDescribe();
                Schema.DisplayType fieldType = descr.fields.getMap().get(fieldName).getDescribe().getType();
                String fieldTypes = String.ValueOf(fieldType);
                if(fieldName == 'OwnerId'){
                    contactObject.put(fieldName,OwnerId);
                }else{
                    if(fieldTypes == 'CURRENCY'){
                        contactObject.put(fieldName,Decimal.valueOf((String)contactRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'BOOLEAN'){
                        contactObject.put(fieldName,Boolean.valueOf(contactRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'DOUBLE'){
                        contactObject.put(fieldName,Double.valueOf((String)contactRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'LONG'){
                        contactObject.put(fieldName,Long.valueOf((String)contactRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'INTEGER'){
                        contactObject.put(fieldName,Integer.valueOf(contactRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'DATE'){
                        contactObject.put(fieldName,Date.valueOf(contactRecord.get(fieldName)));                    	
                    }
                    else if(fieldTypes == 'DATETIME'){
                        contactObject.put(fieldName,Datetime.valueOf(contactRecord.get(fieldName)));                    	
                    }
                    else{
                        contactObject.put(fieldName,(String)contactRecord.get(fieldName));    
                    }
                }
            }
        }
        System.savePoint sp = Database.setSavePoint();      
        if(accountRecord.get('Id') == null){
            system.debug('In first insert');
            try{
                Database.SaveResult accSaveResult = Database.Insert((Account)accountObject);   
                accountId = accSaveResult.getId();
                system.debug('In first insert accountId'+accountId);
                try{
                    system.debug('In second insert');
                    contactObject.put('AccountId', accountId);
                    Database.SaveResult conSaveResult = Database.Insert((Contact)contactObject);   
                    contactId = conSaveResult.getId();
                                 system.debug('In first insert contactId'+contactId);
                    Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(recordId);
                    lc.setAccountId(accountId);
                    lc.setContactId(contactId);
                    lc.setDoNotCreateOpportunity(True);
                    
                    //LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                    //lc.setConvertedStatus(convertStatus.MasterLabel);
                    lc.setConvertedStatus('Closed - Converted');
                    lc.setOwnerId(OwnerId);
                    try{
                        system.debug('In 3rd insert');
                        Database.LeadConvertResult leadConvertResult = Database.convertLead(lc);
                        Contact cont = [SELECT Name FROM contact WHERE Id = :contactId];
                        response = new leadConvertWrap(true, accountId, contactId, accountRecord.get('Name'), cont.Name,null);
                    }catch(Exception ex){
                        system.debug('In 3rd insert exception');
                        database.rollback(sp);
                        //UtilityHolder.errorMethod('Lead', 'customLeadContainerController', 'convertLeadRecord', 'Exception', ex);
                        response = new leadConvertWrap(false,null,null,null,null,ex.getMessage());
                        return response;
                    }
                }catch(Exception ex){
                    system.debug('In 2nd insert exception');
                    database.rollback(sp);
                    UtilityHolder.errorMethod('Contact', 'customLeadContainerController', 'convertLeadRecord', 'Exception', ex);
                    response = new leadConvertWrap(false,null,null,null,null,ex.getMessage());
                    return response;
                }
            }catch(Exception ex){
                system.debug('In 1st insert exception');
                database.rollback(sp);
                UtilityHolder.errorMethod('Account', 'customLeadContainerController', 'convertLeadRecord', 'Exception', ex);
                response = new leadConvertWrap(false,null,null,null,null,ex.getMessage());
                return response;
            }
        }else{
            system.debug('In else 1st upsert');
            upsertObjectList.add(accountObject);
            contactObject.put('AccountId', accountRecord.get('Id'));
            upsertObjectList.add(contactObject);          
            try{                
                Database.UpsertResult[] saveResult = Database.Upsert(upsertObjectList);   
                for(Database.UpsertResult sr :saveResult){
                    if (((String)sr.getId()).startsWith('001')) {
                        accountId = sr.getId();
                        system.debug('In else 1st upsert accountId>>'+accountId);
                    }else if(((String)sr.getId()).startsWith('003')) {
                        contactId = sr.getId();
                        system.debug('In else 2nd upsert contactId>>'+contactId);
                    }
                }
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(recordId);
                lc.setAccountId(accountId);
                lc.setContactId(contactId);
                lc.setDoNotCreateOpportunity(True);
                
                //LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                //lc.setConvertedStatus(convertStatus.MasterLabel);
                lc.setConvertedStatus('Closed - Converted');
                lc.setOwnerId(OwnerId);
                try{
                    system.debug('In else 3rd upsert');
                    Database.LeadConvertResult leadConvertResult = Database.convertLead(lc);
                    Contact cont = [SELECT Name FROM contact WHERE Id = :contactId];
                    response = new leadConvertWrap(true, accountId, contactId, accountRecord.get('Name'), cont.Name,null);
                }catch(Exception ex){
                    system.debug('In else 3rd upsert');
                    database.rollback(sp);
                    UtilityHolder.errorMethod('Lead', 'customLeadContainerController', 'convertLeadRecord', 'Exception', ex);
            		response = new leadConvertWrap(false,null,null,null,null,ex.getMessage());
                    return response;
        		}
            }catch(Exception ex){
                system.debug('In else 1st upsert');
                database.rollback(sp);
                if(ex.getMessage().contains('First exception on row 0')){
                	UtilityHolder.errorMethod('Account', 'customLeadContainerController', 'convertLeadRecord', 'Exception', ex);
                }else if(ex.getMessage().contains('First exception on row 1')){
                	UtilityHolder.errorMethod('Contact', 'customLeadContainerController', 'convertLeadRecord', 'Exception', ex);                    
                }
                response = new leadConvertWrap(false,null,null,null,null,ex.getMessage());
                return response;
            }
        }                      
        return response;
    }
    public class leadConvertWrap{
        @AuraEnabled
        public Boolean isLeadConverted{get;set;}
        @AuraEnabled
        public String accountId{get;set;}
        @AuraEnabled 
        public String contactId{get;set;}
        @AuraEnabled
        public String accountName{get;set;}
        @AuraEnabled 
        public String contactName{get;set;}
        @AuraEnabled 
        public String error{get;set;}
        
        public leadConvertWrap(){
            
        }
        public leadConvertWrap(Boolean isLeadConverted, String accountId, String contactId, String accountName, String contactName, String error){
            this.isLeadConverted = isLeadConverted;
            this.accountId = accountId;
			this.contactId = contactId;
            this.accountName = accountName;
            this.contactName = contactName;
            this.error = error;
        }
    }
}