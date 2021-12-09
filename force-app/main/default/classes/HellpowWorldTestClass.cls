@isTest
private class HellpowWorldTestClass {
    static testmethod void validateHelloWorld() {
        Book__c b = new Book__c(Name='Behind the Cloud', Price__c =100);
        System.debug('Price before inserting new Books: ' + b.Price__c);
        insert b;
        b = [Select Price__c From Book__c Where Id =:b.Id]; 
        System.debug('Price after trigger fired: ' + b.Price__c);        
        System.assertEquals(90,b.Price__c);
    }
}