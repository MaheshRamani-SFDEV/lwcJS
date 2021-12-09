public with sharing class OpportunityDataController { 
    //Fetching Opportunties related to Selected Account;
    @AuraEnabled
    //public static list<oppWrapper> fetchOpportunities(String accId, String strFieldSetName){
    public static list<oppWrapper> fetchOpportunities(String accId){
        List<oppWrapper> oppWrapList = new List<oppWrapper>();
        if(string.isNotBlank(accId)){                      
            //List<String> lstOppFieldsToQuery = getFieldSet(strFieldSetName);
            //SOQL to get account related all opportunity to display in table
            for(Opportunity opp : [SELECT Id,Name,AccountID,Type,StageName FROM Opportunity WHERE AccountId=:accId]){
                oppWrapList.add(new oppWrapper(opp, false));
            }
            /*String query = 'SELECT Id, ' + String.join(lstOppFieldsToQuery, ',') + ' FROM Opportunity WHERE AccountId =:accId';
            List<Opportunity> oppList = Database.query(query);
            for(Opportunity opp :oppList){
            	oppWrapList.add(new oppWrapper(opp, false));
            }*/
        }
        return oppWrapList;
    }
    /*@AuraEnabled
    public static List<String> getFieldSet(String fieldSetName) {
        //Get the fields from FieldSet
        Schema.SObjectType SObjectTypeObj = Schema.getGlobalDescribe().get('Opportunity');
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();            
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        
        //Field to be queried - fetched from fieldset
        List<String> lstFieldsToQuery = new List<String>();
        
        for( Schema.FieldSetMember eachFieldSetMember : fieldSetObj.getFields() ){
            lstFieldsToQuery.add(String.valueOf(eachFieldSetMember.getFieldPath()));
        }
        return lstFieldsToQuery;
    }*/
    // Wrapper Class Hold Opp List & Boolean Variable
    public class oppWrapper{
        @AuraEnabled 
        public Opportunity oppRec{get;set;}
        @AuraEnabled 
        public Boolean isVisible{get;set;}       
        public oppWrapper(Opportunity opp, Boolean visibleFlag){
            this.oppRec = opp;
            this.isVisible = visibleFlag;
        }
    }
    /*
     *  <!--   
    <article class="slds-card">
        <div class="slds-card__body">
            <aura:if isTrue="{!v.Spinner}">
                <div aura:id="spinnerId" class="slds-spinner_container">
                    <div class="slds-spinner--brand  slds-spinner slds-spinner--large slds-is-relative" role="alert">
                        <span class="slds-assistive-text">Loading</span>
                        <div class="slds-spinner__dot-a"></div>
                        <div class="slds-spinner__dot-b"></div>
                    </div>
                </div>
            </aura:if>
            <aura:if isTrue="{! v.showTable}">
                <table class="slds-table slds-table_cell-buffer slds-no-row-hover slds-table_bordered slds-table_fixed-layout" role="grid">
                    <thead>
                        <tr class="slds-line-height_reset">
                            <th class="" scope="col">
                                <div class="slds-truncate" title="Name">Action</div>
                            </th>
                            <th class="" scope="col">
                                <div class="slds-truncate" title="Company">Opportunity</div>
                            </th>
                            <aura:if isTrue="{!v.isheaderVisible}" > 
                                <th class="" scope="col">
                                    <div class="slds-truncate" title="Title">Type</div>
                                </th>
                            </aura:if>
                            <aura:if isTrue="{!v.isheaderVisible}" > 
                                <th class="" scope="col">
                                    <div class="slds-truncate" title="Email">Stage</div>
                                </th>
                            </aura:if>
                        </tr>
                    </thead>
                    <tbody>
                        <aura:iteration items="{!v.currentList}" var="opp" indexVar ="key">
                        <tr class="slds-hint-parent">
                            <td class="slds-truncate">
                                <lightning:input type="radio" label="" name="options" value="{!key}" onclick="{!c.handleClick}"/>
                            </td>
                            <td class="slds-truncate">{!opp.oppRec.Name}</td>
                            <td data-index="{!key}" class="slds-truncate">
                                <aura:if isTrue="{!opp.isVisible}" >
                                    {!opp.oppRec.Type}
                                </aura:if>       
                            </td>
                            <td data-index="{!key}" class="slds-truncate">
                                <aura:if isTrue="{!opp.isVisible}" >
                                    {!opp.oppRec.StageName}
                                </aura:if>   
                            </td>
                        </tr>
                        </aura:iteration>
                    </tbody>
                </table>
            </aura:if>
            <aura:if isTrue="{!!v.showTable}">
                <div class="slds-text-align--center">
                    <br></br> <br></br><br></br><br></br><br></br><br></br><br></br><br></br><br></br>
                    <p><b>No items to display.</b></p>
                </div> 
        	</aura:if>
        </div>
        <aura:if isTrue="{!(v.oppList.length > 10)}">
            <lightning:layout horizontalAlign="center">
                <c:pagination currentPageNumber="{!v.pageNumber}" 
                              maxPageNumber="{!v.maxPage}" />
            </lightning:layout>                    
        </aura:if>
    </article>-->
*/
}