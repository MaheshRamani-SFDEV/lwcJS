trigger EmailAttachmentOpportunityTrigger on Opportunity (after update) {
    if(Trigger.isUpdate){
        For(Opportunity opp : Trigger.new){
            if(opp.hasAttachment__c == True && opp.HasAttachment__c != Trigger.oldMap.get(opp.Id).hasAttachment__c){

                EmailTemplate template = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = 'Send Opportunity Email With Attachment'];
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(template.id); 
                mail.setTargetObjectId(opp.OwnerId);
                mail.setSaveAsActivity(false);
 
                List<Attachment> attList = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId = : opp.id];
                System.Debug('-----$--attList :'+attList );
                
                Messaging.EmailFileAttachment[] efaList = new List<Messaging.EmailFileAttachment>();
                for(Attachment att : attList){ 
                    System.Debug('-----$--for att :'+att );
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(att.Name);
                    efa.setBody(att.body);
                    efa.setContentType(att.ContentType);
                    efa.setInline(false);
                    efaList.add(efa); 
                }
                System.Debug('-----$--efaList:'+efaList);
                mail.setFileAttachments(efaList);
                
                System.Debug('-----$--mail:'+mail);
                    try {
                        messaging.sendEmailResult[] mailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        System.Debug('-----$--mailResults :'+mailResults );
                    } catch (Exception e) {
                        System.debug(e.getMessage());
                    } 
                }
            }
      }
}