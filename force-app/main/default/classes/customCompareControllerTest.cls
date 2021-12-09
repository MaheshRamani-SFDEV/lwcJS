@isTest(SeeAllData = false)
private class customCompareControllerTest {
    
    public static String processName = 'CustomLeadConversion';
    public static String Object1 = 'Account';
    public static String Object2 = 'Contact';
    
    @isTest
    static void getCompareFieldsTest(){
        
       /* User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){*/
            
            list<CustomCompareController.CustomCompareFieldWrapper> compareField1 = new list<CustomCompareController.CustomCompareFieldWrapper>();
            list<CustomCompareController.CustomCompareFieldWrapper> compareField2 = new list<CustomCompareController.CustomCompareFieldWrapper>();
          
            Test.startTest();
            
            compareField1 = CustomCompareController.getCompareFields(processName,Object1);
            compareField2 = CustomCompareController.getCompareFields(processName,Object2);
            
            Test.stopTest();
            
            List<CustomCompareFieldDetail__mdt> compareFieldtoAssert1 = new List<CustomCompareFieldDetail__mdt>();
            List<CustomCompareFieldDetail__mdt> compareFieldtoAssert2 = new List<CustomCompareFieldDetail__mdt>();
            
            for(CustomCompareFieldDetail__mdt param : [SELECT ProcessName__c,Object2__c,Label FROM CustomCompareFieldDetail__mdt]){
                if(param.ProcessName__c == processName && param.Object2__c == Object1){
                    compareFieldtoAssert1.add(param);
                }
                if(param.ProcessName__c == processName && param.Object2__c == Object2){
                    compareFieldtoAssert2.add(param);
                }
              }
            System.assertEquals(compareFieldtoAssert1.size(),compareField1.size(),FALSE);
            System.assertEquals(compareFieldtoAssert2.size(),compareField2.size(),FALSE);
         }
   /* }*/
}