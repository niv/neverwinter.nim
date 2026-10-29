//::///////////////////////////////////////////////
//:: Demon Leaves
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December
//:://////////////////////////////////////////////

void main()
{
    // * April 20: Added commandable stuff to prevent you
    // * from talking to him on his way out
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(OBJECT_SELF));
    DestroyObject(OBJECT_SELF,3.0);
    SetCommandable(FALSE);
}
