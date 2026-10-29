// * Drain the player's constitution for the first time
#include "x2_inc_intweapon"
void main()
{
    object oPC = OBJECT_SELF;
    effect eDrain = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDrain,oPC);
    FloatingTextStrRefOnCreature(101129,oPC);
    object oSword = GetItemPossessedBy(oPC,"x2_iw_enserric");
    IWSetEnhancementAndDrainLevel(oSword, 2);
    SetLocalInt(oPC,"X2_L_ENSERRIC_ASKED_Q3",2);
}
