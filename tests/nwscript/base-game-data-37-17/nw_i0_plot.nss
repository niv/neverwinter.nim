//::///////////////////////////////////////////////
//::
//:: Designer Include File
//::
//:: NW_I0_PLOT.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: This is a sample of design wrote
//:: functions that may need inclusion in multiple
//:: modules.
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent Knowles
//:: Created On: February 12, 2001
//:: Updated On: August, 14, 2003 (Georg) - Fixed AutoDC, Added const statement to constants
//:://////////////////////////////////////////////

const int DC_EASY = 0;
const int DC_MEDIUM = 1;
const int DC_HARD = 2;
const int DC_SUPERIOR = 3;
const int DC_MASTER = 4;
const int DC_LEGENDARY = 5;
const int DC_EPIC = 6;
// * this is used by some of the template scripts
// * 100 - this number is the chance of that dialog
// * appearing
const int G_CLASSCHANCE = 70;

//Experience Point Rewards constants used in the 'des_xp_rewards' 2da
const int XP_VERY_LOW = 1;    //50 xp
const int XP_LOW = 2;         //100 xp
const int XP_MEDIUM_LOW = 3;  //150 xp
const int XP_MEDIUM = 4;      //250 xp
const int XP_MEDIUM_HIGH = 5; //500 xp
const int XP_HIGH = 6;        //1000 xp
const int XP_VERY_HIGH = 7;   //2000 xp
const int XP_EPIC = 8;        //5000 xp


// * FUNCTION DECLARATIONS

// * returns true if the player can afford to lose the indicated amount of XP without losing  a level
int plotCanRemoveXP(object oPC, int nPenalty);

int GetCanCastHealingSpells(object oPC) ;
int DoOnce();
void DebugSpeak(string s);
object GetMyMaster();
int IsRecall();
void DimensionHop(object oTarget);
int CanSeePlayer();
void EscapeArea(int bRun = TRUE, string sTag="NW_EXIT");
int HasItem(object oCreature, string s);
void TakeGold(int nAmount, object oGoldHolder, int bDestroy=TRUE);
object GetNearestPC();
void SetIsEnemy(object oTarget);

// Provide a scaled skill check DC based on the DC_* constant passed in
// DC      -  DC_EASY  DC_MEDIUM  DC_HARD  DC_SUPERIOR  DC_MASTER  DC_LEGENDARY  DC_EPIC
// nSkill  - SKILL_* constant
// oTarget - creature that is going to perform the check;
int AutoDC(int DC, int nSkill, object oTarget);
void AutoAlignG(int DC, object oTarget);
void AutoAlignE(int DC, object oTarget);
void DoGiveXP(string sJournalTag, int nPercentage, object oTarget, int QuestAlignment=ALIGNMENT_NEUTRAL);
void RewardXP(string sJournalTag, int nPercentage, object oTarget, int QuestAlignment=ALIGNMENT_NEUTRAL, int bAllParty=TRUE);
void RewardGP(int GP, object oTarget,int bAllParty=TRUE);
int CheckCharismaMiddle();
int CheckCharismaNormal();
int CheckCharismaLow();
int CheckCharismaHigh();
int CheckIntelligenceLow();
int CheckIntelligenceNormal();
int CheckIntelligenceNormal();
int CheckIntelligenceHigh();
int CheckWisdomHigh();
// Return the wisdom of oTarget
int GetWisdom(object oTarget);
// Return the Intelligence of the Target
int GetIntelligence(object oTarget);
// Return the Charisma of the Target
int GetCharisma(object oTarget);
// Return the numer of items oTarget possesses from type sItem (Tag)
int GetNumItems(object oTarget,string sItem);
// Gives the item with the ResRef sItem to creature oTarget nNumItems times
void GiveNumItems(object oTarget,string sItem,int nNumItems);
// Remove nNumItems Items of Type sItem (Tag) from oTarget
void TakeNumItems(object oTarget,string sItem,int nNumItems);
// * plays the correct character theme
// * assumes OBJECT_SELF is in the area
void PlayCharacterTheme(int nTheme);
// * plays the old theme for the area
// * assumes OBJECT_SELF is in the area
void PlayOldTheme();
int GetPLocalInt(object oPC,string sLocalName);
void SetPLocalInt(object oPC,string sLocalName, int nValue);
// * removes all negative effects
void RemoveEffects(object oDead);
// * starts store using appraise skill
void gplotAppraiseOpenStore(object oStore, object oPC, int nBonusMarkUp = 0, int nBonusMarkDown = 0);
// * starts store with favorable appraise check
void gplotAppraiseFavOpenStore(object oStore, object oPC, int nBonusMarkUp = 0, int nBonusMarkDown = 0);
//Do a DC check and modify the skill by the Target's Strength modifier
int CheckDCStr(int DC, int nSkill, object oTarget);
//Check to see if target is PC and not DM
int GetIsPlayerCharacter(object oTarget);
//Reward Experience based on an entry in the des_xp_rewards 2da file
void Reward_2daXP(object oPC, int nRow, int bAllParty = TRUE, int nPercentage = 100);
//Both speak a string ref as well as play the associate sound file
void PlaySpeakSoundByStrRef(int nStrRef);


