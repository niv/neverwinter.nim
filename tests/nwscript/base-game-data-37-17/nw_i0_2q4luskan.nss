//::///////////////////////////////////////////////
//:: Luskan Plot Include
//:: NW_I0_2Q4LUSKAN
//:: #include "NW_I0_2Q4LUSKAN"
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Generic plot and global setting functions for
    2Q4
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 14, 2002
//:://////////////////////////////////////////////

//Plot Item Constants
int PLOT_2Q4_ITEM_KURTH_BASE_KEY = 1;
int PLOT_2Q4_ITEM_BARAM_BASE_KEY = 2;
int PLOT_2Q4_ITEM_ERBS_RING = 3;

//Function to determine what plot item to hand to the character
void Give2Q4PlotItem(int nPlotItemConstant);
//Test if the object has the specified plot item
int GetHas2Q4PlotItem(object oItemPossesser, int nPlotItemConstant);
//Pass in one of nine predetermined way points to move the character to.
void MoveTo2Q4PlotPoint(int nPlotPointIndex);
//Set a generic plot flag on a specific character
void SetLocalPlotIntOnCharacter(object oNPC, int nPlotStateIndex);
//Get the generic plot flag off of a character
int GetLocalPlotIntFromCharacter(object oNPC);
//Returns true if a PC can be seen
int GetCanSeePC(object oObject = OBJECT_SELF);
//Sets the animation on the creature and makes them face the PC if object left invalid.
void PlayConversationAnimation(int nAnimationConstant, object oTarget = OBJECT_INVALID);
//This is a plot specific function used to generate potions for Colmarr's Machine.
void CreateColmarrPotion();
//Set the new state of the machine after the lever is pressed.
void SetMachineState(int nCondition, int bValid);
//Get the state of one lever
int GetMachineState(int nCondition);
//Makes the NPC face the nearest PC
void FaceNearestPC();
//Make the nearest PC say the stated string
void AssignPCDebugString(string sString);
//Creates a creature with a specific string at a specified location
void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, int bUseAppearAnimation = FALSE);

//::///////////////////////////////////////////////
//:: Give appropriate base key
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the pc an item depending on the constant
    passed in.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 14, 2002
//:://////////////////////////////////////////////

void Give2Q4PlotItem(int nPlotItemConstant)
{
    if (nPlotItemConstant == PLOT_2Q4_ITEM_KURTH_BASE_KEY)
    {
        CreateItemOnObject("2Q4_KurthBaseKey", GetPCSpeaker());
    }
    else if(nPlotItemConstant == PLOT_2Q4_ITEM_BARAM_BASE_KEY)
    {
        CreateItemOnObject("2Q4_BaramBaseKey", GetPCSpeaker());
    }
    else if(nPlotItemConstant == PLOT_2Q4_ITEM_ERBS_RING)
    {
        CreateItemOnObject("2Q4_ErbsRing", GetPCSpeaker());
    }
}

//::///////////////////////////////////////////////
//:: Get has specific plot item.
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Uses a plot item constant to test if the
    specified object has a plot item on them.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 14, 2002
//:://////////////////////////////////////////////

