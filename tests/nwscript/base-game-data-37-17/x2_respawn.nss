//::///////////////////////////////////////////////
//:: Name x2_respawn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Transports player back to Purgatory on respawn...
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Feb 10/03
//:://////////////////////////////////////////////
// * Applies an XP and GP penalty
// * to the player respawning

#include "nw_i0_plot"
#include "x0_i0_henchman"

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


// *  Makes the standard factions neutral to the oChangeMe object
void AdjustReputationWithStandardFactions(object oMaster, object oChangeMe)
{
    //Make friendly to Each of the 3 common factions
    if (GetStandardFactionReputation(STANDARD_FACTION_COMMONER, oMaster) <= 10)
    {
        SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 80, oChangeMe);
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_DEFENDER, oMaster) <= 10)
    {
        SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 80, oChangeMe);
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_MERCHANT, oMaster) <= 10)
    {
        SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 80, oChangeMe);
    }
    //SPECIAL CASES - for non-standard factions
}

// * bring the player back to life, fully healed and
void main()
{



    object oRespawner = GetLastRespawnButtonPresser();
    object oHench;
    
    // * remove 1 rogue stone
    object oStone = GetItemPossessedBy(oRespawner, "x2_p_rogue");
    if (GetIsObjectValid(oStone) == TRUE)
    {
        int nStack = GetItemStackSize(oStone);
        if (nStack > 1)
            SetItemStackSize(oStone, nStack - 1);
        else
            DestroyObject(oStone);
    }

    // ****************************
    // Figure out where to go
    // ****************************
    
    
    //* Return PC to Purgatory

    string sDestTag =  "NW_DEATH_PLACE";
    string sArea = GetTag(GetArea(oRespawner));
    object oSpawnPoint;
    location lLoc;
    
    /*
      1 SPECIAL CASE
    */
    if (sArea == "mod1_hellgate")
    {
        sDestTag = "";
    }

    if (GetIsObjectValid(GetObjectByTag(sDestTag)))
    {
        if (sDestTag == "NW_DEATH_PLACE")
        {
            object oPriest = GetObjectByTag("NW_DEATH_CLERIC");
            SetLocalLocation(oRespawner, "NW_L_I_DIED_HERE", GetLocation(oRespawner));
            SetLocalInt(oRespawner, "NW_L_I_DIED", 1);
            SetLocalObject(oPriest, "NW_L_LASTDIED", oRespawner);
            // * April 2002: Moved penalty here, only when going back to the death temple
            //ApplyPenalty(oRespawner);
        }
        else if (sDestTag == "")
        {
            sDestTag = "NW_DEATH_PLACE";
        }
        oSpawnPoint = GetObjectByTag(sDestTag);
        lLoc = GetLocation(oSpawnPoint);
     }

    // ****************************
    // Iterate through followers
    // ****************************


    // *
    // * July 28 2003
    // * Go through all henchmen and remove
    // * any followers
    // * Adjust their reputations with the standard
    // * factions so that they are all friends again too
    int i = 0;
    do
    {
        i++;
        oHench  = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oRespawner, i);
        if (GetIsObjectValid(oHench) == TRUE)
        {
            AdjustReputationWithStandardFactions(oRespawner, oHench);
            if (GetIsFollower(oHench) == FALSE)
            {
                // * Teleport henchmen to respawn place
                if (GetIsObjectValid(oSpawnPoint) == TRUE)
                    DelayCommand(2.5, AssignCommand(oHench, JumpToLocation(lLoc)));
            }
            else
            // * is a follower.
            // * remove them and signal an event
            {
                RemoveHenchman(oRespawner, oHench);
                SignalEvent(oHench, EventUserDefined(19767));
            }
        }

    }
    while (GetIsObjectValid(oHench) == TRUE);
    
    AdjustReputationWithStandardFactions(oRespawner, oRespawner);


    DelayCommand(2.0, Raise(oRespawner));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oRespawner));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oRespawner)), oRespawner));
    DelayCommand(2.0, RemoveEffects(oRespawner));

    // ****************************
    // Go to teleporation place - Player
    // ****************************
    if (GetIsObjectValid(oSpawnPoint) == TRUE)
    {
        DelayCommand(2.0, AssignCommand(oRespawner,JumpToLocation(GetLocation(oSpawnPoint))));
    }
    else
    {
        // * do nothing, just 'res where you are.
    }

}
