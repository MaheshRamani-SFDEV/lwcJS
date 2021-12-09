public class ContactSearch {
    public Static List<Contact> searchForContacts(String lname, String mpostalcode){
        List<Contact> Lcont = [SELECT ID, Name FROM Contact WHERE (LastName=:lname AND MailingPostalCode=:mpostalcode)];
        return Lcont;
    }
}