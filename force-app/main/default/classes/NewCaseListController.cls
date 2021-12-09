public class NewCaseListController {
    List<Case> newcase = new List<Case>();
    public List<Case> GetNewCases() {
        newcase = [SELECT Id, CaseNumber FROM Case WHERE Status = 'New'];
  		return newcase;
    }
}