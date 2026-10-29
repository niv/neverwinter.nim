//::///////////////////////////////////////////////
//:: Lycanthrope Change
//:: NW_C2_LYRAT_D
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Changes someone into a wererat when they are
    attacked.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 27, 2002
//:://////////////////////////////////////////////

void main()
{
    // Make sure the were creature has a custom on spawn in with the line Custom User On Attacked being
    // commented in.  This becomes the Userdefined script.

    int nUser = GetUserDefinedEventNumber();
    int nChange = GetLocalInt(OBJECT_SELF,"NW_LYCANTHROPE");
    effect eShape = EffectPolymorph(POLYMORPH_TYPE_WERERAT); //Use one of the polymorph constants here (WERE_RAT, WERE_WOLF or WERE_CAT)
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    if(nUser == 1005 && nChange == 0)
    {
        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShape, OBJECT_SELF));
        DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(OBJECT_SELF)));
        SetLocalInt(OBJECT_SELF, "NW_LYCANTHROPE", 1);
    }
}
