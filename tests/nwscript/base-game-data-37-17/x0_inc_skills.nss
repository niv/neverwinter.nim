//::///////////////////////////////////////////////
//:: x0_inc_skills
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This header file is for all the designer
    driven skills.
    KNOWN ISSUE: always takes an entire stack
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "nw_i0_plot"

int mySKILL_CRAFT_TRAP = 22;

// * custom tokens
int SKILL_TRAP_DCMINOR = 2001;
int SKILL_TRAP_DCAVERAGE = 2002;
int SKILL_TRAP_DCSTRONG = 2003;
int SKILL_TRAP_DCDEADLY = 2004;

// * CONSTANTS

string SKILL_CTRAP_FIRECOMPONENT = "X1_WMGRENADE002";       // alchemists fire
string SKILL_CTRAP_ELECTRICALCOMPONENT = "NW_IT_MSMLMISC11";// quartz crystal
string SKILL_CTRAP_TANGLECOMPONENT = "X1_WMGRENADE006";     // tanglefoot bag
string SKILL_CTRAP_SPIKECOMPONENT = "X1_WMGRENADE003";      // caltrops
string SKILL_CTRAP_HOLYCOMPONENT = "X1_WMGRENADE005";       // holy water
string SKILL_CTRAP_GASCOMPONENT = "X1_WMGRENADE004";        // choking powder
string SKILL_CTRAP_FROSTCOMPONENT = "X1_IT_MSMLMISC01";     // coldstone
string SKILL_CTRAP_NEGATIVECOMPONENT = "NW_IT_MSMLMISC13";  // skeleton knuckles
string SKILL_CTRAP_SONICCOMPONENT = "X1_WMGRENADE007";      // thunderstone
string SKILL_CTRAP_ACIDCOMPONENT = "X1_WMGRENADE001";       // acid flask


// just defines for the trap types; also the number of
// components required for each trap type

// * modified February 17 2003 to make more expensive

int SKILL_TRAP_MINOR = 1;
int SKILL_TRAP_AVERAGE = 3;
int SKILL_TRAP_STRONG = 5;
int SKILL_TRAP_DEADLY = 7;

