#include "x0_i0_spells"

/* Can not allow a character to use skills while not in their standard form */

int StartingConditional()
{
    int iResult;
    object oPC = GetPCSpeaker();
    int nEff = GetHasEffect(EFFECT_TYPE_POLYMORPH,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_PETRIFY,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_STUNNED,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_DAZED,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_SLEEP,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_FRIGHTENED,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_CHARMED,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_DOMINATED,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_TURNED,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_TIMESTOP,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_PARALYZE,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_IMPROVEDINVISIBILITY,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_INVISIBILITY,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_ETHEREAL,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_ENTANGLE,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_DARKNESS,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_DOMINATED,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_CUTSCENE_PARALYZE,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_SWARM,oPC);
    nEff = nEff || GetHasEffect(EFFECT_TYPE_BLINDNESS,oPC);
    nEff = nEff || GetIsInCombat(oPC);
    nEff = nEff || GetLocalInt(oPC, "X2_L_DO_NOT_ALLOW_CRAFTSKILLS");
    nEff = nEff || GetLocalInt(GetArea(oPC), "X2_L_DO_NOT_ALLOW_CRAFTSKILLS");
    nEff = nEff || GetLocalInt(GetModule(), "X2_L_DO_NOT_ALLOW_CRAFTSKILLS");
    iResult = (nEff == TRUE);
    return iResult;
}

