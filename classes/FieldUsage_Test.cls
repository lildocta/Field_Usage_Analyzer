@isTest
public class FieldUsage_Test {
    @isTest
    public static void getAllFields_Test(){
        Test.startTest();
        Map<String, String> mOppFields = FieldUsage_LWC.getAllFields('Opportunity');
        Map<String, String> mContFields = FieldUsage_LWC.getAllFields('Contact');
        Map<String, String> mAcctFields = FieldUsage_LWC.getAllFields('Account');
        Map<String, String> mNoFields = FieldUsage_LWC.getAllFields('');
        Test.stopTest();
        System.assert(mOppFields.keySet().size() > 0);
    }

    @isTest
    public static void getUsageNumbers_Test(){
        Account acct = new Account(Name='test acct');
       	Database.insert(acct);
        Contact cont1 = new Contact(FirstName = 'Calvin', LastName = 'Tester', AccountId = acct.Id);
        Database.insert(cont1);
        Contact cont2 = new Contact(FirstName = 'Tom', LastName = 'Tester', AccountId = acct.Id);
        Database.insert(cont2);
        Opportunity opp = new Opportunity(Name='Test', StageName='1. Lead Development',x2019_q1_revenue__c = 1, CloseDate = Date.today());
        Database.insert(opp);
        Map<String, String> mOppFields = FieldUsage_LWC.getAllFields('Opportunity');
        Map<String, String> mContFields = FieldUsage_LWC.getAllFields('Contact');
        Map<String, String> mAcctFields = FieldUsage_LWC.getAllFields('Account');
        Test.startTest();
            List<FieldUsage_LWC.FieldUsage> lOppFieldData = FieldUsage_LWC.getUsageNumbers(new List<String> {'x2019_q1_revenue__c'}, 'Opportunity');
            List<FieldUsage_LWC.FieldUsage> lContFieldData = FieldUsage_LWC.getUsageNumbers(new List<String> {'FirstName'}, 'Contact');
            List<FieldUsage_LWC.FieldUsage> lAcctFieldData = FieldUsage_LWC.getUsageNumbers(new List<String> {'priority__c'}, 'Account');
            List<FieldUsage_LWC.FieldUsage> lNoFieldData = FieldUsage_LWC.getUsageNumbers(new List<String> {'priority__c'}, '');
        Test.stopTest();
        System.assert(lOppFieldData[0].total == 1);
        System.assert(lContFieldData[0].total == 2);
        System.assert(lAcctFieldData[0].total == 0);
    }
}
