public class AnimalLocator{
    public static String getAnimalNameById(Integer id){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        string animals = '';
        if(response.getStatusCode() == 200){
             Map<String, Object> result = (Map<String, Object>)json.deserializeUnTyped(response.getBody());
             Map<String, Object> animal = (Map<String, Object>)result.get('animal'); 
             animals = string.valueof(animal.get('name'));      	
        }
        return animals;
    }
}