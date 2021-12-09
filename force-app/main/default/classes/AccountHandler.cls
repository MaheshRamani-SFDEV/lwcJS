public class AccountHandler {
    public Static Account insertNewAccount(String AccountName){
        Account acct = new Account(name=AccountName);
        try{
        	insert acct;
        	return acct;    
        }catch(DMLException e){
            return null;    
        }      
    }
}