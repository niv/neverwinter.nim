// on-enter event for the tracks trigger.

void main()
{
    object oPC = GetEnteringObject();
    if(!GetIsPC(oPC))
        return;

    int nDoOnce = GetLocalInt(oPC, "DO_ONCE" + ObjectToString(OBJECT_SELF)); // a unique do-once
    if(nDoOnce == 1)
        return;
    SetLocalInt(oPC, "DO_ONCE" + ObjectToString(OBJECT_SELF), 1);

    string sTag = GetTag(OBJECT_SELF);
    AssignCommand(oPC, SpeakOneLinerConversation(sTag));

}