// * returns a value that will be subtracted from the
// * oTarget's DC to resist APpraise or Persuasion
int GetNPCEasyMark(object oTarget)
{
    int nCharmMod = 0;
    if (GetHasSpellEffect(SPELL_CHARM_PERSON, oTarget))
    {
        nCharmMod = 10;
    }
    else
    if (GetHasSpellEffect(SPELL_CHARM_MONSTER, oTarget))
    {
        nCharmMod = 10;
    }
    else
    if (GetHasSpellEffect(SPELL_CHARM_PERSON_OR_ANIMAL, oTarget))
    {
        nCharmMod = 10;
    }
    else if (GetHasSpellEffect(SPELL_MASS_CHARM, oTarget))
    {
            nCharmMod = 15;
    }
    else if (GetHasSpellEffect(SPELL_DOMINATE_MONSTER, oTarget))
    {
            nCharmMod = 20;
    }
    else if (GetHasSpellEffect(SPELL_DOMINATE_ANIMAL, oTarget))
    {
            nCharmMod = 20;
    }
    else if (GetHasSpellEffect(SPELL_DOMINATE_PERSON, oTarget))
    {
        nCharmMod = 20;
    }
    return nCharmMod;
}

//::///////////////////////////////////////////////
//:: gplotAppraiseOpenStore
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Opens a store, modifying the store prices
    by the Appraise skill of the PCspeaker

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:: 2003-05-26: Updated from XP1 sources - Georg
//:://////////////////////////////////////////////
void gplotAppraiseOpenStore(object oStore, object oPC, int nBonusMarkUp = 0, int nBonusMarkDown = 0)
{
    int STATE_FAILED = 1;
    int STATE_TIE = 2;
    int STATE_WON = 3;
    string sTag = ObjectToString(OBJECT_SELF);

    int nPlayerSkillRank = GetSkillRank(SKILL_APPRAISE, oPC);

    int nNPCSkillRank = GetSkillRank(SKILL_APPRAISE, OBJECT_SELF) - GetNPCEasyMark(OBJECT_SELF);


    if (nNPCSkillRank < 1 )
        nNPCSkillRank = 1;

    int nAdjust = 0;


    /*
      New System:

        An opposed skill check (a d10 roll instead). Your appraise skill versus the shopkeepers appraise skill.

        Possible Results:

        Percentage Rebate/Penalty: The 'difference'

        Feedback: [Appraise Skill]: Merchant's reaction is unfavorable.
                  [Appraise Skill]: Merchant's reaction is neutral.
                  [Appraise Skill]: Merchant's reaction is favorable.

        Additional: Remember last reaction for this particular skill.
        When the player gets a new skill rank in this skill they'll get a
        reroll against this merchant.

    */

    int nState = 0;
    int nPreviousRank = GetLocalInt(oPC, "X0_APPRAISERANK"+ sTag);

    // * if the player's rank has improved, let them have another appraise check
    // * against this merchant



    if ( (nPlayerSkillRank > nPreviousRank) || !GetLocalInt(oPC, "X0_APPRAISEVISITED"+sTag) )
    {
       SetLocalInt(oPC, "X0_APPRAISERANK"+ sTag, nPlayerSkillRank);
       SetLocalInt(oPC, "X0_APPRAISEVISITED"+sTag, 1);

        nPlayerSkillRank = nPlayerSkillRank + d10();
        nNPCSkillRank = nNPCSkillRank + d10();
        nAdjust = nNPCSkillRank - nPlayerSkillRank; // * determines the level of price modification
        if (nNPCSkillRank > nPlayerSkillRank)
        {
            nState = STATE_FAILED;
        }
        else
        if (nNPCSkillRank < nPlayerSkillRank)
        {
            nState = STATE_WON;
        }
        else
        if (nNPCSkillRank == nPlayerSkillRank)
        {
            nState = STATE_TIE;
        }

    }
    else
    {
        // * recover last reaction
        nAdjust  = GetLocalInt(oPC, "X0_APPRAISEADJUST" + sTag);

        if (nAdjust > 0)
        {
            nState = STATE_FAILED;
        }
        else
        if (nAdjust < 0)
        {
            nState = STATE_WON;
        }
        else
        if (nAdjust == 0)
        {
            nState = STATE_TIE;
        }

    }

    if (nState == STATE_FAILED  )
    {
        FloatingTextStrRefOnCreature(8963, oPC, FALSE);
    }
    else
    if (nState == STATE_WON)
    {
        FloatingTextStrRefOnCreature(8965, oPC, FALSE);
    }
    else
    if (nState == STATE_TIE)
    {
        FloatingTextStrRefOnCreature(8964, oPC, FALSE);
    }

    SetLocalInt(oPC, "X0_APPRAISEADJUST"+ sTag, nAdjust);
  //  SpawnScriptDebugger();


    // * Hard cap of 30% max up or down
    if (nAdjust > 30)
        nAdjust = 30;
    if (nAdjust < -30)
        nAdjust = -30;
    nBonusMarkUp = nBonusMarkUp + nAdjust;
    nBonusMarkDown = nBonusMarkDown - nAdjust;
    OpenStore(oStore, oPC, nBonusMarkUp, nBonusMarkDown);
}

//::///////////////////////////////////////////////
//:: gplotAppraiseFavOpenStore
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Opens a store, modifying the store prices
    by the Appraise skill of the PCspeaker
    THIS SCRIPT ALWAYS RESULTS IN A GOOD APPRAISE
    RESULT

