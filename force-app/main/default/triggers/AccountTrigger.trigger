/**
 * This trigger is responsible for handling the logic related to Account object.
 * Developer: Hasanul Banna
 * Description: 
 * Created Date: 2026-04-04
 * Last Modified: 2026-04-04
 */

 trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            AccountTriggerHandler.updateContactState(Trigger.new, Trigger.oldMap);
        }
    }
}