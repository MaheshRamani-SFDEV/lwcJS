public with sharing class ImageContentExtractorLWC
{
    //static string apiUrl='https://api.einstein.ai/v2/vision/ocr';
    static string token='';
    public static String VISION_API = 'https://api.einstein.ai/v2/vision';
    public static String PREDICT = VISION_API + '/predict';
    public static String OCR = VISION_API + '/ocr';
    
    public static String MODEL = 'GeneralImageClassifier';
    
    public static String LANGUAGE_API = 'https://api.einstein.ai/v2/language';
    public static String SENTIMENT = LANGUAGE_API + '/sentiment';
    public static String INTENT = LANGUAGE_API + '/intent';
    @AuraEnabled
    public static string getImageUrlAndToken(Id recordId){
	        
        List<ContentDocumentLink> links=[SELECT ContentDocumentId, ContentDocument.Title,LinkedEntityId, SystemModstamp FROM ContentDocumentLink where LinkedEntityId = :recordId ORDER BY SystemModstamp DESC Limit 1];
        Set<Id> ids=new Set<Id>();
        for(ContentDocumentLink link:links)
        {
            system.debug('link>>>'+link.ContentDocumentId);
             ids.add(link.ContentDocumentId);
        }
        System.debug('ids>>>'+ids);
        List<ContentVersion> versions=[SELECT Id, VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
        System.debug('Versions>>>'+versions);
        ContentDistribution cd = new ContentDistribution();
        cd.Name = links[0].ContentDocument.Title;
        cd.ContentVersionId = versions[0].id;
        cd.PreferencesAllowViewInBrowser= true;
        cd.PreferencesLinkLatestVersion=true;
        cd.PreferencesNotifyOnVisit=false;
        cd.PreferencesPasswordRequired=false;
        cd.PreferencesAllowOriginalDownload= true;
        cd.PreferencesAllowPDFDownload = false;
        insert cd;
        List<ContentDistribution> cdts=[select ContentDocumentId,DistributionPublicUrl,ContentDownloadUrl from ContentDistribution where ContentDocumentId = :ids];
        
        System.debug('cdts>>>'+cdts);
        Map<String, String> contentList= new Map <String, String>();  
        for(ContentDistribution cdt:cdts)
        {
            contentList.put(cdt.ContentDocumentId, cdt.ContentDownloadURL);  
            system.debug('cdt.ContentDownloadURL>>>'+cdt.ContentDownloadURL);
        }
        
        String imageUrl;
        for(ContentVersion attach:versions){     
            imageUrl=contentList.get(attach.ContentDocumentId);
            system.debug('imageUrl'+imageUrl);
    	}
        system.debug('imageUrlaaaaaa'+imageUrl);
        return imageUrl;        
    }
	 
    @AuraEnabled
    public static String getDataFromImage(Id recordId, String imageCategory, String imageUrl){
        String OCRModelName = 'OCRModel';
        if(imageCategory == 'Invoice'){
        	OCRModelName = 'tabulatev2';
        }
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        system.debug('ÍN call of token ');
        EinsteinOCRExtract__c extractRecord = new EinsteinOCRExtract__c();
		
        List<EinsteinOCRTemplateMapping__c> mappings=[Select name, ImageType__c, MinX__c,MaxX__c,MinY__c,MaxY__c,Name__c from EinsteinOCRTemplateMapping__c where ImageType__c= :imageCategory];                        	
		if(string.isNotBlank(imageUrl)){     system.debug('imageUrl2'+imageUrl);      
            token=new EinsteinVisionOCRController().getAccessToken();system.debug('imageUrl3'+imageUrl);
            string response=EinsteinOCR.extractText(imageUrl, token, 'OCRModel'); system.debug('imageUrl4'+imageUrl);           
            EinsteinOCRReponse plateRespone=EinsteinOCRReponse.parse(response);system.debug('imageUrl5'+imageUrl);
            if(plateRespone.probabilities!=null){
                for(EinsteinOCRTemplateMapping__c mapping:mappings){   
                    string value='';
                    for(EinsteinOCRReponse.Probability prob:plateRespone.probabilities){                
                     	EinsteinOCRReponse.BoundingBox  bpx=prob.boundingBox; 
                        if(bpx.minY>=mapping.MinY__c && bpx.maxY<=mapping.MaxY__c && bpx.minX>=mapping.MinX__c){
                            value+=prob.label+' ';
                        }
                    }
                    system.debug('In extract>>>>'+value);
                    extractRecord.put(mapping.Name__c,value);                    
                }
            }
            system.debug('imageUrl6'+imageUrl);
            if(sObjName == 'Contact'){
                extractRecord.ContactId__c = recordId;
            }else if(sObjName == 'Case'){
                extractRecord.CaseId__c = recordId;
            }
            insert extractRecord;
            return extractRecord.id;
        }else{
			return null;                                           
        }
    }
    
	@AuraEnabled(cacheable=true)
    public static List<EinsteinOCRExtractFieldMapping__mdt> getFieldDetails(String imageCategory){system.debug('Get fieldssssss');
        List<EinsteinOCRExtractFieldMapping__mdt> fieldDetails = [SELECT FieldApiName__c, ImageCategory__c, FieldOrder__c  FROM EinsteinOCRExtractFieldMapping__mdt WHERE ImageCategory__c = :imageCategory ORDER BY FieldOrder__c ASC NULLS LAST];
        system.debug('IN image con??>>>>'+fieldDetails);
        return fieldDetails;
    }
    
    @AuraEnabled
    public static Boolean predictImageCategory(String imageCategory, String imageUrl){
        if(string.isNotBlank(imageUrl)){     system.debug('imageUrlA'+imageUrl);      
            token=new EinsteinVisionOCRController().getAccessToken();system.debug('imageUrlB'+imageUrl);
            string response=EinsteinImageClassification.predictImageCategory(imageUrl, token, 'GeneralImageClassifier'); system.debug('imageUrlC'+imageUrl);           
			parseResponse(response);    
            return true;
       	}else{
           return false;
       	}
    }
    
    private static void parseResponse(String result){
        EinsteinPredictionResponse response = (EinsteinPredictionResponse)System.JSON.deserialize(result, EinsteinPredictionResponse.class);
        for(EinsteinPredictionResponse.Probabilities prob : response.probabilities){
            System.debug(System.LoggingLevel.DEBUG, prob.label+' '+prob.probability);
        }
    }  
}