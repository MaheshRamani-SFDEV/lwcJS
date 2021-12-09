public class FormulaHyperlink {
    //Below code run in anonymous window then variable x will contain all formula fields which contain HYPERLINK text across ORG.
    //Like wise to find specific text in formula field - can be acheive using below code by modifying it
    /*String s = '';
    String x = '';
    Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
    for (String key: globalMap.keySet())
    {
        Map<String, Schema.SObjectField> fieldsMap = globalMap.get( key ).getDescribe().fields.getMap();
        for(String fieldKey: fieldsMap.keySet() ) 
        {
            DescribeFieldResult dfr = fieldsMap.get( fieldKey ).getDescribe();
            if ( ! dfr.isCalculated() ) 
            {
                System.debug(LoggingLevel.ERROR, '@@@ Field : ' + key + '.' +fieldKey + ' not a formula' );
            } 
            else 
            {
                String f = dfr.getCalculatedFormula();
                System.debug(LoggingLevel.ERROR, '@@@ Field : ' + key + '.' +fieldKey + '?:' + dfr.getCalculatedFormula() );
                s += '(' + key + '.' +fieldKey + ':' + dfr.getCalculatedFormula() + ')'+'\r\n';
                if ( !String.isBlank( f ) && f.contains('HYPERLINK') ) 
                {
                    x += '(' + key + '.' +fieldKey + ':' + f + ')'+'\r\n';
                }
            }
        }
    }
    System.debug(LoggingLevel.ERROR, '@@@ s: ' + s );
    System.debug(LoggingLevel.ERROR, '@@@ x: ' + x );*/
}