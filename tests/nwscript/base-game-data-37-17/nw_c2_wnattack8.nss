//::///////////////////////////////////////////////
//::
//:: Warning: Attack On Distrubed
//::
//:: NW_C2_WnAttack8.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: If I am disturbed, give a warning.
//:: If I am disturbed again, I attack my attacker.
//::
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
        ActionSpeakString("Disturb me again and you'll be sorry.");
        SetLocalInt(OBJECT_SELF,"NW_L_GENERICHostile",TRUE);
    }
    else
    {
        // * Make me hostile to the faction of my last attacker (TEMP)
        AdjustReputation(OBJECT_SELF,GetFaction(GetLastAttacker()),-100);
        // * Attack my last attacker
        ActionAttack(GetLastAttacker());
    }
}
