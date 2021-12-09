@Restresource(urlMapping='/Accounts/*/contacts/')
global class AccountManager {
	@HttpGet
    global static Account getAccount(){
        RestRequest request = RestContext.request;
        String Acct_Id = request.requestURI.substringBetween('Accounts/','/contacts');
        Account act = [SELECT Id, Name, (SELECT Id, Name FROM contacts) FROM Account WHERE Id = :Acct_Id];
        return act;
    }
}