@isTest
public class TestVerifyDate {
    @isTest static void TestDate2LessThenDate1() {
		Date date10 = VerifyDate.CheckDates(date.today(),date.today().addDays(-2));
        System.assertEquals(date.newInstance(2017,12,23),date10);
	}
    @isTest static void TestDate2IsNotWithin30Days() {
		Date date11 = VerifyDate.CheckDates(date.today(),date.today().addDays(20));
        System.assertEquals(date.newInstance(2017,12,31),date11);
	}
	 @isTest static void TestDate2IsWithin30Days() {
		Date date12 = VerifyDate.CheckDates(date.today(),date.today().addDays(35));
        System.assertEquals(date.newInstance(2017,12,31),date12);
	}
}