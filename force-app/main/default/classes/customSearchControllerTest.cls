@isTest(SeeAllData = false)
private class customSearchControllerTest {
    
    public static String processName1 = 'CustomLeadConversion';
    public static String Object1 = 'Account';
    public static String Object2 = 'Contact';
    public static String Object3 = 'Opportunity';
    public static String Object4 = 'Lead';
}
   /* @testSetup
    static void testData(){
             NAICS_Description__c naicsdesc = new NAICS_Description__c();
            naicsdesc.Name = 'TestNAICS321';
            insert naicsdesc;*
            
            Account acc = new Account();
            acc.Name = 'TestAccount';
            acc.CIN__c = '123456789';
            acc.BillingCity='Arizona City';
            acc.BillingStreet = 'abc';
            acc.BillingPostalCode = '123451';
            acc.Tax_ID__c = '987654321';
  			insert acc;
            
            Lead ld = new Lead();
            ld.stintro__Client_CIN__c = '123456789';
            ld.stintro__Client_Tax_ID__c = '987654321';
        	ld.State = 'Arizona';
            ld.City ='Arizona City';
            ld.Country = 'United States';
            ld.Street = 'abc';
            ld.PostalCode = '123451';
            ld.stintro__CRS__c = '123456';
            ld.FirstName = 'Test';
            ld.Company = 'TestAccount';
            ld.LastName = 'Test';
            ld.OwnerId = userInfo.getuserId();
            ld.stintro__Related_Account__c = acc.id;
            ld.Email = 'abc@gmail.com';
            insert ld;
            
    }
    @isTest
    static void getSearchFieldMappingTest(){
        
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
            
            Integer i = 0;
            
            Account acc = new Account();
            acc.Name = 'Test';
            insert acc;
            
            Contact con = new Contact();
            con.FirstName = 'Test1';
            con.LastName = 'Contact1';
            con.AccountId = acc.Id;
            con.CIN__c = '12345';
            insert con;
            
            Lead ld = new Lead();
            ld.stintro__Client_CIN__c = '12345';
            ld.FirstName = 'Test';
            ld.Company = 'TestCompany';
            ld.LastName = 'Test';
            ld.OwnerId = u.Id;
            //ld.OwnerId = userInfo.getUserId();
            ld.stintro__Related_Account__c = acc.id;
            insert ld;
            
            String mapKey1 = processName1 + Object4 + Object1;
            String mapKey2 = processName1 + Object4 + Object2;
            String mapKey3 = processName1 + Object4 + Object3;
            Map<String,List<CustomFieldMappingDetail__mdt>> AssertMap = new Map<String,List<CustomFieldMappingDetail__mdt>>();
            
            String fieldMappingDetailAssert1;
            String fieldMappingDetailAssert2;
            String fieldMappingDetailAssert3;
            String fieldMappingDetailAssert4;
            String fieldMappingDetailAssert5;
            
            Test.startTest();
            
            List<CustomFieldMappingDetail__mdt> fieldMappingDetail1 = customSearchController.getSearchFieldMapping(processName1, Object1, ld.Id,acc.Id);
            List<CustomFieldMappingDetail__mdt> fieldMappingDetail2 = customSearchController.getSearchFieldMapping(processName1, Object2, ld.Id,acc.Id);
            List<CustomFieldMappingDetail__mdt> fieldMappingDetail3 = customSearchController.getSearchFieldMapping(processName1, Object2, ld.Id,acc.Id);
            
            AssertMap.put(mapKey1,fieldMappingDetail1);
          
            Test.stopTest();
            
            for(String key : AssertMap.Keyset()){
                for(CustomFieldMappingDetail__mdt param : AssertMap.get(key)){
                    if(param.Object1_FieldName__c == 'stintro__Client_CIN__c' && param.Object1_FieldType__c != Null){
                        fieldMappingDetailAssert1 = param.Object2_FieldValue__c;
                        System.assertEquals('12345',fieldMappingDetailAssert1,False);
                    }
                    if(param.Object1_FieldName__c == 'FirstName' && param.Object1_FieldType__c != Null){
                        fieldMappingDetailAssert2 = param.Object2_FieldValue__c;
                        System.assertEquals('Test',fieldMappingDetailAssert2,False);
                    }
                    if(param.Object1_FieldName__c == 'Company' && param.Object1_FieldType__c != Null){
                        fieldMappingDetailAssert3 = param.Object2_FieldValue__c;
                        System.assertEquals('TestCompany',fieldMappingDetailAssert3,False);
                    }
                    if(param.Object1_FieldName__c == 'stintro__Related_Account__c' && param.Object1_FieldType__c != Null){
                        fieldMappingDetailAssert4 = param.Object2_FieldValue__c;
                        System.assertEquals('Test',fieldMappingDetailAssert4,False);
                    }
                    if(param.Object1_FieldName__c == 'OwnerId' && param.Object1_FieldType__c != Null){
                        fieldMappingDetailAssert5 = param.Object2_FieldValue__c;
                        System.assertEquals('Test CIB',fieldMappingDetailAssert5,False);
                    }
                }
            }
        }
    }
    
    @isTest
    static void getColumnFieldListTest(){
        
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
            
            customSearchController.searchResultFieldWrapp searchResultFieldWrapp = new customSearchController.searchResultFieldWrapp();
            List<customSearchController.searchResultFieldWrapp> searchResultFieldWrapp1 = new List<customSearchController.searchResultFieldWrapp>();
            List<customSearchController.searchResultFieldWrapp> searchResultFieldWrapp2 = new List<customSearchController.searchResultFieldWrapp>();
            
            Test.startTest();
            
            searchResultFieldWrapp1 = customSearchController.getColumnFieldList(processName1,Object1);
            searchResultFieldWrapp2 = customSearchController.getColumnFieldList(processName1,Object2);
            
            Test.stopTest();
            
            List<CustomSearchResultDetail__mdt> searchfieldDetailstoAssert1 = new List<CustomSearchResultDetail__mdt>();
            List<CustomSearchResultDetail__mdt> searchfieldDetailstoAssert2 = new List<CustomSearchResultDetail__mdt>();
            
            for(CustomSearchResultDetail__mdt param :[SELECT ProcessName__c,ObjectName__c,SearchResult_FieldName__c FROM CustomSearchResultDetail__mdt WHERE SearchResult_FieldOrder__c!=NULL]){
                if(param.ProcessName__c == processName1 && param.ObjectName__c == Object1){
                    searchfieldDetailstoAssert1.add(param);
                }
                if(param.ProcessName__c == processName1 && param.ObjectName__c == Object2){
                    searchfieldDetailstoAssert2.add(param);
                }
            }
            System.AssertEquals(searchfieldDetailstoAssert1.size(),searchResultFieldWrapp1.size(),False);
            System.AssertEquals(searchfieldDetailstoAssert2.size(),searchResultFieldWrapp2.size(),False);
        }
    }
    
    @isTest
    static void getInitRecordListTest1(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
            NAICS_Description__c nsDesc = [SELECT Name FROM NAICS_Description__c WHERE Name = 'TestNAICS321' Limit 1];
 			List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);            
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            Map<String,String> tempSearchMapAcc = new Map<String,String>();
            Map<String,String> tempSearchMapCon = new Map<String,String>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
					if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingCity'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
                    else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'Name'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','WildCard');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Company);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }                    
                    else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'CIN__c'){
                        searchMapAcc.put('IsInitialSearchField__c','True');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].stintro__Client_CIN__c);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
                    else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'CIN__c'){
                        searchMapCon.put('IsInitialSearchField__c','True');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].stintro__Client_CIN__c);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
                	else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'Tax_ID__c'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].stintro__Client_Tax_ID__c);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }                   
                	else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingPostalCode'){
						searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].PostalCode);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
                	else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingStreet'){
						searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','WildCard');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Street);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
                	
                    else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingStreet'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','WildCard');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].Street);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingCity'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }                	
                    else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'OwnerId'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].OwnerId);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'Email'){
                        searchMapCon.put('IsInitialSearchField__c','true');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].Email);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
            }
            if(Object1 == 'Account'){
                tempSearchMapAcc.put('IsInitialSearchField__c','false');
                tempSearchMapAcc.put('SearchMatchType__c','Exact');
                tempSearchMapAcc.put('Object2_FieldType__c','reference');
                tempSearchMapAcc.put('Object2_FieldValue__c',nsDesc.id);
                tempSearchMapAcc.put('Object2_FieldName__c','NAICS_Description__c');
                searchKeyAcclist.add(tempSearchMapAcc);
            }
            if(Object2 == 'Contact'){
                tempSearchMapCon.put('IsInitialSearchField__c','false');
                tempSearchMapCon.put('SearchMatchType__c','Exact');
                tempSearchMapCon.put('Object2_FieldType__c','reference');
                tempSearchMapCon.put('Object2_FieldValue__c',leadlist[0].OwnerId);
                tempSearchMapCon.put('Object2_FieldName__c','OwnerId');
                searchKeyConlist.add(tempSearchMapCon);
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            System.debug('searchKeyAcc>>>>'+searchKeyAcc);
             System.debug('searchKeyCon>>>>'+searchKeyCon);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,true,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,true,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
    static void getInitRecordListTest2(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
                   if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'Name'){
                        searchMapAcc.put('IsInitialSearchField__c','true');
                        searchMapAcc.put('SearchMatchType__c','WildCard');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Company);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    } 
                	else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingStreet'){
                        searchMapAcc.put('IsInitialSearchField__c','true');
                        searchMapAcc.put('SearchMatchType__c','WildCard');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Street);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                         searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    } 
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingStreet'){
                        searchMapCon.put('IsInitialSearchField__c','true');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    } 
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,true,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,true,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
    static void getInitRecordListTest3(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
					if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingCity'){
                        searchMapAcc.put('IsInitialSearchField__c','true');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    } 
                	else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingState'){
                        searchMapAcc.put('IsInitialSearchField__c','true');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].State);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    } 
                if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingCountry'){
                        searchMapAcc.put('IsInitialSearchField__c','true');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Country);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    } 
                if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingPostalCode'){
                        searchMapAcc.put('IsInitialSearchField__c','true');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].PostalCode);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    } 
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingCity'){
                        searchMapCon.put('IsInitialSearchField__c','true');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingState'){
                        searchMapCon.put('IsInitialSearchField__c','true');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].State);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingCountry'){
                        searchMapCon.put('IsInitialSearchField__c','true');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].Country);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingPostalCode'){
                        searchMapCon.put('IsInitialSearchField__c','true');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].PostalCode);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,true,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,true,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
    static void getInitRecordListTest4(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
                   if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingStreet'){
                        searchMapAcc.put('IsInitialSearchField__c','true');
                        searchMapAcc.put('SearchMatchType__c','WildCard');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Street);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }               	
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingStreet'){
                        searchMapCon.put('IsInitialSearchField__c','true');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].Street);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    } 
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,true,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,true,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
    static void getInitRecordListTest5(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
                    if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'CIN__c'){
                        searchMapAcc.put('IsInitialSearchField__c','True');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].stintro__Client_CIN__c);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
					else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingCity'){
                        searchMapAcc.put('IsInitialSearchField__c','true');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }  
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingCity'){
                        searchMapCon.put('IsInitialSearchField__c','true');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    } 
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,true,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,true,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
    static void getInitRecordListTest6(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
					if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingState'){
                        searchMapAcc.put('IsInitialSearchField__c','true');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].State);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }                	
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingState'){
                        searchMapCon.put('IsInitialSearchField__c','true');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].State);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }                 	
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,true,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,true,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
    static void getInitRecordListTest7(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
           /* for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
					if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingCountry'){
                        searchMapAcc.put('IsInitialSearchField__c','true');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Country);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }                   
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingCountry'){
                        searchMapCon.put('IsInitialSearchField__c','true');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].Country);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    } 
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,true,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,true,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
    static void getInitRecordListTest8(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
					if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingPostalCode'){
                        searchMapAcc.put('IsInitialSearchField__c','true');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].PostalCode);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }                   
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingPostalCode'){
                        searchMapCon.put('IsInitialSearchField__c','true');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].PostalCode);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    } 
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,true,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,true,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    
    @isTest
    static void getOnSearchRecordListTest1(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
            NAICS_Description__c nsDesc = [SELECT Name FROM NAICS_Description__c WHERE Name = 'TestNAICS321' Limit 1];
 			List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            Map<String,String> tempSearchMapAcc = new Map<String,String>();
            Map<String,String> tempSearchMapCon = new Map<String,String>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
					if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingCity'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
                    else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'Name'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','WildCard');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Company);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }                    
                    else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'CIN__c'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].stintro__Client_CIN__c);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
                    else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'CIN__c'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].stintro__Client_CIN__c);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
                	else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'Tax_ID__c'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].stintro__Client_Tax_ID__c);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }                   
                	else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingPostalCode'){
						searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].PostalCode);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
                	else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingStreet'){
						searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','WildCard');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Street);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
                	
                    else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingStreet'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','WildCard');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].Street);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingCity'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }                	                   
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'Email'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].Email);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
            }
            if(Object2 == 'Contact'){
                tempSearchMapCon.put('IsInitialSearchField__c','false');
                tempSearchMapCon.put('SearchMatchType__c','Exact');
                tempSearchMapCon.put('Object2_FieldType__c','reference');
                tempSearchMapCon.put('Object2_FieldValue__c',leadlist[0].OwnerId);
                tempSearchMapCon.put('Object2_FieldName__c','OwnerId');
                searchKeyConlist.add(tempSearchMapCon);
            }
            if(Object1 == 'Account'){
                tempSearchMapAcc.put('IsInitialSearchField__c','false');
                tempSearchMapAcc.put('SearchMatchType__c','Exact');
                tempSearchMapAcc.put('Object2_FieldType__c','reference');
                tempSearchMapAcc.put('Object2_FieldValue__c',nsDesc.id);
                tempSearchMapAcc.put('Object2_FieldName__c','NAICS_Description__c');
                searchKeyAcclist.add(tempSearchMapAcc);
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            System.debug('searchKeyAcc>>>>'+searchKeyAcc);
             System.debug('searchKeyCon>>>>'+searchKeyCon);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,false,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,false,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
  /*  static void getOnSearchRecordListTest2(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
                   if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'Name'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','WildCard');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Company);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
                	else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingStreet'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','WildCard');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Street);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingStreet'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    } 
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,false,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,false,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
    static void getOnSearchRecordListTest3(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
					if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingCity'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    } 
                	else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingState'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].State);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    } 
                if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingCountry'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Country);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    } 
                if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingPostalCode'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].PostalCode);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    } 
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingCity'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingState'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].State);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingCountry'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].Country);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingPostalCode'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].PostalCode);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,false,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,false,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
   /* static void getOnSearchRecordListTest4(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
                   if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingStreet'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','WildCard');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Street);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }               	
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingStreet'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].Street);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    } 
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,false,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,false,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
    /*static void getOnSearchRecordListTest5(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
                	if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'CIN__c'){
                        searchMapAcc.put('IsInitialSearchField__c','True');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].stintro__Client_CIN__c);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }
					else if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingCity'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }  
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingCity'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].City);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    } 
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,false,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,false,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }*/
/*}*/
    /*@isTest
    static void getOnSearchRecordListTest6(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
					if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingState'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].State);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }                	
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingState'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].State);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    }                 	
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,false,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,false,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
    static void getOnSearchRecordListTest7(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
					if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingCountry'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].Country);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }                   
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingCountry'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].Country);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    } 
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,false,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,false,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
    @isTest
    static void getOnSearchRecordListTest8(){
        testData();
        User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){
                        
            List<Lead> leadlist = new List<Lead>([Select id,Email,stintro__Client_CIN__c,stintro__Client_Tax_ID__c,stintro__CRS__c,Owner.Name,Street,City,Country,State,PostalCode,FirstName,Company,stintro__Related_Account__r.Name FROM Lead WHERE Company = 'TestAccount' limit 1]);
            
            List<Map<String,String>> searchKeyAcclist = new List<Map<String,String>>();
            List<Map<String,String>> searchKeyConlist = new List<Map<String,String>>();
            
            for(CustomFieldMappingDetail__mdt param : [SELECT Object1_FieldName__c, Object2_FieldType__c,Object2_FieldValue__c,ObjectName2__c,Object2_FieldName__c,Field_Order__c,RecordType__c FROM CustomFieldMappingDetail__mdt WHERE ProcessName__c =: processName1 AND ObjectName1__c =: Object4 AND IsSearchMapping__c = true ORDER BY Field_Order__c ASC NULLS LAST]){
                Map<String,String> searchMapAcc = new Map<String,String>();
                Map<String,String> searchMapCon = new Map<String,String>();
					if(param.ObjectName2__c == Object1 && param.Object2_FieldName__c == 'BillingPostalCode'){
                        searchMapAcc.put('IsInitialSearchField__c','false');
                        searchMapAcc.put('SearchMatchType__c','Exact');
                        searchMapAcc.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapAcc.put('Object2_FieldValue__c',leadlist[0].PostalCode);
                        searchMapAcc.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapAcc.put('RecordType__c',param.RecordType__c);
                        searchKeyAcclist.add(searchMapAcc);
                    }                   
                	else if(param.ObjectName2__c == Object2 && param.Object2_FieldName__c == 'MailingPostalCode'){
                        searchMapCon.put('IsInitialSearchField__c','false');
                        searchMapCon.put('SearchMatchType__c','Exact');
                        searchMapCon.put('Object2_FieldType__c',param.Object2_FieldType__c);
                        searchMapCon.put('Object2_FieldValue__c',leadlist[0].PostalCode);
                        searchMapCon.put('Object2_FieldName__c',param.Object2_FieldName__c);
                        searchMapCon.put('RecordType__c',param.RecordType__c);
                        searchKeyConlist.add(searchMapCon);
                    } 
            }
            
            String searchKeyAcc = json.Serialize(searchKeyAcclist);
            String searchKeyCon = json.Serialize(searchKeyConlist);
            Test.startTest();
            
            List<Object> accnt = customSearchController.getRecordList(processName1,Object1,searchKeyAcc,false,'');
            List<Object> cntct = customSearchController.getRecordList(processName1,Object2,searchKeyCon,false,leadlist[0].stintro__Related_Account__c);
            
            Test.stopTest();
        }
    }
}*/