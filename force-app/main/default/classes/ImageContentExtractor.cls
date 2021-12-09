public class ImageContentExtractor
{
    static string apiUrl='https://api.einstein.ai/v2/vision/ocr';
    static string token='';
    
	@AuraEnabled
    public static void getImageText(List<string> recIds)
    {
        List<Id> recordId = new List<Id>();
        List<Case> cases = [SELECT Id FROM Case WHERE Id in :recIds];
        Case record;
        for (Case c : cases) {
            recordId.add(c.Id);
            record=c;
        }
        System.debug('recodId>>>'+recordId);
        List<ContentDocumentLink> links=[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId= :recordId];
        Set<Id> ids=new Set<Id>();
        System.debug('links>>>'+links);
        for(ContentDocumentLink link:links)
        {
            ids.add(link.ContentDocumentId);
            //ids.add('0697F00000m59JfQAI');//Image1
            //ids.add('0697F00000m5AxLQAU');//Image2 - PAN
        }
        System.debug('ids>>>'+ids);
        List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
        System.debug('Versions>>>'+versions);
        List<ContentDistribution> cdts=[select ContentDocumentId,DistributionPublicUrl,ContentDownloadUrl from ContentDistribution where ContentDocumentId = :ids];
        System.debug('cdts>>>'+cdts);
        Map<String, String> contentList= new Map <String, String>();  
        for(ContentDistribution cdt:cdts)
        {
            contentList.put(cdt.ContentDocumentId, cdt.ContentDownloadURL);     
        }
        List<EinsteinOCRTemplateMapping__c> mappings=[Select MinX__c,MaxX__c,MinY__c,MaxY__c,Name__c from EinsteinOCRTemplateMapping__c where name='Image1'];
        for(ContentVersion attach:versions)
        {           
            String imageUrl=contentList.get(attach.ContentDocumentId);
            system.debug('imageUrl'+imageUrl);
            if(string.isNotBlank(imageUrl))
            {           
                token=new EinsteinVisionOCRController().getAccessToken();
                //token = 'GNBE4VCZKE2UCNKHKVDFOR2YJBLTESCTJBLFGUJSKNBUSTCGINETOSJWKFBEYWSEJE2UMMZUIJEVITSHKI3DMRKMGRBUIRCBGVHUGWSVIREVCVSFLJEVUQJSGY2VMQSXJJDTOWKGGZMEQUSEJNAVUQSMKRFTONJTJZAVS7COIE';
                system.debug('token'+token);
                string response=EinsteinOCR.extractText(imageUrl, token, 'OCRModel');
                
                EinsteinOCRReponse plateRespone=EinsteinOCRReponse.parse(response);
                if(plateRespone.probabilities!=null)
                {
                    for(EinsteinOCRTemplateMapping__c mapping:mappings)
                    {   
                        string value='';
                        for(EinsteinOCRReponse.Probability prob:plateRespone.probabilities)
                        {
                            EinsteinOCRReponse.BoundingBox  bpx=prob.boundingBox;
                            if(bpx.minY>=mapping.MinY__c && bpx.maxY<=mapping.MaxY__c && bpx.minX>=mapping.MinX__c)
                            {
                               value+=prob.label+' ';
                            }
                        }system.debug('In extract>>>>'+value);
                        record.put(mapping.Name__c,value);
                    }
                }
                update record;
            }
        }
        
    }
    @AuraEnabled
    public static void getImageText1(String recIds)
    {
        Case cases = [SELECT Id FROM Case WHERE Id = :recIds];
        Case record;
        record=cases;
        System.debug('recodId>>>'+recIds);
        List<ContentDocumentLink> links=[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId= :recIds];
        Set<Id> ids=new Set<Id>();
        System.debug('links>>>'+links);
        for(ContentDocumentLink link:links)
        {
            ids.add(link.ContentDocumentId);
            //ids.add('0697F00000m59JfQAI');//Image1
            //ids.add('0697F00000m5AxLQAU');//Image2 - PAN
        }
        System.debug('ids>>>'+ids);
        List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
        System.debug('Versions>>>'+versions);
        List<ContentDistribution> cdts=[select ContentDocumentId,DistributionPublicUrl,ContentDownloadUrl from ContentDistribution where ContentDocumentId = :ids];
        System.debug('cdts>>>'+cdts);
        Map<String, String> contentList= new Map <String, String>();  
        for(ContentDistribution cdt:cdts)
        {
            contentList.put(cdt.ContentDocumentId, cdt.ContentDownloadURL);     
        }
        List<EinsteinOCRTemplateMapping__c> mappings=[Select MinX__c,MaxX__c,MinY__c,MaxY__c,Name__c from EinsteinOCRTemplateMapping__c where name='Image1'];
        for(ContentVersion attach:versions)
        {           
            String imageUrl=contentList.get(attach.ContentDocumentId);
            system.debug('imageUrl'+imageUrl);
            if(string.isNotBlank(imageUrl))
            {           
                token=new EinsteinVisionOCRController().getAccessToken();
                //token = 'GNBE4VCZKE2UCNKHKVDFOR2YJBLTESCTJBLFGUJSKNBUSTCGINETOSJWKFBEYWSEJE2UMMZUIJEVITSHKI3DMRKMGRBUIRCBGVHUGWSVIREVCVSFLJEVUQJSGY2VMQSXJJDTOWKGGZMEQUSEJNAVUQSMKRFTONJTJZAVS7COIE';
                system.debug('token'+token);
                string response=EinsteinOCR.extractText(imageUrl, token, 'OCRModel');
                
                EinsteinOCRReponse plateRespone=EinsteinOCRReponse.parse(response);
                if(plateRespone.probabilities!=null)
                {
                    for(EinsteinOCRTemplateMapping__c mapping:mappings)
                    {   
                        string value='';
                        
                        for(EinsteinOCRReponse.Probability prob:plateRespone.probabilities)
                        {
                            System.debug('prob>>>>'+prob);                           
                            EinsteinOCRReponse.BoundingBox  bpx=prob.boundingBox;
                         	System.debug('bpx>>>>'+bpx);
                            if(bpx.minY>=mapping.MinY__c && bpx.maxY<=mapping.MaxY__c && bpx.minX>=mapping.MinX__c)
                            {
                               value+=prob.label+' ';
                            }
                        }system.debug('In extract>>>>'+value);
                        record.put(mapping.Name__c,value);
                    }
                }
                //update record;
            }
        }
                        update record;
    }
    @AuraEnabled
    public static void getImageText2(string recIds)
    {
        //List<Id> recordId = new List<Id>();
        EinsteinOCRExtract__c exs = [SELECT Id FROM EinsteinOCRExtract__c WHERE Id = :recIds];
        //EinsteinOCRExtract__c record;
		//record=exs;
        System.debug('recodId>>>'+recIds);
        List<ContentDocumentLink> links=[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId = :recIds];
        Set<Id> ids=new Set<Id>();
        System.debug('links>>>'+links);
        for(ContentDocumentLink link:links)
        {
            system.debug('link>>>'+link.ContentDocumentId);
             ids.add(link.ContentDocumentId);
            //ids.add('0697F00000m5Ax7QAE');//Image1
            //ids.add('0697F00000m5Ax6QAE');//Image2 - PAN
        }
        System.debug('ids>>>'+ids);
        List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
        System.debug('Versions>>>'+versions);
        List<ContentDistribution> cdts=[select ContentDocumentId,DistributionPublicUrl,ContentDownloadUrl from ContentDistribution where ContentDocumentId = :ids];
        System.debug('cdts>>>'+cdts);
        Map<String, String> contentList= new Map <String, String>();  
        for(ContentDistribution cdt:cdts)
        {
            contentList.put(cdt.ContentDocumentId, cdt.ContentDownloadURL);  
            system.debug('cdt.ContentDownloadURL>>>'+cdt.ContentDownloadURL);
        }
        List<EinsteinOCRTemplateMapping__c> mappings=[Select name, MinX__c,MaxX__c,MinY__c,MaxY__c,Name__c from EinsteinOCRTemplateMapping__c where name='Image1' OR name='Image2'];                        	
        String imageUrl1=contentList.get(versions[0].ContentDocumentId);//PAN Card Image
        String imageUrl2=contentList.get(versions[1].ContentDocumentId);//Visiting Card Image
        /*for(ContentVersion attach:versions){     
            String imageUrl=contentList.get(attach.ContentDocumentId);//PAN Card Image
            system.debug('imageUrl'+imageUrl);
    	}*/
        if(string.isNotBlank(imageUrl1)){           
            token=new EinsteinVisionOCRController().getAccessToken();
            //token = 'J4ZEYM2EIRIDIRKBIIZVCSJSKJCVEWKHIVJEGMSIINFVSUSXGJBTEM2HI43VKRCNK5JVOTCGG5NDIRSNIREEWNKNLFGEQSSRKRBFQNKDG5HDINZWIJIVAWKVKFHVKWCUKNJEUQ22JZMFOVZWLIZEWM22JVFFQSZVJZEFS7COIE';
            system.debug('token'+token);
            string response=EinsteinOCR.extractText(imageUrl1, token, 'OCRModel');
            
            EinsteinOCRReponse plateRespone=EinsteinOCRReponse.parse(response);
            if(plateRespone.probabilities!=null){                
                for(EinsteinOCRTemplateMapping__c mapping:mappings){   
                    string value='';
                    if(mapping.name == 'Image2'){
                        for(EinsteinOCRReponse.Probability prob:plateRespone.probabilities){
                            //System.debug('prob>>>>'+prob);
                            EinsteinOCRReponse.BoundingBox  bpx=prob.boundingBox;
                            //System.debug('bpx>>>>'+bpx);
                            if(bpx.minY>=mapping.MinY__c && bpx.maxY<=mapping.MaxY__c && bpx.minX>=mapping.MinX__c){
                                value+=prob.label+' ';
                            }
                        }
                    	system.debug('In extract>>>>'+value);
                    	exs.put(mapping.Name__c,value);
                    }
                }                
            }
        }        	
        if(string.isNotBlank(imageUrl2)){           
            token=new EinsteinVisionOCRController().getAccessToken();
            //token = 'J4ZEYM2EIRIDIRKBIIZVCSJSKJCVEWKHIVJEGMSIINFVSUSXGJBTEM2HI43VKRCNK5JVOTCGG5NDIRSNIREEWNKNLFGEQSSRKRBFQNKDG5HDINZWIJIVAWKVKFHVKWCUKNJEUQ22JZMFOVZWLIZEWM22JVFFQSZVJZEFS7COIE';
            system.debug('token'+token);
            string response=EinsteinOCR.extractText(imageUrl2, token, 'OCRModel');            
            EinsteinOCRReponse plateRespone=EinsteinOCRReponse.parse(response);
            if(plateRespone.probabilities!=null){
                for(EinsteinOCRTemplateMapping__c mapping:mappings){   
                    string value='';
                    if(mapping.name == 'Image1' && (mapping.Name__c == 'Mobile__c' || mapping.Name__c == 'Companyname__c')){
                        for(EinsteinOCRReponse.Probability prob:plateRespone.probabilities){
                            System.debug('prob>>>>'+prob);
                            EinsteinOCRReponse.BoundingBox  bpx=prob.boundingBox;
                            System.debug('bpx>>>>'+bpx);
                            if(bpx.minY>=mapping.MinY__c && bpx.maxY<=mapping.MaxY__c && bpx.minX>=mapping.MinX__c){
                                value+=prob.label+' ';
                            }
                        }
                        system.debug('In extract>>>>'+value);
                        exs.put(mapping.Name__c,value);
                    }
                }
            }
        }
        update exs;
    }
}
/*public class ImageContentExtractor
{
    static string apiUrl='https://api.einstein.ai/v2/vision/ocr';
    static string token='';
    
    @InvocableMethod
    public static void getImageText(List<string> records)
    {
        List<Id> recodId = new List<Id>();
        List<Case> cases = [SELECT Id FROM Case WHERE Id in :records];
        Case record;
        for (Case c : cases) {
            recodId.add(c.Id);
            record=c;
        }
        
        List<ContentDocumentLink> links=[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId=:recodId];
        Set<Id> ids=new Set<Id>();
        for(ContentDocumentLink link:links)
        {
            ids.add(link.ContentDocumentId);
        }
        
        List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
        
        List<ContentDistribution> cdts=[select ContentDocumentId,DistributionPublicUrl,ContentDownloadURL from ContentDistribution where ContentDocumentId =:ids];
        
        Map<String, String> contentList= new Map <String, String>();  
        for(ContentDistribution cdt:cdts)
        {
            contentList.put(cdt.ContentDocumentId, cdt.ContentDownloadURL);     
        }
        
        List<EinsteinOCRTemplateMapping__c> mappings=[Select MinX__c,MaxX__c,MinY__c,MaxY__c,Name__c from EinsteinOCRTemplateMapping__c where name='Image1'];
        for(ContentVersion attach:versions)
        {           
            String imageUrl=contentList.get(attach.ContentDocumentId);
            system.debug('imageUrl'+imageUrl);
            if(string.isNotBlank(imageUrl))
            {           
                //token=new EinsteinController().getAccessToken();
                token = 'J4ZEYM2EIRIDIRKBIIZVCSJSKJCVEWKHIVJEGMSIINFVSUSXGJBTEM2HI43VKRCNK5JVOTCGG5NDIRSNIREEWNKNLFGEQSSRKRBFQNKDG5HDINZWIJIVAWKVKFHVKWCUKNJEUQ22JZMFOVZWLIZEWM22JVFFQSZVJZEFS7COIE';
                system.debug('token'+token);
                string response=EinsteinOCR.extractText(imageUrl, token, 'OCRModel');
                
                EinsteinOCRReponse plateRespone=EinsteinOCRReponse.parse(response);
                if(plateRespone.probabilities!=null)
                {
                    for(EinsteinOCRTemplateMapping__c mapping:mappings)
                    {   
                        string value='';
                        for(EinsteinOCRReponse.Probability prob:plateRespone.probabilities)
                        {
                            EinsteinOCRReponse.BoundingBox  bpx=prob.boundingBox;
                            if(bpx.minY>=mapping.MinY__c && bpx.maxY<=mapping.MaxY__c && bpx.minX>=mapping.MinX__c)
                            {
                               value+=prob.label+' ';
                            }
                        }
                        record.put(mapping.Name__c,value);
                    }
                }
                update record;
            }
        }
        
    }
}*/