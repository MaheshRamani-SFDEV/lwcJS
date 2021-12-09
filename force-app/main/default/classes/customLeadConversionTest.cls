@isTest(SeeAllData = false)
private class customLeadConversionTest {
    
    public static String processName = 'CustomLeadConversion';
    
    @isTest
    static void getStepDetailsTest(){
        
       /* User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){*/
            
            List<CustomLeadConversion.wrapp> stepwrapp1 = new List<CustomLeadConversion.wrapp>();
            
            Test.startTest();
            
            stepwrapp1 = CustomLeadConversion.getStepDetails(processName);
            
            Test.stopTest();
            
            List<CustomStepDetail__mdt> stepDetailtoAssert1 = new List<CustomStepDetail__mdt>();
            
            for(CustomStepDetail__mdt param :  [SELECT Step_Label__c,ProcessName__c FROM CustomStepDetail__mdt])
            {
                if(param.ProcessName__c == processName){
                    stepDetailtoAssert1.add(param);
                }
            }
            System.assertEquals(stepDetailtoAssert1.size(),stepwrapp1.size(),FALSE);
        }
   /* }*/
}