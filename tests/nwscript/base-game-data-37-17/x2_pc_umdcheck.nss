//------------------------------------------------------------------------------
/*
Use Magic Device Check.
Simple use magic device check to prevent abuse of
the engine level implementation of use magic device
This function is not supposed to mirror the 3E use
magic device mechanics.

Returns TRUE if the Spell is allowed to be
cast, either because the character is allowed
to cast it or he has won the required UMD check

returns TRUE if
   ... spell not cast by an item
   ... item is not a scroll (may be extended)
   ... caster has levels in wiz, bard, sorc
   ... caster is no rogue and has no UMD skill
   ... caster has memorized this spell
   ... the property corresponding to the spell does not exist (2da inconsistency)

   ... a UMD check against 25+InnateLevel of the spell is won

Note: I am not using the effective level of the spell for DC calculation but
      instead the lowest possible effective level. This is by design to allow
      rogues to use most low level scrolls in the game (i.e. light scrolls have
      an effective level 5 but a lowest effective level of 1 and we want low level
      rogues to cast these spells..)

      Setting a Local Interger called X2_SWITCH_CLASSIC_UMD (TRUE) on the Module
      will result in this function to return TRUE all the time

      User's can change this default implementation by modifing this file


                                                                              */
//------------------------------------------------------------------------------

#include "x2_inc_switches"
#include "x2_inc_itemprop"

int X2_UMD()
{

    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_UMD_SCROLLS) == FALSE)
    {
        return TRUE;
    }

    object oItem = GetSpellCastItem();
    // Spell not cast from an item, exit
    if  (!GetIsObjectValid(oItem))
    {
        return TRUE; // Spell not cast by item, UMD not required
    }

    // -------------------------------------------------------------------------
    // Only Scrolls are subject to our default UMD Check
    // -------------------------------------------------------------------------
    int nBase = GetBaseItemType(oItem);
    if ( nBase != BASE_ITEM_SPELLSCROLL)
    {
        return TRUE; // spell not cast from a scroll
    }


    // -------------------------------------------------------------------------
    // Ignore scrolls that have no use limitations (i.e. raise dead)
    // -------------------------------------------------------------------------
    if (!IPGetHasUseLimitation(oItem))
    {
        return TRUE;
    }

    object oCaster = OBJECT_SELF;
    int nBard = GetLevelByClass(CLASS_TYPE_BARD,oCaster);

    // -------------------------------------------------------------------------
    // Wizards and Sorcerors are supposed to cast scrolls via spellcraft
    // -------------------------------------------------------------------------
    if (GetLevelByClass(CLASS_TYPE_WIZARD,oCaster) >0 ||GetLevelByClass(CLASS_TYPE_SORCERER,oCaster)  >0 || nBard>0)
    {
        // -------------------------------------------------------------------------
        // We only punish rogues, so other classes cast for free :)
        // -------------------------------------------------------------------------
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // If the caster used the item and has no UMD Skill and is not a rogue
    // thus we assume he must be allowed to use it because the engine
    // prevents people that are not capable of using an item from using it....
    // -------------------------------------------------------------------------
    if (!GetHasSkill(SKILL_USE_MAGIC_DEVICE, oCaster) && (GetLevelByClass(CLASS_TYPE_ROGUE,oCaster) ==0 ) && (GetLevelByClass(CLASS_TYPE_ASSASSIN,oCaster) ==0 ) && (GetLevelByClass(CLASS_TYPE_SHADOWDANCER,oCaster) ==0 ))
    {
        // ---------------------------------------------------------------------
        //SpeakString("I have no UMD, thus I can cast the spell... ");
        // ---------------------------------------------------------------------
        return TRUE;
    }

    int nSpellID = GetSpellId();

    // -------------------------------------------------------------------------
    // if we knew that spell we could also cast it from an item (may be redundant)
    // -------------------------------------------------------------------------
    if(GetHasSpell(nSpellID)>0)
    {
        //SpeakString("I have memorized this spell, I must be able to cast it without UMD ");
        return TRUE;
    }

    string sPropID = Get2DAString("des_crft_spells","IPRP_SpellIndex",nSpellID);

    // -------------------------------------------------------------------------
    //I am using des_crft_spells.2da Innate Level column here, not (as would be correct)
    //the IPPR_Spells.2da InnateLvl column, because some of the scrolls in
    //the game (i.e. light) would not be useable (DC 30+)
    // -------------------------------------------------------------------------
    int nInnateLevel = StringToInt(Get2DAString("des_crft_spells","Level",nSpellID));
    int nSkill = SKILL_USE_MAGIC_DEVICE;

    int nPropID = StringToInt(sPropID);
    if (nPropID == 0)
    {
        WriteTimestampedLogEntry("***X2UseMagicDevice (Warning): Found no property matching SpellID "+ IntToString(nSpellID));
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // Base DC for casting a spell from a scroll is 25+SpellLevel
    // We do not have a way to check for misshaps here but GetIsSkillSuccessful
    /// does not return the required information
    // -------------------------------------------------------------------------
    if (GetIsSkillSuccessful(oCaster,nSkill, 25+ nInnateLevel))
    {
        return TRUE;
    }
    else
    {
        effect ePuff =  EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,ePuff,oCaster);
        return FALSE;
    }
}

void main()
{
    //--------------------------------------------------------------------------
    // Reset
    //--------------------------------------------------------------------------
    if (GetLocalInt(GetModule(),"X2_L_STOP_EXPERTISE_ABUSE") == TRUE)
    {
         SetActionMode(OBJECT_SELF,ACTION_MODE_EXPERTISE,FALSE);
         SetActionMode(OBJECT_SELF,ACTION_MODE_IMPROVED_EXPERTISE,FALSE);
    }

    //--------------------------------------------------------------------------
    // Do use magic device check
    //--------------------------------------------------------------------------
    int nRet = X2_UMD();
    SetExecutedScriptReturnValue (nRet);
}
