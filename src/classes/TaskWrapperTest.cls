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
        String json = '{"userId": 1,"id": 1,"title": "delectus aut autem","completed": false}';
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

    @isTest
    private static void testGetRecordExisting() {
        String json = '{"userId": 1,"id": 1,"title": "delectus aut autem","completed": false}';

        Test.startTest();
        TaskWrapper wrapper = new TaskWrapper(json);
        wrapper.insertRecord();
        Task record = wrapper.getRecord();
        Test.stopTest();

        System.assertNotEquals(null, record);
    }

    @isTest
    private static void testGetRecordNonExisting() {
        String json = '{"userId": 1,"id": 1,"title": "delectus aut autem","completed": false}';

        Test.startTest();
        TaskWrapper wrapper = new TaskWrapper(json);
        Task record = wrapper.getRecord();
        Test.stopTest();

        System.assertNotEquals(null, record);
    }

    @isTest
    private static void testGenerateRecord() {
        String json = '{"userId": 1,"id": 1,"title": "delectus aut autem","completed": false}';

        Test.startTest();
        TaskWrapper wrapper = new TaskWrapper(json);
        Task record = wrapper.generateRecord();
        Test.stopTest();

        System.assertEquals('Not Started', record.Status);
        System.assertEquals('delectus aut autem', record.Subject);
        System.assertEquals(1, record.ExternalTaskId__c);
    }
}
