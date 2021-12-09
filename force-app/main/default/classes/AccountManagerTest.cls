@isTest
public class AccountManagerTest {
    public static testMethod void getAccountTest(){
        Id recordId = createRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://maramani-dev-ed.my.salesforce.com/services/apexrest/Accounts/'+recordId+'/contacts';
        request.httpMethod = 'GET';    
        RestContext.request = request;
        Account thisAccount = AccountManager.getAccount();
        System.assert(thisAccount != null);
        System.assertEquals('Test Account', thisAccount.Name);
        }    
    static Id createRecord(){
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        Contact cont = new Contact(LastName = 'Hitesh Patel', AccountId = acct.Id);
        return acct.Id;
    }
}