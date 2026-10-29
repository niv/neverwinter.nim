//::///////////////////////////////////////////////
//:: x0_inc_portal
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This include file is for the portal stone.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

// * CONSTANT DECLARATIONS

//int PORTAL_COST_DEAD = 100;
//int PORTAL_COST_ANCHOR1 = 100;
//int PORTAL_COST_ANCHOR2 = 500;
//int PORTAL_COST_ANCHOR3 = 1000;
//int PORTAL_COST_ANCHOR4 = 2000;
//int PORTAL_COST_ANCHOR5 = 5000;
//int PORTAL_COST_JUMPTOANCHOR = 100;
#include "x0_i0_henchman"

string BASE_ANCHOR ="WBASE"; // * base anchor for the area

// * FUNCTION DECLARATIONS
void PortalSetupTokens();
int PortalHasGold(int nConstant, object oPC);
void PortalTakeGold(int nConstant, object oPC);
int PortalAnchorExists(int nAnchor, object oPC);
int PortalAllAnchorExists(object oPC);
int PortalNoAnchorExists(object oPC);
int PortalGetNextAnchor(object oPC); // * returns the next # of anchor allowed to be made, returns -1 if all are made
void PortalCreateAnchor(int nAnchor, object oPC);
string PortalGetAnchorName(int nAnchor, object oPC);
object PortalGetAnchor(int nAnchor, object oPC);
void PortalDeleteAnchor(int nAnchor, object oPC);
void PortalJumpAnchor(int nAnchor, object oPC);
void PortalJumpHall(object oPC);

int PortalPlayerDied(object oPC);
void PortalJumpToPlayerDeath(object oPC);
void PortalJumpToHero(object oPC);

// * Rogue stone functions
int PortalHasRogueStone(object oPC);
// * Rogue stone functions
void PortalTakeRogueStone(object oPC);


//******************
//* FUNCTION DEFINITIONS
//******************

//::///////////////////////////////////////////////
//:: SetupTokens
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets up the dialog tokens for the Portal stone
    to work correctly.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void PortalSetupTokens()
{
//    SetCustomToken(1001, IntToString(PORTAL_COST_DEAD));
//    SetCustomToken(1002, IntToString(PORTAL_COST_ANCHOR1));
//    SetCustomToken(1003, IntToString(PORTAL_COST_ANCHOR2));
//    SetCustomToken(1004, IntToString(PORTAL_COST_ANCHOR3));
//    SetCustomToken(1005, IntToString(PORTAL_COST_ANCHOR4));
//    SetCustomToken(1006, IntToString(PORTAL_COST_ANCHOR5));
//    SetCustomToken(1007, IntToString(PORTAL_COST_JUMPTOANCHOR));
}

// * checks the Portal stone in the player's pack to see
// * if they have a Rogue Stone -- Rogue Stones are
// * required for teleportation
int PortalStoneHasRogueStone(object oPC)
{
    object oFirst = GetFirstItemInInventory(oPC);
    int bFound = FALSE;
    // * cycle through, looking for Rogue Stones
    // * inside a Portal Stone
    while (GetIsObjectValid(oFirst) == TRUE)
    {
        if (GetTag(oFirst) == "x2_p_rogue")
        {

            bFound = TRUE;
        }
        oFirst = GetNextItemInInventory(oPC);
    }
    return bFound;
}
int PortalHasGold(int nConstant, object oPC)
{
    if (GetGold(oPC) >= nConstant)
    {
        return TRUE;
    }
    return FALSE;
}
void PortalTakeGold(int nConstant, object oPC)
{
    TakeGoldFromCreature(nConstant, oPC, TRUE);
}
string PortalGetAnchorName(int nAnchor, object oPC)
{
    string sObjectID = GetName(oPC); //ObjectToString(oPC);
    string sTag = "W" + IntToString(nAnchor)+ "P" +  sObjectID;  //W1P1
    
    if (nAnchor == 0)
    {
        sTag = BASE_ANCHOR;
    }
    return sTag;
}
object PortalGetAnchor(int nAnchor, object oPC)
{
    return GetObjectByTag(PortalGetAnchorName(nAnchor, oPC));
}
int PortalAnchorExists(int nAnchor, object oPC)
{
    if (GetIsObjectValid(PortalGetAnchor(nAnchor, oPC)) == TRUE)
    {

        return TRUE;
    }
    else
    {

        return FALSE;
    }
}
int PortalAllAnchorExists(object oPC)
{
    return PortalAnchorExists(1, oPC) && PortalAnchorExists(2, oPC) && PortalAnchorExists(3, oPC) &&
      PortalAnchorExists(4, oPC) && PortalAnchorExists(5, oPC);
}
int PortalNoAnchorExists(object oPC)
{
    return !PortalAnchorExists(0, oPC) && !PortalAnchorExists(1, oPC) && !PortalAnchorExists(2, oPC) && !PortalAnchorExists(3, oPC) &&
      !PortalAnchorExists(4, oPC) && !PortalAnchorExists(5, oPC);
}

