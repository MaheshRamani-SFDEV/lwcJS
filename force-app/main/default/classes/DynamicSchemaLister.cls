public class DynamicSchemaLister {

    List<FieldProperties> FieldProperties;
    public string objToQuery {get;set;}
      
    public DynamicSchemaLister () { }  
    
    public List<FieldProperties> getfieldProperties ()
    {
        FieldProperties= new List<FieldProperties>();
        SObjectType objType = Schema.getGlobalDescribe().get(objtoquery);
        if (objType != null)
        {
        Map<String,Schema.SObjectField> fields = objType.getDescribe().fields.getMap();
        for (String s : fields.keySet()) 
             {
                if (s != 'Name' && fields.get(s).getDescribe().isUpdateable() && 
                    fields.get(s).getDescribe().isAccessible() && 
                    fields.get(s).getDescribe().isCustom() ) 
                { FieldProperties.add(new FieldProperties(objtoquery, s) );  }
             }
        }
        return FieldProperties;
    }
    
   
    public List<SelectOption> getItems() 
    {
       string cobjname;
       List<SelectOption> options = new List<SelectOption>();
       List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();  
       for(Schema.SObjectType f : gd)
            {
               if (f.getDescribe().isCustom() && f.getDescribe().getName().contains('_c'))
               { 
                 cobjname = f.getDescribe().getName();
                 options.add(new SelectOption(cobjname ,cobjname ));
               }
            }
       return options;
    }
   
    
    //Innerclass to hold important attributes of the field object
    public class FieldProperties
    {
        private string sObjtoquery;
        public string fieldname{get;set;}
        public string fieldtype{get;set;}
        
        public FieldProperties() {}  
        
        public FieldProperties(string objname, string fieldname) {
            this.sObjtoquery = objname;
            this.fieldname = fieldname;
            getAttributes(objname, fieldname);
        }
    
    
        public void getAttributes(string objtoquery, string afieldname)
        {
          SObjectType objType = Schema.getGlobalDescribe().get(objtoquery);
          Map<String,Schema.SObjectField> fields = objType.getDescribe().fields.getMap();
          if (fields.get(afieldname).getDescribe().isUpdateable() &&
             fields.get(afieldname).getDescribe().isAccessible()
             && fields.get(afieldname).getDescribe().isCustom() ) 
              {  
                fieldname = afieldname;
                fieldtype = string.valueof(fields.get(afieldname).getDescribe().getType());
              }
        }
    } 
    
    
    
    Public Pagereference QueryObject()
    {    return null;    }
 }