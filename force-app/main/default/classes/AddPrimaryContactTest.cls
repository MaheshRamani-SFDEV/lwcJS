@isTest
public class AddPrimaryContactTest {
	@isTest
    static void Qtest1(){
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<50 ;i++){
        	accounts.add(new Account(BillingState='NY', Name='QTestt'+i));
        }
         for(Integer j=50; j<100 ;j++){
        	accounts.add(new Account(BillingState='CA',Name='QTestt'+j));    
        }
    	insert accounts;
   		
        Contact ct = new Contact(FirstName='QFirstTestt', LastName='QLastTestt');
    	insert ct;
        String sab = 'CA'; 
      	
        AddPrimaryContact apc = new AddPrimaryContact(ct, sab);    
        Test.startTest();
      		System.enqueueJob(apc);   
      	Test.stopTest();       
    }
}