//::///////////////////////////////////////////////
//:: Actuvate Item Script
//:: NW_S3_ActItem01
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This fires the event on the module that allows
    for items to have special powers.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 19, 2001
//:://////////////////////////////////////////////

void main()
{
    object oItem = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();
    location lLocal = GetSpellTargetLocation();

    SignalEvent(GetModule(), EventActivateItem(oItem, lLocal, oTarget));
}
