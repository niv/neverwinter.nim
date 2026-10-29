//::///////////////////////////////////////////////
//:: Scaling Summoned Monsters
//:: X2_uinc_summscale
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////

/*
    This file holds functions related to
    scaling up a summoned creature to match the
    master's level (i.e. Epic Shadowlord)
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-25
//:://////////////////////////////////////////////


// Level up a creature to a specific level.
// See x2_inc_summscale for more information
int SSMLevelUpCreature(object oCreature, int nLevelUpTo, int nClass = CLASS_TYPE_INVALID, int bReadySpells =TRUE);

// Scale up a summoned shadowlord into epic leves
// See x2_inc_summscale for more information
int SSMScaleEpicShadowLord(object oLord);

// Scale up a summoned fiendish servant into epic leves
// See x2_inc_summscale for more information
int SSMScaleEpicFiendishServant(object oServant);

// There is a timing issue with the GetMaster() function not returning the master of a creature
// immediately after spawn. Some code which might appear to make no sense has been added
// to the nw_ch_ac1 and x2_inc_summon files to work around this

int SSMGetSummonFailedLevelUp(object oCreature);
void SSMSetSummonLevelUpOK(object oCreature);
void SSMSetSummonFailedLevelUp(object oCreature, int nLevel);


//::///////////////////////////////////////////////
//:: SSMLevelUpCreature
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Level a creature up to a certain level using
   a specified package

   oCreature    = The creature to level up
   nLevelUpTo   = The level the creature shall reach
   nClass       = The class package to use
   bReadySpells = Ready spells without resting

   Returns TRUE if the creature was successfully leveled
   up to nLevelUpTo, or the creature already has that
   level or a higher level.

   (See documentation of the LevelUpHenchman command
    for more detailed information on the parameter)

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-25
//:://////////////////////////////////////////////

int SSMLevelUpCreature(object oCreature, int nLevelUpTo, int nClass = CLASS_TYPE_INVALID, int bReadySpells =TRUE)
{
  int nCurrLevel = GetHitDice(oCreature);
  //PrintString(GetName(oCreature) + " is level " + IntToString(nCurrLevel) + " and wants to become level " + IntToString(nLevelUpTo));
  if (nCurrLevel >= nLevelUpTo)
  {
    return TRUE;    // creature already has that level
  }

  int nLevel = LevelUpHenchman(oCreature,nClass,bReadySpells);
  // level me up until I the same level as my master (or something fails)
  while (nLevel < (nLevelUpTo) && nLevel != 0)
  {
     // level up to thenext level
       //PrintString(GetName(oCreature) + " is now level "+ IntToString(nLevel));
     nLevel = LevelUpHenchman(OBJECT_SELF,nClass,bReadySpells);
  }

  // PrintString(GetName(oCreature) + " LevelUp returned "+ IntToString(nLevel));

  // verify success
  if (nLevel < nLevelUpTo)
  {
    return FALSE;
  }


  return TRUE;
}

//::///////////////////////////////////////////////
//:: SSMScaleEpicShadowLord
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Level up an epic shadowlord summoned by
    a shadowdancer's summon shadow ability
    into epic levels

    (1 level below the master's classlevel)
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-25
//:://////////////////////////////////////////////
int SSMScaleEpicShadowLord(object oLord)
{
    // no master? no levelup!
    if (!GetIsObjectValid(GetMaster(oLord)))
    {
        SSMSetSummonFailedLevelUp(oLord,-1);
        return FALSE;
    }

    // Target level is masters shadowdancer classlevels -1
    int nLevelTo = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, GetMaster(oLord))-1;
    int nRet = SSMLevelUpCreature(oLord, nLevelTo, CLASS_TYPE_INVALID);

    if (nRet == FALSE)
    {
        SSMSetSummonFailedLevelUp(oLord,nLevelTo);
    }

    return nRet;
}

//::///////////////////////////////////////////////
//:: SSMScaleEpicFiendishServant
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Level up an epic fiendish servant summoned by
    a blackguard into epic levels

    (4 level below the master's classlevel)
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-25
//:://////////////////////////////////////////////
int SSMScaleEpicFiendishServant(object oServant)
{

    // no master? no levelup!
    if (!GetIsObjectValid(GetMaster(oServant)))
    {
        SSMSetSummonFailedLevelUp(oServant,-2);
        return FALSE;
    }

    int nLevelTo = GetLevelByClass(CLASS_TYPE_BLACKGUARD, GetMaster(oServant))-4;
    int nRet = SSMLevelUpCreature(oServant, nLevelTo, CLASS_TYPE_INVALID);

    if (nRet == FALSE)
    {
        SSMSetSummonFailedLevelUp(oServant,nLevelTo);
    }

    return nRet;
}







// SSMSetSummonFailedLevelUp()
// Georg, 2003-07-25
// Sets a flag on the summoned creature, indicating that it failed
// to level up to the level it was required to level up to.
// setting the level to a negative number will indicate that one
// of the special functions in this include will be called to level up the creature:
// - 1 : SSMScaleEpicShadowLord(object oLord)
//
void SSMSetSummonFailedLevelUp(object oCreature, int nLevel)
{
    SetLocalInt(oCreature, "X2_SSM_FAILED_LEVEL_UP",nLevel);
}

int SSMGetSummonFailedLevelUp(object oCreature)
{
    int nRet = GetLocalInt(oCreature, "X2_SSM_FAILED_LEVEL_UP");
    return nRet;
}

void SSMSetSummonLevelUpOK(object oCreature)
{
    DeleteLocalInt(oCreature, "X2_SSM_FAILED_LEVEL_UP");
}



