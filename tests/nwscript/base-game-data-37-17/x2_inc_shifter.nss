//::///////////////////////////////////////////////
//:: Shifter Include File
//:: x2?inc_shifter
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    This file holds functions tied to the XP 2 shifter
    class and it's abilities.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-10-19
//:://////////////////////////////////////////////



// * These constants are used with the ShifterGetSaveDC function
const int SHIFTER_DC_VERY_EASY    = 0;
const int SHIFTER_DC_EASY         = 1;
const int SHIFTER_DC_EASY_MEDIUM  = 2;
const int SHIFTER_DC_NORMAL       = 3;
const int SHIFTER_DC_HARD         = 4;


// * These constants mark the shifter level from which a new polymorph
// * type is selected to upgrade an older one.
const int X2_GW2_EPIC_THRESHOLD = 11;
const int X2_GW3_EPIC_THRESHOLD = 15;


// * Returns and decrements the number of times this ability can be used
// * while in this shape. See x2_s2_gwildshp for more information
// * Do not place this on any spellscript that is not called
// * exclusively from Greater Wildshape
int ShifterDecrementGWildShapeSpellUsesLeft();

// * Introduces an artifical limit on the special abilities of the Greater
// * Wildshape forms,in order to work around the engine limitation
// * of being able to cast any assigned spell an unlimited number of times
// * Current settings:
// *  Darkness (Drow/Drider) : 1+ 1 use per 5 levels
// *  Stonegaze(Medusa) :      1+ 1 use per 5 levels
// *  Stonegaze(Basilisk) :    1+ 1 use per 5 levels
// *  Stonegaze(Basilisk) :    1+ 1 use per 5 levels
// *  MindBlast(Illithid) :    1+ 1 use per 3 levels
// *  Domination(Vampire) :    1+ 1 use per 5 levels
void ShifterSetGWildshapeSpellLimits(int nSpellId);

// * Used for the scaling DC of various shifter abilities.
// * Parameters:
// * oPC              - The Shifter
// * nShifterDCConst  - SHIFTER_DC_EASY, SHIFTER_DC_NORMAL, SHIFTER_DC_HARD
// * bAddDruidLevels  - Take druid levels into account
int ShifterGetSaveDC(object oPC, int nShifterDCConst = SHIFTER_DC_NORMAL, int bAddDruidLevels = FALSE);

// * Returns TRUE if the shifter's current weapon should be merged onto his
// * newly equipped melee weapon
int ShifterMergeWeapon (int nPolymorphConstant);

// * Returns TRUE if the shifter's current armor should be merged onto his
// * creature hide after shifting.
int ShifterMergeArmor  (int nPolymorphConstant);

// * Returns TRUE if the shifter's current items (gloves, belt, etc) should
// * be merged onto his creature hide after shiftng.
int ShifterMergeItems  (int nPolymorphConstant);


//------------------------------------------------------------------------------
// GZ, 2003-07-09
// Introduces an artifical limit on the special abilities of the Greater
// Wildshape forms,in order to work around the engine limitation
// of being able to cast any assigned spell an unlimited number of times
//------------------------------------------------------------------------------
void ShifterSetGWildshapeSpellLimits(int nSpellId)
{
    string sId;
    int nLevel = GetLevelByClass(CLASS_TYPE_SHIFTER);
    switch (nSpellId)
    {
        case 673:       // Drider Shape
                        sId = "688"; // SpellIndex of Drider Darkness Ability
                        SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, 1 + nLevel/10);
                        break;

        case  670 :     // Basilisk Shape
                        sId = "687"; // SpellIndex of Petrification Gaze Ability
                        SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, 1 + nLevel/5);
                        break;

        case 679 :      // Medusa Shape
                        sId = "687"; // SpellIndex of Petrification Gaze Ability
                        SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, 1+ nLevel/5);
                        break;

        case 682 :      // Drow shape
                        sId = "688"; // Darkness Ability
                        SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId,1+ nLevel/10);
                        break;

        case 691 :      // Mindflayer shape
                        sId = "693"; // SpellIndex Mind Blast Ability
                        SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, 1 + nLevel/3);
                        break;

        case 705:       // Vampire Domination Gaze
                        sId = "800";
                        SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, 1 + nLevel/5);
                        break;

    }
}


