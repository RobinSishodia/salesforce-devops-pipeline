@IsTest
private class ProjectServiceTest {

    private static User createAdminUser() {
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User admin = new User(
            Alias = 'padmin',
            Email = 'project.admin@test.example',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Admin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = adminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'project.admin.' + System.now().getTime() + '@test.example'
        );
        insert admin;
        return admin;
    }

    @IsTest
    static void testCreateProject() {
        System.runAs(createAdminUser()) {
            Test.startTest();
            Project__c result = ProjectService.createProject('Test Project Alpha');
            Test.stopTest();

            System.assertNotEquals(null, result.Id, 'Project should have been inserted and have an Id');
            System.assertEquals('Test Project Alpha', result.Name, 'Project name should match input');
        }
    }

    @IsTest
    static void testGetAllProjects() {
        System.runAs(createAdminUser()) {
            ProjectService.createProject('Project One');
            ProjectService.createProject('Project Two');

            Test.startTest();
            List<Project__c> projects = ProjectService.getAllProjects();
            Test.stopTest();

            System.assertEquals(2, projects.size(), 'Should return exactly 2 projects');
        }
    }
}
