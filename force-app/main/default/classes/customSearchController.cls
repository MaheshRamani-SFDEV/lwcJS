public with sharing class customSearchController {
    
    @AuraEnabled
    public static List<CustomFieldMappingDetail__mdt> getSearchFieldMapping(String ProcessName, String sObjectName2, Id RecordId, Id searchRecordId){
        String sObjectName1 = RecordId.getSObjectType().getDescribe().getName();
        String sObjectName;
        if(String.isNotBlank(searchRecordId)){
        	sObjectName = searchRecordId.getSObjectType().getDescribe().getName();
        }
        List<String> fieldNames = new List<String>(); 
        List<CustomFieldMappingDetail__mdt> customFieldMap = new List<CustomFieldMappingDetail__mdt>(); 
        List<CustomFieldMappingDetail__mdt> customFieldValueMap = new List<CustomFieldMappingDetail__mdt>(); 
        for(CustomFieldMappingDetail__mdt param :  [SELECT Field_Label__c, Object1_FieldName__c,Object2_FieldName__c,Object2_FieldValue__c,Object1_FieldType__c, Object2_FieldType__c, IsAddressField__c, SearchMatchType__c, RecordType__c, IsInitialSearchField__c, IsSearch_Editable__c, Field_Order__c FROM CustomFieldMappingDetail__mdt 
                                                    WHERE ProcessName__c = :ProcessName AND ObjectName1__c = :sObjectName1 AND ObjectName2__c =: sObjectName2 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST])
        {
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
        String query1 = 'SELECT ' + String.join(fieldNames, ',');
        query1 +=' FROM ' + sObjectName1 + ' WHERE Id =\'' + String.escapeSingleQuotes(RecordId) + '\'';
        List<Lead> leadRecord = (Database.query(query1));
        Account accRecord;
        if(String.isNotBlank(searchRecordId)){
        	String query2 = 'SELECT Name FROM ' + sObjectName + ' WHERE Id =:searchRecordId Limit 1';
        	accRecord = (Database.query(query2));
        	System.debug('Mahesh:>searchRecord Name>>'+accRecord.get('Name'));
        }
        for(CustomFieldMappingDetail__mdt fieldMap : customFieldMap){         
            if(!String.isBlank(fieldMap.Object1_FieldName__c)){
                if(fieldMap.Object1_FieldType__c == 'reference'){
                    String relationshipField = ''; 
                    if(fieldMap.Object1_FieldName__c.indexOf('__c') == -1){
                        if(fieldMap.Object1_FieldName__c == 'Id'){
                            fieldMap.Object2_FieldValue__c = (String)leadRecord[0].get('Name');
                        }else{
                        	relationshipField = fieldMap.Object1_FieldName__c.substring(0,fieldMap.Object1_FieldName__c.indexOf('Id'));
                        	if(leadRecord[0].getSObject(relationshipField) != null){
                            	fieldMap.Object2_FieldValue__c = (String)leadRecord[0].getSObject(relationshipField).get('Name');
                       	 	}
                        }
                    }else{ 
                        relationshipField = fieldMap.Object1_FieldName__c.substring(0,fieldMap.Object1_FieldName__c.indexOf('__c')) + '__r';
                        /*if(relationshipField == 'stintro__Related_Account__r' && String.isNotBlank(searchRecordId)){                       	
                            fieldMap.Object2_FieldValue__c = (String)accRecord.get('Name');
                        }else*/ if(leadRecord[0].getSObject(relationshipField) != null){
                            fieldMap.Object2_FieldValue__c = (String)leadRecord[0].getSObject(relationshipField).get('Name');
                        }
                    }
                }else{
                    fieldMap.Object2_FieldValue__c = (String)leadRecord[0].get(fieldMap.Object1_FieldName__c);
                }
            }else{
            	fieldMap.Object2_FieldValue__c = null;    
            }
            system.debug('Mahesh in search >>>'+fieldMap);
            customFieldValueMap.add(fieldMap);
        }
        return customFieldValueMap;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<searchResultFieldWrapp> getColumnFieldList(String ProcessName, String sObjectName){
        List<searchResultFieldWrapp> searchResultFieldDetails = new List<searchResultFieldWrapp>();
        for(CustomSearchResultDetail__mdt param : [SELECT SearchResult_FieldLabel__c, SearchResult_FieldName__c, SearchResult_FieldOrder__c, SearchResult_FieldType__c, Sortable__c 
                                                    FROM CustomSearchResultDetail__mdt 
                                                    WHERE ProcessName__c = :ProcessName AND ObjectName__c = :sObjectName AND SearchResult_FieldOrder__c != null ORDER BY SearchResult_FieldOrder__c ASC NULLS LAST])
        {
            searchResultFieldWrapp obj = new searchResultFieldWrapp(param.SearchResult_FieldLabel__c, param.SearchResult_FieldName__c, param.SearchResult_FieldType__c, param.Sortable__c); 
            searchResultFieldDetails.add(obj);             
        }

        return searchResultFieldDetails;
    }
    
    @AuraEnabled
    public static list<object> getRecordList(String ProcessName, String sObjectName, String searchKey, Boolean isInitialCall, String searchRecordId) {
        String searchString = '';
        String recordTypeString = '';
        String exactString = '';
        String wildcardString = '';
        String extraWildcardString = '';
        system.debug('searchRecordId >>>>'+searchRecordId);
        List<Map<String, String>> searchKeyValueMaps = (List<Map<String, String>>) JSON.deserialize(searchKey, List<Map<String, String>>.class);  
        System.debug('Mahesh searchKeyValueMaps : '+searchKeyValueMaps);
        System.debug('Mahesh searchKeyValueMaps size : '+searchKeyValueMaps.size());
        for(integer i=0;i<searchKeyValueMaps.size();i++){            
        	String searchFieldName = searchKeyValueMaps[i].get('Object2_FieldName__c');
            String searchFieldValue = searchKeyValueMaps[i].get('Object2_FieldValue__c');
        	String searchFieldType = searchKeyValueMaps[i].get('Object2_FieldType__c');           
            String searchFieldClause = searchKeyValueMaps[i].get('SearchMatchType__c');
            Boolean initialSearchField = Boolean.valueOf(searchKeyValueMaps[i].get('IsInitialSearchField__c'));
            if(String.isBlank(recordTypeString)){
            	recordTypeString = ' RecordType.Name IN ' + searchKeyValueMaps[i].get('RecordType__c');
            }
            System.debug('Mahesh searchKeyValueMaps record : '+searchKeyValueMaps[i]);
            if(String.isNotBlank(searchFieldType) && searchFieldType == 'reference'){                    
                if(searchFieldName.indexOf('__c') == -1){
                    if(searchFieldName =='Id'){
                        searchFieldName = searchFieldName.substring(0,searchFieldName.indexOf('Id')) + 'Name';
                    }else{
                    	searchFieldName = searchFieldName.substring(0,searchFieldName.indexOf('Id')) + '.Name';
                    }
                }else{
                    searchFieldName = searchFieldName.substring(0,searchFieldName.indexOf('__c')) + '__r.Name';    
                }
            }
            System.debug('searchFieldName>after>>>'+searchFieldName); 
            if(isInitialCall){
                System.debug('In intial Call');
                if(String.isNotBlank(searchFieldName) && String.isNotBlank(searchFieldValue) && searchFieldClause == 'Exact' && initialSearchField){
                    if(sObjectName == 'Account' && (searchFieldName == 'BillingCity' || searchFieldName == 'BillingState' || searchFieldName == 'BillingCountry' || searchFieldName == 'BillingPostalCode')){
                    	if(wildcardString == ''){
                        	wildcardString += '(( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';
                            if(searchFieldName == 'BillingCity'){
                                searchFieldName = 'ShippingCity';   
                            }else if(searchFieldName == 'BillingState'){
                                searchFieldName = 'ShippingState';    
                            }else if(searchFieldName == 'BillingCountry'){
                                searchFieldName = 'ShippingCountry';    
                            }else if(searchFieldName == 'BillingPostalCode'){
                                searchFieldName = 'ShippingPostalCode';
                            }
                            extraWildcardString = ' OR (( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';   
                    	}else{
                            wildcardString += '( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';
                            if(searchFieldName == 'BillingCity'){
                                searchFieldName = 'ShippingCity';   
                            }else if(searchFieldName == 'BillingState'){
                                searchFieldName = 'ShippingState';     
                            }else if(searchFieldName == 'BillingCountry'){
                                searchFieldName = 'ShippingCountry';    
                            }else if(searchFieldName == 'BillingPostalCode'){
                                searchFieldName = 'ShippingPostalCode';
                            }
                            extraWildcardString += '( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';       
                        }
                    }else if(sObjectName == 'Contact' && (searchFieldName == 'MailingCity' || searchFieldName == 'MailingState' || searchFieldName == 'MailingCountry' || searchFieldName == 'MailingPostalCode')){
                    	if(wildcardString == ''){
                        	wildcardString += '(( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';  
                    	}else{
                            wildcardString += '( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';     
                        }
                    }else if(searchFieldName != 'Account.Name'){
                    	exactString += searchFieldName + '= \'' + searchFieldValue + '\' OR ';    
                	}
                }else if(String.isNotBlank(searchFieldName) && String.isNotBlank(searchFieldValue) && searchFieldClause == 'WildCard' && initialSearchField){ 
                    if(wildcardString == ''){
                        wildcardString += '(( ' + searchFieldName + ' LIKE \'' + '%' + searchFieldValue + '%' + '\') AND ';
                        if(sObjectName == 'Account' && (searchFieldName == 'Name' || searchFieldName == 'BillingStreet')){
                            if(searchFieldName == 'Name'){
                                searchFieldName = 'Name';  
                            }else if(searchFieldName == 'BillingStreet'){
                                searchFieldName = 'ShippingStreet';
                            }
                            extraWildcardString = ' OR (( ' + searchFieldName + ' LIKE \'' + '%' + searchFieldValue + '%' + '\') AND ';    
                        } 
                    }else{
                        wildcardString += '( ' + searchFieldName + ' LIKE \'' + '%' + searchFieldValue + '%' + '\') AND ';
                        if(sObjectName == 'Account' && (searchFieldName == 'Name' || searchFieldName == 'BillingStreet')){
                            if(searchFieldName == 'Name'){
                                searchFieldName = 'Name';  
                            }else if(searchFieldName == 'BillingStreet'){
                                searchFieldName = 'ShippingStreet';
                            }
                            extraWildcardString += '( ' + searchFieldName + ' LIKE \'' + '%' + searchFieldValue + '%' + '\') AND ';       
                       	}
                    }   
                }
            }else{
                System.debug('In else Call');
                if(String.isNotBlank(searchFieldName) && String.isNotBlank(searchFieldValue) && searchFieldClause == 'Exact'){
                   if(sObjectName == 'Account' && (searchFieldName == 'BillingCity' || searchFieldName == 'BillingState' || searchFieldName == 'BillingCountry' || searchFieldName == 'BillingPostalCode')){
                    	if(wildcardString == ''){
                        	wildcardString += '(( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';
                            if(searchFieldName == 'BillingCity'){
                                searchFieldName = 'ShippingCity';   
                            }else if(searchFieldName == 'BillingState'){
                                searchFieldName = 'ShippingState';    
                            }else if(searchFieldName == 'BillingCountry'){
                                searchFieldName = 'ShippingCountry';    
                            }else if(searchFieldName == 'BillingPostalCode'){
                                searchFieldName = 'ShippingPostalCode';
                            }
                            extraWildcardString = ' OR (( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';   
                    	}else{
                            wildcardString += '( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';
                            if(searchFieldName == 'BillingCity'){
                                searchFieldName = 'ShippingCity';   
                            }else if(searchFieldName == 'BillingState'){
                                searchFieldName = 'ShippingState';     
                            }else if(searchFieldName == 'BillingCountry'){
                                searchFieldName = 'ShippingCountry';    
                            }else if(searchFieldName == 'BillingPostalCode'){
                                searchFieldName = 'ShippingPostalCode';
                            }
                            extraWildcardString += '( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';       
                        }
                    }else if(sObjectName == 'Contact' && (searchFieldName == 'MailingCity' || searchFieldName == 'MailingState' || searchFieldName == 'MailingCountry' || searchFieldName == 'MailingPostalCode')){
                    	if(wildcardString == ''){
                        	wildcardString += '(( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';  
                    	}else{
                            wildcardString += '( ' + searchFieldName + '= \'' + searchFieldValue + '\') AND ';     
                        }
                    }else if(searchFieldName != 'Account.Name'){
                    	exactString += searchFieldName + '= \'' + searchFieldValue + '\' OR ';    
                	}
                }else if(String.isNotBlank(searchFieldName) && String.isNotBlank(searchFieldValue) && searchFieldClause == 'WildCard'){ 
                    if(wildcardString == ''){
                        wildcardString += '(( ' + searchFieldName + ' LIKE \'' + '%' + searchFieldValue + '%' + '\') AND ';
                        if(sObjectName == 'Account' && (searchFieldName == 'Name' || searchFieldName == 'BillingStreet')){
                            if(searchFieldName == 'Name'){
                                searchFieldName = 'Name';  
                            }else if(searchFieldName == 'BillingStreet'){
                                searchFieldName = 'ShippingStreet';
                            }
                            extraWildcardString = ' OR (( ' + searchFieldName + ' LIKE \'' + '%' + searchFieldValue + '%' + '\') AND ';    
                        } 
                    }else{
                        wildcardString += '( ' + searchFieldName + ' LIKE \'' + '%' + searchFieldValue + '%' + '\') AND ';
                        if(sObjectName == 'Account' && (searchFieldName == 'Name' || searchFieldName == 'BillingStreet')){
                            if(searchFieldName == 'Name'){
                                searchFieldName = 'Name';  
                            }else if(searchFieldName == 'BillingStreet'){
                                searchFieldName = 'ShippingStreet';
                            }
                            extraWildcardString += '( ' + searchFieldName + ' LIKE \'' + '%' + searchFieldValue + '%' + '\') AND ';       
                       	}
                    }   
                }
            }
        }
        System.debug('Mahesh Test if>exactString>>>>'+exactString);
        System.debug('Mahesh Test if>wildcardString>>>>'+wildcardString);
        if(String.isNotBlank(exactString) || String.isNotBlank(wildcardString)){
            if(sObjectName == 'Account'){
                searchString = recordTypeString + ' AND (' + exactString + wildcardString;	
            }else if(sObjectName == 'Contact' && String.isNotBlank(searchRecordId)){
                searchString = recordTypeString + ' AND AccountId = ' + '\'' + searchRecordId + '\' AND (' + exactString + wildcardString;
            }
            if(String.isNotBlank(wildcardString)){
            	searchString = searchString.subString(0,searchString.length()-4) + ')';
                if(String.isNotBlank(extraWildcardString)){
                	searchString += extraWildcardString;
                    searchString = searchString.subString(0,searchString.length()-4) + '))';
                }else{
                	searchString += ')';    
                }
            }else{
            	searchString = searchString.subString(0,searchString.length()-3) + ')';    
            }
            System.debug('Mahesh Test final>searchString>>>>'+searchString);
        }else if(sObjectName == 'Contact' && String.isNotBlank(searchRecordId)){
            searchString = recordTypeString + ' AND AccountId = ' + '\'' + String.escapeSingleQuotes(searchRecordId) + '\'';   
        }
        System.debug('Mahesh Test before >searchString>>>>'+searchString);
        if(!String.isBlank(searchString)){
            List<String> fieldNames = new List<String>();   
            for(CustomSearchResultDetail__mdt param :  [SELECT SearchResult_FieldName__c,SearchResult_FieldOrder__c FROM CustomSearchResultDetail__mdt 
                                                        WHERE ProcessName__c = :ProcessName AND ObjectName__c = :sObjectName ORDER BY SearchResult_FieldOrder__c ASC NULLS LAST])
            {	
                fieldNames.add(param.SearchResult_FieldName__c); 
            }
            list<object> lstRecord = new list<object>();
            String query = 'SELECT ' + String.join(fieldNames, ',');
            query +=' FROM ' + sObjectName + ' WHERE ' + searchString;
            System.debug('Query---->'+query);
            lstRecord = Database.query(query);
            if(!lstRecord.isEmpty()){
            	return lstRecord;    
            }else{
            	return null;
            }
        }else{
        	return null;   
        }
	}

    public class searchResultFieldWrapp{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String fieldName{get;set;}
        @AuraEnabled 
        public String type{get;set;}
        @AuraEnabled 
        public Boolean sortable{get;set;}
        
        public searchResultFieldWrapp(){}
        public searchResultFieldWrapp(String fieldLabel, String name, String fieldType, Boolean sortable){
            this.label = fieldLabel;
            this.fieldName = name;
            this.type = fieldType; 
            this.sortable = sortable; 
        }
    }
}