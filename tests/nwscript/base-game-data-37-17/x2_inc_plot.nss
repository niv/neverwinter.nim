//::///////////////////////////////////////////////
//:: inc_plot_func
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This include file has all the commonly needed
    functions required for this module..
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

// *********************
// * Setup Functions
// *********************

void SetupWander(string sMonster, int nPercent, int nNumber);
//::///////////////////////////////////////////////
//:: SetupWander
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Called from area heartbeat to set up creatures.
That is why local is being set.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void SetupWander(string sMonster, int nPercent, int nNumber)
{
    if (GetLocalInt(OBJECT_SELF, "NW_L_SetupWander") == 0)
    {
        SetLocalString(OBJECT_SELF, "NW_L_MYWANDERCREATURE", sMonster);
        SetLocalInt(OBJECT_SELF, "NW_L_MYCHANCEOFWANDER", nPercent);
        SetLocalInt(OBJECT_SELF, "NW_L_MYWANDERNUMBER", nNumber);
        SetLocalInt(OBJECT_SELF, "NW_L_SetupWander", 10);
    }
}
//::///////////////////////////////////////////////
//:: Name GetMartialClass
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Checks to see if Player has levels in either
     Fighter/Ranger/Barbarian
*/
//:://////////////////////////////////////////////
//:: Created By: Dan Whiteside
//:: Created On: Nov 2002
//:://////////////////////////////////////////////

int GetMartialClass(object oPC)
{
    int nLevel = GetLevelByClass(CLASS_TYPE_FIGHTER, oPC) && (GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) > 0) && (GetLevelByClass(CLASS_TYPE_BARBARIAN, GetPCSpeaker()) > 0);
    return nLevel;
}
// * moves all associates of oMaster to oDest.
void MoveAllAssociatesTo(object oDest, object oMaster)
{
    int i = 0;
    object oHench;
    for (i=0; i<=10; i++)
    {
        oHench =  GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oMaster, i);
        i++;
        if (GetIsObjectValid(oHench) == TRUE)
        {
            AssignCommand(oHench, JumpToObject(oDest));
        }
    }
        oHench =  GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster, 1);
        if (GetIsObjectValid(oHench) == TRUE)
        {
            AssignCommand(oHench, JumpToObject(oDest));
        }
        oHench =  GetAssociate(ASSOCIATE_TYPE_DOMINATED, oMaster, 1);
        if (GetIsObjectValid(oHench) == TRUE)
        {
            AssignCommand(oHench, JumpToObject(oDest));
        }
        oHench =  GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster, 1);
        if (GetIsObjectValid(oHench) == TRUE)
        {
            AssignCommand(oHench, JumpToObject(oDest));
        }
        oHench =  GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster, 1);
        if (GetIsObjectValid(oHench) == TRUE)
        {
            AssignCommand(oHench, JumpToObject(oDest));
        }

}

// * adds up all three class levels (i.e., returns hit die)
int GetPCTotalLevel(object oPC)
{
    return GetHitDice(oPC);
}
