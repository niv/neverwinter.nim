//::///////////////////////////////////////////////
//:: Tasha's Hideous Laughter
//:: [x0_s0_laugh.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target is held, laughing for the duration
    of the spell (1d3 rounds)

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nCnt;
    effect eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);


    int nDuration = d3(1);


    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }


    int nModifier = 0;

    // * creatures of different race find different things funny
    if (GetRacialType(oTarget) != GetRacialType(OBJECT_SELF))
    {
        nModifier = 4;
    }
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TASHAS_HIDEOUS_LAUGHTER));

        if (spellsIsMindless(oTarget) == FALSE)
        {
            if (!MyResistSpell(OBJECT_SELF, oTarget) && !/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()-nModifier, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                if ( !GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS ))
                {
                    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                    float fDur = RoundsToSeconds(nDuration);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDur);

                /*    string szLaughMale = "as_pl_laughingm2";
                    string szLaughFemale = "as_pl_laughingf3";

                    if (GetGender(oTarget) == GENDER_FEMALE)
                    {
                        PlaySound(szLaughFemale);
                    }
                    else
                    {
                        PlaySound(szLaughMale);
                    }      */
                    AssignCommand(oTarget, ClearAllActions());
                    AssignCommand(oTarget, PlayVoiceChat(VOICE_CHAT_LAUGH));
                    AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
                    effect eLaugh = EffectKnockdown();
                    DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLaugh, oTarget, fDur));
                }
            }
        }
    }
}