// * DC's of all the different trap types to make the
// * trap kit.
int SKILLDC_TRAP_BASE_TYPE_MINOR_SPIKE          = 5;
int SKILLDC_TRAP_BASE_TYPE_AVERAGE_SPIKE        = 20;
int SKILLDC_TRAP_BASE_TYPE_STRONG_SPIKE         = 25;
int SKILLDC_TRAP_BASE_TYPE_DEADLY_SPIKE         = 35;
int SKILLDC_TRAP_BASE_TYPE_MINOR_HOLY           = 15;
int SKILLDC_TRAP_BASE_TYPE_AVERAGE_HOLY         = 20;
int SKILLDC_TRAP_BASE_TYPE_STRONG_HOLY          = 25;
int SKILLDC_TRAP_BASE_TYPE_DEADLY_HOLY          = 30;
int SKILLDC_TRAP_BASE_TYPE_MINOR_TANGLE         = 15;
int SKILLDC_TRAP_BASE_TYPE_AVERAGE_TANGLE       = 20;
int SKILLDC_TRAP_BASE_TYPE_STRONG_TANGLE        = 25;
int SKILLDC_TRAP_BASE_TYPE_DEADLY_TANGLE        = 30;
int SKILLDC_TRAP_BASE_TYPE_MINOR_ACID           = 15;
int SKILLDC_TRAP_BASE_TYPE_AVERAGE_ACID         = 25;
int SKILLDC_TRAP_BASE_TYPE_STRONG_ACID          = 30;
int SKILLDC_TRAP_BASE_TYPE_DEADLY_ACID          = 35;
int SKILLDC_TRAP_BASE_TYPE_MINOR_FIRE           = 20;
int SKILLDC_TRAP_BASE_TYPE_AVERAGE_FIRE         = 25;
int SKILLDC_TRAP_BASE_TYPE_STRONG_FIRE          = 30;
int SKILLDC_TRAP_BASE_TYPE_DEADLY_FIRE          = 35;
int SKILLDC_TRAP_BASE_TYPE_MINOR_ELECTRICAL     = 20;
int SKILLDC_TRAP_BASE_TYPE_AVERAGE_ELECTRICAL   = 25;
int SKILLDC_TRAP_BASE_TYPE_STRONG_ELECTRICAL    = 30;
int SKILLDC_TRAP_BASE_TYPE_DEADLY_ELECTRICAL    = 35;
int SKILLDC_TRAP_BASE_TYPE_MINOR_GAS            = 30;
int SKILLDC_TRAP_BASE_TYPE_AVERAGE_GAS          = 35;
int SKILLDC_TRAP_BASE_TYPE_STRONG_GAS           = 40;
int SKILLDC_TRAP_BASE_TYPE_DEADLY_GAS           = 45;
int SKILLDC_TRAP_BASE_TYPE_MINOR_FROST          = 15;
int SKILLDC_TRAP_BASE_TYPE_AVERAGE_FROST        = 20;
int SKILLDC_TRAP_BASE_TYPE_STRONG_FROST         = 25;
int SKILLDC_TRAP_BASE_TYPE_DEADLY_FROST         = 30;
int SKILLDC_TRAP_BASE_TYPE_MINOR_NEGATIVE       = 15;
int SKILLDC_TRAP_BASE_TYPE_AVERAGE_NEGATIVE     = 20;
int SKILLDC_TRAP_BASE_TYPE_STRONG_NEGATIVE      = 25;
int SKILLDC_TRAP_BASE_TYPE_DEADLY_NEGATIVE      = 30;
int SKILLDC_TRAP_BASE_TYPE_MINOR_SONIC          = 15;
int SKILLDC_TRAP_BASE_TYPE_AVERAGE_SONIC        = 20;
int SKILLDC_TRAP_BASE_TYPE_STRONG_SONIC         = 25;
int SKILLDC_TRAP_BASE_TYPE_DEADLY_SONIC         = 30;
int SKILLDC_TRAP_BASE_TYPE_MINOR_ACID_SPLASH    = 15;
int SKILLDC_TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH  = 20;
int SKILLDC_TRAP_BASE_TYPE_STRONG_ACID_SPLASH   = 25;
int SKILLDC_TRAP_BASE_TYPE_DEADLY_ACID_SPLASH   = 30;


// * FUNCTIONS

int skillCTRAPGetHasComponent(string sComponent, object oPC, int nTrapDifficulty);
void skillCTRAPTakeComponent(string sComponent, object oPC, int nTrapDifficulty);

int skillCTRAPSetCurrentTrapView(string sComponent);
int skillCTRAPGetCurrentTrapViewEquals(string sComponent);

string skillCTRAPGetCurrentTrapView();

// * destroys the indicated number of items
void DestroyNumItems(object oTarget,string sItem,int nNumItems);


void skillCTRAPCreateTrapKit(string sComponent, object oPC, int nTrapDifficulty);

//::///////////////////////////////////////////////
//:: skillGetHasComponent
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the oPC has enough components for
    this type of trap
    sComponents
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////

int skillCTRAPGetHasComponent(string sComponent, object oPC, int nTrapDifficulty)
{
    object oItem = GetFirstItemInInventory(oPC);
    int nFound = 0;
    while (GetIsObjectValid(oItem) == TRUE)
    {
        if (GetTag(oItem) == sComponent)
        {
            //nFound++;
            //SpeakString("here");
            nFound = nFound + GetNumStackedItems(oItem);
        }
        oItem = GetNextItemInInventory(oPC);
    }

    // * if we have found more than or equal to the number of components
    // * required to build this trap
    if (nFound >= nTrapDifficulty)
    {
        return TRUE;
    }
    return FALSE;
}

void skillCTRAPTakeComponent(string sComponent, object oPC, int nTrapDifficulty)
{
    DestroyNumItems(oPC, sComponent, nTrapDifficulty);
}

