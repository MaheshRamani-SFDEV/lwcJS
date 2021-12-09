@isTest
global class contactSetExtTest {
    @isTest  
    global static void contactSetExtSuccessTest(){   
        List<Contact> Contacts = new List<Contact>();
        for(Integer i=0;i<5;i++) {
            Contacts.add(new Contact(FirstName ='FirstContact'+i,
                                     LastName = 'LastContact'+i, 
                                     Email = 'Test'+i+'@gmail.com'));
        }
        insert Contacts;  
        Test.startTest();
            Test.setCurrentPage(page.HelloWorld);
            ApexPages.StandardSetController stdSetConExt = new ApexPages.standardSetController(Contacts);
            stdSetConExt.setSelected(Contacts);
             contactSetExt engageConExt = new contactSetExt(stdSetConExt);   
            PageReference pageRef = engageConExt.gotoHelloWorldPage();
        Test.stopTest();
    }    
    @isTest  
    global static void contactSetExtFailureTest() {   
        List<Contact> Contacts = new List<Contact>();  
        Test.startTest();
       		Test.setCurrentPage(page.HelloWorld);
            ApexPages.StandardSetController stdSetConExt = new ApexPages.standardSetController(Contacts);
        	stdSetConExt.setSelected(Contacts);
            contactSetExt engageConExt = new contactSetExt(stdSetConExt);   
            PageReference pageRef = engageConExt.goToHelloWorldPage();
        Test.stopTest();
    }    
}