/*  * Test class for Class MockHttpResponseGenerator 
    *
    * @name           MockHttpResponseGenerator 
    * @author         Mahesh Ramani
    * @since          11/27/2019
    * @version        1
    * @Decsription    M11.2019
* */
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('GET', req.getMethod());        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Name":"Individual"}');//page layout name
        res.setStatusCode(200);
        return res;
    }
}