*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Mar 7/03
//:: 2003-05-26: Updated from XP1 sources - Georg
//:://////////////////////////////////////////////
void gplotAppraiseFavOpenStore(object oStore, object oPC, int nBonusMarkUp = 0, int nBonusMarkDown = 0)
{
    int STATE_WON = 3;
    string sTag = ObjectToString(OBJECT_SELF);

    int nPlayerSkillRank = GetSkillRank(SKILL_APPRAISE, oPC);

    int nNPCSkillRank = 0;


    int nAdjust = 0;

    int nState = STATE_WON;
    int nPreviousRank = GetLocalInt(oPC, "X0_APPRAISERANK"+ sTag);

    // * if the player's rank has improved, let them have another appraise check
    // * against this merchant



    if ( (nPlayerSkillRank > nPreviousRank) || !GetLocalInt(oPC, "X0_APPRAISEVISITED"+sTag) )
    {
       SetLocalInt(oPC, "X0_APPRAISERANK"+ sTag, nPlayerSkillRank);
       SetLocalInt(oPC, "X0_APPRAISEVISITED"+sTag, 1);

        nPlayerSkillRank = nPlayerSkillRank + d10();

        nAdjust = nNPCSkillRank - nPlayerSkillRank; // * determines the level of price modification

    }
    else
    {
        // * recover last reaction
        nAdjust  = GetLocalInt(oPC, "X0_APPRAISEADJUST" + sTag);
    }

    FloatingTextStrRefOnCreature(8965, oPC, FALSE);


    SetLocalInt(oPC, "X0_APPRAISEADJUST"+ sTag, nAdjust);

    // * Hard cap of 30% max up or down
    if (nAdjust > 30)
        nAdjust = 30;
    if (nAdjust < -30)
        nAdjust = -30;

    nBonusMarkUp = nBonusMarkUp + nAdjust;
    nBonusMarkDown = nBonusMarkDown - nAdjust;
    OpenStore(oStore, oPC, nBonusMarkUp, nBonusMarkDown);
}


// * plays the correct character theme
// * assumes OBJECT_SELF is in the area
void PlayCharacterTheme(int nTheme)
{
    object oArea =GetArea(OBJECT_SELF);
    int nMusicNight = MusicBackgroundGetNightTrack(oArea);
    int nMusicDay = MusicBackgroundGetDayTrack(oArea);
   // AssignCommand(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC), SpeakString(IntToString(nMusic)));
    //* stores the last music track
    SetLocalInt(oArea, "NW_L_MYLASTTRACKNight", nMusicNight);
    SetLocalInt(oArea, "NW_L_MYLASTTRACKDay", nMusicDay);
    MusicBackgroundStop(oArea);
    MusicBackgroundChangeNight(oArea, nTheme);
    MusicBackgroundChangeDay(oArea, nTheme);
    MusicBackgroundPlay(oArea);

}

// * plays the old theme for the area
// * assumes OBJECT_SELF is in the area
void PlayOldTheme()
{
    object oArea =GetArea(OBJECT_SELF);
    //* stores the last music track
    int nMusicNight = GetLocalInt(oArea, "NW_L_MYLASTTRACKNight");
    int nMusicDay = GetLocalInt(oArea, "NW_L_MYLASTTRACKDay");
    MusicBackgroundStop(oArea);
    MusicBackgroundChangeNight(oArea, nMusicNight);
    MusicBackgroundChangeDay(oArea, nMusicDay);
    MusicBackgroundPlay(oArea);

}


//  Returns the adjusted Reaction for the purposes of store pricing.
float GetReactionAdjustment(object oTarget);
/*
    Adjusts all faction member's reputation visa via
    another faction.  Pass in a member from each
    faction.
*/
void AdjustFactionReputation(object oTargetCreature, object oMemberOfSourceFaction, int nAdjustment);
/*
    Makes the person teleport away and look like
    they are casting a spell.
*/
void EscapeViaTeleport(object oFleeing);

// * FUNCTION DEFINITIONS


int GetCanCastHealingSpells(object oPC)
{
    talent tTalent = GetCreatureTalentBest(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, 20, oPC);
    if (GetIsTalentValid(tTalent) == TRUE)
    {
      return TRUE;
    }
      return FALSE;
}


int DoOnce()
{
    int bResult = FALSE;

    if (GetLocalInt(OBJECT_SELF,"NW_L_DOONCE999") == 0)
    {
        SetLocalInt(OBJECT_SELF,"NW_L_DOONCE999",1);
        bResult = TRUE;
    }
    return bResult;
}

void DebugSpeak(string s)
{
    SpeakString(s);
}
object GetMyMaster()
{
    return GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
}



