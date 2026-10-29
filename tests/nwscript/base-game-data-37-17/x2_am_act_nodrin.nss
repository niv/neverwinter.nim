//::///////////////////////////////////////////////
//:: act_innnodrinks
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If player doesn't want a drink, waitress
    will stop asking him.
    Need to check for the valid talker because when
    she talks to an NPC they won't have a valid object
    with GetPCSpeaker() or GetLastSpeaker.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    object oTalker = GetPCSpeaker();
   if (GetIsObjectValid(oTalker) == FALSE)
    {
        oTalker = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
    }
    SetLocalInt(oTalker, "NW_L_NODRINKSFORME", 10);
}