int GetHas2Q4PlotItem(object oItemPossesser, int nPlotItemConstant)
{
    if (nPlotItemConstant == PLOT_2Q4_ITEM_KURTH_BASE_KEY)
    {
        if(GetIsObjectValid(GetItemPossessedBy(oItemPossesser, "2Q4_KurthBaseKey")))
        {
            return TRUE;
        }
    }
    else if(nPlotItemConstant == PLOT_2Q4_ITEM_BARAM_BASE_KEY)
    {
        if(GetIsObjectValid(GetItemPossessedBy(oItemPossesser, "2Q4_BaramBaseKey")))
        {
            return TRUE;
        }
    }
    else if(nPlotItemConstant == PLOT_2Q4_ITEM_ERBS_RING)
    {
        if(GetIsObjectValid(GetItemPossessedBy(oItemPossesser, "2Q4_ErbsRing")))
        {
            return TRUE;
        }
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: Move To a Plot Point
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Moves an NPC to a predetermined way point.
    Named "PLOT2Q4_" + NPC Tag
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 14, 2002
//:://////////////////////////////////////////////

void MoveTo2Q4PlotPoint(int nPlotPointIndex)
{
    string sTag = GetTag(OBJECT_SELF);
    sTag = "PLOT2Q4_" + sTag + "_0" + IntToString(nPlotPointIndex);
    object oWay = GetWaypointByTag(sTag);

    if(GetIsObjectValid(oWay))
    {
        ActionForceMoveToObject(oWay, TRUE, 1.0, 20.0);
    }
}

//::///////////////////////////////////////////////
//:: Generic Plot Flag Get and Set
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets or gets a generic plot flag on a character.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 14, 2002
//:://////////////////////////////////////////////

void SetLocalPlotIntOnCharacter(object oNPC, int nPlotStateIndex)
{
    string sTag = "PLOT2Q4" + GetTag(oNPC);
    SetLocalInt(oNPC, sTag, nPlotStateIndex);
}

int GetLocalPlotIntFromCharacter(object oNPC)
{
    string sTag = "PLOT2Q4" + GetTag(oNPC);
    return GetLocalInt(oNPC, sTag);
}

//::///////////////////////////////////////////////
//:: Can a PC be Seen
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Can the NPC see a PC near them
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 14, 2002
//:://////////////////////////////////////////////

int GetCanSeePC(object oObject = OBJECT_SELF)
{
    if(GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN)))
    {
        return TRUE;
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: Play Animation and Set Facing
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the facing of the NPC using the function
    towards the specified object and plays the
    animation.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 28, 2002
//:://////////////////////////////////////////////
void PlayConversationAnimation(int nAnimationConstant, object oTarget)
{
    if(oTarget == OBJECT_INVALID)
    {
        oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    }
    vector vFace = GetPosition(oTarget);
    SetFacingPoint(vFace);
    PlayAnimation(nAnimationConstant, 1.0, 2.0);
}

//::///////////////////////////////////////////////
//:: Determine Potion From Levers
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Based on the position of the Levers in the
    machine spawn in a potion at the appropriate
    location and play a visual effect.  Reset
    all levers to state 0.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 1, 2002
//:://////////////////////////////////////////////

int NW_2Q4_COLMARR_FIRE_LEVER  = 0x00000001;
int NW_2Q4_COLMARR_AIR_LEVER   = 0x00000002;
int NW_2Q4_COLMARR_WATER_LEVER = 0x00000004;
int NW_2Q4_COLMARR_STONE_LEVER = 0x00000008;

int NW_2Q4_ENGINE_STATE_OFF    = 0x00000000; //Levers all off
//Single States
int NW_2Q4_ENGINE_IDENTIFY     = 0x00000001; //Fire
int NW_2Q4_ENGINE_AID          = 0x00000002;  //Air
int NW_2Q4_ENGINE_CURE_LIGHT   = 0x00000004; //Water
int NW_2Q4_ENGINE_BARKSKIN     = 0x00000008;  //Earth
//Dual States
int NW_2Q4_FOXS_CUNNING        = 0x00000005; //Fire and Water
int NW_2Q4_INVISIBILITY        = 0x0000000A; //Air and Earth
int NW_2Q4_ENDURANCE           = 0x0000000C; //Water and Earth
int NW_2Q4_BULLS_STRENGTH      = 0x00000009; //Fire and Earth
int NW_2Q4_CATS_GRACE          = 0x00000003; //Fire and Air
int NW_2Q4_CURE_MODERATE       = 0x00000006; //Water and Air
//Triple States
int NW_2Q4_SPEED               = 0x00000007; //Fire, Air and Water
int NW_2Q4_CURE_SERIOUS        = 0x0000000B; //Fire, Air and Earth
int NW_2Q4_CLARITY             = 0x0000000E; //Air, Water and Earth
//State Off
int NW_2Q4_ENGINE_STATE_ON     = 0x0000000F; //Levers all on gives sewage

void CreateColmarrPotion()
{
    object oEngine = GetObjectByTag("2Q4_ColmarrEng");
    object oPotion;
    object oLocation = GetWaypointByTag("2Q4_Potion_Appear");
    location lSpawn = GetLocation(oLocation);
    if(GetIsObjectValid(oEngine))
    {
        int nPlot = GetLocalInt(oEngine, "NW_2Q4_COLMARR_MACHINE_LEVER_STATE");
        if(nPlot == NW_2Q4_ENGINE_STATE_OFF)
        {
        }
        else if (nPlot == NW_2Q4_ENGINE_BARKSKIN)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION005", lSpawn);
        }
        else if (nPlot == NW_2Q4_ENGINE_AID)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION016", lSpawn);
        }
        else if (nPlot == NW_2Q4_ENGINE_CURE_LIGHT)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION001", lSpawn);
        }
        else if (nPlot == NW_2Q4_ENGINE_IDENTIFY)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION019", lSpawn);
        }
        else if (nPlot == NW_2Q4_FOXS_CUNNING)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION017", lSpawn);
        }
        else if (nPlot == NW_2Q4_INVISIBILITY)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION008", lSpawn);
        }
        else if (nPlot == NW_2Q4_ENDURANCE)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION013", lSpawn);
        }
        else if (nPlot == NW_2Q4_BULLS_STRENGTH)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION015", lSpawn);
        }
        else if (nPlot == NW_2Q4_CATS_GRACE)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION014", lSpawn);
        }
        else if (nPlot == NW_2Q4_CURE_MODERATE)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION020", lSpawn);
        }
        else if (nPlot == NW_2Q4_SPEED)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION004", lSpawn);
        }
        else if (nPlot == NW_2Q4_CURE_SERIOUS)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION002", lSpawn);
        }
        else if (nPlot == NW_2Q4_CLARITY)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "NW_IT_MPOTION007", lSpawn);
        }
        else if (nPlot == NW_2Q4_ENGINE_STATE_ON)
        {
            oPotion = CreateObject(OBJECT_TYPE_ITEM, "2Q4_Sewage", lSpawn);
        }
    }
}

