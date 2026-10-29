//:://////////////////////////////////////////////////
//:: X0_CH_HEN_SPAWN
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Henchman-specific OnSpawn handler for XP1. Based on NW_CH_AC9 by Bioware.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 10/09/2002
//:://////////////////////////////////////////////////

#include "x0_inc_henai"
#include "x2_inc_banter"
#include "x2_inc_globals"

// * there are only a couple potential interjections henchmen can say in c3
void StrikeOutStrings(object oNathyrra)
{
    SetLocalString(oNathyrra, "X2_L_RANDOMONELINERS", "26|27|28|29|30|");
    SetLocalString(oNathyrra, "X2_L_RANDOM_INTERJECTIONS", "6|7|");
}
            
void main()
{
    string sAreaTag = GetTag(GetArea(OBJECT_SELF));
    string sModuleTag = GetTag(GetModule());
    string sMyTag = GetTag(OBJECT_SELF);


    // * Setup how many random interjectiosn and popups they have
    if (sMyTag == "x2_hen_deekin")
    {
        SetNumberOfRandom("X2_L_RANDOMONELINERS", OBJECT_SELF, 50);
        SetNumberOfRandom("X2_L_RANDOM_INTERJECTIONS", OBJECT_SELF, 10);
    }
    else
    if (sMyTag == "x2_hen_daelan")
    {
        SetNumberOfRandom("X2_L_RANDOMONELINERS", OBJECT_SELF, 20);
        SetNumberOfRandom("X2_L_RANDOM_INTERJECTIONS", OBJECT_SELF, 2);
    }
    else
    if (sMyTag == "x2_hen_linu")
    {
        SetNumberOfRandom("X2_L_RANDOMONELINERS", OBJECT_SELF, 20);
        SetNumberOfRandom("X2_L_RANDOM_INTERJECTIONS", OBJECT_SELF, 2);
    }
    else
    if (sMyTag == "x2_hen_sharwyn")
    {
        SetNumberOfRandom("X2_L_RANDOMONELINERS", OBJECT_SELF, 20);
        SetNumberOfRandom("X2_L_RANDOM_INTERJECTIONS", OBJECT_SELF, 4);
    }
    else
    if (sMyTag == "x2_hen_tomi")
    {
        SetNumberOfRandom("X2_L_RANDOMONELINERS", OBJECT_SELF, 20);
        SetNumberOfRandom("X2_L_RANDOM_INTERJECTIONS", OBJECT_SELF, 4);
    }
    else
    if (sMyTag == "H2_Aribeth")
    {
        SetNumberOfRandom("X2_L_RANDOMONELINERS", OBJECT_SELF, 20);
        SetNumberOfRandom("X2_L_RANDOM_INTERJECTIONS", OBJECT_SELF, 2);
    }
    else
    // * valen and Nathyrra have certain random lines that only show up in
    // * in Chapter 2 (Chapter 3 they'll get this variable set on them
    // * as well, with different numbers)
    // * Basically #1-5 are Chapter 2 only, 26-30 are Chapter 3 only. The rest can show up anywhere
    if (sMyTag == "x2_hen_nathyra" || sMyTag == "x2_hen_valen")
    {
        // * only fire this in Chapter 2. THey setup differently in the transition from C2 to C3
        if (GetTag(GetModule()) == "x0_module2")
        {
            SetNumberOfRandom("X2_L_RANDOMONELINERS", OBJECT_SELF, 25);
            SetNumberOfRandom("X2_L_RANDOM_INTERJECTIONS", OBJECT_SELF, 3);
        }
        else
        {
            StrikeOutStrings(OBJECT_SELF);
        }

    }

    //Sets up the special henchmen listening patterns
    SetAssociateListenPatterns();

    // Set additional henchman listening patterns
    bkSetListeningPatterns();

    // Default behavior for henchmen at start
    SetAssociateState(NW_ASC_POWER_CASTING);
    SetAssociateState(NW_ASC_HEAL_AT_50);
    SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS);
    SetAssociateState(NW_ASC_DISARM_TRAPS);
    
    // * July 2003. Set this to true so henchmen
    // * will hopefully run off a little less often
    // * by default
    // * September 2003. Bad decision. Reverted back
    // * to original. This mode too often looks like a bug
    // * because they hang back and don't help each other out.
    //SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, TRUE);
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);

    //Use melee weapons by default
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE);

    // Set starting location
    SetAssociateStartLocation();

    // Set respawn location
    SetRespawnLocation();

    // For some general behavior while we don't have a master,
    // let's do some immobile animations
    SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);

    // **************************************
    // * CHAPTER 1
    // * Kill henchmen who spawn in
    // * to any area for the first time
    // * in Undermountain.
    // **************************************
    SetIsDestroyable(FALSE, TRUE, TRUE);
    
    // * September 2003
    // * Scan through all equipped items and make
    // * sure they are identified
    int i = 0;
    object oItem;
    for (i = INVENTORY_SLOT_HEAD; i<=INVENTORY_SLOT_CARMOUR; i++)
    {
        oItem = GetItemInSlot(i, OBJECT_SELF);
        if (GetIsObjectValid(oItem) == TRUE)
            SetIdentified( oItem, TRUE);
    }
    
    // *
    // * Special CHAPTER 1 - XP2
    // * Levelup code
    // *
    if (sModuleTag == "x0_module1" && GetLocalInt(GetModule(), "X2_L_XP2") == TRUE)
    {
        if (GetLocalInt(OBJECT_SELF, "X2_KilledInUndermountain") == 1)
            return;
        SetLocalInt(OBJECT_SELF, "X2_KilledInUndermountain", 1);

        //Level up henchman to level 13   if in Starting Room
        //Join script will level them up correctly once hired
        if (sAreaTag == "q2a_yawningportal" )
        {
            int nLevel = 1;
            for (nLevel = 1; nLevel < 14; nLevel++)
            {
                LevelUpHenchman(OBJECT_SELF);
            }
        }
        //'kill the henchman'
        
        // * do not kill if spawning in main room
        string szAreaTag = GetTag(GetArea(OBJECT_SELF));
        if (szAreaTag != "q2a_yawningportal" && szAreaTag != "q2c_um2east")
        {
            effect eDamage = EffectDamage(500);
            DelayCommand(10.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, OBJECT_SELF));
        }
    }
    
    // * Nathyrra in Chapter 1 is not allowed to have her inventory fiddled with
    if (sMyTag == "x2_hen_nathyrra" && sModuleTag == "x0_module1")
    {
        SetLocalInt(OBJECT_SELF, "X2_JUST_A_DISABLEEQUIP", 1);
    }
    
    
    // *
    // * if I am Aribeth then do my special level-up
    // *
    if (sMyTag == "H2_Aribeth")
    {
        LevelUpAribeth(OBJECT_SELF);
    }
}