//::///////////////////////////////////////////////
//:: skillCTRAPCreateTrapKit
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures a trap kit and removes the
    appropriate number of reagents.

    Must perform the skill roll and if fail by 5
    or more destroy the reagent

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void ClearTrapMaking()
{

    // * make creature stand up
    ClearAllActions();
}
void skillCTRAPCreateTrapKit(string sComponent, object oPC, int nTrapDifficulty)
{
    string sTrapKit = "";
    int nDifficulty = 20;

    if (sComponent == SKILL_CTRAP_FIRECOMPONENT)
    {
        if (nTrapDifficulty ==  SKILL_TRAP_MINOR)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_MINOR_FIRE;
         sTrapKit = "NW_IT_TRAP017";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_AVERAGE)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_AVERAGE_FIRE;
         sTrapKit = "NW_IT_TRAP018";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_STRONG)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_STRONG_FIRE;
         sTrapKit = "NW_IT_TRAP019";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_DEADLY)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_DEADLY_FIRE;
         sTrapKit = "NW_IT_TRAP020";
        }
    }
    else
    if (sComponent == SKILL_CTRAP_ELECTRICALCOMPONENT)
    {
        if (nTrapDifficulty ==  SKILL_TRAP_MINOR)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_MINOR_ELECTRICAL;
         sTrapKit = "NW_IT_TRAP021";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_AVERAGE)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_AVERAGE_ELECTRICAL;
         sTrapKit = "NW_IT_TRAP022";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_STRONG)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_STRONG_ELECTRICAL;
         sTrapKit = "NW_IT_TRAP023";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_DEADLY)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_DEADLY_ELECTRICAL;
         sTrapKit = "NW_IT_TRAP024";
        }
    }
    else
    if (sComponent == SKILL_CTRAP_TANGLECOMPONENT)
    {
        if (nTrapDifficulty ==  SKILL_TRAP_MINOR)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_MINOR_TANGLE;
         sTrapKit = "NW_IT_TRAP009";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_AVERAGE)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_AVERAGE_TANGLE;
         sTrapKit = "NW_IT_TRAP010";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_STRONG)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_STRONG_TANGLE;
         sTrapKit = "NW_IT_TRAP011";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_DEADLY)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_DEADLY_TANGLE;
         sTrapKit = "NW_IT_TRAP012";
        }
    }
    else
    if (sComponent == SKILL_CTRAP_SPIKECOMPONENT)
    {
        if (nTrapDifficulty ==  SKILL_TRAP_MINOR)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_MINOR_SPIKE;
         sTrapKit = "NW_IT_TRAP001";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_AVERAGE)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_AVERAGE_SPIKE;
         sTrapKit = "NW_IT_TRAP002";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_STRONG)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_STRONG_SPIKE;
         sTrapKit = "NW_IT_TRAP003";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_DEADLY)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_DEADLY_SPIKE;
         sTrapKit = "NW_IT_TRAP004";
        }
    }
    else
    if (sComponent == SKILL_CTRAP_HOLYCOMPONENT)
    {
        if (nTrapDifficulty ==  SKILL_TRAP_MINOR)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_MINOR_HOLY;
         sTrapKit = "NW_IT_TRAP005";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_AVERAGE)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_AVERAGE_HOLY;
         sTrapKit = "NW_IT_TRAP006";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_STRONG)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_STRONG_HOLY;
         sTrapKit = "NW_IT_TRAP007";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_DEADLY)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_DEADLY_HOLY;
         sTrapKit = "NW_IT_TRAP008";
        }
    }
    else
    if (sComponent == SKILL_CTRAP_GASCOMPONENT)
    {
        if (nTrapDifficulty ==  SKILL_TRAP_MINOR)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_MINOR_GAS;
         sTrapKit = "NW_IT_TRAP025";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_AVERAGE)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_AVERAGE_GAS;
         sTrapKit = "NW_IT_TRAP026";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_STRONG)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_STRONG_GAS;
         sTrapKit = "NW_IT_TRAP027";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_DEADLY)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_DEADLY_GAS;
         sTrapKit = "NW_IT_TRAP028";
        }
    }
    else
    if (sComponent == SKILL_CTRAP_FROSTCOMPONENT)
    {
        if (nTrapDifficulty ==  SKILL_TRAP_MINOR)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_MINOR_FROST;
         sTrapKit = "NW_IT_TRAP029";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_AVERAGE)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_AVERAGE_FROST;
         sTrapKit = "NW_IT_TRAP030";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_STRONG)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_STRONG_FROST;
         sTrapKit = "NW_IT_TRAP031";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_DEADLY)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_DEADLY_FROST;
         sTrapKit = "NW_IT_TRAP032";
        }
    }
    else
    if (sComponent == SKILL_CTRAP_NEGATIVECOMPONENT)
    {
        if (nTrapDifficulty ==  SKILL_TRAP_MINOR)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_MINOR_NEGATIVE;
         sTrapKit = "NW_IT_TRAP041";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_AVERAGE)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_AVERAGE_NEGATIVE;
         sTrapKit = "NW_IT_TRAP042";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_STRONG)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_STRONG_NEGATIVE;
         sTrapKit = "NW_IT_TRAP043";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_DEADLY)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_DEADLY_NEGATIVE;
         sTrapKit = "NW_IT_TRAP044";
        }
    }
    else
    if (sComponent == SKILL_CTRAP_SONICCOMPONENT)
    {
        if (nTrapDifficulty ==  SKILL_TRAP_MINOR)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_MINOR_SONIC;
         sTrapKit = "NW_IT_TRAP037";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_AVERAGE)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_AVERAGE_SONIC;
         sTrapKit = "NW_IT_TRAP038";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_STRONG)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_STRONG_SONIC;
         sTrapKit = "NW_IT_TRAP039";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_DEADLY)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_DEADLY_SONIC;
         sTrapKit = "NW_IT_TRAP040";
        }
    }
    else
    if (sComponent == SKILL_CTRAP_ACIDCOMPONENT)
    {
        if (nTrapDifficulty ==  SKILL_TRAP_MINOR)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_MINOR_ACID;
         sTrapKit = "NW_IT_TRAP033";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_AVERAGE)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_AVERAGE_ACID;
         sTrapKit = "NW_IT_TRAP034";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_STRONG)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_STRONG_ACID;
         sTrapKit = "NW_IT_TRAP035";
        }
        else
        if (nTrapDifficulty ==  SKILL_TRAP_DEADLY)
        {
         nDifficulty = SKILLDC_TRAP_BASE_TYPE_DEADLY_ACID;
         sTrapKit = "NW_IT_TRAP036";
        }
    }

    // * do skill roll
