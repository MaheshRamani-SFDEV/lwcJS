public with sharing class customCreateNewRecordController {
    @AuraEnabled
    public static List<CustomCreateFieldDetail__mdt> getCreateFieldMapping(String ProcessName, String sObjectName2, Id RecordId, String accountName){
        String sObjectName1 = RecordId.getSObjectType().getDescribe().getName();
		System.debug('In create>ProcessName>>'+ProcessName);	
        System.debug('In create>sObjectName2>>'+sObjectName2);	
        System.debug('In create>RecordId>>'+RecordId);	
        System.debug('In create>accountName>>'+accountName);
        String newAccountName;
        if(string.valueOf(accountName).startsWith('001')){
        	Account accountRecord = [SELECT Name From Account WHERE Id = :accountName];
            newAccountName = accountRecord.Name;
        }else{
            newAccountName = accountName;
        }
        List<String> fieldNames = new List<String>(); 
        List<CustomCreateFieldDetail__mdt> customFieldMap = new List<CustomCreateFieldDetail__mdt>(); 
        List<CustomCreateFieldDetail__mdt> customFieldValueMap = new List<CustomCreateFieldDetail__mdt>(); 
        for(CustomCreateFieldDetail__mdt param :  [SELECT Field_Label__c, Object1_FieldName__c,Object2_FieldName__c,Object2_FieldValue__c,Object1_FieldType__c, Object2_FieldType__c, Editable__c, ReadOnly__c, Required__c, IsScreenDisplay__c, IsAddressField__c, IsBillingAddress__c, IsMailingAddress__c, IsShippingAddress__c, IsRecordEditField__c, RecordType__c, Field_Order__c FROM CustomCreateFieldDetail__mdt 
                                                    WHERE ProcessName__c = :ProcessName AND ObjectName1__c = :sObjectName1 AND ObjectName2__c =: sObjectName2 AND IsScreenDisplay__c = true ORDER BY Field_Order__c ASC NULLS LAST])
        {
            System.debug('Param>>>>>'+param);
            if(!String.isBlank(param.Object1_FieldName__c)){
            	if(!fieldNames.contains(param.Object1_FieldName__c)){
                    fieldNames.add(param.Object1_FieldName__c);
                    if(param.Object1_FieldType__c == 'reference'){                        
                        String relationshipField = '';
                        if(param.Object1_FieldName__c.indexOf('__c') == -1){
                            if(param.Object1_FieldName__c =='Id'){
                            	relationshipField = param.Object1_FieldName__c.substring(0,param.Object1_FieldName__c.indexOf('Id')) + 'Name';                           	
                        	}else{
                            	relationshipField = param.Object1_FieldName__c.substring(0,param.Object1_FieldName__c.indexOf('Id')) + '.Name';
                            }
                            fieldNames.add(relationshipField);
                        }else{
                            relationshipField = param.Object1_FieldName__c.substring(0,param.Object1_FieldName__c.indexOf('__c')) + '__r.Name';
                            fieldNames.add(relationshipField);
                        }
                    }
                }
            }
            customFieldMap.add(param);
        }        
        System.debug('Mahesh >>>>>>fieldNames>>>>>>>'+fieldNames);      			
        String query = 'SELECT ' + String.join(fieldNames, ',');
        query +=' FROM ' + sObjectName1 + ' WHERE Id =\'' + String.escapeSingleQuotes(RecordId) + '\'';
        System.debug('Mahesh >>>>>>query>>>>>>>'+query);
        List<Lead> leadRecord = (Database.query(query));
        System.debug('Mahesh >>>>>>leadRecord>>>>>>>'+leadRecord);
        for(CustomCreateFieldDetail__mdt fieldMap : customFieldMap){         
            if(!String.isBlank(fieldMap.Object1_FieldName__c)){
                if(fieldMap.Object1_FieldType__c == 'reference'){
                    String relationshipField = ''; 
                    if(fieldMap.Object1_FieldName__c.indexOf('__c') == -1){
                        if(fieldMap.Object1_FieldName__c =='Id'){
                            fieldMap.Object2_FieldValue__c = (String)leadRecord[0].get(fieldMap.Object1_FieldName__c);
                        }else{
                            relationshipField = fieldMap.Object1_FieldName__c.substring(0,fieldMap.Object1_FieldName__c.indexOf('Id'));
                            if(leadRecord[0].getSObject(relationshipField) != null){
                                if(string.valueOf(leadRecord[0].get(fieldMap.Object1_FieldName__c)).startsWith('00G')){      
                                    fieldMap.Object2_FieldValue__c = UserInfo.getUserId();
                                }else{
                                    fieldMap.Object2_FieldValue__c = (String)leadRecord[0].getSObject(relationshipField).get('Name');     
                                }
                        	}
                        }
                    }else{
                        relationshipField = fieldMap.Object1_FieldName__c.substring(0,fieldMap.Object1_FieldName__c.indexOf('__c')) + '__r';                        	
                     	/*if(relationshipField == 'stintro__Related_Account__r'){                       	
                            fieldMap.Object2_FieldValue__c = newAccountName;    
                        }else */if(leadRecord[0].getSObject(relationshipField) != null){
                            fieldMap.Object2_FieldValue__c = (String)leadRecord[0].getSObject(relationshipField).get('Name');
                        }
                    }
                }else if(fieldMap.Object1_FieldType__c == 'address'){
                    //fieldMap.Object2_FieldValue__c = leadRecord[0].get(fieldMap.Object1_FieldName__c);    
                }else{
                    fieldMap.Object2_FieldValue__c = (String)leadRecord[0].get(fieldMap.Object1_FieldName__c);
                }
            }else{
            	fieldMap.Object2_FieldValue__c = null;    
            }
            System.debug('Mahesh >>>>>>fieldMap>>>>>>>'+fieldMap);
            customFieldValueMap.add(fieldMap);
        }
        return customFieldValueMap;
    }
   /* @AuraEnabled
    public static List<CustomFieldMappingDetail__mdt> getCreateFieldMapping(String ProcessName, String sObjectName2, Id RecordId){
        String sObjectName1 = RecordId.getSObjectType().getDescribe().getName();

        List<String> fieldNames = new List<String>(); 
        List<CustomFieldMappingDetail__mdt> customFieldMap = new List<CustomFieldMappingDetail__mdt>(); 
        List<CustomFieldMappingDetail__mdt> customFieldValueMap = new List<CustomFieldMappingDetail__mdt>(); 
for(CustomFieldMappingDetail__mdt param :  [SELECT Field_Label__c, Object1_FieldName__c,Object2_FieldName__c,Object2_FieldValue__c,Object1_FieldType__c, Object2_FieldType__c, Object2_Field_IsEditable__c, Object2_Field_IsReadOnly__c, Object2_Field_IsRequired__c, IsAddressField__c, RecordType__c, Field_Order__c FROM CustomFieldMappingDetail__mdt 
                                                    WHERE ProcessName__c = :ProcessName AND ObjectName1__c = :sObjectName1 AND ObjectName2__c =: sObjectName2 AND ISCreateMapping__c == true ORDER BY Field_Order__c ASC NULLS LAST])
        {
            if(!fieldNames.contains(param.Object1_FieldName__c)){
               	fieldNames.add(param.Object1_FieldName__c);
                if(param.Object1_FieldType__c == 'reference'){
                    String relationshipField = '';
               		if(param.Object1_FieldName__c.indexOf('__c') == -1){
               			relationshipField = param.Object1_FieldName__c.substring(0,param.Object1_FieldName__c.indexOf('Id')) + '.Name';
               			fieldNames.add(relationshipField);
               		}else{
                        relationshipField = param.Object1_FieldName__c.substring(0,param.Object1_FieldName__c.indexOf('__c')) + '__r.Name';
               			fieldNames.add(relationshipField);
               		}
                }
               	customFieldMap.add(param);
            }
        }        
        System.debug('Mahesh >>>>>>fieldNames>>>>>>>'+fieldNames);      			
        String query = 'SELECT ' + String.join(fieldNames, ',');
        query +=' FROM ' + sObjectName1 + ' WHERE Id =:RecordId';
        System.debug('Mahesh >>>>>>query>>>>>>>'+query);
        List<Lead> leadRecord = (Database.query(query));
       
        for(CustomFieldMappingDetail__mdt fieldMap : customFieldMap){         
            if(fieldMap.Object1_FieldType__c == 'reference'){
                String relationshipField = ''; 
                if(fieldMap.Object1_FieldName__c.indexOf('__c') == -1){
                    relationshipField = fieldMap.Object1_FieldName__c.substring(0,fieldMap.Object1_FieldName__c.indexOf('Id'));
                    if(leadRecord[0].getSObject(relationshipField) != null){
                    	fieldMap.Object2_FieldValue__c = (String)leadRecord[0].getSObject(relationshipField).get('Name');
                    }
                }else{ 
                    relationshipField = fieldMap.Object1_FieldName__c.substring(0,fieldMap.Object1_FieldName__c.indexOf('__c')) + '__r';
                    if(leadRecord[0].getSObject(relationshipField) != null){
                    	fieldMap.Object2_FieldValue__c = (String)leadRecord[0].getSObject(relationshipField).get('Name');
                	}
                }
            }else{
                fieldMap.Object2_FieldValue__c = (String)leadRecord[0].get(fieldMap.Object1_FieldName__c);
            }
            System.debug('Mahesh >>>>>>fieldMap>>>>>>>'+fieldMap);
            customFieldValueMap.add(fieldMap);
        }
        return customFieldValueMap;
    }*/
    /*@AuraEnabled
    public static list<CustomCreateFieldDetail__mdt> getCreateNewField(String ProcessName, String sObjectName){
    	List<CustomCreateFieldDetail__mdt> createFieldDetails = new List<CustomCreateFieldDetail__mdt>();
        for(CustomCreateFieldDetail__mdt param :  [SELECT CreateField_Label__c, CreateField_Name__c, CreateField_Value__c, CreateField_Type__c, Editable__c, ReadOnly__c, Required__c,IsAddressField__c,CreateField_Order__c FROM CustomCreateFieldDetail__mdt WHERE ProcessName__c = :ProcessName AND ObjectName__c = :sObjectName ORDER BY CreateField_Order__c ASC NULLS LAST])
        {
            createFieldDetails.add(param);
        }
        return createFieldDetails;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getRecordTypeId(String sObjectName){
        Id recordTypeId;
        if(sObjectName == 'Account'){
    		 recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client_Prospect').getRecordTypeId();
        }else if(sObjectName == 'Contact'){
         	 recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('External_Contact').getRecordTypeId();   
        }
        System.debug('@@@@Mahesh> recordTypeId>>>>>>>>>'+recordTypeId);
        return recordTypeId;
    }
	@AuraEnabled(cacheable=true)
    public static list<createFieldWrapp> getCreateFieldList(String ProcessName, String sObjectName){
        System.debug('@@@@Mahesh> In getSearchFieldList>>>>>>>>>');
        System.debug('@@@@Mahesh> ProcessName>>>>>>>>>'+ProcessName);
        System.debug('@@@@Mahesh> sObjectName>>>>>>>>>'+sObjectName);
    	List<createFieldWrapp> createFieldDetails = new List<createFieldWrapp>();
        for(CustomCreateFieldDetail__mdt param :  [SELECT CreateField_Label__c, CreateField_Name__c, CreateField_Type__c, Editable__c, ReadOnly__c, Required__c,IsAddressField__c,CreateField_Order__c FROM CustomCreateFieldDetail__mdt WHERE ProcessName__c = :ProcessName AND ObjectName__c = :sObjectName ORDER BY CreateField_Order__c ASC NULLS LAST])
        {
            createFieldWrapp obj = new createFieldWrapp(param.CreateField_Label__c,param.CreateField_Name__c, param.CreateField_Type__c,param.ReadOnly__c,param.Editable__c, param.Required__c,param.IsAddressField__c);
            createFieldDetails.add(obj);
        }
        System.debug('@@@@Mahesh> createFieldDetails>>>>>>>>>'+createFieldDetails);
        return createFieldDetails;
    }   
    public class createFieldWrapp{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String fieldName{get;set;}
        @AuraEnabled 
        public String type{get;set;}
        @AuraEnabled 
        public Boolean readonly{get;set;}
        @AuraEnabled 
        public Boolean editable{get;set;}
        @AuraEnabled 
        public Boolean required{get;set;}
         @AuraEnabled 
        public Boolean isAddressField{get;set;}
        
        public createFieldWrapp(String fieldLabel, String name, String fieldType, Boolean ReadOnly , Boolean Editable, Boolean Required, Boolean IsAddressField){
            this.label = fieldLabel;
            this.fieldName = name;
			this.type = fieldType; 
            this.readonly = readonly; 
            this.editable = editable; 
            this.required = Required;
            this.isAddressField = IsAddressField;
        }
    }*/
}