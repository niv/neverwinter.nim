//::///////////////////////////////////////////////
//:: Name x1_chp1_respawn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Transports player back to Drogan's upon death...
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Feb 10/03
//:://////////////////////////////////////////////
// * Applies an XP and GP penalty
// * to the player respawning

#include "nw_i0_plot"
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
void ApplyPenalty(object oDead)
{
    int nXP = GetXP(oDead);
    int nPenalty = 50 * GetHitDice(oDead);
    int nHD = GetHitDice(oDead);
    // * You can not lose a level with this respawning
    int nMin = ((nHD * (nHD - 1)) / 2) * 1000;

    int nNewXP = nXP - nPenalty;
    if (nNewXP < nMin)
       nNewXP = nMin;
    SetXP(oDead, nNewXP);
    //int nGoldToTake =    FloatToInt(0.10 * GetGold(oDead));
    // * a cap of 10 000gp taken from you
    //if (nGoldToTake > 10000)
    //{
    //    nGoldToTake = 10000;
    //}
    //AssignCommand(oDead, TakeGoldFromCreature(nGoldToTake, oDead, TRUE));
    DelayCommand(4.0, FloatingTextStrRefOnCreature(58299, oDead, FALSE));
    //DelayCommand(4.8, FloatingTextStrRefOnCreature(58300, oDead, FALSE));

}


    // * bring the player back to life, fully healed and
    // * move them to Drogan's House
void main()
{



    object oRespawner = GetLastRespawnButtonPresser();
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oRespawner);

    // * remove focus crystals
    object oCrystal = GetItemPossessedBy(oRespawner, "focuscrystal");
    if (GetIsObjectValid(oCrystal) == TRUE)
    {
       DestroyObject(oCrystal);
    }

    //Make friendly to Each of the 3 common factions
    if (GetStandardFactionReputation(STANDARD_FACTION_COMMONER, oRespawner) <= 10)
    {
        SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 80, oRespawner);
        SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 80, oHench);
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_DEFENDER, oRespawner) <= 10)
    {
        SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 80, oRespawner);
        SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 80, oHench);
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_MERCHANT, oRespawner) <= 10)
    {
        SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 80, oRespawner);
        SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 80, oHench);
    }
    //SPECIAL CASES - for non-standard factions
    object oPiper = GetObjectByTag("q1gpiper");
    if (GetIsObjectValid(oPiper))
    {
        SetIsTemporaryFriend(oRespawner, oPiper);
    }

    DelayCommand(2.0, Raise(oRespawner));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oRespawner));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oRespawner)), oRespawner));
    DelayCommand(2.0, RemoveEffects(oRespawner));


    //* Return PC to Drogan's House



    string sDestTag =  "X1_TPORT_LOC";
    string sArea = GetTag(GetArea(oRespawner));
    //Set a location on the PC for where he died..
    SetLocalLocation(oRespawner, "X1_DEATHPLACE", GetLocation(oRespawner));
    /*
      1 SPECIAL CASE
    */
    if (sArea == "EXCEPTION")
    {
        sDestTag = "";
    }

    if (GetIsObjectValid(GetObjectByTag(sDestTag)))
    {
        if (sDestTag == "X1_TPORT_LOC")
        {
            object oPriest = GetObjectByTag("NW_DEATH_CLERIC");
            SetLocalLocation(oRespawner, "NW_L_I_DIED_HERE", GetLocation(oRespawner));
            SetLocalInt(oRespawner, "NW_L_I_DIED", 1);
            SetLocalObject(oPriest, "NW_L_LASTDIED", oRespawner);
            // * April 2002: Moved penalty here, only when going back to the death temple
            ApplyPenalty(oRespawner);
        }
        else if (sDestTag == "")
        {
            sDestTag = "X1_TPORT_LOC";
        }
        object oSpawnPoint = GetObjectByTag(sDestTag);
        DelayCommand(2.0, AssignCommand(oRespawner,JumpToLocation(GetLocation(oSpawnPoint))));

        //Jump any Henchmen to the PC
        object oMissingHench = GetLocalObject(oRespawner, "Q1DHENCHMAN");
        if (oMissingHench != OBJECT_INVALID)
        {
            AddHenchman(oRespawner, oMissingHench);
            SetLocalObject(oRespawner, "Q1DHENCHMAN", OBJECT_INVALID);
        }

        object oHenchman = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oRespawner);
        if (oHenchman != OBJECT_INVALID)
        {
            DelayCommand(2.5, AssignCommand(oHenchman,JumpToLocation(GetLocation(oSpawnPoint))));

        }
    }
    else
    {
        // * do nothing, just 'res where you are.
    }

}
