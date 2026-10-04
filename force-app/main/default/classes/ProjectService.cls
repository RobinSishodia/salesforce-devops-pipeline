/**
 * Service methods for working with Project__c records.
 * All data access runs in user mode so object and field permissions are enforced.
 */
public with sharing class ProjectService {

    /**
     * Creates and inserts a new project.
     * @param projectName Name of the project
     * @return The inserted Project__c record
     */
    public static Project__c createProject(String projectName) {
        Project__c newProject = new Project__c(Name = projectName);
        insert as user newProject;
        return newProject;
    }

    /**
     * Returns all projects visible to the running user, ordered by name.
     * @return List of Project__c records
     */
    public static List<Project__c> getAllProjects() {
        return [SELECT Id, Name FROM Project__c WITH USER_MODE ORDER BY Name];
    }
}
