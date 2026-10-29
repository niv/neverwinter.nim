//::///////////////////////////////////////////////
//:: Spells Include
//:: NW_I0_SPELLS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 2, 2002
//:: Updated By: 2003/20/10 Georg Zoeller
//:://////////////////////////////////////////////

// GZ: Number of spells in GetSpellBreachProtections
const int NW_I0_SPELLS_MAX_BREACH = 33;

// * Function for doing electrical traps
void TrapDoElectricalDamage(int ngDamageMaster, int nSaveDC, int nSecondary);

// * Used to route the resist magic checks into this function to check for spell countering by SR, Globes or Mantles.
//   Return value if oCaster or oTarget is an invalid object: FALSE
//   Return value if spell cast is not a player spell: - 1
//   Return value if spell resisted: 1
//   Return value if spell resisted via magic immunity: 2
//   Return value if spell resisted via spell absorption: 3
int MyResistSpell(object oCaster, object oTarget, float fDelay = 0.0);

// * Used to route the saving throws through this function to check for spell countering by a saving throw.
//   Returns: 0 if the saving throw roll failed
//   Returns: 1 if the saving throw roll succeeded
//   Returns: 2 if the target was immune to the save type specified
//   Note: If used within an Area of Effect Object Script (On Enter, OnExit, OnHeartbeat), you MUST pass
//   GetAreaOfEffectCreator() into oSaveVersus!!    \
int MySavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

// * Will pass back a linked effect for all the protection from alignment spells.  The power represents the multiplier of strength.
// * That is instead of +3 AC and +2 Saves a  power of 2 will yield +6 AC and +4 Saves.
effect CreateProtectionFromAlignmentLink(int nAlignment, int nPower = 1);

// * Will pass back a linked effect for all of the doom effects.
effect CreateDoomEffectsLink();

// * Searchs through a persons effects and removes those from a particular spell by a particular caster.
void RemoveSpellEffects(int nSpell_ID, object oCaster, object oTarget);

// * Searchs through a persons effects and removes all those of a specific type.
void RemoveSpecificEffect(int nEffectTypeID, object oTarget);

// * Returns the time in seconds that the effect should be delayed before application.
float GetSpellEffectDelay(location SpellTargetLocation, object oTarget);

// * This allows the application of a random delay to effects based on time parameters passed in.  Min default = 0.4, Max default = 1.1
float GetRandomDelay(float fMinimumTime = 0.4, float MaximumTime = 1.1);

// * Get Difficulty Duration
int GetScaledDuration(int nActualDuration, object oTarget);

// * Get Scaled Effect
effect GetScaledEffect(effect eStandard, object oTarget);

// * Remove all spell protections of a specific type
int RemoveProtections(int nSpell_ID, object oTarget, int nCount);

// * Performs a spell breach up to nTotal spells are removed and nSR spell
// * resistance is lowered.
int GetSpellBreachProtection(int nLastChecked);

//* Assigns a debug string to the Area of Effect Creator
void AssignAOEDebugString(string sString);

// * Plays a random dragon battlecry based on age.
void PlayDragonBattleCry();

// * Returns true if Target is a humanoid
int AmIAHumanoid(object oTarget);


// * Performs a spell breach up to nTotal spell are removed and
// * nSR spell resistance is  lowered. nSpellId can be used to override
// * the originating spell ID. If not specified, SPELL_GREATER_SPELL_BREACH
// * is used
void DoSpellBreach(object oTarget, int nTotal, int nSR, int nSpellId = -1);


