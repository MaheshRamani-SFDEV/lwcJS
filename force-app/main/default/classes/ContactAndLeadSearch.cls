public class ContactAndLeadSearch {
    public Static List<List<SObject>> searchContactsAndLeads(String lastname){
		List<List<SObject>> Lobj = [FIND :lastname IN ALL FIELDS RETURNING Contact(FirstName, LastName), Lead(FirstName, LastName)];        
    	return Lobj;
    }
}