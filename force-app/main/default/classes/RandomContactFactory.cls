public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer contcnt, String lastname){
       List<Contact> Listcontact = new List<Contact>();
       For(Integer i=1;i<=contcnt; i++){
       		Contact c = new Contact(LastName=lastname,
                                   	FirstName='Test '+ i);     
       		Listcontact.add(c); 
       } 
        return Listcontact;
    }
}