// * Returns true if Target is a humanoid
int AmIAHumanoid(object oTarget)
{
   int nRacial = GetRacialType(oTarget);

   if((nRacial == RACIAL_TYPE_DWARF) ||
      (nRacial == RACIAL_TYPE_HALFELF) ||
      (nRacial == RACIAL_TYPE_HALFORC) ||
      (nRacial == RACIAL_TYPE_ELF) ||
      (nRacial == RACIAL_TYPE_GNOME) ||
      (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
      (nRacial == RACIAL_TYPE_HALFLING) ||
      (nRacial == RACIAL_TYPE_HUMAN) ||
      (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
      (nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
      (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
   {
    return TRUE;
   }
   return FALSE;
}

//::///////////////////////////////////////////////
//:: spellsCure
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Used by the 'cure' series of spells.
    Will do max heal/damage if at normal or low
    difficulty.
    Random rolls occur at higher difficulties.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void spellsCure(int nDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int nSpellID)
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nHeal;
    int nMetaMagic = GetMetaMagicFeat();
    effect eHeal, eDam;

    int nExtraDamage = GetCasterLevel(OBJECT_SELF); // * figure out the bonus damage
    if (nExtraDamage > nMaxExtraDamage)
    {
        nExtraDamage = nMaxExtraDamage;
    }
    // * if low or normal difficulty is treated as MAXIMIZED
    if(GetIsPC(oTarget) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
    {
        nDamage = nMaximized + nExtraDamage;
    }
    else
    {
        nDamage = nDamage + nExtraDamage;
    }


    //Make metamagic checks
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        // 04/06/2005 CraigW - We should be using the maximized value here instead of 8.
        nDamage = nMaximized + nExtraDamage;
        // * if low or normal difficulty then MAXMIZED is doubled.
        if(GetIsPC(OBJECT_SELF) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
        {
            nDamage = nDamage + nExtraDamage;
        }
    }
    if (nMetaMagic == METAMAGIC_EMPOWER || GetHasFeat(FEAT_HEALING_DOMAIN_POWER))
    {
        nDamage = nDamage + (nDamage/2);
    }


    if (GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
        //Figure out the amount of damage to heal
        //nHeal = nDamage;  -- this line seemed kinda pointless
        //Set the heal effect
        eHeal = EffectHeal(nDamage);
        //Apply heal effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        effect eVis2 = EffectVisualEffect(vfx_impactHeal);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));


    }
    //Check that the target is undead
    else
    {
        int nTouch = TouchAttackMelee(oTarget);
        if (nTouch > 0)
        {
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    eDam = EffectDamage(nDamage,DAMAGE_TYPE_POSITIVE);
                    //Apply the VFX impact and effects
                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    effect eVis = EffectVisualEffect(vfx_impactHurt);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
}

//::///////////////////////////////////////////////
//:: DoSpelLBreach
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Performs a spell breach up to nTotal spells
    are removed and nSR spell resistance is
    lowered.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2002
//:: Modified  : Georg, Oct 31, 2003
//:://////////////////////////////////////////////
void DoSpellBreach(object oTarget, int nTotal, int nSR, int nSpellId = -1)
{
    if (nSpellId == -1)
    {
        nSpellId =  SPELL_GREATER_SPELL_BREACH;
    }
    effect eSR = EffectSpellResistanceDecrease(nSR);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eVis = EffectVisualEffect(VFX_IMP_BREACH);
    int nCnt, nIdx;
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId ));
        //Search through and remove protections.
        while(nCnt <= NW_I0_SPELLS_MAX_BREACH && nIdx < nTotal)
        {
            nIdx = nIdx + RemoveProtections(GetSpellBreachProtection(nCnt), oTarget, nCnt);
            nCnt++;
        }
        effect eLink = EffectLinkEffects(eDur, eSR);
        //--------------------------------------------------------------------------
        // This can not be dispelled
        //--------------------------------------------------------------------------
        eLink = ExtraordinaryEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10));
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}

//::///////////////////////////////////////////////
//:: GetDragonFearDC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Adding a function, we were using two different
    sets of numbers before. Standardizing it to be
    closer to 3e.
    nAge - hit dice
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Sep 13, 2002
//:://////////////////////////////////////////////
int GetDragonFearDC(int nAge)
{
    //hmm... not sure what's up with all these nCount variables, they're not
    //actually used... so I'm gonna comment them out

    int nDC = 13;
//    int nCount = 1;
    //Determine the duration and save DC
    //wyrmling meant no change from default, so we don't need it
/*
    if (nAge <= 6) //Wyrmling
    {
        nDC = 13;
        nCount = 1;
    }
    else
*/
    if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDC = 15;
//        nCount = 2;
    }
    else if (/*nAge >= 10 &&*/ nAge <= 12) //Young
    {
        nDC = 17;
//        nCount = 3;
    }
    else if (/*nAge >= 13 &&*/ nAge <= 15) //Juvenile
    {
        nDC = 19;
//        nCount = 4;
    }
    else if (/*nAge >= 16 &&*/ nAge <= 18) //Young Adult
    {
        nDC = 21;
//        nCount = 5;
    }
    else if (/*nAge >= 19 &&*/ nAge <= 21) //Adult
    {
        nDC = 24;
//        nCount = 6;
    }
    else if (/*nAge >= 22 &&*/ nAge <= 24) //Mature Adult
    {
        nDC = 27;
//        nCount = 7;
    }
    else if (/*nAge >= 25 &&*/ nAge <= 27) //Old
    {
        nDC = 28;
//        nCount = 8;
    }
    else if (/*nAge >= 28 &&*/ nAge <= 30) //Very Old
    {
        nDC = 30;
//        nCount = 9;
    }
    else if (/*nAge >= 31 &&*/ nAge <= 33) //Ancient
    {
        nDC = 32;
//        nCount = 10;
    }
    else if (/*nAge >= 34 &&*/ nAge <= 37) //Wyrm
    {
        nDC = 34;
//        nCount = 11;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nDC = 37;
//        nCount = 12;
    }

    return nDC;
}

//------------------------------------------------------------------------------
// Kovi function: calculates the appropriate base number of attacks
// for spells that increase this (tensers, divine power)
//------------------------------------------------------------------------------
int CalcNumberOfAttacks()
{
  int n = GetCasterLevel(OBJECT_SELF);
  int nBAB1 = GetLevelByClass(CLASS_TYPE_RANGER)
   + GetLevelByClass(CLASS_TYPE_FIGHTER)
   + GetLevelByClass(CLASS_TYPE_PALADIN)
   + GetLevelByClass(CLASS_TYPE_BARBARIAN);
  int nBAB2 = GetLevelByClass(CLASS_TYPE_DRUID)
   + GetLevelByClass(CLASS_TYPE_MONK)
   + GetLevelByClass(CLASS_TYPE_ROGUE)
   + GetLevelByClass(CLASS_TYPE_BARD);
  int nBAB3 = GetLevelByClass(CLASS_TYPE_WIZARD)
   + GetLevelByClass(CLASS_TYPE_SORCERER);

  int nOldBAB = nBAB1 + (nBAB2 + n) * 3 / 4 + nBAB3 / 2;
  int nNewBAB = nBAB1 + n + nBAB2 * 3 / 4 + nBAB3 / 2;
  if (nNewBAB / 5 > nOldBAB / 5)
    return 2; // additional attack
  else
    return 1; // everything is normal
}

//------------------------------------------------------------------------------
// GZ: gets rids of temporary hit points so that they will not stack
//------------------------------------------------------------------------------
void RemoveTempHitPoints()
{
    effect eProtection;
    int nCnt = 0;

    eProtection = GetFirstEffect(OBJECT_SELF);
    while (GetIsEffectValid(eProtection))
    {
      if(GetEffectType(eProtection) == EFFECT_TYPE_TEMPORARY_HITPOINTS)
        RemoveEffect(OBJECT_SELF, eProtection);
      eProtection = GetNextEffect(OBJECT_SELF);
    }
}

// * Kovi. removes any effects from this type of spell
// * i.e., used in Mage Armor to remove any previous
// * mage armors
void RemoveEffectsFromSpell(object oTarget, int SpellID)
{
  effect eLook = GetFirstEffect(oTarget);
  while (GetIsEffectValid(eLook)) {
    if (GetEffectSpellId(eLook) == SpellID)
      RemoveEffect(oTarget, eLook);
    eLook = GetNextEffect(oTarget);
  }
}

int MyResistSpell(object oCaster, object oTarget, float fDelay = 0.0)
{
    if (fDelay > 0.5)
    {
        fDelay = fDelay - 0.1;
    }
    int nResist = ResistSpell(oCaster, oTarget);
    effect eSR = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    effect eGlobe = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eMantle = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
    if(nResist == 1) //Spell Resistance
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSR, oTarget));
    }
    else if(nResist == 2) //Globe
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGlobe, oTarget));
    }
    else if(nResist == 3) //Spell Mantle
    {
        if (fDelay > 0.5)
        {
            fDelay = fDelay - 0.1;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMantle, oTarget));
    }
    return nResist;
}

int MySavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    // -------------------------------------------------------------------------
    // GZ: sanity checks to prevent wrapping around
    // -------------------------------------------------------------------------
    if (nDC<1)
    {
       nDC = 1;
    }
    else if (nDC > 255)
    {
      nDC = 255;
    }

    effect eVis;
    int bValid = FALSE;
    int nSpellID;
    if(nSavingThrow == SAVING_THROW_FORT)
    {
        bValid = FortitudeSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
        }
    }
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        bValid = ReflexSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        }
    }
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
        bValid = WillSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
        }
    }

    nSpellID = GetSpellId();

    /*
        return 0 = FAILED SAVE
        return 1 = SAVE SUCCESSFUL
        return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST
    */
    if(bValid == 0)
    {
        if((nSaveType == SAVING_THROW_TYPE_DEATH
         || nSpellID == SPELL_WEIRD
         || nSpellID == SPELL_FINGER_OF_DEATH) &&
         nSpellID != SPELL_HORRID_WILTING)
        {
            eVis = EffectVisualEffect(VFX_IMP_DEATH);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
    }
    //redundant comparison on bValid, let's move the eVis line down below
/*    if(bValid == 2)
    {
        eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    }*/
    if(bValid == 1 || bValid == 2)
    {
        if(bValid == 2)
        {
            eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
            /*
            If the spell is save immune then the link must be applied in order to get the true immunity
            to be resisted.  That is the reason for returing false and not true.  True blocks the
            application of effects.
            */
            bValid = FALSE;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return bValid;
}

effect CreateProtectionFromAlignmentLink(int nAlignment, int nPower = 1)
{
    int nFinal = nPower * 2;
    effect eAC = EffectACIncrease(nFinal, AC_DEFLECTION_BONUS);
    eAC = VersusAlignmentEffect(eAC, ALIGNMENT_ALL, nAlignment);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nFinal);
    eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, nAlignment);
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    eImmune = VersusAlignmentEffect(eImmune,ALIGNMENT_ALL, nAlignment);
    effect eDur;
    if(nAlignment == ALIGNMENT_EVIL)
    {
        eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    }
    else if(nAlignment == ALIGNMENT_GOOD)
    {
        eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
    }

    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eImmune, eSave);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
    return eLink;
}