//::///////////////////////////////////////////////
//:: IsRecall
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Attempts  to transport the player
    back to closest Temple of Tyr using
    a Recall Stone.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int IsRecall()
{
    if (GetTag(GetItemActivated()) == "NW_IT_RECALL")
    {
       string sAreaTag = GetTag(GetArea(GetItemActivator()));
       if (/*Chapter 1 Areas*/
           sAreaTag == "MAP_M1S3B" ||
           sAreaTag == "Map_M1S4C" ||
           sAreaTag == "MAP_M1Q6F4" || // Fenthick area in Chapter1e
           sAreaTag == "Map_M1S4D" ||
           sAreaTag == "Map_M1S4E" ||
           sAreaTag == "Map_M1S4F" ||

           /* Chapter 3 and 4 Areas*/
           sAreaTag == "MAP_M1Q6A" || /*Castle Never*/
           sAreaTag == "M4Q1D2" /*Final Source Stone level*/ ||
           sAreaTag == "M4FinalArea" || /*Haedralines area*/
           sAreaTag == "M3Q1A10" || /*Aarin Gend's Lodge*/
           sAreaTag == "M3Q3C" || sAreaTag == "M3Q3Ca" ||  sAreaTag == "M3Q2G" ||  sAreaTag == "M3Q2I" ||
           sAreaTag == "Map_M2Q2E2" || sAreaTag == "Map_M2Q2G" || sAreaTag == "Map_M2Q3GA" || sAreaTag == "Map_M2Q3GB")
       {
        AssignCommand(GetItemActivator(), ActionSpeakStringByStrRef(10611));
        return TRUE;
       }
       else
/*       if (CanAffordIt() == FALSE)
       {
        AssignCommand(GetItemActivator(), ActionSpeakStringByStrRef(66200));
        return TRUE;

       }
       else */
       // * May 2002: Checking a global to see if Haedraline is around as well
       if (        GetLocalInt(GetModule(),"NW_G_RECALL_HAED") == 10
       || GetIsObjectValid(GetNearestObjectByTag("Haedraline3Q11", GetItemActivator())) == TRUE)
       {
        AssignCommand(GetItemActivator(), ActionSpeakStringByStrRef(10612));
        return TRUE;
       }
       else
       {
           object oPortal = GetObjectByTag("NW_RECALL_PORTAL");
           if (GetIsObjectValid(oPortal) == TRUE)
           {
             SetLocalInt(GetItemActivator(), "NW_L_USED_RECALL", 1);
             SetLocalLocation(GetItemActivator(), "NW_L_LOC_RECALL", GetLocation(GetItemActivator()));
             string sTag =  "NW_RECALL_PORTAL";
              object oClicker = GetItemActivator();
              object oTarget = GetObjectByTag(sTag);
             // AssignCommand(GetItemActivator(), SpeakString(sTag));
                // * if I don't do this, gets stuck in a loop
                // * of casting.
              AssignCommand(oClicker, ClearAllActions());

              AssignCommand(oClicker, PlaySound("as_mg_telepout1"));


              //SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);
//              AssignCommand(oClicker, PlaySound("as_mg_telepout1"));
              AssignCommand(oClicker,JumpToObject(oTarget));
//              AssignCommand(oClicker, DelayCommand(1.0,PlaySound("as_mg_telepout1")));
              AssignCommand(oClicker, ActionDoCommand(ClearAllActions()));
              return TRUE;
           }
           // * this module does not have a temple of tyr
           else
           {
                AssignCommand(GetItemActivator(), ActionSpeakStringByStrRef(10614));
                return TRUE;
           }
       }
    }
    return FALSE;

}

//::///////////////////////////////////////////////
//:: DimensionHop
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Will move the character from one point to oTarget
     with a flashy graphic.
     Original Use: Dryads in M3Q3, SnowGlobe
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: January 10, 2002
//:://////////////////////////////////////////////

void DimensionHop(object oTarget)
{
    if (GetDistanceToObject(oTarget) > 2.5)
    {
        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
        ActionJumpToObject(oTarget);
    }
}



//::///////////////////////////////////////////////
//:: CanSeePlayer
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Returns true if OBJECT_SELF can see the player
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int CanSeePlayer()
{
    return GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN));
}
//::///////////////////////////////////////////////
//:: EscapeArea()
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Runs object to nearest waypoint with tag
  "NW_EXIT".  This tag can be overridden.
  You can also specify whether to run or not.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December 2001
//:://////////////////////////////////////////////
void EscapeArea(int bRun = TRUE, string sTag="NW_EXIT")
{
    object oWay = GetNearestObjectByTag(sTag);
    if (GetIsObjectValid(oWay))
    {
        ActionMoveToObject(oWay, bRun);
        ActionDoCommand(DestroyObject(OBJECT_SELF));
        SetCommandable(FALSE); // * this prevents them from being interrupted
    }
    //else
    //SpeakString("invalid exit waypoint");
}

//::///////////////////////////////////////////////
//:: HasItem
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
      A wrapper to simplify checking for an item.
*/
//:://////////////////////////////////////////////
//:: Created By:        Brent
//:: Created On:        November 2001
//:://////////////////////////////////////////////

int HasItem(object oCreature, string s)
{
    return  GetIsObjectValid(GetItemPossessedBy(oCreature, s));
}

//::///////////////////////////////////////////////
//:: Take Gold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Takes nAmount of gold from the object speaking.
    By default, the gold is destroyed.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: November 2001
//:://////////////////////////////////////////////
void TakeGold(int nAmount, object oGoldHolder, int bDestroy=TRUE)
{
    TakeGoldFromCreature(nAmount, oGoldHolder, bDestroy);
}


//::///////////////////////////////////////////////
//:: HasGold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if the player has nAmount of gold
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int HasGold(int nAmount, object oGoldHolder)
{
    return GetGold(oGoldHolder) >= nAmount;
}

//:: GetNearestPC
//////////////////////////////////////////////////
//
//  GetNearestPC
//
//////////////////////////////////////////////////
//
//
// Returns the PC closes to the object calling
// the function.
//
//////////////////////////////////////////////////
//
//  Created By: Brent
//  Created On: May 16, 2001
//
//////////////////////////////////////////////////
object GetNearestPC()
{
   return GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC);
}


