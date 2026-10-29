//::///////////////////////////////////////////////
//:: Death Script
//:: NW_O0_DEATH.NSS
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script handles the default behavior
    that occurs when a player dies.

    BK: October 8 2002: Overriden for Expansion

    Deva Winblood:  April 21th, 2008: Modified to
    handle dismounts when PC dies while mounted.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: November 6, 2001
//:://////////////////////////////////////////////

#include "x3_inc_horse"

 /*
void ClearAllFactionMembers(object oMember, object oPlayer)
{
//    AssignCommand(oMember, SpeakString("here"));
    AdjustReputation(oPlayer, oMember, 100);
    SetLocalInt(oPlayer, "NW_G_Playerhasbeenbad", 10); // * Player bad
    object oClear = GetFirstFactionMember(oMember, FALSE);
    while (GetIsObjectValid(oClear) == TRUE)
    {
        ClearPersonalReputation(oPlayer, oClear);
        oClear = GetNextFactionMember(oMember, FALSE);
    }
}   */
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


///////////////////////////////////////////////////////////////[ MAIN ]/////////
void main()
{
    object oPlayer = GetLastPlayerDied();
    object oHorse;
    object oInventory;
    string sID;
    int nC;
    string sT;
    string sR;
    int nCH;
    int nST;
    object oItem;
    effect eEffect;
    string sDB="X3SADDLEBAG"+GetTag(GetModule());
    if (GetStringLength(GetLocalString(GetModule(),"X3_SADDLEBAG_DATABASE"))>0) sDB=GetLocalString(GetModule(),"X3_SADDLEBAG_DATABASE");
    if (HorseGetIsMounted(oPlayer))
    { // Dismount and then die
        //SetCommandable(FALSE,oPlayer);
        //ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPlayer);
        DelayCommand(0.3,HORSE_SupportResetUnmountedAppearance(oPlayer));
        DelayCommand(3.0,HORSE_SupportCleanVariables(oPlayer));
        DelayCommand(1.0,HORSE_SupportRemoveACBonus(oPlayer));
        DelayCommand(1.0,HORSE_SupportRemoveHPBonus(oPlayer));
        DelayCommand(1.1,HORSE_SupportRemoveMountedSkillDecreases(oPlayer));
        DelayCommand(1.1,HORSE_SupportAdjustMountedArcheryPenalty(oPlayer));
        DelayCommand(1.2,HORSE_SupportOriginalSpeed(oPlayer));
        if (!GetLocalInt(GetModule(),"X3_HORSE_NO_CORPSES"))
        { // okay to create lootable horse corpses
            sR=GetSkinString(oPlayer,"sX3_HorseResRef");
            sT=GetSkinString(oPlayer,"sX3_HorseMountTag");
            nCH=GetSkinInt(oPlayer,"nX3_HorseAppearance");
            nST=GetSkinInt(oPlayer,"nX3_HorseTail");
            nC=GetLocalInt(oPlayer,"nX3_HorsePortrait");
            if (GetStringLength(sR)>0&&GetStringLeft(sR,GetStringLength(HORSE_PALADIN_PREFIX))!=HORSE_PALADIN_PREFIX)
            { // create horse
                oHorse=HorseCreateHorse(sR,GetLocation(oPlayer),oPlayer,sT,nCH,nST);
                SetLootable(oHorse,TRUE);
                SetPortraitId(oHorse,nC);
                SetLocalInt(oHorse,"bDie",TRUE);
                AssignCommand(oHorse,SetIsDestroyable(FALSE,TRUE,TRUE));
            } // create horse
        } // okay to create lootable horse corpses
        oInventory=GetLocalObject(oPlayer,"oX3_Saddlebags");
        sID=GetLocalString(oPlayer,"sDB_Inv");
        if (GetIsObjectValid(oInventory))
        { // drop horse saddlebags
            if (!GetIsObjectValid(oHorse))
            { // no horse created
                HORSE_SupportTransferInventory(oInventory,OBJECT_INVALID,GetLocation(oPlayer),TRUE);
            } // no horse created
            else
            { // transfer to horse
                HORSE_SupportTransferInventory(oInventory,oHorse,GetLocation(oHorse),TRUE);
                //DelayCommand(2.0,PurgeSkinObject(oHorse));
                //DelayCommand(3.0,KillTheHorse(oHorse));
                //DelayCommand(1.8,PurgeSkinObject(oHorse));
            } // transfer to horse
        } // drop horse saddlebags
        else if (GetStringLength(sID)>0)
        { // database based inventory
            nC=GetCampaignInt(sDB,"nCO_"+sID);
            while(nC>0)
            { // restore inventory
                sR=GetCampaignString(sDB,"sR"+sID+IntToString(nC));
                sT=GetCampaignString(sDB,"sT"+sID+IntToString(nC));
                nST=GetCampaignInt(sDB,"nS"+sID+IntToString(nC));
                nCH=GetCampaignInt(sDB,"nC"+sID+IntToString(nC));
                DeleteCampaignVariable(sDB,"sR"+sID+IntToString(nC));
                DeleteCampaignVariable(sDB,"sT"+sID+IntToString(nC));
                DeleteCampaignVariable(sDB,"nS"+sID+IntToString(nC));
                DeleteCampaignVariable(sDB,"nC"+sID+IntToString(nC));
                if (!GetIsObjectValid(oHorse))
                { // no lootable corpse
                    oItem=CreateObject(OBJECT_TYPE_ITEM,sR,GetLocation(oPlayer),FALSE,sT);
                } // no lootable corpse
                else
                { // lootable corpse
                    oItem=CreateItemOnObject(sR,oHorse,nST,sT);
                } // lootable corpse
                if (GetItemStackSize(oItem)!=nST) SetItemStackSize(oItem,nST);
                if (nCH>0) SetItemCharges(oItem,nCH);
                nC--;
            } // restore inventory
            DeleteCampaignVariable(sDB,"nCO_"+sID);
            //DelayCommand(2.0,PurgeSkinObject(oHorse));
            if (GetIsObjectValid(oHorse)&&GetLocalInt(oHorse,"bDie")) DelayCommand(3.0,KillTheHorse(oHorse));
            //DelayCommand(2.5,PurgeSkinObject(oHorse));
        } // database based inventory
        else if (GetIsObjectValid(oHorse))
        { // no inventory
            //DelayCommand(1.0,PurgeSkinObject(oHorse));
            DelayCommand(2.0,KillTheHorse(oHorse));
            //DelayCommand(1.8,PurgeSkinObject(oHorse));
        } // no inventory
        //eEffect=EffectDeath();
        //DelayCommand(1.6,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffect,oPlayer));
        //DelayCommand(1.7,SetCommandable(TRUE,oPlayer));
        //return;
    } // Dismount and then die

    // * increment global tracking number of times that I died
    SetLocalInt(oPlayer, "NW_L_PLAYER_DIED", GetLocalInt(oPlayer, "NW_L_PLAYER_DIED") + 1);

    // * BK: Automation Control. Autopcs ignore death
    if (GetLocalInt(oPlayer, "NW_L_AUTOMATION") == 10)
    {
        Raise(oPlayer);
        DelayCommand(1.0, ExecuteScript("crawl", OBJECT_SELF));
        return; // Raise and return
    }


    // * Handle Spirit of the Wood Death
     string sArea = GetTag(GetArea(oPlayer));
/*
    if (sArea == "MAP_M2Q2F2" && GetDistanceBetweenLocations(GetLocation(GetObjectByTag("M2Q2F2_M2Q2G")), GetLocation(oPlayer)) < 5.0 && GetLocalInt(GetModule(),"NW_M2Q2E_WoodsFreed") == 0)
    {
        int bValid;

        Raise(oPlayer);
        string sDestTag = "WP_M2Q2GtoM2Q2F";
        object oSpawnPoint = GetObjectByTag(sDestTag);
        AssignCommand(oPlayer,JumpToLocation(GetLocation(oSpawnPoint)));
        return;

    }
*/
    // * in last level of the Sourcestone, move the player to the beginning of the area
    // * May 16 2002: or the main area of the Snowglobe (to prevent plot logic problems).
    // * May 21 2002: or Castle Never
    if (sArea == "M4Q1D2" || sArea == "M3Q3C" || sArea == "MAP_M1Q6A")
    {

        //Raise(oPlayer);
        //string sDestTag = "M4QD07_ENTER";
        //object oSpawnPoint = GetObjectByTag(sDestTag);
//        AssignCommand(oPlayer, DelayCommand(1.0, JumpToLocation(GetLocation(oSpawnPoint))));
// * MAY 2002: Just popup the YOU ARE DEAD panel at this point
        DelayCommand(2.5, PopUpDeathGUIPanel(oPlayer,FALSE, TRUE, 66487));
        return;
    }

    // * make friendly to Each of the 3 common factions
    AssignCommand(oPlayer, ClearAllActions());
    // * Note: waiting for Sophia to make SetStandardFactionReptuation to clear all personal reputation
    if (GetStandardFactionReputation(STANDARD_FACTION_COMMONER, oPlayer) <= 10)
    {   SetLocalInt(oPlayer, "NW_G_Playerhasbeenbad", 10); // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 80, oPlayer);
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_MERCHANT, oPlayer) <= 10)
    {   SetLocalInt(oPlayer, "NW_G_Playerhasbeenbad", 10); // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 80, oPlayer);
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_DEFENDER, oPlayer) <= 10)
    {   SetLocalInt(oPlayer, "NW_G_Playerhasbeenbad", 10); // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 80, oPlayer);
    }

    DelayCommand(2.5, PopUpGUIPanel(oPlayer,GUI_PANEL_PLAYER_DEATH));

}
///////////////////////////////////////////////////////////////[ MAIN ]/////////