void SetMachineState(int nCondition, int bValid)
{
    object oEngine = GetObjectByTag("2Q4_ColmarrEng");
    if(GetIsObjectValid(oEngine))
    {
        int nPlot = GetLocalInt(oEngine, "NW_2Q4_COLMARR_MACHINE_LEVER_STATE");
        if(bValid == TRUE)
        {
            nPlot = nPlot | nCondition;
            SetLocalInt(oEngine, "NW_2Q4_COLMARR_MACHINE_LEVER_STATE", nPlot);
        }
        else if (bValid == FALSE)
        {
            nPlot = nPlot & ~nCondition;
            SetLocalInt(oEngine, "NW_2Q4_COLMARR_MACHINE_LEVER_STATE", nPlot);
        }
    }
}

int GetMachineState(int nCondition)
{
    object oEngine = GetObjectByTag("2Q4_ColmarrEng");
    if(GetIsObjectValid(oEngine))
    {
        int nPlot = GetLocalInt(oEngine, "NW_2Q4_COLMARR_MACHINE_LEVER_STATE");
        if(nPlot & nCondition)
        {
            return TRUE;
        }
    }
    return FALSE;
}

void FaceNearestPC()
{
    vector vFace = GetPosition(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN));
    SetFacingPoint(vFace);
}

void AssignPCDebugString(string sString)
{
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    AssignCommand(oPC, SpeakString(sString));
}

void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, int bUseAppearAnimation = FALSE)
{
    object oVoid = CreateObject(nObjectType, sTemplate, lLoc, bUseAppearAnimation);
}
