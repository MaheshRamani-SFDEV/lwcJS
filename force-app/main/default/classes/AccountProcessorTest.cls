@isTest
private class AccountProcessorTest {
    @isTest
    static void testMethodOne() {
        Account acc = new Account();
        acc.Name='Test Account' ;
        insert acc;
        List<Contact> listCont = new List<Contact>();
        for(Integer i=0; i<5; i++){
        	Contact cont = new Contact();
            cont.FirstName='Test'+i;
        	cont.LastName='Test'+i;
        	cont.Email='demo@demo.com';
        	cont.Accountid=acc.id;
            listCont.add(cont);
        }
        insert listCont;
        Test.startTest();
        
        List<Id> accList = new List<Id>();
        accList.add(acc.Id);
        AccountProcessor.countContacts(accList);
        Test.stopTest();
        Account accNew = [select Id, Number_of_Contacts__c from Account where Id =: acc.Id LIMIT 1];
        
        System.assertEquals(5, accNew.Number_of_Contacts__c);

    }
}