//::///////////////////////////////////////////////
//:: The dreaded ChaosShield
//:: x2_s3_chaosshld
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    The chaosshield has a variety of different
    effects, that have a chance of striking each
    creature successfully doing damage to the
    person wearing the shield

    the chance for an effect to happen are
    2% per level of the item property

    The effects differ, depending on wether the
    attacker is a melee attacker or a ranged
    attacker

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-10-17
//:://////////////////////////////////////////////




void main()
{

   object oItem;        // The item casting triggering this spellscript
   object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
   object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

   // fill the variables
   oSpellOrigin = OBJECT_SELF;
   oSpellTarget = GetSpellTargetObject();
   oItem        =  GetSpellCastItem();

   //---------------------------------------------------------------------------
   // There is a 2% chance per level of the item property that something
   // happens
   //---------------------------------------------------------------------------
   int nChance = GetCasterLevel(OBJECT_SELF) * 2;
   if (Random(100)+1 > nChance)
   {
      return;
   }

   //---------------------------------------------------------------------------
   // Only One Effect At A Time
   //---------------------------------------------------------------------------
   if (GetHasSpellEffect(GetSpellId(),oSpellTarget))
   {
        return;
   }


   if (GetIsObjectValid(oItem))
   {
        int bMelee = GetDistanceBetween(oSpellOrigin,oSpellTarget) < 4.0f;
        int nRandom;


        FloatingTextStrRefOnCreature(100925, oSpellOrigin);
        FloatingTextStrRefOnCreature(100925, oSpellTarget);

        if (!bMelee)
        {
          nRandom = Random(4);
        }
        else
        {
           nRandom = Random(4)+4;
        }

        effect eVis;
        effect eDur;
        effect eEffect;
        effect eDur2;
        switch (nRandom)
        {
            case 0:
                    eEffect = EffectStunned();
                    eDur = EffectBeam(VFX_BEAM_CHAIN,OBJECT_SELF, BODY_NODE_CHEST);
                    eVis = EffectVisualEffect(VFX_COM_SPARKS_PARRY);
                    eDur = EffectLinkEffects(eEffect,eDur);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oSpellTarget,RoundsToSeconds(d2()));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
                    break;

            case 1:
                    eEffect = EffectDamage(d6()+1, DAMAGE_TYPE_FIRE);
                    eVis = EffectBeam(444,OBJECT_SELF, BODY_NODE_CHEST);
                    eDur = EffectVisualEffect(VFX_DUR_INFERNO);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oSpellTarget,4.0f);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffect,oSpellTarget);
                    DelayCommand(0.3f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oSpellTarget,4.0f));
                    break;

            case 2:
                    eEffect = EffectDamage(d8()+1, DAMAGE_TYPE_ELECTRICAL);
                    eVis = EffectBeam(VFX_BEAM_LIGHTNING,OBJECT_SELF, BODY_NODE_CHEST);
                    eDur = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oSpellTarget,4.0f);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffect,oSpellTarget);
                    DelayCommand(0.3f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDur,oSpellTarget));
                    break;

            case 3:
                    eEffect = EffectBlindness();
                    eDur = EffectBeam(VFX_BEAM_BLACK,OBJECT_SELF, BODY_NODE_CHEST);
                    eDur2 =EffectVisualEffect(VFX_DUR_BLIND);
                    eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
                    eDur = EffectLinkEffects(eEffect,eDur);
                    eDur = EffectLinkEffects(eDur2,eDur);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oSpellTarget,RoundsToSeconds(d2()));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
                             break;


            //------------------------------------------------------------------
            // Melee
            //------------------------------------------------------------------
            case 4: eEffect = EffectSlow();
                    eVis = EffectVisualEffect(VFX_IMP_SLOW);
                    eDur = EffectVisualEffect(VFX_DUR_ICESKIN);
                    eDur = EffectLinkEffects (eEffect,eDur);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oSpellTarget,RoundsToSeconds(d4()));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
                    break;

            case 5: eEffect = EffectKnockdown();
                    eVis = EffectVisualEffect(VFX_IMP_STUN);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEffect,oSpellTarget,6.0f);
                    break;

            case 6:
                    eEffect = EffectDamage(d4(2),DAMAGE_TYPE_FIRE);
                    eDur = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
                    eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEffect,oSpellTarget,6.0f);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oSpellOrigin,4.0f);
                    break;

            case 7:
                    eEffect = EffectMissChance(50,MISS_CHANCE_TYPE_VS_MELEE);
                     eDur = EffectVisualEffect(VFX_DUR_STONEHOLD);
                    eDur = EffectLinkEffects(eDur,eEffect);
                    eDur = EffectLinkEffects(EffectCutsceneImmobilize(),eDur);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oSpellTarget,RoundsToSeconds(d3()));
                    break;

        }
   }
}
