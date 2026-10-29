//::///////////////////////////////////////////////
//:: Name x2_death
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Pops up the death gui for the pc
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: July 22/03
//:://////////////////////////////////////////////
// *

#include "nw_i0_plot"
#include "x0_i0_henchman"
// * used only by automator
void Raise(object oPlayer);


    // * Pop up the death gui
void main()
{
    object oRespawner = GetLastPlayerDied();
    object oArea = GetArea(oRespawner);

    // * Bk - Nov 3 2003. If you die in final battle area, death is permanent, give correct feedback.
    if (GetTag(oArea) == "Waterdeep")
    {
        DelayCommand(1.75, PopUpDeathGUIPanel(oRespawner, FALSE, TRUE, 110120));
        return;
    }
    else
    // * If player dies in Chapter 3 -- death is permanent
    if (GetTag(GetModule()) == "x0_module3")
    {
        DelayCommand(1.75, PopUpDeathGUIPanel(oRespawner, FALSE, TRUE, 101127));
        return;
    }



        // * BK: Automation Control. Autopcs ignore death
    if (GetLocalInt(oRespawner, "NW_L_AUTOMATION") == 10)
    {
        Raise(oRespawner);
        int nTimesDied = GetLocalInt(oRespawner, "NW_L_PLAYER_DIED");
        nTimesDied++;
        SetLocalInt(oRespawner, "NW_L_PLAYER_DIED", nTimesDied);
        DelayCommand(1.0, ExecuteScript("crawl", oRespawner));
        return; // Raise and return
    }

    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oRespawner);

    // * consume rogue stone
    // * if no rogue stone to consume, permanent death
    object oStone = GetItemPossessedBy(oRespawner, "x2_p_rogue");

    int bAllowRespawn = TRUE;
    int nString = 40141;

    //Special Case - if the PC dies in House Maeviir in Chapter 2 -
    //Jump Any Henchmen outside so they don't trigger any cutscenes
    if (GetTag(oArea) == "q2a2_house")
    {
        object oTarget = GetWaypointByTag("wp_q2azesplot_deadhench");
        object oDeekin = GetObjectByTag("x2_hen_deekin");
        object oValen = GetObjectByTag("x2_hen_valen");
        object oNath = GetObjectByTag("x2_hen_nathyra");
        if (GetIsObjectValid(oDeekin) == TRUE)
        {
            if (GetMaster(oDeekin) == oRespawner)
            {
                AssignCommand(oDeekin, ClearAllActions(TRUE));
                DelayCommand(1.0, AssignCommand(oDeekin, JumpToObject(oTarget)));
            }
        }
        if (GetIsObjectValid(oValen) == TRUE)
        {
            if (GetMaster(oValen) == oRespawner)
            {
                AssignCommand(oValen, ClearAllActions(TRUE));
                DelayCommand(1.0, AssignCommand(oValen, JumpToObject(oTarget)));
            }
        }
        if (GetIsObjectValid(oNath) == TRUE)
        {
            if (GetMaster(oNath) == oRespawner)
            {
                AssignCommand(oNath, ClearAllActions(TRUE));
                DelayCommand(1.0, AssignCommand(oNath, JumpToObject(oTarget)));
            }
        }

    }
    // if the player dies during the Talona challenge, he won't be able to respawn.
    else if(GetTag(oArea) == "q6e_ShaorisFellTemple")
    {
        bAllowRespawn = FALSE;

        DelayCommand(1.75, PopUpDeathGUIPanel(oRespawner, FALSE, TRUE, 101134));
        return;
    }

    // * September 30 2003
    // * kick henchmen out of the party. They are on their own now.
   // SpawnScriptDebugger();
    RemoveAllFollowers(oRespawner, TRUE);
    

    if (GetIsObjectValid(oStone) == TRUE)
    {
        // SPECIAL CASES

        //If the PC dies during phase 1 or 2 of the Siege - pop up the modified death gui
        //'With your death the Seer's army was quickly overwhelmed.'
        if (GetLocalInt(GetModule(), "X2_Q2ABattle1Started") == 1 || GetLocalInt(GetModule(), "X2_Q2ABattle2Started") == 1)
        {
            bAllowRespawn = FALSE;
            nString = 85568;
            
            //if the rebels were betrayed - show a different string
            if (GetLocalInt(GetModule(), "X2_Q2ARebelsBetrayed") == 1)
                nString = 86677;
        }


        // * Don't actually destroy the crystal here. Only if you respawn.
        DelayCommand(1.75, PopUpDeathGUIPanel(oRespawner, bAllowRespawn , TRUE, nString));

    }
    else
    // * no focus crystal, permanent death
    {
        bAllowRespawn = FALSE;

        DelayCommand(1.75, PopUpDeathGUIPanel(oRespawner, FALSE, TRUE, 83902));
    }


}
// * used only by automator
void Raise(object oPlayer)
{
        effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);

        effect eBad = GetFirstEffect(oPlayer);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPlayer);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPlayer)), oPlayer);

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
                GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
                GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
                {
                    //Remove effect if it is negative.
                    RemoveEffect(oPlayer, eBad);
                }
            eBad = GetNextEffect(oPlayer);
        }
        //Fire cast spell at event for the specified target
        SignalEvent(oPlayer, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPlayer);
}
