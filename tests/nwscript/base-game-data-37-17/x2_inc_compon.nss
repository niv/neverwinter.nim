//::///////////////////////////////////////////////
//:: x2_inc_compon
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    This include file has routines to handle the
    distribution of components requried for the
    XP2 crafting system.

*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  July 30, 2003
//:://////////////////////////////////////////////
const int MIN_SKILL_LEVEL = 5;


// * Drops craft items if killed or bashed
void craft_drop_items(object oSlayer);
// * handles dropping crafting items if a placeable is bashed
void craft_drop_placeable();


void craft_drop_items(object oSlayer)
{
    // * only drop components if the player has some decent skill level
    // * the reason is to prevent clutter for players who have no interest
    // * in the crafting system
    if (GetSkillRank(SKILL_CRAFT_ARMOR, oSlayer) > MIN_SKILL_LEVEL || GetSkillRank(SKILL_CRAFT_WEAPON, oSlayer) > MIN_SKILL_LEVEL)
    {
        object oSelf = OBJECT_SELF;
        int nAppearance = GetAppearanceType(oSelf);

        string sCol = "Placeable_Drop";
        string sNumCol = "Placeable_Num";
        int bDoor = FALSE;
        int nNum = 1;

        if (GetObjectType(oSelf) == OBJECT_TYPE_CREATURE)
        {
            sCol = "Creature_Drop";
            sNumCol = "Creature_Num";

        }
        else
        if (GetObjectType(oSelf) == OBJECT_TYPE_DOOR)
        {
            sCol = "Door_Drop";
            bDoor = TRUE;
            sNumCol = "Door_Num";
        }
        // * if does not have an inventory then treat as a door
        if (GetHasInventory(OBJECT_SELF) == FALSE)
          bDoor = TRUE;
        
        // * appearance type is index into the 2da
        string sResRef = Get2DAString("des_crft_drop", sCol, nAppearance );
        
        string sNum = Get2DAString("des_crft_drop", sNumCol, nAppearance);
        if (sNum != "****" && sNum != "")
         nNum = StringToInt(sNum);

        
        if (sResRef != "****" && sResRef != "")
        {
            int i = 1;
            location lLoc = GetLocation(OBJECT_SELF);


            // * By default only spawn 1 of each unless otherwise indicated
            for (i=1; i<=nNum; i++)
            {
                if (bDoor == TRUE)
                {
                    CreateObject(OBJECT_TYPE_ITEM, sResRef, lLoc);
                }
                else
                    CreateItemOnObject(sResRef, oSelf); // * create item on object's inventory
            }
        }
    }
}
// * handles dropping crafting items if a placeable is bashed
void craft_drop_placeable()
{
    object oKiller = GetLastKiller();
    // * I was bashed!
    if (GetIsObjectValid(oKiller) == TRUE)
    {
        craft_drop_items(oKiller);
    }
}
