/*
    Intelligent Weapon: Enserric
    Remove enhancement bonus and Ability Draing
    Georg Zoeller, 2003-10-26
*/
#include "x2_inc_intweapon"
void main()
{
    effect eDrain = EffectVisualEffect(VFX_IMP_HEAD_HEAL);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDrain,GetPCSpeaker());

    object oSword = GetItemPossessedBy(GetPCSpeaker(),"x2_iw_enserric");
    // Remove Enhancement
    if (GetIsObjectValid(oSword))
    {
        IWSetEnhancementAndDrainLevel(oSword, 0, TRUE);
    }
}
