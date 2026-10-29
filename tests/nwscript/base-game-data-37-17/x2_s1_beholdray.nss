//::///////////////////////////////////////////////
//:: Beholder Ray Attacks
//:: x2_s2_beholdray
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Implementation for the new version of the
    beholder rays, using projectiles instead of
    rays
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-16
//:://////////////////////////////////////////////


#include "x0_i0_spells"


void DoBeholderPetrify(int nDuration,object oSource, object oTarget, int nSpellID);

void main()
{

    int     nSpell = GetSpellId();
    object  oTarget = GetSpellTargetObject();
    int     nSave, bSave;
    int     nSaveDC = 15;
    float   fDelay;
    effect  e1, eLink, eVis, eDur;


    switch (nSpell)
    {
         case 776 :
                                  nSave = SAVING_THROW_FORT;      //BEHOLDER_RAY_DEATH
                                  break;

        case  777:
                                  nSave = SAVING_THROW_WILL;     //BEHOLDER_RAY_TK
                                  break;

        case 778 :                                              //BEHOLDER_RAY_PETRI
                                  nSave = SAVING_THROW_FORT;
                                  break;

        case 779:                                                   // BEHOLDER_RAY_CHARM
                                  nSave = SAVING_THROW_WILL;
                                  break;

        case 780:                                                   //BEHOLDER_RAY_SLOW
                                  nSave = SAVING_THROW_WILL;
                                  break;

       case 783:
                                  nSave = SAVING_THROW_FORT;        //BEHOLDER_RAY_WOUND
                                  break;

       case 784:                                                    // BEHOLDER_RAY_FEAR
                                  nSave = SAVING_THROW_WILL;
                                  break;

       case 785:
       case 786:
       case 787:
    }

    SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId(),TRUE));
    fDelay  = 0.0f;  //old -- GetSpellEffectDelay(GetLocation(oTarget),OBJECT_SELF);
    if (nSave == SAVING_THROW_WILL)
    {
        bSave = MySavingThrow(SAVING_THROW_WILL,oTarget, nSaveDC,SAVING_THROW_TYPE_ALL,OBJECT_SELF,fDelay) >0;
    }
    else if (nSave == SAVING_THROW_FORT)
    {
      bSave = MySavingThrow(SAVING_THROW_FORT,oTarget, nSaveDC,SAVING_THROW_TYPE_ALL,OBJECT_SELF,fDelay) >0;
    }

    if (!bSave)
    {

      switch (nSpell)
      {
         case 776:                 e1 = EffectDeath(TRUE);
                                   eVis = EffectVisualEffect(VFX_IMP_DEATH);
                                   eLink = EffectLinkEffects(e1,eVis);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget);
                                   break;

          case 777:                e1 = ExtraordinaryEffect(EffectKnockdown());
                                   eVis = EffectVisualEffect(VFX_IMP_STUN);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oTarget,6.0f);
                                   break;

          // Petrify for one round per SaveDC
          case 778:                eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                   DoBeholderPetrify(nSaveDC,OBJECT_SELF,oTarget,GetSpellId());
                                   break;


          case 779:                e1 = EffectCharmed();
                                   eVis = EffectVisualEffect(VFX_IMP_CHARM);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oTarget,24.0f);
                                   break;


          case 780:                e1 = EffectSlow();
                                   eVis = EffectVisualEffect(VFX_IMP_SLOW);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oTarget,RoundsToSeconds(6));
                                   break;

          case 783:                e1 = EffectDamage(d8(2)+10);
                                   eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,e1,oTarget);
                                   break;


          case 784:
                                   e1 = EffectFrightened();
                                   eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
                                   eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
                                   e1 = EffectLinkEffects(eDur,e1);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oTarget,RoundsToSeconds(1+d4()));
                                   break;


       }

    }
    else
    {
         switch (nSpell)
         {
               case 776:         e1 = EffectDamage(d6(3)+13);
                                 eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
                                 eLink = EffectLinkEffects(e1,eVis);
                                 ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget);
        }
    }
}



void DoBeholderPetrify(int nDuration,object oSource, object oTarget, int nSpellID)
{

    if(!GetIsReactionTypeFriendly(oTarget) && !GetIsDead(oTarget))
    {
        // * exit if creature is immune to petrification
        if (spellsIsImmuneToPetrification(oTarget) == TRUE)
        {
            return;
        }
        float fDifficulty = 0.0;
        int bIsPC = GetIsPC(oTarget);
        int bShowPopup = FALSE;

        // * calculate Duration based on difficulty settings
        int nGameDiff = GetGameDifficulty();
        switch (nGameDiff)
        {
            case GAME_DIFFICULTY_VERY_EASY:
            case GAME_DIFFICULTY_EASY:
            case GAME_DIFFICULTY_NORMAL:
                    fDifficulty = RoundsToSeconds(nDuration); // One Round per hit-die or caster level
                break;
            case GAME_DIFFICULTY_CORE_RULES:
            case GAME_DIFFICULTY_DIFFICULT:
                if (!GetPlotFlag(oTarget))
                {
                    bShowPopup = TRUE;
                }
            break;
        }

        effect ePetrify = EffectPetrify();
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eLink = EffectLinkEffects(eDur, ePetrify);


                /// * The duration is permanent against NPCs but only temporary against PCs
                if (bIsPC == TRUE)
                {
                    if (bShowPopup == TRUE)
                    {
                        // * under hardcore rules or higher, this is an instant death
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                        DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, FALSE , TRUE, 40579));
                        // if in hardcore, treat the player as an NPC
                        bIsPC = FALSE;
                    }
                    else
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDifficulty);
                }
                else
                {
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                    // * Feb 11 2003 BK I don't think this is necessary anymore
                    //if the target was an NPC - make him uncommandable until Stone to Flesh is cast
                    //SetCommandable(FALSE, oTarget);

                    // Feb 5 2004 - Jon
                    // Added kick-henchman-out-of-party code from generic petrify script
                    if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_HENCHMAN)
                    {
                        FireHenchman(GetMaster(oTarget),oTarget);
                    }
                }
                // April 2003: Clearing actions to kick them out of conversation when petrified
                AssignCommand(oTarget, ClearAllActions());
    }
}
