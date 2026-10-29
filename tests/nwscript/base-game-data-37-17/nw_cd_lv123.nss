//*  Cleric: Level 20
//*  Spell Level    0    1   2   3   4   5   6   7   8   9
//* --------------------------------------------------------
//*  Spell/Day
//*  Level 1        3   1+1  -   -   -   -   -   -   -   -
//*  Level 2        4   2+1  -   -   -   -   -   -   -   -
//*  Level 3        4   2+1 1+1  -   -   -   -   -   -   -
//*  Level 4        5   3+1 2+1  -   -   -   -   -   -   -
//*  Level 5        5   3+1 2+1 1+1  -   -   -   -   -   -
//*  Level 6        5   3+1 3+1 2+1  -   -   -   -   -   -
//*  Level 7        6   4+1 3+1 2+1 1+1  -   -   -   -   -

// * Protection Spells:  Level 0: Resistance, Virtue
// *                     Level 1: Bless, Endure Elements, Protection from C/E/G/L, Sanctuary
// *                     Level 2: Aid, Bull's Strength, Calm Emotions, Darkness,
// *                              Endurance, Find Traps, Resist Elements,
// *                     Level 3: Magic Circle against C/E/G/L, Magic Vestment,
// *                              Negative Energy Protection, Prayer, Protection from Elements
// *                     Level 4: Death Ward, Divine Power, Freedom of Movement
// * Offensive Spells:   Level 0: n/a
// *                     Level 1: Cause Fear, Doom, Magic Stone, Magic Weapon
// *                              Summon Monster I
// *                     Level 2: Enthrall, Hold Person, Silence, Sound Burst,
// *                              Summon Monster II
// *                     Level 3: Animate Dead, Blindness/Deafness, Contagion, Dispel Magic,
// *                              Invisibility Purge, Searing Light, Summon Monster III
// *                     Level 4: Dismissal, Summon Monster IV
// * Defensive Spells:   Level 0: Cure Minor Wounds, Light
// *                     Level 1: Cure Light Wounds, Remove Fear
// *                     Level 2: Cure Moderate Wounds, Lesser Restoration, Remove Paralysis
// *                     Level 3: Cure Serious Wounds, Remove Blindness/Deafness,
// *                              Remove Curse, Remove Disease,
// *                     Level 4: Cure Critical Wounds, Neutralize Poison, Restoration
int HasSpell(int Spell)
{
 int nResult = FALSE;
    if (GetLocalInt(OBJECT_SELF,"SPELLS" + IntToString(Spell)) == 0)
    {
        nResult = TRUE;
        SetLocalInt(OBJECT_SELF,"SPELLS" + IntToString(Spell), 1);
    }
 return nResult;
}

int GetObjectNeedsHealing(object oMostDamagedMember, int nPercent)
{
    int nResult = FALSE;
    nPercent = nPercent / 100;
    int nDamagedAmount = GetMaxHitPoints(oMostDamagedMember) * nPercent;
    if(GetCurrentHitPoints(oMostDamagedMember) < nDamagedAmount)
        nResult = TRUE;
    return nResult;
}

void main()
{
    // * HACK: should replace with get nearest creature reputation type
    object oNearestTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    object oNearestFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_FRIEND);
    object oMostDamagedMember = GetFactionMostDamagedMember(GetFaction(OBJECT_SELF));
    if(GetLocalInt(OBJECT_SELF,"FindClericType") == 0)
        {
            int nRandNum = 0;
/*            if(nRandNum > 0 )
                {
                nRandNum = 0;
                }            */
            SetLocalInt(OBJECT_SELF,"ClericType",nRandNum);// * 0 - Typical Cleric
                                                         // * 1 - ?
            SetLocalInt(OBJECT_SELF,"FindClericType",1);
        }
     //GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY);

switch (GetLocalInt(OBJECT_SELF,"ClericType"))
{
case 0:
  {
    if(HasSpell(SPELL_DEATH_WARD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_DEATH_WARD, OBJECT_SELF);
        SpeakString("*Death Ward*");
    }
    else
    if((HasSpell(SPELL_CURE_SERIOUS_WOUNDS) == TRUE) && (GetObjectNeedsHealing(oMostDamagedMember,20)))
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CURE_SERIOUS_WOUNDS, oMostDamagedMember);
        SpeakString("*Cure Serious Wounds*");
    }
    else
    // * Check if player has protection spells on
    if(HasSpell(SPELL_GREATER_DISPELLING) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_GREATER_DISPELLING, oNearestTarget);
        SpeakString("*Greater Dispelling*");
    }
    else
    if(HasSpell(SPELL_SILENCE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_SILENCE, oNearestTarget);
        SpeakString("*Silence*");
    }
    else
    if(HasSpell(SPELL_HOLD_PERSON) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_HOLD_PERSON, oNearestTarget);
        SpeakString("*Hold Person*");
    }
    else
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
}
}


