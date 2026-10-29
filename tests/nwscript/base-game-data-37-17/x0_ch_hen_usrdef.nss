//:://////////////////////////////////////////////////
//:: X0_CH_HEN_USRDEF
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
 */
//:://////////////////////////////////////////////////
//:://////////////////////////////////////////////////
#include "X0_INC_HENAI"

// Try to cast nSpell on oMaster. returns 1 on success, 0 on failure.
int CheckSpell(int nSpell, object oMaster);

// Try to cast a restorative spell if the master has a spell effect
// that prevents him from talking to the henchmen and asking for help (hold, fear, confusion etc')
// The henchmen would also try to help other disabled henchmen.
// The henchmen would try to cast dispel-magic spells to remove disabling spells from the player
// unless the player told him not to do it (since it might dispel other helpful buffing spells).
void CheckForDisabledPartyMembers();


// Try to cast nSpell on oMaster. returns 1 on success, 0 on failure.
int CheckSpell(int nSpell, object oMaster);

// Try to cast a restorative spell if the master has a spell effect
// that prevents him from talking to the henchmen and asking for help (hold, fear, confusion etc')
// The henchmen would also try to help other disabled henchmen.
// The henchmen would try to cast dispel-magic spells to remove disabling spells from the player
// unless the player told him not to do it (since it might dispel other helpful buffing spells).
void CheckForDisabledPartyMembers();


void main()
{
    int nEvent = GetUserDefinedEventNumber();

    if (nEvent == 20000 + ACTION_MODE_STEALTH)
    {
    
      int bStealth = GetActionMode(GetMaster(), ACTION_MODE_STEALTH);
      SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, bStealth);
    }
    else
    if (nEvent == 20000 + ACTION_MODE_DETECT)
    {
      int bDetect = GetActionMode(GetMaster(), ACTION_MODE_DETECT);
      SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, bDetect);
    }
    else
    // *
    // * This event is triggered whenever an NPC or PC in the party
    // * is disabled (or potentially disabled).
    // * This is a migration of a useful heartbeat routine Yaron made
    // * into a less AI extensive route
    if (nEvent == 46500)
    {
        CheckForDisabledPartyMembers();
    }
}

int CheckSpell(int nSpell, object oMaster)
{
    if(GetHasSpell(nSpell))
    {
        ClearAllActions();
        ActionCastSpellAtObject(nSpell, oMaster);
        return 1;
    }
    return 0;
}

// Check whether the creature has disabling effects that are magical and therefor and can removed by
// dispel magic spells.
int HasDisablingMagicalEffect(object oCreature)
{
    effect eEff = GetFirstEffect(oCreature);
    while(GetIsEffectValid(eEff))
    {
        if(GetEffectType(eEff) == EFFECT_TYPE_CONFUSED ||
           GetEffectType(eEff) == EFFECT_TYPE_PARALYZE ||
           GetEffectType(eEff) == EFFECT_TYPE_FRIGHTENED ||
           GetEffectType(eEff) == EFFECT_TYPE_DOMINATED ||
           GetEffectType(eEff) == EFFECT_TYPE_DAZED ||
           GetEffectType(eEff) == EFFECT_TYPE_STUNNED)
        {
            if(GetEffectSubType(eEff) == SUBTYPE_MAGICAL)
                return TRUE; // can be dispelled
            else
                return FALSE;
        }
        eEff = GetNextEffect(oCreature);
    }
    return FALSE;
}

// Checks a single creature for disabling effects, trying to remove them if possible.
void CheckCreature(object oCreature)
{
    // First, trying to cast specific-purpose spells and then trying more general spells.
    if(GetHasEffect(EFFECT_TYPE_FRIGHTENED, oCreature))
        if(CheckSpell(SPELL_REMOVE_FEAR, oCreature)) return;
    if(GetHasEffect(EFFECT_TYPE_PARALYZE, oCreature))
        if(CheckSpell(SPELL_REMOVE_PARALYSIS, oCreature)) return;

    if(GetHasEffect(EFFECT_TYPE_CONFUSED, oCreature) ||
       GetHasEffect(EFFECT_TYPE_FRIGHTENED, oCreature) ||
       GetHasEffect(EFFECT_TYPE_PARALYZE, oCreature) ||
       GetHasEffect(EFFECT_TYPE_DOMINATED, oCreature) ||
       GetHasEffect(EFFECT_TYPE_DAZED, oCreature) ||
       GetHasEffect(EFFECT_TYPE_STUNNED, oCreature))
    {
        if(CheckSpell(SPELL_GREATER_RESTORATION, oCreature)) return;
        if(CheckSpell(SPELL_RESTORATION, oCreature)) return;
        if(HasDisablingMagicalEffect(oCreature) &&
            GetLocalInt(OBJECT_SELF, "X2_HENCH_DO_NOT_DISPEL") == 0)
        {
            if(CheckSpell(SPELL_GREATER_DISPELLING, oCreature)) return;
            if(CheckSpell(SPELL_DISPEL_MAGIC, oCreature)) return;
            if(CheckSpell(SPELL_LESSER_DISPEL, oCreature)) return;
        }

    }
}

void CheckForDisabledPartyMembers()
{
    object oMaster = GetMaster(OBJECT_SELF);
    if(oMaster != OBJECT_INVALID)
        CheckCreature(oMaster);
    int i = 1;
    object oHench = GetHenchman(oMaster, i);
    while(oHench != OBJECT_INVALID)
    {
        CheckCreature(oHench);
        i++;
        oHench = GetHenchman(oMaster, i);
    }
}

