//::///////////////////////////////////////////////
//:: Henchman Death Script
//::
//:: NW_CH_AC7.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: <description>
//:://////////////////////////////////////////////
//::
//:: Created By:
//:: Modified by:   Brent, April 3 2002
//::                Removed delay in respawning
//::                the henchman - caused bugs
//:://////////////////////////////////////////////

//::///////////////////////////////////////////////
//:: Greater Restoration
//:: NW_S0_GrRestore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes all negative effects of a temporary nature
    and all permanent effects of a supernatural nature
    from the character. Does not remove the effects
    relating to Mind-Affecting spells or movement alteration.
    Heals target for 5d8 + 1 point per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
#include "nw_i0_generic"
#include "nw_i0_plot"

/*
// * June 1: use RemoveEffects from plot include instead
void GreaterRestore(object oHench)
{
    //Declare major variables
    object oTarget = oHench;
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);

    effect eBad = GetFirstEffect(oTarget);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
            GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
            GetEffectType(eBad) == EFFECT_TYPE_POISON ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
        {
            //Remove effect if it is negative.
            RemoveEffect(oTarget, eBad);
        }
        eBad = GetNextEffect(oTarget);
    }
   // ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
}     */


void BringBack()
{
    SetLocalObject(OBJECT_SELF,"NW_L_FORMERMASTER", GetMaster());
    // : REMINDER: The delay is here   for a reason
    DelayCommand(0.1, RemoveEffects(OBJECT_SELF));
    DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectResurrection(), OBJECT_SELF));
    DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectHeal(GetMaxHitPoints(OBJECT_SELF)), OBJECT_SELF));
    DelayCommand(5.1, SetIsDestroyable(TRUE, TRUE, TRUE));
    object oWay = GetObjectByTag("NW_DEATH_TEMPLE");
    if (GetIsObjectValid(oWay) == TRUE)
    {
        // * if in Source stone area, respawn at opening to area
        if (GetTag(GetArea(OBJECT_SELF)) == "M4Q1D2")
        {
            DelayCommand(0.2, JumpToObject(GetObjectByTag("M4QD07_ENTER"), FALSE));
        }
        else
            DelayCommand(0.2, JumpToObject(oWay, FALSE));
    }
    else
        DelayCommand(0.3, ActionSpeakString("UT: No place to go"));


}
void main()
{
    // * This is used by the advanced henchmen
    // * Let Brent know if it interferes with animal
    // * companions et cetera
    if (GetIsObjectValid(GetMaster()) == TRUE)
    {
        object oMe = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, GetMaster());
        if (oMe == OBJECT_SELF
            // * this is to prevent 'double hits' from stopping
            // * the henchmen from moving to the temple of tyr
            // * I.e., henchmen dies 'twice', once after leaving  your party
            || GetLocalInt(OBJECT_SELF, "NW_L_HEN_I_DIED") == TRUE)
        {
           SetPlotFlag(oMe, TRUE);
           SetAssociateState(NW_ASC_IS_BUSY, TRUE);
           AddJournalQuestEntry("Henchman", 99, GetMaster(), FALSE, FALSE, FALSE);
           SetIsDestroyable(FALSE, TRUE, TRUE);
           SetLocalInt(OBJECT_SELF, "NW_L_HEN_I_DIED", TRUE);
       //     RemoveHenchman(GetMaster());
           // effect eRaise = EffectResurrection();
            ClearAllActions();
            DelayCommand(0.5, ActionDoCommand(SetCommandable(TRUE)));
            DelayCommand(5.0, ActionDoCommand(SetAssociateState(NW_ASC_IS_BUSY, FALSE)));

            DelayCommand(5.0, SetPlotFlag(oMe, FALSE));

            BringBack();
            SetCommandable(FALSE);


        }
        else
        // * I am a familiar, give 1d6 damage to my master
        if (GetAssociate(ASSOCIATE_TYPE_FAMILIAR, GetMaster()) == OBJECT_SELF)
        {
            // April 2002: Made it so that familiar death can never kill the player
            // only wound them.
            int nDam =d6();
            if (nDam >= GetCurrentHitPoints(GetMaster()))
            {
                nDam = GetCurrentHitPoints(GetMaster()) - 1;
            }
            effect eDam = EffectDamage(nDam);
            FloatingTextStrRefOnCreature(63489, GetMaster(), FALSE);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, GetMaster());
        }
    }
}
