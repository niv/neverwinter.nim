//*  Bard: Level 7 (Offensive)
//*  Spell Level    0   1   2   3   4   5   6   7
//* -----------------------------------------------
//*  Spell/Day
//*  Level 1        2   -   -   -   -   -   -   -
//*  Level 2        3   0   -   -   -   -   -   -
//*  Level 3        3   1   -   -   -   -   -   -
//*  Level 4        3   2   0   -   -   -   -   -
//*  Level 5        3   3   1   -   -   -   -   -
//*  Level 6        3   3   2   -   -   -   -   -
//*  Level 7        3   3   2   0   -   -   -   -

// * Protection Spells:  Level 1: Protection from Evil/Good/Law, Mage Armor, Resistance
// *                     Level 2: See Invisibility, Invisibility, Mirror Image, Bull's Strength
// *                     Level 3: Magic Circle against Chaos/Evil/Good/Law, Invisibility Sphere, Haste
// * Offensive Spells:   Level 1: Charm Person, Sleep, Summon Monster I
// *                     Level 2: Summon Monster II, Blindness/Deafness, Hold Person
// *                     Level 3: Charm Monster, Confusion, Dispel Magic, Fear, Gust of Wind, Slow,
// *                              Summon Monster III
// * Defensive Spells:   Level 1: Cure Light Woulds
// *                     Level 2: Cure Moderate Wounds
// *                     Level 3: Cure Serious Wounds, Remove Curse, Remove Disease

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

void main()
{
    // * HACK: should replace with get nearest creature reputation type
    object oNearestTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    object oNearestFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_FRIEND);
    if(GetLocalInt(OBJECT_SELF,"FindBardType") == 0)
        {
            int nRandNum = 0;
/*            if(nRandNum > 0)
                {
                nRandNum = 0;
                }               */
            SetLocalInt(OBJECT_SELF,"BardType",nRandNum);// * 0 - Typical Bard
                                                         // * 1 - ?
            SetLocalInt(OBJECT_SELF,"FindBardType",1);
        }
     //GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY);

switch (GetLocalInt(OBJECT_SELF,"BardType"))
{
case 0:
  {
    if(HasSpell(SPELL_HASTE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_HASTE, OBJECT_SELF);
        SpeakString("*Haste*");
    }
    else
    if(HasSpell(SPELL_CURE_LIGHT_WOUNDS) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CURE_LIGHT_WOUNDS, OBJECT_SELF);
    }
    else
    if(HasSpell(SPELL_MAGE_ARMOR) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGE_ARMOR, OBJECT_SELF);
        SpeakString("*Mage Armor*");
    }
    else
    // * Check Alignment
    if(HasSpell(SPELL_MAGIC_CIRCLE_AGAINST_CHAOS) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGIC_CIRCLE_AGAINST_CHAOS, OBJECT_SELF);
        SpeakString("*Magic Circle*");
    }
    else
    // * Check if player has protection spells on
    if(HasSpell(SPELL_DISPEL_MAGIC) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_DISPEL_MAGIC, oNearestTarget);
        SpeakString("*Dispel Magic*");
    }
    else
    if( (HasSpell(SPELL_SLOW) == TRUE) && (GetDistanceToObject(oNearestTarget) > 10.0))
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_SLOW, oNearestTarget);
        SpeakString("*Slow*");
    }
    else
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
}
}
