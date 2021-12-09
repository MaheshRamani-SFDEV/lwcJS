({ 
    initJSONData : function(component, event, helper){
        component.set("v.lstItem",helper.getSampleJSON());
        
    },
    getSampleJSON : function(){
        return  [ { "companyName" : "Salesforce" } ,
                 { "companyName" : "IBM" },
                 { "companyName" : "Oracle" } ,
                 { "companyName" : "Twitter" }]  ; 
    },
    textChange: function(cmp, event,helper) {  
        if(event.getSource){
            var target = event.getSource();  
            var txtVal = target.get("v.value") ;
            cmp.set("v.selectedItem",txtVal);   
        }else{
            var target = event.target;  
            var dataEle = target.getAttribute("data-selected-Index"); 
            cmp.set("v.selectedItem", "Component at index "+dataEle+" has value "+target.value); 
        }
         
    }
})