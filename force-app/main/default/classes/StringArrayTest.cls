public class StringArrayTest {
    public static List<String> generateStringArray(Integer num){
   		List<String> lStr = new List<String>(); 
        for(Integer i=0;i<num;i++){
         	lStr.add('Test '+i); 
            System.debug('Test '+i);
        }
        return lStr;
    }
}