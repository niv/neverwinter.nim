//::///////////////////////////////////////////////
//::
//:: Summon: No Death On Attacked
//::
//:: NW_C2_SmNoDeath5.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: If I am attacked, give a warning.
//:: If I am attacked again, I summon guards.
//:: Do this by summoning them through conversation.
//:: A user-defined script will then catch this
//:: event and summon guards.
//::
//:: L_GENERICHostile = 0 : Not annoyed
//:: L_GENERICHostile = 2 : Summoning guards
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: April 30, 2001
//::
//:://////////////////////////////////////////////

void main()
{
    ClearAllActions();
    if (GetLocalInt(OBJECT_SELF,"NW_L_GENERICHostile") == 0)
    {
        // * TEMP, this should become a SpeakString by resref
        ActionSpeakString("Attack me again and I will be forced to react.");
        SetLocalInt(OBJECT_SELF,"NW_L_GENERICHostile",2);
        ActionStartConversation(GetLastAttacker());
    }
}
