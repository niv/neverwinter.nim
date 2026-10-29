//::///////////////////////////////////////////////
//:: Alchemists fire
//:: x0_s3_alchem
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grenade.
    Fires at a target. If hit, the target takes
    direct damage. If missed, all enemies within
    an area of effect take splash damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
void main()
{
    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nCnt;
    effect eMissile;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    location lTarget = GetSpellTargetLocation();
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
     //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);


    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    int nTouch;
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);

        if (GetIsObjectValid(oTarget) == TRUE)
        {
            nTouch = TouchAttackRanged(oTarget);
        }
        else
        {
            nTouch = -1; // * this means that target was the ground, so the user
                        // * intended to splash
        }
        if (nTouch >= 0)
        {
            eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
            //Roll damage
            int nDam = d6(1);

            if(nTouch == 2)
            {
                nDam *= 2;
            }

            //Set damage effect
            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_FIRE);
            //Apply the MIRV and damage effect

            // * only damage enemies
        	if(!GetIsReactionTypeFriendly(oTarget))
        	{
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
            }

        //    ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
        }
        else
        {
            // * Splash damage
           eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
           SpeakString("splash");
           // * need to determine by own 'miss' area
           // * and do an explosion from that point

           // TEMP: assume miss is on object?

        //   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eMissile, GetSpellTargetLocation());

        }

}



