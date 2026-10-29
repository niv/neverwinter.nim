//::///////////////////////////////////////////////
//:: Name x1_chp1_death
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Pops up the death gui for the pc
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Feb 10/03
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

    /// * end the game if the player dies before the first cutscene in XP1
    if (GetTag(GetModule()) == "x0_module1")
    {
        if (GetLocalInt(GetModule(), "X1_CUT1RUNNING") < 2)
        {
            EndGame("");
        }
    }
    


    //SPECIAL CASES

    /*If Ferran (q1ferran), the elf ranger in the foothills, ever kills the PC,
    he should leave the area permanently.
    As well, if he kills the PC and the PC had the horns (q1foot_horns) item on him,
    destroy them (Ferran takes them)
    */
    object oKiller = GetLastHostileActor(oRespawner);
    if (GetTag(oKiller) == "q1ferran")
    {
        SetLocalInt(oKiller, "nFleeArea", 1);
        object oHorns = GetItemPossessedBy(oRespawner, "q1foot_horns");
        if (GetIsObjectValid(oHorns) == TRUE)
        {
            DestroyObject(oHorns);
            CreateItemOnObject("q1foot_horns", oKiller);
            AddJournalQuestEntry("q1foot_horns", 36, oRespawner);
        }
    }
    /* If henchman is in dying mode
         - CHAPTER 1: They should be raised and teleported to Drogan's House
         - OTHER CHAPTERS: They should remain where they are, waiting for rescue
    */
    
    //SpawnScriptDebugger();
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oRespawner);
    
    int bInChapter1 = FALSE;
    if (GetTag(GetModule()) == "x0_module1")
    {
        bInChapter1 = TRUE;
    }
    
    if (GetIsObjectValid(oHench) == TRUE && GetIsHenchmanDying(oHench) == TRUE)
    {

            // * only in Chapter 1 will the henchmen respawn
            // * somewhere, otherwise they'll stay where they are.
            if (bInChapter1 == TRUE)
            {   RemoveHenchman(oRespawner, oHench);
                // Indicate that this master got us killed
                SetCommandable(TRUE, oHench);
                SetKilled(oRespawner, oHench);
                // Do the respawn
                PostRespawnCleanup(oHench);
                AssignCommand(oHench, DelayCommand(1.0, RespawnHenchman(oHench)));
                //DelayCommand(1.1, SetCommandable(TRUE, oHench));
            }
    }
    if (bInChapter1 == TRUE)
    {
        // * consume focus crystal
        // * if no focus crystal to consume, permanent death
        object oCrystal = GetItemPossessedBy(oRespawner, "focuscrystal");
        object oRing = GetItemPossessedBy(oRespawner, "xp1_mystrashand");
        
        int bAllowRespawn = TRUE;
        int nString = 40526;
        
        if (GetIsObjectValid(oCrystal) == TRUE && GetIsObjectValid(oRing) == TRUE)
        {
           // DestroyObject(oCrystal);
           // * Don't actually destroy the crystal here. Only if you respawn.
        }
        else
        // * no focus crystal, permanent death
        {
            bAllowRespawn = FALSE;
            nString = 40142;
        }
        DelayCommand(1.75, PopUpDeathGUIPanel(oRespawner, bAllowRespawn , TRUE, nString));
    }
    else
    // * death without respawning
    {
        DelayCommand(1.75, PopUpDeathGUIPanel(oRespawner, FALSE, TRUE, 40141));
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
