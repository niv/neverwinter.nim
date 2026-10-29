// Whenever a player clicks on the tracks - give the proper feedback

// NOTICE: make sure this object's tag is 16 or less chars!!!

void main()
{
    object oPC = GetLastUsedBy();
    string sTag = GetTag(OBJECT_SELF);
    AssignCommand(oPC, SpeakOneLinerConversation(sTag));
}
