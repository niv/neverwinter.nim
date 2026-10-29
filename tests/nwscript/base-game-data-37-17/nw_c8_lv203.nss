//*  Bard: Level 20 (Offensive)
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
//*  Level 8        3   3   3   1   -   -   -   -
//*  Level 9        3   3   3   2   -   -   -   -
//*  Level 10       3   3   3   2   0   -   -   -
//*  Level 11       3   3   3   3   1   -   -   -
//*  Level 12       3   3   3   3   2   -   -   -
//*  Level 13       3   3   3   3   2   0   -   -
//*  Level 14       4   3   3   3   3   1   -   -
//*  Level 15       4   4   3   3   3   2   -   -
//*  Level 16       4   4   4   3   3   2   0   -
//*  Level 17       4   4   4   4   3   3   1   -
//*  Level 18       4   4   4   4   4   3   2   -
//*  Level 19       4   4   4   4   4   4   3   -
//*  Level 20       4   4   4   4   4   4   4   -

// * Protection Spells:  Level 1: Protection from Evil/Good/Law, Mage Armor, Resistance(0)
// *                     Level 2: See Invisibility, Invisibility, Mirror Image, Bull's Strength
// *                     Level 3: Magic Circle against Chaos/Evil/Good/Law, Invisibility Sphere, Haste
// *                     Level 4: Improved Invisibility
// *                     Level 5: Mislead
// *                     Level 6: Mass Haste
// * Offensive Spells:   Level 1: Charm Person, Sleep, Summon Monster I
// *                     Level 2: Summon Monster II, Blindness/Deafness, Hold Person
// *                     Level 3: Charm Monster, Confusion, Dispel Magic, Fear, Gust of Wind, Slow,
// *                              Summon Monster III
// *                     Level 4: Dominate Person, Hold Monster, Summon Monster IV
// *                     Level 5: Greater Dispelling, Summon Monster V
// *                     Level 6: Summon VI
// * Defensive Spells:   Level 1: Cure Light Woulds
// *                     Level 2: Cure Moderate Wounds
// *                     Level 3: Cure Serious Wounds, Remove Curse, Remove Disease
// *                     Level 4: Cure Critical Wounds, Neutralize Poison
// *                     Level 5: Healing Circle
// *                     Level 6: N/A

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
/*            if(nRandNum > 0 )
                {
                nRandNum = 0;
                }            */
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
    if(HasSpell(SPELL_CLARITY) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CLARITY, OBJECT_SELF);
        SpeakString("*Clarity*");
    }
    else
    if(HasSpell(SPELL_MISLEAD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MISLEAD, OBJECT_SELF);
        SpeakString("*Mislead*");
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
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
}
}