//:: SetIsEnemy
//////////////////////////////////////////////////
//
//  [Function Name]
//
//////////////////////////////////////////////////
//
//
// [A description of the function.  This should contain any
// special ranges on input values]
//
//////////////////////////////////////////////////
//
//  Created By:
//  Created On:
//
//////////////////////////////////////////////////
void SetIsEnemy(object oTarget)
{
    AdjustReputation(oTarget, OBJECT_SELF,-100);
    ActionAttack(oTarget);
}




///////////////////////////////////////////////////////////////////////////////
//
//  AutoDC
//
///////////////////////////////////////////////////////////////////////////////
//  Returns a pass value based on the object's level and the suggested DC
// December 20 2001: Changed so that the difficulty is determined by the
// NPC's Hit Dice
// November 2002 (Brent): Adding a higher upper range for level 15+ campaigns.
// August 2003 (Georg): Fixed bug not adding up DCs in the correct order
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13 2001
///////////////////////////////////////////////////////////////////////////////
int AutoDC(int DC, int nSkill, object oTarget)
{
    /*
    Easy = Lvl/4 ...rounded up
    Moderate = 3/Lvl + Lvl ...rounded up
    Difficult = Lvl * 1.5 + 6 ...rounded up
    */
    int nLevel = GetHitDice(OBJECT_SELF);
    int nTest = 0;

    // * July 2
    // * If nLevel is less than 0 or 0 then set it to 1
    if (nLevel <= 0)
    {
        nLevel = 1;
    }

    switch (DC)
    {
        case DC_EASY: nTest = nLevel / 4 + 1; break;
            // * minor tweak to lower the values a little
        case DC_MEDIUM: nTest = (3 / nLevel + nLevel) - abs( (nLevel/2) -2); break;
        case DC_HARD: nTest = FloatToInt(nLevel * 1.5 + 6) - abs( ( FloatToInt(nLevel/1.5) -2)); break;
        case DC_SUPERIOR: nTest = 7+ FloatToInt(nLevel * 1.5 + 6) - abs( ( FloatToInt(nLevel/1.5) -2)); break;
        case DC_MASTER: nTest = 14 + FloatToInt(nLevel * 1.5 + 6) - abs( ( FloatToInt(nLevel/1.5) -2)); break;
        case DC_LEGENDARY: nTest = 21 + FloatToInt(nLevel * 1.5 + 6) - abs( ( FloatToInt(nLevel/1.5) -2)); break;
        case DC_EPIC: nTest = 28 + FloatToInt(nLevel * 1.5 + 6) - abs( ( FloatToInt(nLevel/1.5) -2)); break;
    }



    // *********************************
    // * CHARM/DOMINATION
    // * If charmed or dominated the NPC
    // * will be at a disadvantage
    // *********************************
    int nCharmMod = 0;

    if (nSkill == SKILL_PERSUADE || nSkill == SKILL_BLUFF || nSkill == SKILL_INTIMIDATE)
        nCharmMod = GetNPCEasyMark(oTarget);
    int nDC = nTest + 10 - nCharmMod ;
    if (nDC < 1 )
        nDC = 1;

    // * Roll d20 + skill rank vs. DC + 10
    if (GetSkillRank(nSkill, oTarget) + d20() >= (nDC) )
    {
       return TRUE;
    }
       return FALSE;
}

///////////////////////////////////////////////////////////////////////////////
//
//  AutoAlignG(int DC, object oTarget)
//
///////////////////////////////////////////////////////////////////////////////
//  Adjusts the alignment of the object towards good, relative to the
//  degree indicated.
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////
void AutoAlignG(int DC, object oTarget)
{
    int nShift = 0;
    switch (DC)
    {
        case 0: nShift = 3;  break;
        case 1: nShift = 7; break;
        case 2: nShift = 10; break;
    }
    AdjustAlignment(oTarget, ALIGNMENT_GOOD, nShift);
}
///////////////////////////////////////////////////////////////////////////////
//
//  AutoAlignE
//
///////////////////////////////////////////////////////////////////////////////
//  Adjusts the alignment of the object towards evil, relative to the
//  degree indicated.
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////
void AutoAlignE(int DC, object oTarget)
{
    int nShift = 0;
    switch (DC)
    {
        case 0: nShift = 3;   break;
        case 1: nShift = 7;  break;
        case 2: nShift = 10;  break;
    }
    AdjustAlignment(oTarget, ALIGNMENT_EVIL, nShift);
}


