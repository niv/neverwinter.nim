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
//*  Level 8        6   4+1 3+1 3+1 2+1  -   -   -   -   -
//*  Level 9        6   4+1 4+1 3+1 2+1 1+1  -   -   -   -
//*  Level 10       6   4+1 4+1 3+1 3+1 2+1  -   -   -   -
//*  Level 11       6   5+1 4+1 4+1 3+1 2+1 1+1  -   -   -
//*  Level 12       6   5+1 4+1 4+1 3+1 3+1 2+1  -   -   -
//*  Level 13       6   5+1 5+1 4+1 4+1 3+1 2+1 1+1  -   -
//*  Level 14       6   5+1 5+1 4+1 4+1 3+1 3+1 2+1 1+1  -
//*  Level 15       6   5+1 5+1 5+1 4+1 4+1 3+1 2+1 2+1  -
//*  Level 16       6   5+1 5+1 5+1 4+1 4+1 3+1 3+1 2+1  -
//*  Level 17       6   5+1 5+1 5+1 5+1 4+1 4+1 3+1 3+1 1+1
//*  Level 18       6   5+1 5+1 5+1 5+1 4+1 4+1 3+1 3+1 2+1
//*  Level 19       6   5+1 5+1 5+1 5+1 5+1 4+1 4+1 3+1 3+1
//*  Level 20       6   5+1 5+1 5+1 5+1 5+1 4+1 4+1 4+1 4+1

// * Protection Spells:  Level 0: Resistance, Virtue
// *                     Level 1: Bless, Endure Elements, Protection from C/E/G/L, Sanctuary
// *                     Level 2: Aid, Bull's Strength, Calm Emotions, Darkness,
// *                              Endurance, Find Traps, Resist Elements,
// *                     Level 3: Magic Circle against C/E/G/L, Magic Vestment,
// *                              Negative Energy Protection, Prayer, Protection from Elements
// *                     Level 4: Death Ward, Divine Power, Freedom of Movement
// *                     Level 5: Spell Resistance
// *                     Level 6: n/a
// *                     Level 7: n/a
// *                     Level 8: Cloak of Chaos, Holy Aura, Shield of Law, Unholy Aura
// *                     Level 9: n/a
// * Offensive Spells:   Level 0: n/a
// *                     Level 1: Cause Fear, Doom, Magic Stone, Magic Weapon
// *                              Summon Monster I
// *                     Level 2: Enthrall, Hold Person, Silence, Sound Burst,
// *                              Summon Monster II
// *                     Level 3: Animate Dead, Blindness/Deafness, Contagion, Dispel Magic,
// *                              Invisibility Purge, Searing Light, Summon Monster III
// *                     Level 4: Dismissal, Summon Monster IV
// *                     Level 5: Circle of Doom, Dispel C/E/G/L, Flame Strike, Slay Living,
// *                              Summon Monster V, True Seeing
// *                     Level 6: Blade Barrier, Create Undead, Greater Dispelling, Harm, Summon Monster VI
// *                     Level 7: Summon Monster VII
// *                     Level 8: Create Greater Undead, Fire Storm, Summon Monster VIII
// *                     Level 9: Energy Drain, Gate, Implosion, Storm of Vengeance, Summon Monster IX
// * Defensive Spells:   Level 0: Cure Minor Wounds, Light
// *                     Level 1: Cure Light Wounds, Remove Fear
// *                     Level 2: Cure Moderate Wounds, Lesser Restoration, Remove Paralysis
// *                     Level 3: Cure Serious Wounds, Remove Blindness/Deafness,
// *                              Remove Curse, Remove Disease,
// *                     Level 4: Cure Critical Wounds, Neutralize Poison, Restoration
// *                     Level 5: Healing Circle, Raise Dead
// *                     Level 6: Heal
// *                     Level 7: Greater Restoration, Resurrection
// *                     Level 8: Mass Heal
// *                     Level 9: n/a
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
    if(HasSpell(SPELL_BLADE_BARRIER) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_BLADE_BARRIER, OBJECT_SELF);
        SpeakString("*Blade Barrier*");
    }
    else
    if(HasSpell(SPELL_HOLY_AURA) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_HOLY_AURA, OBJECT_SELF);
        SpeakString("*Holy Aura*");
    }
    else
    if((HasSpell(SPELL_HEAL) == TRUE) && (GetObjectNeedsHealing(oMostDamagedMember,25)))
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_HEAL,oMostDamagedMember);
        SpeakString("*Heal*");
    }
    else
    if((HasSpell(SPELL_CURE_SERIOUS_WOUNDS) == TRUE) && (GetObjectNeedsHealing(oMostDamagedMember,20)))
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CURE_SERIOUS_WOUNDS,oMostDamagedMember);
        SpeakString("*Cure Serious Wounds*");
    }
    else
    if(HasSpell(SPELL_STORM_OF_VENGEANCE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_STORM_OF_VENGEANCE, oNearestTarget);
        SpeakString("*Storm of Vengeance*");
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
    if(HasSpell(SPELL_FIRE_STORM) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FIRE_STORM, oNearestTarget);
        SpeakString("*Fire Storm*");
    }
    else
    if(HasSpell(SPELL_FLAME_STRIKE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FLAME_STRIKE, oNearestTarget);
        SpeakString("*Flame Strike*");
    }
    else
    if(HasSpell(SPELL_IMPLOSION) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_IMPLOSION, oNearestTarget);
        SpeakString("*Implosion*");
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
    if(HasSpell(SPELL_HARM) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_HARM, oNearestTarget);
        SpeakString("*Harm*");
    }
    else
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
}
}