effect CreateDoomEffectsLink()
{
    //Declare major variables
    effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eAttack = EffectAttackDecrease(2);
    effect eDamage = EffectDamageDecrease(2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eSaves);
    eLink = EffectLinkEffects(eLink, eSkill);
    eLink = EffectLinkEffects(eLink, eDur);

    return eLink;
}

void RemoveSpellEffects(int nSpell_ID, object oCaster, object oTarget)
{
    //Declare major variables
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(nSpell_ID, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == oCaster)
            {
                //If the effect was created by the spell then remove it
                if(GetEffectSpellId(eAOE) == nSpell_ID)
                {
                    RemoveEffect(oTarget, eAOE);
                    bValid = TRUE;
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

void RemoveSpecificEffect(int nEffectTypeID, object oTarget)
{
    //Declare major variables
    //Get the object that is exiting the AOE
    int bValid = FALSE;
    effect eAOE;
    //Search through the valid effects on the target.
    eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        if (GetEffectType(eAOE) == nEffectTypeID)
        {
            //If the effect was created by the spell then remove it
            bValid = TRUE;
            RemoveEffect(oTarget, eAOE);
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
}

float GetSpellEffectDelay(location SpellTargetLocation, object oTarget)
{
    float fDelay;
    return fDelay = GetDistanceBetweenLocations(SpellTargetLocation, GetLocation(oTarget))/20;
}

float GetRandomDelay(float fMinimumTime = 0.4, float MaximumTime = 1.1)
{
    float fRandom = MaximumTime - fMinimumTime;
    if(fRandom < 0.0)
    {
        return 0.0;
    }
    else
    {
        int nRandom;
        nRandom = FloatToInt(fRandom  * 10.0);
        nRandom = Random(nRandom) + 1;
        fRandom = IntToFloat(nRandom);
        fRandom /= 10.0;
        return fRandom + fMinimumTime;
    }
}

int GetScaledDuration(int nActualDuration, object oTarget)
{

    int nDiff = GetGameDifficulty();
    int nNew = nActualDuration;
    if(GetIsPC(oTarget) && nActualDuration > 3)
    {
        if(nDiff == GAME_DIFFICULTY_VERY_EASY || nDiff == GAME_DIFFICULTY_EASY)
        {
            nNew = nActualDuration / 4;
        }
        else if(nDiff == GAME_DIFFICULTY_NORMAL)
        {
            nNew = nActualDuration / 2;
        }
        if(nNew == 0)
        {
            nNew = 1;
        }
    }
    return nNew;
}

effect GetScaledEffect(effect eStandard, object oTarget)
{
    int nDiff = GetGameDifficulty();
    effect eNew = eStandard;
    object oMaster = GetMaster(oTarget);
    if(GetIsPC(oTarget) || (GetIsObjectValid(oMaster) && GetIsPC(oMaster)))
    {
        if(GetEffectType(eStandard) == EFFECT_TYPE_FRIGHTENED && nDiff == GAME_DIFFICULTY_VERY_EASY)
        {
            eNew = EffectAttackDecrease(-2);
            return eNew;
        }
        if(GetEffectType(eStandard) == EFFECT_TYPE_FRIGHTENED && nDiff == GAME_DIFFICULTY_EASY)
        {
            eNew = EffectAttackDecrease(-4);
            return eNew;
        }
        if(nDiff == GAME_DIFFICULTY_VERY_EASY &&
            (GetEffectType(eStandard) == EFFECT_TYPE_PARALYZE ||
             GetEffectType(eStandard) == EFFECT_TYPE_STUNNED ||
             GetEffectType(eStandard) == EFFECT_TYPE_CONFUSED))
        {
            eNew = EffectDazed();
            return eNew;
        }
        else if(GetEffectType(eStandard) == EFFECT_TYPE_CHARMED || GetEffectType(eStandard) == EFFECT_TYPE_DOMINATED)
        {
            eNew = EffectDazed();
            return eNew;
        }
    }
    return eNew;
}

int RemoveProtections(int nSpell_ID, object oTarget, int nCount)
{
    //Declare major variables
    effect eProtection;
    int nCnt = 0;
    if(GetHasSpellEffect(nSpell_ID, oTarget))
    {
        //Search through the valid effects on the target.
        eProtection = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eProtection))
        {
            //If the effect was created by the spell then remove it
            if(GetEffectSpellId(eProtection) == nSpell_ID)
            {
                RemoveEffect(oTarget, eProtection);
                //return 1;
                nCnt++;
            }
            //Get next effect on the target
            eProtection = GetNextEffect(oTarget);
        }
    }
    if(nCnt > 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

//------------------------------------------------------------------------------
// Returns the nLastChecked-nth highest spell on the creature for use in
// the spell breach routines
// Please modify the constatn NW_I0_SPELLS_MAX_BREACH at the top of this file
// if you change the number of spells.
//------------------------------------------------------------------------------
int GetSpellBreachProtection(int nLastChecked)
{
    //--------------------------------------------------------------------------
    // GZ: Protections are stripped in the order they appear here
    //--------------------------------------------------------------------------
    if(nLastChecked == 1) {return SPELL_GREATER_SPELL_MANTLE;}
    else if (nLastChecked == 2){return SPELL_PREMONITION;}
    else if(nLastChecked == 3) {return SPELL_SPELL_MANTLE;}
    else if(nLastChecked == 4) {return SPELL_SHADOW_SHIELD;}
    else if(nLastChecked == 5) {return SPELL_GREATER_STONESKIN;}
    else if(nLastChecked == 6) {return SPELL_ETHEREAL_VISAGE;}
    else if(nLastChecked == 7) {return SPELL_GLOBE_OF_INVULNERABILITY;}
    else if(nLastChecked == 8) {return SPELL_ENERGY_BUFFER;}
    else if(nLastChecked == 9) {return 443;} // greater sanctuary
    else if(nLastChecked == 10) {return SPELL_MINOR_GLOBE_OF_INVULNERABILITY;}
    else if(nLastChecked == 11) {return SPELL_SPELL_RESISTANCE;}
    else if(nLastChecked == 12) {return SPELL_STONESKIN;}
    else if(nLastChecked == 13) {return SPELL_LESSER_SPELL_MANTLE;}
    else if(nLastChecked == 14) {return SPELL_MESTILS_ACID_SHEATH;}
    else if(nLastChecked == 15) {return SPELL_MIND_BLANK;}
    else if(nLastChecked == 16) {return SPELL_ELEMENTAL_SHIELD;}
    else if(nLastChecked == 17) {return SPELL_PROTECTION_FROM_SPELLS;}
    else if(nLastChecked == 18) {return SPELL_PROTECTION_FROM_ELEMENTS;}
    else if(nLastChecked == 19) {return SPELL_RESIST_ELEMENTS;}
    else if(nLastChecked == 20) {return SPELL_DEATH_ARMOR;}
    else if(nLastChecked == 21) {return SPELL_GHOSTLY_VISAGE;}
    else if(nLastChecked == 22) {return SPELL_ENDURE_ELEMENTS;}
    else if(nLastChecked == 23) {return SPELL_SHADOW_SHIELD;}
    else if(nLastChecked == 24) {return SPELL_SHADOW_CONJURATION_MAGE_ARMOR;}
    else if(nLastChecked == 25) {return SPELL_NEGATIVE_ENERGY_PROTECTION;}
    else if(nLastChecked == 26) {return SPELL_SANCTUARY;}
    else if(nLastChecked == 27) {return SPELL_MAGE_ARMOR;}
    else if(nLastChecked == 28) {return SPELL_STONE_BONES;}
    else if(nLastChecked == 29) {return SPELL_SHIELD;}
    else if(nLastChecked == 30) {return SPELL_SHIELD_OF_FAITH;}
    else if(nLastChecked == 31) {return SPELL_LESSER_MIND_BLANK;}
    else if(nLastChecked == 32) {return SPELL_IRONGUTS;}
    else if(nLastChecked == 33) {return SPELL_RESISTANCE;}
    return nLastChecked;
}

void AssignAOEDebugString(string sString)
{
    object oTarget = GetAreaOfEffectCreator();
    AssignCommand(oTarget, SpeakString(sString));
}


void PlayDragonBattleCry()
{
    if(d100() > 50)
    {
        PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
    }
    else
    {
        PlayVoiceChat(VOICE_CHAT_BATTLECRY2);
    }
}

void TrapDoElectricalDamage(int ngDamageMaster, int nSaveDC, int nSecondary)
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    object o2ndTarget;
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oTarget, BODY_NODE_CHEST);
    int nDamageMaster = ngDamageMaster;
    int nDamage = nDamageMaster;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    location lTarget = GetLocation(oTarget);
    int nCount = 0;
    //Adjust the trap damage based on the feats of the target
    if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_TRAP))
    {
        if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
        {
            nDamage /= 2;
        }
    }
    else if (GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
    {
        nDamage = 0;
    }
    else
    {
        nDamage /= 2;
    }
    if (nDamage > 0)
    {
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
        DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    //Reset the damage;
    nDamage = nDamageMaster;
    o2ndTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    while (GetIsObjectValid(o2ndTarget) && nCount <= nSecondary)
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //check to see that the original target is not hit again.
            if(o2ndTarget != oTarget)
            {
                //Adjust the trap damage based on the feats of the target
                if(!MySavingThrow(SAVING_THROW_REFLEX, o2ndTarget, nSaveDC, SAVING_THROW_TYPE_ELECTRICITY))
                {
                    if (GetHasFeat(FEAT_IMPROVED_EVASION, o2ndTarget))
                    {
                        nDamage /= 2;
                    }
                }
                else if (GetHasFeat(FEAT_EVASION, o2ndTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, o2ndTarget))
                {
                    nDamage = 0;
                }
                else
                {
                    nDamage /= 2;
                }
                if (nDamage > 0)
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                    //Apply the VFX impact and damage effect
                    DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, o2ndTarget));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, o2ndTarget);
                    //Connect the lightning stream from one target to another.
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, o2ndTarget, 0.75);
                    //Set the last target as the new start for the lightning stream
                    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, o2ndTarget, BODY_NODE_CHEST);
                }
            }
            //Reset the damage
            nDamage = nDamageMaster;
            //Increment the count
            nCount++;
        }
        //Get next target in the shape.
        o2ndTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    }
}

