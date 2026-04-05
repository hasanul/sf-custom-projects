/**
 * Handler class for managing Account trigger logic.
 * Developer: Hasanul Banna
 * Description: This class contains the logic to update the Account_State__c field on related Contact records when the BillingState of an Account is changed.
 * Created Date: 2026-04-04
 * Last Modified: 2026-04-04
 */

public with sharing class AccountTriggerHandler {
    public static void updateContactState(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
        Set<Id> changedAccountIds = new Set<Id>();
        Map<Id, String> accountIdToState = new Map<Id, String>();

        for (Account acc : newAccounts) {
            if (acc.BillingState != oldAccountMap.get(acc.Id).BillingState) {
                changedAccountIds.add(acc.Id);
                accountIdToState.put(acc.Id, acc.BillingState);
            }
        }

        if (changedAccountIds.isEmpty()) {
            return;
        }

        List<Contact> contactsToUpdate = [
            SELECT Id, AccountId, Account_State__c
            FROM Contact
            WHERE AccountId IN :changedAccountIds
        ];

        for (Contact con : contactsToUpdate) {
            con.Account_State__c = accountIdToState.get(con.AccountId);
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}