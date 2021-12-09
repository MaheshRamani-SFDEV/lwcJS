@isTest(SeeAllData = false)
private class customProgressIndicatorTest {
    
    public static String processName = 'CustomLeadConversion';
    
    @isTest
    static void getStepDetailsTest(){
        
        /*User u = TestClass_Utility.getAdminUser('zx1');
        insert u;
        
        System.runAs(u){*/
            
            Test.startTest();
            
            List<CustomStepDetail__mdt> StepDetail1 = customProgressIndicator.getStepDetails(processName);
            
            Test.stopTest();
            
            List<CustomStepDetail__mdt> stepDetailtoAssert1 = new List<CustomStepDetail__mdt>();
            
            for(CustomStepDetail__mdt param : [SELECT ProcessName__c FROM CustomStepDetail__mdt]){
                if(param.ProcessName__c == processName){
                    stepDetailtoAssert1.add(param);
                }
            }
            System.assertEquals(StepDetail1.size(), stepDetailtoAssert1.size(),False);
        }
/*    }*/
}