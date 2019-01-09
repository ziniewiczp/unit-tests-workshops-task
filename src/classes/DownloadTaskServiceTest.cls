@isTest
public class DownloadTaskServiceTest {
    
    @isTest
    private static void testDownloadTaskPositive() {
        Integer taskId = 1;
        Test.setMock(HttpCalloutMock.class, new MockExternalResponse(taskId, true));
        
        List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(0, tasks.size());
        
        Test.startTest();
        DownloadTaskService.downloadTask(taskId);
        Test.stopTest();
        
        tasks = [SELECT Id FROM Task];
        System.assertEquals(1, tasks.size());
    }
    
    @isTest
    private static void testDownloadTaskNegative() {
        Integer taskId = 1;
        Test.setMock(HttpCalloutMock.class, new MockExternalResponse(taskId, false));
        Exception thrownException;
        
        Test.startTest();
        try {
        	DownloadTaskService.downloadTask(taskId);
            
        } catch (Exception e) {
            thrownException = e;
        }
        Test.stopTest();
        
        List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(0, tasks.size());
        
        System.assertEquals('TaskWrapper.WrongTaskSchemaException', thrownException.getTypeName());
    }
    
    @isTest
    private static void testDownloadTasksPositive() {
        List<Integer> taskIds = new List<Integer>{1, 2, 3};
        Test.setMock(HttpCalloutMock.class, new MockExternalResponse(taskIds, true));
        
        List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(0, tasks.size());
        
        Test.startTest();
        DownloadTaskService.downloadTasks();
        Test.stopTest();
        
        tasks = [SELECT Id FROM Task];
        System.assertEquals(3, tasks.size());
    }
    
    @isTest
    private static void testDownloadTasksNegative() {
		List<Integer> taskIds = new List<Integer>{1, 2, 3};
        Test.setMock(HttpCalloutMock.class, new MockExternalResponse(taskIds, false));
        Exception thrownException;
        
        Test.startTest();
        try {
            DownloadTaskService.downloadTasks();
            
        } catch (Exception e) {
            thrownException = e;
        }
        Test.stopTest();
        
        List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(0, tasks.size());

		System.assertEquals('System.JSONException', thrownException.getTypeName());        
    }
    
    @isTest
    private static void testDeleteTasksPositive() {
        List<Task> tasks = new List<Task>();
        
        for(Integer i = 0; i < 5; i++) {
            tasks.add(new Task(
                ExternalTaskId__c = i,
            	Priority = 'Low',
                Status = 'Low')
            );
        }
        
        insert tasks;
        
        tasks = [SELECT Id FROM Task];
        System.assertEquals(5, tasks.size());
        
        Set<Integer> taskIds = new Set<Integer>{ 0, 1, 2, 3 };
        
        Test.startTest();
        DownloadTaskService.deleteTasks(taskIds);
        Test.stopTest();
        
        tasks = [SELECT Id, ExternalTaskId__c FROM Task];
        System.assertEquals(1, tasks.size());
        System.assertEquals(4, tasks.get(0).ExternalTaskId__c);
    }

    public class MockExternalResponse implements HttpCalloutMock {
        private Boolean isSuccessful;
        private Integer taskId;
        private List<Integer> taskIds;
                
        private MockExternalResponse(Integer taskId, Boolean isSuccessful) {
            this.taskId = taskId;
            this.isSuccessful = isSuccessful;
        }
        
        private MockExternalResponse(List<Integer> taskIds, Boolean isSuccessful) {
            this.taskIds = taskIds;
            this.isSuccessful = isSuccessful;
        }
        
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            if(this.isSuccessful) {
                res.setStatusCode(200);
                        
                if(this.taskId != null) {
                    res.setBody('{"userId": 1,"id": ' + this.taskId + ',"title": "delectus aut autem","completed": false}');
                
                } else {
                    String body = '[';
                    
                    for(Integer i = 0; i < this.taskIds.size(); i++) {
                        body += '{"userId": ' + i + ',"id": ' + this.taskIds.get(i)
                            	+ ',"title": "delectus aut autem","completed": false}';
                        
                        // insert comma after every row except the last one
                        if(i < this.taskIds.size() - 1) {
                            body += ',';
                        }
                    }
                    
                    res.setBody(body + ']');
                }
            
            } else {
                res.setStatusCode(404);
                res.setBody('');
            }
            
            return res;
        }
    }
}