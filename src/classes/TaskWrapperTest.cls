@isTest
public class TaskWrapperTest {

    @isTest
    private static void testConstructorJsonPositive() {
        String json = '{"userId": 1,"id": 1,"title": "delectus aut autem","completed": false}';
        Exception thrownException;

        Test.startTest();
        try {
        	TaskWrapper wrapper = new TaskWrapper(json);

        } catch (Exception e) {
            thrownException = e;
        }
        Test.stopTest();

        System.assertEquals(null, thrownException);
    }

    @isTest
    private static void testConstructorJsonNegative() {
        String json = '"userId": 1,"id": 1,"title": "delectus aut autem","completed": false}';
        Exception thrownException;

        Test.startTest();
        try {
        	TaskWrapper wrapper = new TaskWrapper(json);

        } catch (Exception e) {
            thrownException = e;
        }
        Test.stopTest();

        System.assertEquals('TaskWrapper.WrongTaskSchemaException', thrownException.getTypeName());
    }

    @isTest
    private static void testConstructorSchema() {
        TaskSchema schema = new TaskSchema();
        Exception thrownException;

        Test.startTest();
        try {
        	TaskWrapper wrapper = new TaskWrapper(schema);

        } catch (Exception e) {
            thrownException = e;
        }
        Test.stopTest();

        System.assertEquals(null, thrownException);
    }

    @isTest
    private static void testInsertRecord() {
        String json = '"userId": 1,"id": 1,"title": "delectus aut autem","completed": false}';
        Exception thrownException;

        Test.startTest();
        try {
            TaskWrapper wrapper = new TaskWrapper(json);
            Task record = wrapper.insertRecord();

            System.assertNotEquals(null, record);

        } catch (Exception e) {
            thrownException = e;
        }
        Test.stopTest();

        System.assertEquals(null, thrownException);
    }
}
