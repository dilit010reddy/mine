global class NotifyBoardofDirectorsChange implements Database.Batchable<SObject>, Database.Stateful {
    // accountIDtoContact maps (Account ID) => Map of an [Operation string] (either Remove or Add) => List of Contacts that
    // have been changed with respect to the board of directors
    global Map<ID, Map<String, List<Contact>>> accountIDtoContact = new Map<ID, Map<String, List<Contact>>>();

    // TODO can simplify this code a bit if the start method queries on the Account table and uses an inner query on
    // Contacts, rather than having to go bottom up from Contact
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator(
            'SELECT ID, Remove_Board__c, Added_Board__c, Account.Email__c, Account.ID, Account.Name, Name FROM Contact ' +
            'Where Remove_Board__c = true OR Added_Board__c = true'
        );
    }
    global void execute(Database.BatchableContext bc, List<Contact> records) {
        system.debug('records = ' + records);
        // Clear board flags on each daily operation
        List<Contact> resetBoardFlagContacts = new List<Contact>();
        // Build the map to key on Account
        // There should be max 2 entries in the value Map, one for Remove and one for Add
        for (Contact con : records) {
            Map<String, List<Contact>> opToContactValueMap;
            if (!accountIDtoContact.containsKey(con.Account.ID)) {
                accountIDtoContact.put(
                    con.Account.ID,
                    new Map<String, List<Contact>>()
                );
            }
            opToContactValueMap = accountIDtoContact.get(con.Account.Id);
            if (con.Remove_Board__c == true) {
                if (!opToContactValueMap.containsKey('Remove')) {
                    opToContactValueMap.put('Remove', new List<Contact>());
                }
                opToContactValueMap.get('Remove').add(con);
                con.Remove_Board__c = false;
                resetBoardFlagContacts.add(con);
                system.debug('in remove board');
            } else if (con.Added_Board__c == true) {
                if (!opToContactValueMap.containsKey('Add')) {
                    opToContactValueMap.put('Add', new List<Contact>());
                }
                opToContactValueMap.get('Add').add(con);
                con.Added_Board__c = false;
                resetBoardFlagContacts.add(con);
                system.debug('in add board');
            }
        }
        system.debug('accountIDtoContact = ' + accountIDtoContact);
        update resetBoardFlagContacts;
    }
    global void finish(Database.BatchableContext bc) {
        System.debug('Finish Method accountIDtoContact: ' + accountIDtoContact);
        List<Messaging.SingleEmailMessage> boardAlertEmails = new List<Messaging.SingleEmailMessage>();
        List<String> mailToAddresses = new List<String>();
        List<User> users = [
            SELECT Email
            FROM User
            WHERE
                Id IN (
                    SELECT UserOrGroupId
                    FROM GroupMember
                    WHERE Group.Name = :'AcctPayables'
                )
        ];

        for (User u : users) {
            mailToAddresses.add(u.email);
        }
        // Notify the Helsing Group of account board changes
        // Only one email per account should be sent summarizing the changes on all contacts under that account
        for (ID accID : accountIDtoContact.keySet()) {
            Map<String, List<Contact>> opToContactValueMap = accountIDtoContact.get(
                accID
            );
            String accName = '';

            String body = 'Account: {0} has recent board of directors changes. ';
            if (opToContactValueMap.containsKey('Remove')) {
                body += '\n\nMembers to be removed:';
                for (Contact con : opToContactValueMap.get('Remove')) {
                    accName = con.Account.Name;
                    body += '\n' + con.Name;
                }
            }
            if (opToContactValueMap.containsKey('Add')) {
                body += '\n\nMembers to be added:';
                for (Contact con : opToContactValueMap.get('Add')) {
                    accName = con.Account.Name;
                    body += '\n' + con.Name;
                }
            }
            body = String.format(body, new List<Object>{ accName });
            String subj = 'BOARD MEMBER CHANGES - ' + accName;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(mailToAddresses);
            mail.setSenderDisplayName('The Helsing Group');
            mail.setSubject(subj);
            mail.setPlainTextBody(body);
            boardAlertEmails.add(mail);
        }
        system.debug('board alert email list = ' + boardAlertEmails);
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(boardAlertEmails);
        }
    }
}