//::///////////////////////////////////////////////
//:: PortalGetNextAnchor
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Figures out the next anchor that could be made
    Valid from 1..5.
    For example: if portals 1 and 2 exist, then
    Portal3 can be made
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int PortalGetNextAnchor(object oPC) // * returns the next # of anchor allowed to be made, returns -1 if all are made
{
    int i=1;
    int bBroke = FALSE;
    for (i = 1; i<= 5; i++)
    {
        if (PortalAnchorExists(i, oPC) == FALSE)
        {
            bBroke = TRUE;
            break;
        }
    }
    // * All anchors exist
    if (bBroke == FALSE)
    {
        i = -1;
    }
    return i;
}
// *Creates a blank waypoint with the appropriate NAME as generated by the PLAYER NAME
void PortalCreateAnchor(int nAnchor, object oPC)
{
    //some areas cannot be used as anchors...
    object oArea = GetArea(oPC);
    if ((GetTag(oArea) != "HallofDoors") && (GetTag(oArea) != "mod1_hellgate"))
    {

        object oWay = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, PortalGetAnchorName(nAnchor, oPC));
        //SpeakString("TAG SHOULD BE = " +  PortalGetAnchorName(nAnchor, oPC));
        //SpeakString("NEW TAG = " + GetTag(oWay));
        // * create a red sparkle
        object oVisual = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_solred", GetLocation(oPC));

        object oItem = GetItemPossessedBy(oPC, "x2_p_rogue");
        int nStackSize = GetNumStackedItems(oItem);


        // * Set Custom Token to Area Name
        SetCustomToken(1000 + nAnchor, GetName(oArea));

        // * make sure only one rogue stone is taken away
        if (nStackSize == 1)
        {
            DestroyObject(oItem);
        }
        else
        {
            SetItemStackSize(oItem, nStackSize - 1);
        }

        SetLocalObject(oWay, "NW_L_MYVISUAL", oVisual);
    }
    else
    {
        FloatingTextStrRefOnCreature(3776, oPC, FALSE);
    }

}
void PortalDeleteAnchor(int nAnchor, object oPC)
{
    object oAnchor = PortalGetAnchor(nAnchor, oPC);
    if (GetIsObjectValid(oAnchor) == TRUE)
    {
        object oVis = GetLocalObject(oAnchor, "NW_L_MYVISUAL");
        DestroyObject(oAnchor, 0.1);
        DestroyObject(oVis, 0.1);
    }
}
int RestrictedArea(object oPC)
{
    object oArea = GetArea(oPC);
    if ((GetTag(oArea) == "NotthisOne") || (GetTag(oArea) == "Thisoneeither"))
    {
        return TRUE;
    }
    return FALSE;
}
void PortalJumpAnchor(int nAnchor, object oPC)
{
 object oAnchor;
    // * base anchor is a hard coded tag and costs nothing to jump to
    if (nAnchor == 0)
    {
        oAnchor = GetObjectByTag(BASE_ANCHOR);
    }
    else
    {

    }
    oAnchor = PortalGetAnchor(nAnchor, oPC);
    if (GetIsObjectValid(oAnchor) == TRUE)
    {
        // * if player in an area that forbids teleportation make this fail
      if (RestrictedArea(oPC) == TRUE)
      {
        AssignCommand(oPC, ActionSpeakStringByStrRef(10611));
        return;
      }
      object oClicker = oPC;
     // AssignCommand(GetItemActivator(), SpeakString(sTag));
        // * if I don't do this, gets stuck in a loop
        // * of casting.

        //Set the death variable so that is shows the PC as no longer dead
        //This function should only be called when a PC is leaving the Realm of the Reaper
        //This variable is set in the x2_death script
        SetLocalInt(oClicker, "NW_L_I_DIED", 0);
        
      AssignCommand(oClicker, ClearAllActions());
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_IMP_UNSUMMON), oClicker);
      AssignCommand(oClicker, PlaySound("as_mg_telepout1"));
      AssignCommand(oClicker, JumpToObject(oAnchor));

    }
}

//::///////////////////////////////////////////////
//:: PortalPlayerDied
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    REturns true if the player has died and not jumped
    back to that point of death.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int PortalPlayerDied(object oPC)
{
    if (GetLocalInt(oPC, "NW_L_I_DIED") == 1)
    {
        return TRUE;
    }
    {
        return FALSE;
    }
}

