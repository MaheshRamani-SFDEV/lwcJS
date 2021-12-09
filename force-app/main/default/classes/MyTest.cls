public class MyTest{
	public static List<ID> insertID(List<Account> accounts){
		List<ID> accountID = new List<ID>();
		Database.SaveResult[] results = Database.insert(accounts);
		for( Database.SaveResult rs1: results){
  			accountID.add(rs1.getID());    
		}
		return accountID;
	}
}