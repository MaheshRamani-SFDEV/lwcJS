/*
On the server side, the Apex controller includes
Aura-enabled methods that accept a list of emails as parameters.
*/
public class EmailController {
        /*
    This method searches for Contacts with matching emails in the email list,
    and includes Account information in the fields. Then, it filters the
    information to return a list of objects to use on the client side.
    */
    @AuraEnabled
    public static List<Map<String, Object>> findAccountAges(List<String> emails) {
        List<Map<String, Object>> ret = new List<Map<String, Object>>();
        List<Contact> contacts = [SELECT Name, Account.Name, Account.CreatedDate FROM Contact WHERE Contact.Email IN :emails];
        for (Contact c: contacts) {
        	Map<String, Object> item = new Map<String, Object>();
       		item.put('name', c.Account.Name);
        	item.put('age', Date.valueOf(c.Account.CreatedDate).daysBetween(System.Date.today()));
        	ret.add(item);
        }
        return ret;
    }
        /*
    This method searches for OpportunityContactRoles with matching emails
    in the email list.
    Then, it calculates the number of days until closing to return a list
    of objects to use on the client side.
    */
    @AuraEnabled
    public static List<Map<String, Object>> findOpportunityCloseDateTime(List<String> emails) {
        List<Map<String, Object>> ret = new List<Map<String, Object>>();
        List<OpportunityContactRole> contacts = [SELECT Opportunity.Name, Opportunity.CloseDate FROM OpportunityContactRole WHERE isPrimary=true AND Contact.Email IN :emails];
        for (OpportunityContactRole c: contacts) {
            Map<String, Object> item = new Map<String, Object>();
            item.put('name', c.Opportunity.Name);
            item.put('closesIn', System.Date.today().daysBetween(Date.valueOf(c.Opportunity.CloseDate)));
            ret.add(item);
        }
        return ret;
    }
}