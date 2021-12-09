@isTest
public class MYHELLOWORLDTEST {

    @isTest
    public static void TestDiscount(){
        List<Book__c> listBook = new List<Book__c>();
        Book__c book1 = new Book__c(Name='MyBook1',price__c=100);     
        Book__c book2 = new Book__c(Name='MyBook1',price__c=100);     
        listBook.add(book1);
        listBook.add(book2);
        insert listBook;
        Test.startTest();
        //MyHelloWorld mhw = new MyHelloWorld();
        MyHelloWorld.applyDiscount(listBook);
        Test.stopTest();
    }
}