//::///////////////////////////////////////////////
//:: DoGiveXP
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
      Gives the designated XP to the object
      using the design rules for XP
      distribution.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoGiveXP(string sJournalTag, int nPercentage, object oTarget, int QuestAlignment=ALIGNMENT_NEUTRAL)
{

    float nRewardMod = 1.0;
    // * error handling
    if ((nPercentage < 0) || (nPercentage > 100))
    {
        nPercentage = 100;
    }
    float nXP = GetJournalQuestExperience(sJournalTag) * (nPercentage * 0.01);

    // * for each party member
    // * cycle through them and
    // * and give them the appropriate reward
    // * HACK FOR NOW
    if ((GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL) || (QuestAlignment ==ALIGNMENT_NEUTRAL) )
    {
        nRewardMod = 1.0;
    }
    else
    if (GetAlignmentGoodEvil(oTarget) == QuestAlignment)
    {
        nRewardMod = 1.25;
    }
    else
    if (GetAlignmentGoodEvil(oTarget) != QuestAlignment)
    {
        nRewardMod = 0.75;
    }
//    AssignCommand(oTarget,SpeakString("My XP reward is: " + FloatToString(nRewardMod * nXP)));
    GiveXPToCreature(oTarget, FloatToInt(nRewardMod * nXP));

}
///////////////////////////////////////////////////////////////////////////////
//
//  RewardXP
//
///////////////////////////////////////////////////////////////////////////////
//  Gives each player the reward, scaled 1.25 times if of the correct alignment
//  and 0.75 times if of the wrong alignment.  Neutral always get the
//  1.0 times reward.
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////
void RewardXP(string sJournalTag, int nPercentage, object oTarget, int QuestAlignment=ALIGNMENT_NEUTRAL, int bAllParty=TRUE)
{

//   AssignCommand(oTarget, SpeakString("in rewardxp funtion"));
    if (bAllParty == TRUE)
    {
        object oPartyMember = GetFirstFactionMember(oTarget, TRUE);
        while (GetIsObjectValid(oPartyMember) == TRUE)
        {
            DoGiveXP(sJournalTag, nPercentage, oPartyMember, QuestAlignment);
            oPartyMember = GetNextFactionMember(oTarget, TRUE);
//            AssignCommand(oTarget,SpeakString("here your xp sir"));
        }
    }
    else
    {
     DoGiveXP(sJournalTag, nPercentage, oTarget, QuestAlignment);
    }


}


///////////////////////////////////////////////////////////////////////////////
//
//  RewardGP
//
///////////////////////////////////////////////////////////////////////////////
//  Gives the GP to (if bAllParty = TRUE) all party members.
//  Each players gets the GP value amount.
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////

void RewardGP(int GP, object oTarget,int bAllParty=TRUE)
{
    // * for each party member
    // * cycle through them and
    // * and give them the appropriate reward
    // * HACK FOR NOW
    if (bAllParty == TRUE)
    {
        object oPartyMember = GetFirstFactionMember(oTarget, TRUE);
        while (GetIsObjectValid(oPartyMember) == TRUE)
        {
            //AssignCommand(oPartyMember, SpeakString("MY GP reward is: " + IntToString(GP)));
            GiveGoldToCreature(oPartyMember, GP);
            oPartyMember = GetNextFactionMember(oTarget, TRUE);
        }
    }
    else
    {
     GiveGoldToCreature(oTarget, GP);
    }
}


// *
// * Conversation Functions
// *

///////////////////////////////////////////////////////////////////////////////
//
//  CheckCharismaMiddle
//
///////////////////////////////////////////////////////////////////////////////
//  Returns TRUE if charisma is in the normal range.
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////
int CheckCharismaMiddle()
{
 if (GetAbilityScore(GetPCSpeaker(),ABILITY_CHARISMA) >= 10 && GetAbilityScore(GetPCSpeaker(),ABILITY_CHARISMA) < 15)
 {
   return TRUE;
 }
 return FALSE;
}

///////////////////////////////////////////////////////////////////////////////
//
//  CheckCharismaNormal
//
///////////////////////////////////////////////////////////////////////////////
//  Returns TRUE if charisma is in the normal range.
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////
int CheckCharismaNormal()
{
 if (GetAbilityScore(GetPCSpeaker(),ABILITY_CHARISMA) >= 10)
 {
   return TRUE;
 }
 return FALSE;
}

///////////////////////////////////////////////////////////////////////////////
//
//  CheckCharismaLow
//
///////////////////////////////////////////////////////////////////////////////
//  Returns TRUE if charisma is in the low range.
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////
int CheckCharismaLow()
{
 if (GetAbilityScore(GetPCSpeaker(),ABILITY_CHARISMA) < 10)
 {
  return TRUE;
 }
 return FALSE;
}
///////////////////////////////////////////////////////////////////////////////
//
//  CheckCharismaHigh
//
///////////////////////////////////////////////////////////////////////////////
//  Returns TRUE if charisma is in the high range.
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////
int CheckCharismaHigh()
{
 if (GetAbilityScore(GetPCSpeaker(),ABILITY_CHARISMA) >= 15)
 {
  return TRUE;
 }
 return FALSE;
}
///////////////////////////////////////////////////////////////////////////////
//
//  CheckIntelligenceLow
//
///////////////////////////////////////////////////////////////////////////////
//  Returns TRUE if intelligence is in the low range
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////

int CheckIntelligenceLow()
{
 if (GetAbilityScore(GetPCSpeaker(),ABILITY_INTELLIGENCE) < 9)
   return TRUE;
 return FALSE;
}

///////////////////////////////////////////////////////////////////////////////
//
//  CheckIntelligenceNormal
//
///////////////////////////////////////////////////////////////////////////////
//  Returns TRUE if intelligence is in the normal range
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////
int CheckIntelligenceNormal()
{
 if (GetAbilityScore(GetPCSpeaker(),ABILITY_INTELLIGENCE) >= 9)
   return TRUE;
 return FALSE;
}

//::///////////////////////////////////////////////
//:: CheckIntelligenceHigh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int CheckIntelligenceHigh()
{
 if (GetAbilityScore(GetPCSpeaker(),ABILITY_INTELLIGENCE) >= 15)
   return TRUE;
 return FALSE;
}
///////////////////////////////////////////////////////////////////////////////
//
//  CheckWisdomHigh
//
///////////////////////////////////////////////////////////////////////////////
//  Returns TRUE if wisdom is in the High range
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////
int CheckWisdomHigh()
{
 if (GetAbilityScore(GetPCSpeaker(),ABILITY_WISDOM) > 13)
   return TRUE;
 return FALSE;
}

