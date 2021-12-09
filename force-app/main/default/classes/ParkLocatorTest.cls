@isTest
private class ParkLocatorTest {
    @isTest static void countryMock1(){
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        String[] parks = ParkLocator.country('India');
    	System.assert(parks.size() > 0);
    }    
}