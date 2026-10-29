//::///////////////////////////////////////////////
//:: Name: inc_mf_combat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Mindflayer Combat Round include file.
    Perform specific Mindflayer combat actions
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 5/02
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"
#include "NW_I0_SPELLS"

void ActionPsionicMB(object oSpellTarget);

void ActionPsionicCharm(object oSpellTarget);

void DetermineMindflayerCombat(object oTarget = OBJECT_INVALID)
{
    //FloatingTextStringOnCreature("In the function!!", GetFirstPC());
    //variables
    effect eEffect;
    int nTargetStunned = 0;
    //See if I have a target
    if (oTarget != OBJECT_INVALID)
    {
        //If I do have a target - is the target stunned and hit once
        if (GetName(GetLocalObject(OBJECT_SELF, "oLockedTarget")) == GetName(oTarget))
        {
            //FloatingTextStringOnCreature("Locked Target - trying to hit again", GetFirstPC());
            //if so finish him off
            if (GetDistanceToObject(oTarget) < 2.0)
            {
                PlayAnimation(ANIMATION_FIREFORGET_STEAL);
                if (TouchAttackMelee(oTarget) > 0)
                {
                    // Then target is hit and mind sucked! - Kill target, send message
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                    if (GetIsPC(oTarget))
                    {
                        FloatingTextStrRefOnCreature(3899, oTarget);
                    }
                }

                else
                {
                    SetLocalObject(OBJECT_SELF, "oLockedTarget", OBJECT_INVALID);
                    DelayCommand(6.0, DetermineMindflayerCombat(oTarget));
                }
            }
            else
            {
                SetLocalObject(OBJECT_SELF, "oLockedTarget", OBJECT_INVALID);
                //if (Random(2) == 1)
                //{
                    ActionMoveToObject(oTarget, TRUE);
                    DelayCommand(6.0, DetermineMindflayerCombat(oTarget));
                //}
                //else
                //{//Do confusion...
                //    ActionCastSpellAtObject(552, oTarget, METAMAGIC_ANY, TRUE);
                //}
            }
        }
        //else I have a target who hasn't been hit..check if he's stunned.
        else
        {
            nTargetStunned = 0;
            eEffect = GetFirstEffect(oTarget);
            while (GetIsEffectValid(eEffect))
            {
                //if the mindflayer created the effect - must be the stun effect
                //so the target is stunned
                if(GetEffectCreator(eEffect) == OBJECT_SELF)
                {
                    //FloatingTextStringOnCreature("Found a stunned target!!!!", GetFirstPC());
                    nTargetStunned = 1;
                }
                //else
                //{
                    //FloatingTextStringOnCreature("Didn't find a stunned target!!!!", GetFirstPC());
                //}
                eEffect = GetNextEffect(oTarget);
            }
            if (nTargetStunned == 1)
            {
                //FloatingTextStringOnCreature("Stunned Target - trying to hit", GetFirstPC());
                //yes he's stunned - so attempt a first attack on him
                if (GetDistanceToObject(oTarget) < 2.0)
                {
                    PlayAnimation(ANIMATION_FIREFORGET_STEAL);
                    if (TouchAttackMelee(oTarget) > 0)
                    {
                        // Then target is hit- commence mind sucking! - send message
                        SetLocalObject(OBJECT_SELF, "oLockedTarget", oTarget);
                            //**might want some kind of effect here**
                        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                        if (GetIsPC(oTarget))
                        {
                            FloatingTextStrRefOnCreature(3900, oTarget);
                        }
                        DelayCommand(6.0, DetermineMindflayerCombat(oTarget));
                    }
                    else
                    {
                        DelayCommand(6.0, DetermineMindflayerCombat(oTarget));
                    }
                }
                else
                {
                    SetLocalObject(OBJECT_SELF, "oLockedTarget", OBJECT_INVALID);
                    //if (Random(2) == 1)
                    //{
                        ActionMoveToObject(oTarget, TRUE);
                        DelayCommand(6.0, DetermineMindflayerCombat(oTarget));
                    //}
                    //else
                    //{//Do confusion...
                    //    ActionCastSpellAtObject(552, oTarget, METAMAGIC_ANY, TRUE);
                    //}
                }
            }
            //else he's not stunned - so use psionic stun power on him
            else
            {
                //FloatingTextStringOnCreature("Non-Stunned Target - trying to Stun", GetFirstPC());
                if (Random(2) == 1)
                {
                    ActionPsionicMB(oTarget);
                    //ActionCastSpellAtObject(551, oTarget, METAMAGIC_ANY, TRUE);
                }
                else
                {//Do confusion...
                    ActionPsionicCharm(oTarget);
                    ActionCastSpellAtObject(552, oTarget, METAMAGIC_ANY, TRUE);
                }
            }
        }
    }
    //If I have no target - find the first target in range
    else
    {
        //FloatingTextStringOnCreature("REALLY REALLY TRYING TO Acquire Target", GetFirstPC());
        object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY);
        if (oTarget == OBJECT_INVALID)
        {//if I can't find a target -hmmmm, just determinecombatround()
            //FloatingTextStringOnCreature("Can't find target", GetFirstPC());
            DetermineCombatRound();
        }
        //else - target found - see if he's stunned or not
        else
        {
            nTargetStunned = 0;
            eEffect = GetFirstEffect(oTarget);
            while (GetIsEffectValid(eEffect))
            {
                //if the mindflayer created the effect - must be the stun effect
                //so the target is stunned
                if(GetEffectCreator(eEffect) == OBJECT_SELF)
                {
                    //FloatingTextStringOnCreature("Adding to stunned target count!!!!", GetFirstPC());
                    nTargetStunned = 1;
                }
                //else
                //{
                    //FloatingTextStringOnCreature("NOT Adding to stunned target count!!!!", GetFirstPC());
                //}
                eEffect = GetNextEffect(oTarget);
            }
            if (nTargetStunned == 1)
            {
                //If I do have a target - is the target stunned and hit once
                if (GetName(GetLocalObject(OBJECT_SELF, "oLockedTarget")) == GetName(oTarget))
                {
                    //FloatingTextStringOnCreature("Really Locked Target - trying to hit again", GetFirstPC());
                    //if so finish him off
                    if (GetDistanceToObject(oTarget) < 2.0)
                    {
                        PlayAnimation(ANIMATION_FIREFORGET_STEAL);
                        if (TouchAttackMelee(oTarget) > 0)
                        {
                            // Then target is hit and mind sucked! - Kill target, send message
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                            if (GetIsPC(oTarget))
                            {
                                FloatingTextStrRefOnCreature(3899, oTarget);
                            }
                        }
                        else
                        {
                            SetLocalObject(OBJECT_SELF, "oLockedTarget", OBJECT_INVALID);
                            //if (Random(2) == 1)
                            //{
                                ActionMoveToObject(oTarget, TRUE);
                                DelayCommand(6.0, DetermineMindflayerCombat(oTarget));
                            //}
                            //else
                            //{//Do confusion...
                            //    ActionCastSpellAtObject(552, oTarget, METAMAGIC_ANY, TRUE);
                            //}
                        }
                    }
                    else
                    {
                        ActionMoveToObject(oTarget, TRUE);
                        SetLocalObject(OBJECT_SELF, "oLockedTarget", OBJECT_INVALID);
                        DelayCommand(6.0, DetermineMindflayerCombat(oTarget));
                    }
                }
                else
                {
                    //FloatingTextStringOnCreature("Acquired Stunned Target - trying to hit", GetFirstPC());
                    //yes he's stunned - so attempt a first attack on him
                    if (GetDistanceToObject(oTarget) < 2.0)
                    {
                        PlayAnimation(ANIMATION_FIREFORGET_STEAL);
                        if (TouchAttackMelee(oTarget) > 0)
                        {
                            // Then target is hit- commence mind sucking! - send message
                            SetLocalObject(OBJECT_SELF, "oLockedTarget", oTarget);
                            //**might want some kind of effect here**
                            //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                            if (GetIsPC(oTarget))
                            {
                                FloatingTextStrRefOnCreature(3900, oTarget);
                            }
                        }
                        else
                        {
                            DelayCommand(6.0, DetermineMindflayerCombat(oTarget));
                        }
                    }
                    else
                    {
                        SetLocalObject(OBJECT_SELF, "oLockedTarget", OBJECT_INVALID);
                        if (Random(2) == 1)
                        {
                            ActionMoveToObject(oTarget, TRUE);
                            DelayCommand(6.0, DetermineMindflayerCombat(oTarget));
                        }
                        //else
                        //{//Do confusion...
                        //    ActionCastSpellAtObject(552, oTarget, METAMAGIC_ANY, TRUE);
                        //}
                    }
                }
            }
            //else he's not stunned - so use psionic stun power on him
            else
            {
                //FloatingTextStringOnCreature("Non-Stunned Target - trying to Stun", GetFirstPC());
                if (Random(2) == 1)
                {
                    ActionCastSpellAtObject(551, oTarget, METAMAGIC_ANY, TRUE);
                }
                else
                {//Do confusion...
                    ActionCastSpellAtObject(552, oTarget, METAMAGIC_ANY, TRUE);
                }
            }
        }

    }



}

