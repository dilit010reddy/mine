/*
@Author: N. Larkin, QuantumRhino
@Date: 3/15/2021
@Description: Turns the Trigger on or Off at runtime.

@History:
*/
public class TriggerStatus{
    public static Boolean doNotRunTrigger = false;

    public static void setDoNotRunTrigger(){
        doNotRunTrigger = true;
    }

    public static Boolean shouldRunTrigger() {
        return !doNotRunTrigger;
    }
}