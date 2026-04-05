/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

@isTest
private class AccountTriggerHandlerTest {

    @isTest
    static void testUpdateContactState_WhenBillingStateChanges() {
        // Create test account
        Account acc = new Account(
            Name = 'Test Account',
            BillingState = 'Texas',
            BillingCountry = 'United States'
        );
        insert acc;

        // Create related contacts
        List<Contact> contacts = new List<Contact>{
            new Contact(LastName = 'Contact One', AccountId = acc.Id),
            new Contact(LastName = 'Contact Two', AccountId = acc.Id)
        };
        insert contacts;

        // Simulate old map
        Account oldAcc = acc.clone(false, true, false, false);
        oldAcc.Id = acc.Id;
        oldAcc.BillingState = 'Texas';
        oldAcc.BillingCountry = 'United States';

        Map<Id, Account> oldAccountMap = new Map<Id, Account>{
            acc.Id => oldAcc
        };

        // Update state
        acc.BillingState = 'California';

        Test.startTest();
        AccountTriggerHandler.updateContactState(
            new List<Account>{acc},
            oldAccountMap
        );
        Test.stopTest();

        // Verify
        List<Contact> updatedContacts = [
            SELECT Account_State__c
            FROM Contact
            WHERE AccountId = :acc.Id
        ];

        for (Contact con : updatedContacts) {
            System.assertEquals('California', con.Account_State__c);
        }
    }

    @isTest
    static void testUpdateContactState_NoChange() {
        Account acc = new Account(
            Name = 'Test Account 2',
            BillingState = 'Florida',
            BillingCountry = 'United States'
        );
        insert acc;

        Contact con = new Contact(
            LastName = 'No Change Contact',
            AccountId = acc.Id,
            Account_State__c = 'Florida'
        );
        insert con;

        Account oldAcc = acc.clone(false, true, false, false);
        oldAcc.Id = acc.Id;
        oldAcc.BillingState = 'Florida';
        oldAcc.BillingCountry = 'United States';

        Map<Id, Account> oldMap = new Map<Id, Account>{
            acc.Id => oldAcc
        };

        Test.startTest();
        AccountTriggerHandler.updateContactState(
            new List<Account>{acc},
            oldMap
        );
        Test.stopTest();

        Contact result = [
            SELECT Account_State__c
            FROM Contact
            WHERE Id = :con.Id
        ];

        System.assertEquals('Florida', result.Account_State__c);
    }
}