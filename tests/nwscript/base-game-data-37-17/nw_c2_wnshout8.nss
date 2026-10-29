//::///////////////////////////////////////////////
//::
//:: Warning: Shout On Disturbed
//::
//:: NW_C2_WnShout8.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: If I am disturbed, give a warning.
//:: If I am disturbed again, I shout to my guards for help and fight defensively.
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
        ActionSpeakString("Attack me again and my guards will trash you.");
        SetLocalInt(OBJECT_SELF,"NW_L_GENERICHostile",TRUE);
    }
    else
    {
        // * Make me hostile to the faction of my last attacker (TEMP)
        AdjustReputation(OBJECT_SELF,GetFaction(GetLastAttacker()),-100);
        // * Attack my last attacker
        
        // TEMP How should this work, should I parry  / run away
        //   is this reaction group redundant???
        // MAYBE the shout can be a long distance shout, or a summoning shout?
        ActionAttack(GetLastAttacker());
    }
}
