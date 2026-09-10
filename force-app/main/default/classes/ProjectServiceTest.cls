@isTest
private class ProjectServiceTest {

    @isTest
    static void testCreateProject() {
        Test.startTest();
        Project__c result = ProjectService.createProject('Test Project Alpha');
        Test.stopTest();

        System.assertNotEquals(null, result.Id, 'Project should have been inserted and have an Id');
        System.assertEquals('Test Project Alpha', result.Name, 'Project name should match input');
    }

    @isTest
    static void testGetAllProjects() {
        ProjectService.createProject('Project One');
        ProjectService.createProject('Project Two');

        Test.startTest();
        List<Project__c> projects = ProjectService.getAllProjects();
        Test.stopTest();

        System.assertEquals(2, projects.size(), 'Should return exactly 2 projects');
    }
}