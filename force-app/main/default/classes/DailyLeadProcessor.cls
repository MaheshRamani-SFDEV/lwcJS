public class DailyLeadProcessor implements Schedulable{
	public static void execute(SchedulableContext sc)
    {
		List<Lead> leads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = null LIMIT 200];
        for(Lead lead : leads){
            lead.LeadSource = 'Dreamforce';
        }
    }
}