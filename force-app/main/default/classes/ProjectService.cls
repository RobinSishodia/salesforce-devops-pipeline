public with sharing class ProjectService {

    public static Project__c createProject(String projectName) {
        Project__c newProject = new Project__c(Name = projectName);
        insert newProject;
        return newProject;
    }

    public static List<Project__c> getAllProjects() {
        return [SELECT Id, Name FROM Project__c ORDER BY Name];
    }
}
