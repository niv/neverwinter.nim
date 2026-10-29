//::///////////////////////////////////////////////
//:: Henchman Death Script
//::
//:: NW_CH_AC7.nss
//::
//:: Copyright (c) 2001-2008 Bioware Corp.
//:://////////////////////////////////////////////
//:: Official Campaign Henchmen Respawn
//:://////////////////////////////////////////////
//::
//:: Modified by:   Brent, April 3 2002
//::                Removed delay in respawning
//::                the henchman - caused bugs
//:
//::                Georg, Oct 8 2003
//::                Rewrote teleport to temple routine
//::                because it was broken by
//::                some delicate timing issues in XP2
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: April 9th, 2008
//:: Added Support for Dying Wile Mounted
//:://///////////////////////////////////////////////

#include "nw_i0_generic"
#include "nw_i0_plot"
#include "x3_inc_horse"

// -----------------------------------------------------------------------------
// Georg, 2003-10-08
// Rewrote that jump part to get rid of the DelayCommand Code that was prone to
// timing problems. If want to see a really back hack, this function is just that.
// -----------------------------------------------------------------------------
void WrapJump(string sTarget)
{
    if (GetIsDead(OBJECT_SELF))
    {
        // * Resurrect and heal again, just in case
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectResurrection(), OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectHeal(GetMaxHitPoints(OBJECT_SELF)), OBJECT_SELF);

        // * recursively call self until we are alive again
        DelayCommand(1.0f,WrapJump( sTarget));
        return;
    }
    // * since the henchmen are teleporting very fast now, we leave a bloodstain on the ground
    object oBlood = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_bloodstain", GetLocation(OBJECT_SELF));

    // * Remove blood after a while
    DestroyObject(oBlood,30.0f);

    // * Ensure the action queue is open to modification again
    SetCommandable(TRUE,OBJECT_SELF);

    // * Jump to Target
    JumpToObject(GetObjectByTag(sTarget), FALSE);

    // * Unset busy state
    ActionDoCommand(SetAssociateState(NW_ASC_IS_BUSY, FALSE));

    // * Make self vulnerable
    SetPlotFlag(OBJECT_SELF, FALSE);

    // * Set destroyable flag to leave corpse
    DelayCommand(6.0f, SetIsDestroyable(TRUE, TRUE, TRUE));

    // * if mounted make sure dismounted
    if (HorseGetIsMounted(OBJECT_SELF))
    { // dismount
        DelayCommand(3.0,AssignCommand(OBJECT_SELF,HorseDismountWrapper()));
    } // dismount

}

// -----------------------------------------------------------------------------
// Georg, 2003-10-08
// Changed to run the bad recursive function above.
// -----------------------------------------------------------------------------
void BringBack()
{
    object oSelf = OBJECT_SELF;

    SetLocalObject(oSelf,"NW_L_FORMERMASTER", GetMaster());
    RemoveEffects(oSelf);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectResurrection(), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectHeal(GetMaxHitPoints(OBJECT_SELF)), OBJECT_SELF);

    object oWay = GetObjectByTag("NW_DEATH_TEMPLE");

    if (GetIsObjectValid(oWay) == TRUE)
    {
        // * if in Source stone area, respawn at opening to area
        if (GetTag(GetArea(oSelf)) == "M4Q1D2")
        {
            DelayCommand(1.0, WrapJump("M4QD07_ENTER"));
        }
        else
        {
            DelayCommand(1.0, WrapJump(GetTag(oWay)));
        }
    }
    else
    {
        WriteTimestampedLogEntry("UT: No place to go");
    }

}


void main()
{
    SetLocalString(OBJECT_SELF,"sX3_DEATH_SCRIPT","nw_ch_ac7");
    if (HorseHandleDeath()) return;
    DeleteLocalString(OBJECT_SELF,"sX3_DEATH_SCRIPT");

    // * This is used by the advanced henchmen
    // * Let Brent know if it interferes with animal
    // * companions et cetera
    if (GetIsObjectValid(GetMaster()) == TRUE)
    {
        object oMe = OBJECT_SELF;
        if (GetAssociateType(oMe) == ASSOCIATE_TYPE_HENCHMAN
            // * this is to prevent 'double hits' from stopping
            // * the henchmen from moving to the temple of tyr
            // * I.e., henchmen dies 'twice', once after leaving  your party
            || GetLocalInt(oMe, "NW_L_HEN_I_DIED") == TRUE)
        {
            // -----------------------------------------------------------------------------
            // Georg, 2003-10-08
            // Rewrote code from here.
            // -----------------------------------------------------------------------------

           SetPlotFlag(oMe, TRUE);
           SetAssociateState(NW_ASC_IS_BUSY, TRUE);
           AddJournalQuestEntry("Henchman", 99, GetMaster(), FALSE, FALSE, FALSE);
           SetIsDestroyable(FALSE, TRUE, TRUE);
           SetLocalInt(OBJECT_SELF, "NW_L_HEN_I_DIED", TRUE);
           BringBack();

           // -----------------------------------------------------------------------------
           // End of rewrite
           // -----------------------------------------------------------------------------

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
