global class UtilsClass {
    global static String getSessionIdFromVFPage(PageReference visualforcePage){
        String content = visualforcePage.getContent().toString();
        Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                e = content.indexOf('End_Of_Session_Id');
        system.debug('Session ID: ' + content.substring(s, e));
        return content.substring(s, e);
    }
}