//------------------------------------------------------------------------------
// GZ, 2003-07-09
// Returns and decrements the number of times this ability can be used
// while in this shape. See x2_s2_gwildshp for more information
// Do not place this on any spellscript that is not called
// exclusively from Greater Wildshape
//------------------------------------------------------------------------------
int ShifterDecrementGWildShapeSpellUsesLeft()
{
    string sId = IntToString(GetSpellId());
    int nLimit = GetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId);
    nLimit --;
    {
        SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, nLimit);
    }
    nLimit++;
    return nLimit;
}

//------------------------------------------------------------------------------
// GZ, Oct 19, 2003
// Used for the scaling DC of various shifter abilities.
// Parameters:
// oPC              - The Shifter
// nShifterDCConst  - SHIFTER_DC_VERY_EASY, SHIFTER_DC_EASY,
 //                   SHIFTER_DC_NORMAL, SHIFTER_DC_HARD, SHIFTER_DC_EASY_MEDIUM
// bAddDruidLevels  - Take druid levels into account
//------------------------------------------------------------------------------
int ShifterGetSaveDC(object oPC, int nShifterDCConst = SHIFTER_DC_NORMAL, int bAddDruidLevels = FALSE)
{
    int nDC;

    //--------------------------------------------------------------------------
    // Calculate the overall level of the shifter used for DC determination
    //--------------------------------------------------------------------------
    int nLevel = GetLevelByClass(CLASS_TYPE_SHIFTER,oPC);
    if (bAddDruidLevels)
    {
        nLevel += GetLevelByClass(CLASS_TYPE_DRUID,oPC);
    }

    //--------------------------------------------------------------------------
    // Calculate the DC based on the requested DC constant
    //--------------------------------------------------------------------------
    switch(nShifterDCConst)
    {

        case  SHIFTER_DC_VERY_EASY :
                                 nDC = 10 + nLevel /3;
                                 break;

        case  SHIFTER_DC_EASY  : nDC = 10 + nLevel /2;
                                 break;

        case  SHIFTER_DC_EASY_MEDIUM:
                                 nDC = 12 + nLevel/2;
                                 break;

        case  SHIFTER_DC_NORMAL:
                                 nDC = 15 + nLevel /2;
                                 break;
        case  SHIFTER_DC_HARD  :
                                 nDC = 10 + nLevel;
                                 break;
    }

    return nDC;
}

//------------------------------------------------------------------------------
// GZ, Oct 19, 2003
// Returns TRUE if the shifter's current weapon should be merged onto his
// newly equipped melee weapon
//------------------------------------------------------------------------------
int ShifterMergeWeapon (int nPolymorphConstant)
{
    int nRet = StringToInt(Get2DAString("polymorph","MergeW",nPolymorphConstant)) == 1;
    return nRet;
}

//------------------------------------------------------------------------------
// GZ, Oct 19, 2003
// Returns TRUE if the shifter's current armor should be merged onto his
// creature hide after shifting.
//------------------------------------------------------------------------------
int ShifterMergeArmor  (int nPolymorphConstant)
{
    int nRet  = StringToInt(Get2DAString("polymorph","MergeA",nPolymorphConstant)) == 1;
    return nRet;
}

//------------------------------------------------------------------------------
// GZ, Oct 19, 2003
// Returns TRUE if the shifter's current items (gloves, belt, etc) should
// be merged onto his creature hide after shifting.
//------------------------------------------------------------------------------
int ShifterMergeItems  (int nPolymorphConstant)
{
    int nRet = StringToInt(Get2DAString("polymorph","MergeI",nPolymorphConstant)) == 1;
    return nRet;
}
