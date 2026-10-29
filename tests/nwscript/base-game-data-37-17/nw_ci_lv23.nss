//*  Sorcerer: Level 2 (Offensive)
//*  Spell Level    0   1   2   3   4   5   6   7   8   9
//* -------------------------------------------------------
//*  Spell/Day
//*  Level 1        3   1   -   -   -   -   -   -   -   -
//*  Level 2        4   2   -   -   -   -   -   -   -   -

// * Spell Suggestions
// * Protection Spells:  Level 1: Protection from Evil/Good/Law, Mage Armor
// * Offensive Spells:   Level 1: Charm Person, Color Spray, Sleep, Magic Missile,
// *                              Ray of Enfeeblement, Burning Hands, Summon Monster I
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
    if(GetLocalInt(OBJECT_SELF,"FindWizardType") == 0)
        {
            int nRandNum = Random(10);
            if(nRandNum > 4)
                {
                nRandNum = 0;
                }
            SetLocalInt(OBJECT_SELF,"WizardType",nRandNum);  // * 0 - Typical Wizard
                                                             // * 1 - Fire Freak Wizard
                                                             // * 2 - Charm/Fear/Domination Wizard
                                                             // * 3 - Heavy Summoning Wizard
                                                             // * 4 - Death Spells
            SetLocalInt(OBJECT_SELF,"FindWizardType",1);
        }
     //GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY);

switch (GetLocalInt(OBJECT_SELF,"WizardType"))
{
case 0:
  {
    SpeakString("Common Wizard");
    if(HasSpell(SPELL_MAGE_ARMOR) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGE_ARMOR, OBJECT_SELF);
        SpeakString("*Mage Armor*");
    }
    else
    if(HasSpell(SPELL_MAGIC_MISSILE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGIC_MISSILE, OBJECT_SELF);
        SpeakString("*Magic Missile*");
    }
    else
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
case 1:  // * Uses more Fire Related Spells
  {
    SpeakString("Fire Wizard");
    if(HasSpell(SPELL_MAGE_ARMOR) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGE_ARMOR, OBJECT_SELF);
        SpeakString("*Mage Armor*");
    }
    else
    if(HasSpell(SPELL_BURNING_HANDS) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_BURNING_HANDS, oNearestTarget);
        SpeakString("*Burning Hands*");
    }
    else
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
case 2:  // * Concentrates on Charming/Domination/Fearing
   {
    SpeakString("Dominating Wizard");
    if(HasSpell(SPELL_CHARM_PERSON) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CHARM_PERSON, oNearestTarget);
        SpeakString("*Charm Person*");
    }
    else
    if(HasSpell(SPELL_RAY_OF_ENFEEBLEMENT) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_RAY_OF_ENFEEBLEMENT, oNearestTarget);
        SpeakString("*Ray of Enfeeblement*");
    }
    else
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
case 3:  // * Uses Many Summoning Spells
   {
    SpeakString("Summoning Wizard");
    if(HasSpell(SPELL_MAGE_ARMOR) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGE_ARMOR, OBJECT_SELF);
        SpeakString("*Mage Armor*");
    }
    else
    if(HasSpell(SPELL_SUMMON_CREATURE_I) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_SUMMON_CREATURE_I, oNearestTarget);
        SpeakString("*Summon I*");
    }
    else
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
case 4:  // * Deadly Wizard
   {
    SpeakString("Deadly Wizard");
    if(HasSpell(SPELL_MAGE_ARMOR) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGE_ARMOR, OBJECT_SELF);
        SpeakString("*Mage Armor*");
    }
    else
    if(HasSpell(SPELL_COLOR_SPRAY) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_COLOR_SPRAY, oNearestTarget);
        SpeakString("*Color Spray*");
    }
    else
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
}
}
