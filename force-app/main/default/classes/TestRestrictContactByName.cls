@isTest
public class TestRestrictContactByName {
    @isTest static void TestInsertRestrictContactbyName(){
            List<Contact> Lcont = new List<Contact>();
                Contact cont1 = new Contact(LastName = 'MaheshRamani');
				Contact cont2 = new Contact(LastName = 'SIDDIK');
    			
        		Lcont.add(cont1);
        		Lcont.add(cont2);

        	Test.startTest();
    		insert Lcont;   	  	
    		Lcont.get(1).LastName = 'INVALIDNAME';
    		update Lcont;
			Test.stopTest();
	}
}