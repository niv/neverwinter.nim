//::///////////////////////////////////////////////
//:: Remove all effects
//:: x2_dm_remeffects
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Removes one level from the calling character

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct 2003
//:://////////////////////////////////////////////


void main()
{
    if (!GetPlotFlag(OBJECT_SELF) && GetIsPC(OBJECT_SELF))
    {
        SpeakString("Must be in god mode to use this script!");
        return;
    }
    object oNoob = OBJECT_SELF;
    int nXP = GetXP(oNoob);
    int nHD = GetHitDice(oNoob) - 1 ;
    int nMin = ((nHD * (nHD - 1)) / 2) * 1000;
    SetXP(oNoob , nMin);
    if (GetIsPC(OBJECT_SELF))
    {
        FloatingTextStringOnCreature("* Lost a level *",OBJECT_SELF);
    }
}
