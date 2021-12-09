@isTest(SeeAllData = false)
private class customCreateNewRecordControllerTest {
    
    public static String processName = 'CustomLeadConversion';
    public static String Object1 = 'Account';
    public static String Object2 = 'Contact';
    public static String Object3 = 'Lead';
    
    @isTest
    static void getCreateFieldMappingTest(){
        
        /*User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){*/
            
            String mapKey1 = processName + Object3 + Object1;
            String mapKey2 = processName + Object3 + Object2;
            Map<String,List<CustomCreateFieldDetail__mdt>> AssertMap = new Map<String,List<CustomCreateFieldDetail__mdt>>();
            
            Account acc = new Account();
            acc.name = 'Test';
            insert acc;
            
            Lead ld = new Lead();
            ld.FirstName = 'Test';
            ld.Company = 'TestCompany';
            ld.LastName = 'Test';
            ld.OwnerId = userinfo.getUserId();
            insert ld;
            
            Test.startTest();
            
            List<CustomCreateFieldDetail__mdt> fieldMapping1 = customCreateNewRecordController.getCreateFieldMapping(processName,Object1,ld.id,acc.Name);
            AssertMap.put(mapKey1,fieldMapping1);
            List<CustomCreateFieldDetail__mdt> fieldMapping2 = customCreateNewRecordController.getCreateFieldMapping(processName,Object2,ld.id,acc.Id);
            AssertMap.put(mapKey2,fieldMapping2);
            
            Test.stopTest();
            
            for(String key : AssertMap.keyset()){
                for(CustomCreateFieldDetail__mdt param : AssertMap.get(key)){
                    if(param.Object1_FieldName__c == 'OwnerId'){
                        System.assertEquals('Test CIB',param.Object2_FieldValue__c,False);
                    }
                    if(param.Object1_FieldName__c == 'FirstName'){
                        System.assertEquals('Test',param.Object2_FieldValue__c,False);
                    }
                }
            }
       /* }*/
    }
}