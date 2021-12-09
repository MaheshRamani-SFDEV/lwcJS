({   
    fetchFields : function(component, event, helper) {
        var action = component.get("c.getFields");
        action.setParams({
            typeName: component.get("v.sObjectName"),
            fsName: component.get("v.fieldSetName")
        });        
        action.setCallback(this, function(response) {
            var fieldSetMemberList = JSON.parse(response.getReturnValue());          
            var fieldList = [];
            var state = response.getState();
            
            if( state == "SUCCESS"){
                if(fieldSetMemberList.length >0){
                    for(var i = 0, size = fieldSetMemberList.length; i < size ; i++){              
                        fieldList.push(fieldSetMemberList[i].fieldPath);
                    }
                    var fieldSetMemberListModified=[];                                       
                    for(var i = 0, size = fieldSetMemberList.length; i < size ; i++){ 
                        if(fieldSetMemberList[i].label == "Account ID"){
                            fieldSetMemberList[i].label ="Account Name";
                        }
                        fieldSetMemberListModified.push(fieldSetMemberList[i]);
                    } 
                }
                component.set('v.fieldSetMemberList',fieldSetMemberListModified);
                component.set('v.fieldList',fieldList);
                helper.fetchRecords(component, event, helper);
            }
        })
        $A.enqueueAction(action);
    },    
    
    fetchRecords : function(component, event, helper){
        var action = component.get("c.getRecords");
        var fieldList = component.get("v.fieldList");
        action.setParams({
            sObjectName: component.get("v.sObjectName"),
            fieldList: JSON.stringify(fieldList),
            numberOfRecords: component.get("v.NumberOfRecords")
        });
        action.setCallback(this, function(response) {
            var records = response.getReturnValue();  
            var state = response.getState();
            if( state == "SUCCESS"){
            if(records!=null || records !=undefined){
                component.set("v.recordList", records);
                component.set("v.showLtngCell", true);
                if(records.length >0){
                    component.set("v.showTable",true);  
                }
                else{
                    component.set("v.showTable",false);  
                }
                component.set("v.allOpportunity", records);
                if(records.length >0){
                    component.set("v.maxPage", Math.floor((records.length+9)/10));
                }
                //helper.sortBy(component, "Name");//Commented as a part of ST956
                helper.sortBy(component, "CloseDate");//Added as a part of ST956
            }
            }   
            
        })
        $A.enqueueAction(action);
    } ,     
    sortBy: function(component, field) {        
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.recordList");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.recordList", records);
        this.renderPage(component);
    },
    renderPage: function(component) {
        component.set("v.flagarrow",false);
        var records = component.get("v.recordList"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
        component.set("v.currentList", pageRecords);
        component.set("v.flagarrow",true);
    },
    fetchUrl : function(component,event) {
        console.log("in helper");
        var action = component.get("c.getURL");        
        action.setCallback(this, function(response){
            var state = response.getState();            
            if (state === "SUCCESS") {               
                component.set("v.url", response.getReturnValue());
            }
            else{
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
    }   
})