//    SpeakString("UT: MY ROLL: "+ IntToString(GetSkillRank(mySKILL_CRAFT_TRAP)));


    if (GetIsSkillSuccessful(oPC, 22, nDifficulty) == TRUE)
    {
        // * "UT: Craft Trap Skill Success."
      FloatingTextStrRefOnCreature(2700, oPC);
      CreateItemOnObject(sTrapKit, oPC, 1);
    }
    else
    // * trap failed
    {
        // * Did not lose components
        if (Random(100) < 90)
        {
            // "UT: Craft Trap Skill Failed."
            FloatingTextStrRefOnCreature(2701, oPC);
            ClearTrapMaking();
            return; // * means you didn't fail enough to lose components
        }
        // * 10% chance that components were lost
        else
            // "UT: Craft Trap Skill Failed. Components lost."
         FloatingTextStrRefOnCreature(2702, oPC);
    }
    ClearTrapMaking();
    // * removed components if succeeded or failed badly
    skillCTRAPTakeComponent(sComponent, oPC, nTrapDifficulty);

}


//::///////////////////////////////////////////////
//:: skillCTRAPSetCurrentTrapView
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This function is called right before the
    node in dialog where the Trap types and DC's are
    shown.
    Its set the trap custom tokens to appropriate values
    based on the DC constants defined above.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void skillCTRAPSetCurrentTrapView(string sComponent)
{
    SetLocalString(GetPCSpeaker(), "NW_L_TRAPVIEW", sComponent);
    if (sComponent == SKILL_CTRAP_FIRECOMPONENT)
    {
        SKILL_TRAP_DCMINOR = SKILLDC_TRAP_BASE_TYPE_MINOR_FIRE;
        SKILL_TRAP_DCAVERAGE = SKILLDC_TRAP_BASE_TYPE_AVERAGE_FIRE;
        SKILL_TRAP_DCSTRONG = SKILLDC_TRAP_BASE_TYPE_STRONG_FIRE;
        SKILL_TRAP_DCDEADLY = SKILLDC_TRAP_BASE_TYPE_DEADLY_FIRE;

    }
    else
    if (sComponent == SKILL_CTRAP_ELECTRICALCOMPONENT)
    {
        SKILL_TRAP_DCMINOR = SKILLDC_TRAP_BASE_TYPE_MINOR_ELECTRICAL;
        SKILL_TRAP_DCAVERAGE = SKILLDC_TRAP_BASE_TYPE_AVERAGE_ELECTRICAL;
        SKILL_TRAP_DCSTRONG = SKILLDC_TRAP_BASE_TYPE_STRONG_ELECTRICAL;
        SKILL_TRAP_DCDEADLY = SKILLDC_TRAP_BASE_TYPE_DEADLY_ELECTRICAL;

    }
    else
    if (sComponent == SKILL_CTRAP_SPIKECOMPONENT)
    {
        SKILL_TRAP_DCMINOR = SKILLDC_TRAP_BASE_TYPE_MINOR_SPIKE;
        SKILL_TRAP_DCAVERAGE = SKILLDC_TRAP_BASE_TYPE_AVERAGE_SPIKE;
        SKILL_TRAP_DCSTRONG = SKILLDC_TRAP_BASE_TYPE_STRONG_SPIKE;
        SKILL_TRAP_DCDEADLY = SKILLDC_TRAP_BASE_TYPE_DEADLY_SPIKE;

    }
    else
    if (sComponent == SKILL_CTRAP_HOLYCOMPONENT)
    {
        SKILL_TRAP_DCMINOR = SKILLDC_TRAP_BASE_TYPE_MINOR_HOLY;
        SKILL_TRAP_DCAVERAGE = SKILLDC_TRAP_BASE_TYPE_AVERAGE_HOLY;
        SKILL_TRAP_DCSTRONG = SKILLDC_TRAP_BASE_TYPE_STRONG_HOLY;
        SKILL_TRAP_DCDEADLY = SKILLDC_TRAP_BASE_TYPE_DEADLY_HOLY;

    }
    else
    if (sComponent == SKILL_CTRAP_TANGLECOMPONENT)
    {
        SKILL_TRAP_DCMINOR = SKILLDC_TRAP_BASE_TYPE_MINOR_TANGLE;
        SKILL_TRAP_DCAVERAGE = SKILLDC_TRAP_BASE_TYPE_AVERAGE_TANGLE;
        SKILL_TRAP_DCSTRONG = SKILLDC_TRAP_BASE_TYPE_STRONG_TANGLE;
        SKILL_TRAP_DCDEADLY = SKILLDC_TRAP_BASE_TYPE_DEADLY_TANGLE;

    }
    else
    if (sComponent == SKILL_CTRAP_GASCOMPONENT)
    {
        SKILL_TRAP_DCMINOR = SKILLDC_TRAP_BASE_TYPE_MINOR_GAS;
        SKILL_TRAP_DCAVERAGE = SKILLDC_TRAP_BASE_TYPE_AVERAGE_GAS;
        SKILL_TRAP_DCSTRONG = SKILLDC_TRAP_BASE_TYPE_STRONG_GAS;
        SKILL_TRAP_DCDEADLY = SKILLDC_TRAP_BASE_TYPE_DEADLY_GAS;

    }
    else
    if (sComponent == SKILL_CTRAP_FROSTCOMPONENT)
    {
        SKILL_TRAP_DCMINOR = SKILLDC_TRAP_BASE_TYPE_MINOR_FROST;
        SKILL_TRAP_DCAVERAGE = SKILLDC_TRAP_BASE_TYPE_AVERAGE_FROST;
        SKILL_TRAP_DCSTRONG = SKILLDC_TRAP_BASE_TYPE_STRONG_FROST;
        SKILL_TRAP_DCDEADLY = SKILLDC_TRAP_BASE_TYPE_DEADLY_FROST;

    }
    else
    if (sComponent == SKILL_CTRAP_NEGATIVECOMPONENT)
    {
        SKILL_TRAP_DCMINOR = SKILLDC_TRAP_BASE_TYPE_MINOR_NEGATIVE;
        SKILL_TRAP_DCAVERAGE = SKILLDC_TRAP_BASE_TYPE_AVERAGE_NEGATIVE;
        SKILL_TRAP_DCSTRONG = SKILLDC_TRAP_BASE_TYPE_STRONG_NEGATIVE;
        SKILL_TRAP_DCDEADLY = SKILLDC_TRAP_BASE_TYPE_DEADLY_NEGATIVE;

    }
    else
    if (sComponent == SKILL_CTRAP_SONICCOMPONENT)
    {
        SKILL_TRAP_DCMINOR = SKILLDC_TRAP_BASE_TYPE_MINOR_SONIC;
        SKILL_TRAP_DCAVERAGE = SKILLDC_TRAP_BASE_TYPE_AVERAGE_SONIC;
        SKILL_TRAP_DCSTRONG = SKILLDC_TRAP_BASE_TYPE_STRONG_SONIC;
        SKILL_TRAP_DCDEADLY = SKILLDC_TRAP_BASE_TYPE_DEADLY_SONIC;

    }
    else
    if (sComponent == SKILL_CTRAP_ACIDCOMPONENT)
    {
        SKILL_TRAP_DCMINOR = SKILLDC_TRAP_BASE_TYPE_MINOR_ACID;
        SKILL_TRAP_DCAVERAGE = SKILLDC_TRAP_BASE_TYPE_AVERAGE_ACID;
        SKILL_TRAP_DCSTRONG = SKILLDC_TRAP_BASE_TYPE_STRONG_ACID;
        SKILL_TRAP_DCDEADLY = SKILLDC_TRAP_BASE_TYPE_DEADLY_ACID;

    }


    SetCustomToken(2001, IntToString(SKILL_TRAP_DCMINOR));
    SetCustomToken(2002, IntToString(SKILL_TRAP_DCAVERAGE));
    SetCustomToken(2003, IntToString(SKILL_TRAP_DCSTRONG));
    SetCustomToken(2004, IntToString(SKILL_TRAP_DCDEADLY));
}

