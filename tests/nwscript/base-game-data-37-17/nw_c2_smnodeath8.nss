//::///////////////////////////////////////////////
//::
//:: Summon: No Death On Disturbed
//::
//:: NW_C2_SmNoDeath8.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//::
//:: I summon guards.
//:: Do this by firing event 10
//:: A user-defined script will then catch this
//:: event and summon guards.
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: April 30, 2001
//::
//:://////////////////////////////////////////////

void main()
{
    if (GetLocalInt(OBJECT_SELF,"NW_L_GENERICHostile") == FALSE)
    {
        // * TEMP, this should become a SpeakString by resref
        ActionSpeakString("Stop that.");
        SetLocalInt(OBJECT_SELF,"NW_L_GENERICHostile",TRUE);
    }
}
