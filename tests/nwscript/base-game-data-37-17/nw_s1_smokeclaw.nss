//::///////////////////////////////////////////////
//:: Smoke Claws
//:: NW_S1_SmokeClaw
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If a Belker succeeds at a touch attack the
    target breaths in part of the Belker and suffers
    3d4 damage per round until a Fortitude save is
    made.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 23 , 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main ()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int bSave = FALSE;
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
    effect eSmoke;
    float fDelay = 0.0;
    //Make a touch attack
    if(TouchAttackMelee(oTarget))
    {
    	if(!GetIsReactionTypeFriendly(oTarget))
    	{
            //Make a saving throw check
            while (bSave == FALSE)
            {
                //Make a saving throw check
                if(!/*FortSave*/MySavingThrow(SAVING_THROW_FORT, oTarget, 14, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                {
                   bSave = TRUE;
                }
                else
                {
                    //Set damage
                    eSmoke = EffectDamage(d4(3));
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSmoke, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    //Increment the delay
                    fDelay = fDelay + 6.0;
                }
            }
        }
    }
}