// returns true if sComponent is equal to the current trap view
int skillCTRAPGetCurrentTrapViewEquals(string sComponent)
{
    if (GetLocalString(GetPCSpeaker(), "NW_L_TRAPVIEW") == sComponent)
    {
        return TRUE;
    }
    return FALSE;
}
// * returns the string of the current trap view
string skillCTRAPGetCurrentTrapView()
{
    return GetLocalString(GetPCSpeaker(), "NW_L_TRAPVIEW");
}

// * destroys the indicated number of items
void DestroyNumItems(object oTarget,string sItem,int nNumItems)
{
    int nCount = 0;
    object oItem = GetFirstItemInInventory(oTarget);

//    SpawnScriptDebugger();

    while (GetIsObjectValid(oItem) == TRUE /*&& nCount < nNumItems*/)
    {
        if (GetTag(oItem) == sItem)
        {
            int nStackSize = GetItemStackSize(oItem);
            // * had more items than needed
            if (nStackSize > nNumItems)
            {
                SetItemStackSize(oItem, nStackSize - nNumItems);
                return; // exit quickly
            }
            else
            if (nStackSize == nNumItems)
            {
                DestroyObject(oItem, 0.1);
                return;
            }
            else
            // * this item did not have enough
            // * stack size. Search for another
            if (nStackSize < nNumItems)
            {            //SpawnScriptDebugger();
                DestroyObject(oItem, 0.1);
                nNumItems = nNumItems - nStackSize;
            }

            nCount++;
        }
        oItem = GetNextItemInInventory(oTarget);
    }

   return;
}
