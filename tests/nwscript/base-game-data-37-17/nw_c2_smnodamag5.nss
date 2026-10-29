//::///////////////////////////////////////////////
//::
//:: Summon: No Damage On Attacked
//::
//:: NW_C2_SmNoDamag5.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: If I am attacked, give a warning.
//:: If I am attacked again, I summon guards.
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
    else
    {
    // * fire event to summon guards.
        EventUserDefined(10);
    }
}
