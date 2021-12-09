@isTest
global class AnimalLocatorMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-type', 'application/json');
        response.setBody('{"animal":{"id" : 1, "name" : "Monkey", "eats" :"mango","says":"khavkhav"}}');
        response.setStatusCode(200);
        return response;
    }
}