int GetWisdom(object oTarget)
{
    return GetAbilityScore(oTarget, ABILITY_WISDOM);
}
int GetIntelligence(object oTarget)
{
    return GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
}
int GetCharisma(object oTarget)
{
    return GetAbilityScore(oTarget, ABILITY_CHARISMA);
}

//:: GetNumItems
//////////////////////////////////////////////////
//
//  GetNumItems
//
//////////////////////////////////////////////////
//
//
// Returns the number of specified item in the
// target's inventory.
//
//////////////////////////////////////////////////
//
//  Created By: John
//  Created On: September 19, 2001
//
//////////////////////////////////////////////////
int GetNumItems(object oTarget,string sItem)
{
    int nNumItems = 0;
    object oItem = GetFirstItemInInventory(oTarget);

    while (GetIsObjectValid(oItem) == TRUE)
    {
        if (GetTag(oItem) == sItem)
        {
            nNumItems = nNumItems + GetNumStackedItems(oItem);
        }
        oItem = GetNextItemInInventory(oTarget);
    }

   return nNumItems;
}

//:: GiveNumItems
//////////////////////////////////////////////////
//
//  GiveNumItems
//
//////////////////////////////////////////////////
//
//
// Gives the target the number of items specified.
//
//////////////////////////////////////////////////
//
//  Created By: John
//  Created On: September 19, 2001
//
//////////////////////////////////////////////////
void GiveNumItems(object oTarget,string sItem,int nNumItems)
{
    int nCount = 0;
    object oItem = GetFirstItemInInventory(OBJECT_SELF);

    while (GetIsObjectValid(oItem) == TRUE && nCount < nNumItems)
    {
        if (GetTag(oItem) == sItem)
        {
            ActionGiveItem(oItem,oTarget);
            nCount++;
        }
        oItem = GetNextItemInInventory(OBJECT_SELF);
    }

   return;
}

//:: TakeNumItems
//////////////////////////////////////////////////
//
//  TakeNumItems
//
//////////////////////////////////////////////////
//
//
// Takes the number of items specified from the target.
//
//////////////////////////////////////////////////
//
//  Created By: John
//  Created On: September 19, 2001
//
//////////////////////////////////////////////////
void TakeNumItems(object oTarget,string sItem,int nNumItems)
{
    int nCount = 0;
    object oItem = GetFirstItemInInventory(oTarget);

    while (GetIsObjectValid(oItem) == TRUE && nCount < nNumItems)
    {
        if (GetTag(oItem) == sItem)
        {
            ActionTakeItem(oItem,oTarget);
            nCount++;
        }
        oItem = GetNextItemInInventory(oTarget);
    }

   return;
}


///////////////////////////////////////////////////////////////////////////////
//
//  GetReactionAdjustment
//
///////////////////////////////////////////////////////////////////////////////
//  Returns the adjusted Reaction for the purposes of store pricing.
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 25, 2001
///////////////////////////////////////////////////////////////////////////////
 float GetReactionAdjustment(object oTarget)
{
    float nFactionAdjustment = 2.0;
    // (i)
    if (GetIsFriend(oTarget) == TRUE)
    {
        nFactionAdjustment = 1.0;
    }

    // (ii)
    int oTargetLawChaos = GetLawChaosValue(oTarget);
    int oTargetGoodEvil = GetGoodEvilValue(oTarget);
    int oSourceLawChaos = GetLawChaosValue(OBJECT_SELF);
    int oSourceGoodEvil = GetGoodEvilValue(OBJECT_SELF);
    int APB = abs(oSourceLawChaos - oTargetLawChaos)  + abs(oSourceGoodEvil - oTargetGoodEvil);
    int nTargetCharismaMod = GetAbilityModifier(ABILITY_CHARISMA, oTarget);
    return abs(10 + APB - (nTargetCharismaMod * 10)) * nFactionAdjustment;

}

//::///////////////////////////////////////////////
//:: AdjustFactionReputation
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Adjusts all faction member's reputation visa via
    another faction.  Pass in a member from each
    faction.
*/
//:://////////////////////////////////////////////
//:: Created By: Presotn Watamaniuk
//:: Created On: Nov 15, 2001
//:://////////////////////////////////////////////
void AdjustFactionReputation(object oTargetCreature, object oMemberOfSourceFaction, int nAdjustment)
{
    object oFaction = GetFirstFactionMember(oTargetCreature);
    while(GetIsObjectValid(oFaction))
    {
        AdjustReputation(oTargetCreature, oMemberOfSourceFaction, nAdjustment);
        oFaction = GetNextFactionMember(oTargetCreature);
    }
    AdjustReputation(oTargetCreature, oMemberOfSourceFaction, nAdjustment);
}

//::///////////////////////////////////////////////
//:: Escape Via Teleport
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Makes the person teleport away and look like
    they are casting a spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 12, 2002
//:://////////////////////////////////////////////

void EscapeViaTeleport(object oFleeing)
{
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    ActionCastFakeSpellAtObject(SPELL_MINOR_GLOBE_OF_INVULNERABILITY, oFleeing);
    DelayCommand(1.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oFleeing)));
    DestroyObject(oFleeing, 2.5);
}


