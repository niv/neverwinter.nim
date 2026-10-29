//::///////////////////////////////////////////////
//:: Remove all effects
//:: x2_dm_remeffects
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Removes all effects from the calling object.
    If called by a PC, the character has to be in
    god mode to call it.

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
    effect eEff = GetFirstEffect(OBJECT_SELF) ;
    while (GetIsEffectValid(eEff))
    {
        RemoveEffect(OBJECT_SELF,eEff);
        eEff = GetNextEffect(OBJECT_SELF);
    }
}
