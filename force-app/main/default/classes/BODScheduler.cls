global class BODScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        NotifyBoardofDirectorsChange notifyBOD = new NotifyBoardofDirectorsChange();
        Database.executeBatch(notifyBOD);
    }
}