//::///////////////////////////////////////////////
//:: GetP(arty)LocalInt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Scans through all players in the party, to
    treat them all as 'one person' for the purposes
    of most plots. Makes our plots more multiplayer friendly.
*/
//:://////////////////////////////////////////////
//:: Created By: John
//:: Created On:
//:://////////////////////////////////////////////
int GetPLocalInt(object oPC,string sLocalName)
{
    int nValue = 0;
    object oMember;

    oMember = GetFirstFactionMember(oPC);

    while (GetIsObjectValid(oMember))
    {
        if (GetLocalInt(oPC,sLocalName) > nValue)
        {
            nValue = GetLocalInt(oMember,sLocalName);
        }
        oMember = GetNextFactionMember(oPC);
    }

    return nValue;
}
//::///////////////////////////////////////////////
//:: SetP(arty)LocalInt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: John
//:: Created On:
//:://////////////////////////////////////////////
void SetPLocalInt(object oPC,string sLocalName, int nValue)
{
    object oMember;

    oMember = GetFirstFactionMember(oPC);

    while (GetIsObjectValid(oMember))
    {
        SetLocalInt(oMember,sLocalName,nValue);
         oMember = GetNextFactionMember(oPC);
    }

    return;
}
// * removes all negative effects
void RemoveEffects(object oDead)
{
    //Declare major variables
    object oTarget = oDead;
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
    int bValid;

    effect eBad = GetFirstEffect(oTarget);
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
            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
            GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
            GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
            GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
            GetEffectType(eBad) == EFFECT_TYPE_POISON ||
            GetEffectType(eBad) == EFFECT_TYPE_DISEASE
                )
            {
                //Remove effect if it is negative.
                RemoveEffect(oTarget, eBad);
            }
        eBad = GetNextEffect(oTarget);
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);

    // * May 2002: Removed this because ActionRest is no longer an instant.
    // * rest the player
    //AssignCommand(oDead, ActionRest());
}
int CheckDCStr(int DC, int nSkill, object oTarget)
{
    /*
    Easy = Lvl/4 ...rounded up
    Moderate = 3/Lvl + Lvl ...rounded up
    Difficult = Lvl * 1.5 + 6 ...rounded up
    */
    int nLevel = GetHitDice(OBJECT_SELF);
    int nTest = 0;

    // * July 2
    // * If nLevel is less than 0 or 0 then set it to 1
    if (nLevel <= 0)
    {
        nLevel = 1;
    }

    switch (DC)
    {
    case 0: nTest = nLevel / 4 + 1; break;
        // * minor tweak to lower the values a little
    case 1: nTest = (3 / nLevel + nLevel) - abs( (nLevel/2) -2); break;
    case 2: nTest = FloatToInt(nLevel * 1.5 + 6) - abs( ( FloatToInt(nLevel/1.5) -2));
    case 3: nTest = nTest + 7;
    case 4: nTest = nTest + 7;
    case 5: nTest = nTest + 7;
    // because there are no break statements it should
    // add all the bonuses
    }
    //SpeakString(IntToString(nTest));

    // * Roll d20 + skill rank vs. DC + 10
    if (GetSkillRank(nSkill, oTarget) + d20() + GetAbilityModifier(ABILITY_STRENGTH, oTarget) >= (nTest + 10) )
    {
       return TRUE;
    }
       return FALSE;
}
// * returns true if the player can afford to lose the indicated amount of XP without losing  a level
int plotCanRemoveXP(object oPC, int nPenalty)
{
    int nXP = GetXP(oPC);
    int nHD = GetHitDice(oPC);
    // * You can not lose a level with this
    int nMin = ((nHD * (nHD - 1)) / 2) * 1000;

    int nNewXP = nXP - nPenalty;
    if (nNewXP < nMin)
        return FALSE;
    return TRUE;
}
int GetIsPlayerCharacter(object oTarget)
{
    if (GetIsPC(oTarget) == TRUE && GetIsDM(oTarget) == FALSE)
        return TRUE;
    return FALSE;
}
//::///////////////////////////////////////////////
//:: Name Reward_2daXP
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Pass in a PC and a row from the 'des_xp_rewards'
    2da file to reward the PC and/or party experience
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: May 29/03
//:://////////////////////////////////////////////

void Reward_2daXP(object oPC, int nRow, int bAllParty = TRUE, int nPercentage = 100)
{

   float fPercent = IntToFloat(nPercentage)/100.0;
   int nPlotXP = StringToInt(Get2DAString("des_xp_rewards", "XP", nRow));
   int nReward = FloatToInt(fPercent * nPlotXP);
   if (bAllParty == TRUE)
   {
        object oParty = GetFirstFactionMember(oPC);
        while (oParty != OBJECT_INVALID)
        {
            GiveXPToCreature(oParty, nReward);
            oParty = GetNextFactionMember(oPC);
        }
   }
   else
   {
        GiveXPToCreature(oPC, nReward);
   }
}
//::///////////////////////////////////////////////
//:: Name PlaySpeakSoundByStrRef
/*
    Do both a SpeakStringRef and a Play StringRef
    at the same time.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Oct 23/03
//:://////////////////////////////////////////////
void PlaySpeakSoundByStrRef(int nStrRef)
{
    SpeakStringByStrRef(nStrRef);
    PlaySoundByStrRef(nStrRef, FALSE);
}