//::///////////////////////////////////////////////
//:: Cone: Mindflayer Mind Blast
//:: x2_m1_mindblast
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Anyone caught in the cone must make a
    Will save (DC 17) or be stunned for 3d4 rounds
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 5/02
//:://////////////////////////////////////////////
void ActionPsionicMB(object oSpellTarget)
{

    ActionCastFakeSpellAtObject(551, oSpellTarget);
    //Declare major variables
    int nHD = GetHitDice(OBJECT_SELF);
    int nStunTime;
    int nDC = 17;
    float fDelay;



    location lTargetLocation = GetLocation(oSpellTarget);
    object oTarget;
    effect eCone;
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);

    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 15.0, lTargetLocation, TRUE);
    //Get first target in spell area
    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 551));
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //See if target makes a Will Save.
            if (WillSave(oTarget, nDC) < 1)
            {
                //Calculate the length of the stun
                nStunTime = d4(3);
                //Set stunned effect
                eCone = EffectStunned();
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oTarget, RoundsToSeconds(nStunTime)));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 15.0, lTargetLocation, TRUE);
    }
}

//::///////////////////////////////////////////////
//:: [Psionic Charm Monster]
//:: [x2_m1_CharmMon.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save DC 17 or the target is charmed for 4 rounds
//::   **UPDATE - Now doing confused effect instead of charmed**
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 5, 2002
//:://////////////////////////////////////////////
//::
void ActionPsionicCharm(object oSpellTarget)
{
    ActionCastFakeSpellAtObject(552, oSpellTarget);
    //Declare major variables
    int nDuration = 4;
    int nDC = 17;
    location lTargetLocation = GetLocation(oSpellTarget);
    object oTarget;
    effect eGaze = EffectConfused();
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVisDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);

    effect eLink = EffectLinkEffects(eDur, eVisDur);

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
    	if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
    	{
            if(oTarget != OBJECT_SELF)
            {

                //Determine effect delay
                float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 552));
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                    eGaze = GetScaledEffect(eGaze, oTarget);
                    eLink = EffectLinkEffects(eLink, eGaze);

                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}
