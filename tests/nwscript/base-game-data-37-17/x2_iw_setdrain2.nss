/*
    Intelligent Weapon: Enserric
    Upgrade current enhancement bonus by 1, drain 2 points of con
    Georg Zoeller, 2003-10-26
*/
#include "x2_inc_intweapon"
void main()
{
    effect eDrain = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDrain,GetPCSpeaker());
    FloatingTextStrRefOnCreature(101129,GetPCSpeaker());
    object oSword = GetItemPossessedBy(GetPCSpeaker(),"x2_iw_enserric");
    IWSetEnhancementAndDrainLevel(oSword, 1);
}
