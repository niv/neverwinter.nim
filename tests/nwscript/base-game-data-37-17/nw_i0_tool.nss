//::///////////////////////////////////////////////
//::
//:: Tools Include File
//::
//:: NW_I0_TOOL.nss
//::
//:: Copyright (c) 2002 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Neil Flynn with code from
//::             Brent Knowles
//:: Created On: February 12, 2001
//::
//:://////////////////////////////////////////////

int DC_EASY = 0;
int DC_MEDIUM = 1;
int DC_HARD = 2;
// * this is used by some of the template scripts
// * 100 - this number is the chance of that dialog
// * appearing
int G_CLASSCHANCE = 70;

//::///////////////////////////////////////////////
//:: HasItem
//:: Copyright (c) 2002 Bioware Corp.
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

///////////////////////////////////////////////////////////////////////////////
//
//  AutoDC
//
///////////////////////////////////////////////////////////////////////////////
//  Returns a pass value based on the object's level and the suggested DC
// December 20 2001: Changed so that the difficulty is determined by the
// NPC's Hit Dice
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
    case 0: nTest = nLevel / 4 + 1; break;
        // * minor tweak to lower the values a little
    case 1: nTest = (3 / nLevel + nLevel) - abs( (nLevel/2) -2); break;
    case 2: nTest = FloatToInt(nLevel * 1.5 + 6) - abs( ( FloatToInt(nLevel/1.5) -2));   break;
    }
    //SpeakString(IntToString(nTest));

    // * Roll d20 + skill rank vs. DC + 10
    if (GetSkillRank(nSkill, oTarget) + d20() >= nTest + 10)
    {
	   return TRUE;
    }
       return FALSE;
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

    GiveXPToCreature(oTarget, FloatToInt(nRewardMod * nXP));
}


///////////////////////////////////////////////////////////////////////////////
//
//  RewardPartyGP
//
///////////////////////////////////////////////////////////////////////////////
//  Gives the GP to (if bAllParty = TRUE) all party members.
//  Each players gets the GP value amount.
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////

void RewardPartyGP(int GP, object oTarget,int bAllParty=TRUE)
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

///////////////////////////////////////////////////////////////////////////////
//
//  RewardPartyXP
//
///////////////////////////////////////////////////////////////////////////////
//  Gives the GP to (if bAllParty = TRUE) all party members.
//  Each players gets the GP value amount.
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////

void RewardPartyXP(int XP, object oTarget,int bAllParty=TRUE)
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
            GiveXPToCreature(oPartyMember, XP);
            oPartyMember = GetNextFactionMember(oTarget, TRUE);
        }
    }
    else
    {
     GiveXPToCreature(oTarget, XP);
    }
}

///////////////////////////////////////////////////////////////////////////////
//
//  CheckPartyForItem
//
///////////////////////////////////////////////////////////////////////////////
//  Checks everyone in the party for an item
///////////////////////////////////////////////////////////////////////////////
//  Created By: Brent, September 13, 2001
///////////////////////////////////////////////////////////////////////////////

int CheckPartyForItem(object oMember, string sItem)
{
    object oPartyMember = GetFirstFactionMember(oMember, TRUE);
    while (GetIsObjectValid(oPartyMember) == TRUE)
    {
        if(HasItem(oPartyMember, sItem))
            return TRUE;
        oPartyMember = GetNextFactionMember(oMember, TRUE);
    }

    return FALSE;
}
