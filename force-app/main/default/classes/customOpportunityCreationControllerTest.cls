@isTest(SeeAllData = false)
private class customOpportunityCreationControllerTest {
    public static String processName = 'CustomLeadConversion';
    public static String Object2 = 'Opportunity';
    public static String TEST_NAME = 'Test Lead Creation';
    public static String TEST_FIRST_NAME = 'Test';
    public static String TEST_LAST_NAME = 'Lead Creation';
    public static String TEST_COMPANY = 'Testing';
    public static String TEST_STATUS = 'Open';
    public static String TEST_LEADSOURCE = 'Advertisement';
    public static String FIELD_NAME = 'Name';
    public static String FIELD_LEADSOURCE = 'LeadSource';
    
    @testSetup static void getLeadRecord(){
        Account convertedAccount = new Account();
        convertedAccount.Name = TEST_NAME;
        insert convertedAccount;
        Contact convertedContact = new Contact();
        convertedContact.lastName = TEST_LAST_NAME;
        convertedContact.FirstName = TEST_FIRST_NAME;
        convertedContact.accountId = convertedAccount.Id;
        insert convertedContact;
        
        Lead leadToInsert = new lead();
        leadToInsert.FirstName = TEST_FIRST_NAME;
        leadToInsert.LastName = TEST_LAST_NAME;
        leadToInsert.Company = TEST_COMPANY;
        leadToInsert.Status = TEST_STATUS;
        leadToInsert.LeadSource = TEST_LEADSOURCE;
        leadToInsert.isConverted = true;
        Account convertedAccount1 = [select id from Account limit 1];
        Contact convertedContact1 = [select id from Contact limit 1];
        //leadToInsert.ConvertedAccountId = convertedAccount1.Id;
        //leadToInsert.ConvertedContactId = convertedContact1.Id;
        leadToInsert.OwnerId= userInfo.getUserId();
        insert leadToInsert;
    }
    @isTest
    private static void fetchLeadOpportunityFieldsMappingTest(){
        //User u = TestClass_Utility.getAdminUser('zx1');
       // insert u;
        Lead leadInserted = [select id from lead where isConverted = true limit 1];
        //System.runAs(u){        
        Map<String, String> fieldsWithValuesForObj2 = new Map<String, String>();
        Test.startTest();
        fieldsWithValuesForObj2 = customOpportunityCreationController.fetchLeadOpportunityFieldsMapping(processName,leadInserted.Id, Object2);
        Test.stopTest();
            for(String fielName:fieldsWithValuesForObj2.keySet()){
                if(fielName == FIELD_NAME){
                system.assertEquals(TEST_COMPANY, fieldsWithValuesForObj2.get(fielName));
                }
                if(fielName == FIELD_LEADSOURCE){
                system.assertEquals(TEST_LEADSOURCE, fieldsWithValuesForObj2.get(fielName));
                }
            }
        /*}*/
    }
}