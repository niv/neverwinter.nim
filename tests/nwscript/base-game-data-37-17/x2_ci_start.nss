#include "x2_inc_craft"
void main()
{
    object oPC = GetPCSpeaker();
    StoreCameraFacing();
    ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 0.5, 12000.0);
    CISetDefaultModItemCamera(oPC);

    //* Immobilize player while crafting
    effect eImmob = EffectCutsceneImmobilize();
    eImmob = ExtraordinaryEffect(eImmob);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eImmob,oPC);

}