void MoveAllAssociates(object oParty, location lLoc)
{
            //check for associates
            int i = 0;
            object oHench;

            do
            {
                i++;
                oHench  = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oParty, i);
                if (GetIsObjectValid(oHench) == TRUE)
                {
                    if (GetIsFollower(oHench) == FALSE)
                    {
                        AssignCommand(oHench, JumpToLocation(lLoc));
                    }
                    else
                    // * is a follower.
                    // * remove them and signal an event
                    {
                        RemoveHenchman(oParty, oHench);
                        SignalEvent(oHench, EventUserDefined(19767));
                    }
                }

            }
            while (GetIsObjectValid(oHench) == TRUE);

            if (GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oParty) != OBJECT_INVALID)
                AssignCommand(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oParty), JumpToLocation(GetLocation(GetWaypointByTag("wp_reaperrealm"))));
            if (GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oParty)  != OBJECT_INVALID)
                AssignCommand(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oParty), JumpToLocation(GetLocation(GetWaypointByTag("wp_reaperrealm"))));
            if (GetAssociate(ASSOCIATE_TYPE_DOMINATED, oParty) != OBJECT_INVALID)
                DestroyObject(GetAssociate(ASSOCIATE_TYPE_DOMINATED, oParty));
            if (GetAssociate(ASSOCIATE_TYPE_SUMMONED, oParty) != OBJECT_INVALID)
                RemoveSummonedAssociate(oParty, GetAssociate(ASSOCIATE_TYPE_SUMMONED, oParty));
}

//::///////////////////////////////////////////////
//:: Name
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    PortalJumpHall - Jump the player to the Hall
    of doors - where he/she can then jump to
    any of their binding points.
    Any other party members within 10 meters of the PC
    will be teleported as well
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Nov 25/02
//:://////////////////////////////////////////////
//UPDATE - Jan 16/03 - Added party jump support
void PortalJumpHall(object oPC)
{
    object oParty = GetFirstFactionMember(oPC);
    object oAssociate;
    while (oParty != OBJECT_INVALID)
    {
        //check to see if this is the main PC
        if (GetName(oParty) != GetName(oPC))
        {
            //jump PC to hall
            AssignCommand(oParty, JumpToLocation(GetLocation(GetWaypointByTag("wp_reaperrealm"))));


            MoveAllAssociates(oParty, GetLocation(GetWaypointByTag("wp_reaperrealm")));

        }
        else //if it is another PC - must be within 10 meters
        {
            if (GetDistanceBetween(oParty, oPC) < 11.0)
            {
                //jump PC to hall
                AssignCommand(oParty, JumpToLocation(GetLocation(GetWaypointByTag("wp_reaperrealm"))));

                //check for associates
                MoveAllAssociates(oParty, GetLocation(GetWaypointByTag("wp_reaperrealm")));
            }
        }
        oParty = GetNextFactionMember(oPC);
    }

}

void PortalJumpToPlayerDeath(object oPC)
{
    SetLocalInt(oPC, "NW_L_I_DIED",0);
    object oClicker = oPC;
 // AssignCommand(GetItemActivator(), SpeakString(sTag));
    // * if I don't do this, gets stuck in a loop
    // * of casting.
  AssignCommand(oClicker, ClearAllActions());
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_IMP_UNSUMMON), oClicker);
  AssignCommand(oClicker, PlaySound("as_mg_telepout1"));
  AssignCommand(oClicker, JumpToLocation(GetLocalLocation(oClicker, "NW_L_I_DIED_HERE")));

}


void PortalJumpToHero(object oPC)
{
    object oHero = GetItemPossessor(GetObjectByTag("x2_p_reaper"));

    SetLocalInt(oPC, "NW_L_I_DIED",0);
    object oClicker = oPC;
 // AssignCommand(GetItemActivator(), SpeakString(sTag));
    // * if I don't do this, gets stuck in a loop
    // * of casting.
  AssignCommand(oClicker, ClearAllActions());
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_IMP_UNSUMMON), oClicker);
  AssignCommand(oClicker, PlaySound("as_mg_telepout1"));
  AssignCommand(oClicker, JumpToLocation(GetLocation(oHero)));

}


// * Rogue stone functions
int PortalHasRogueStone(object oPC)
{
    if (GetIsObjectValid(GetItemPossessedBy(oPC, "x2_p_rogue")) == TRUE)
    {
        return TRUE;
    }
    return FALSE;
}
void PortalTakeRogueStone(object oPC)
{
// * This code is being done elsewhere in the actual creation
// * of the binding
//    object oRogueStone = GetItemPossessedBy(oPC, "x2_p_rogue");
//    if (GetIsObjectValid(oRogueStone) == TRUE)
//    {
//        DestroyObject(oRogueStone);
//    }
}


