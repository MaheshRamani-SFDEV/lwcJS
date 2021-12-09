@isTest
public class AnimalLocatorTest{
    @isTest static void AnimalLocatorMock1(){
       Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
  	   String actual = AnimalLocator.getAnimalNameByID(1);
       System.debug('expected result: '+ actual);
    }
}