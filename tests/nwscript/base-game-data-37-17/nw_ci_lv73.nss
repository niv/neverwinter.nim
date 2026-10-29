//*  Sorcerer: Level 7 (Offensive)
//*  Spell Level    0   1   2   3   4   5   6   7
//* -----------------------------------------------
//*  Spell/Day
//*  Level 1        3   1   -   -   -   -   -   -
//*  Level 2        4   2   -   -   -   -   -   -
//*  Level 3        4   2   1   -   -   -   -   -
//*  Level 4        4   3   2   -   -   -   -   -
//*  Level 5        4   3   2   1   -   -   -   -
//*  Level 6        4   3   3   2   -   -   -   -
//*  Level 7        4   4   3   2   1   -   -   -
// *
// * Spell Suggestions
// * Protection Spells:  Level 1: Protection from Evil/Good/Law, Mage Armor
// *                     Level 2: Resist Elements, Invisibility, Mirror Image, Bull's Strength
// *                     Level 3: Magic Circle against Chaos/Evil/Good/Law, Protection from Elements,
// *                              Invisibility Sphere, Haste
// *                     Level 4: Minor Globe of Invulnerability, Stoneskin, Fire Shield,
// *                              Improved Invisibility
// * Offensive Spells:   Level 1: Charm Person, Color Spray, Sleep, Magic Missile,
// *                              Ray of Enfeeblement, Burning Hands, Summon Monster I
// *                     Level 2: Melfs Acid Arrow, Summon Monster II, Web,
// *                              Ghoul Touch, Blindness/Deafness
// *                     Level 3: Dispel Magic, Flame Arrow, Stinking Cloud, Summon Monster III,
// *                              Hold Person, Fireball, Lightning Bolt, Vampiric Touch, Slow
// *                     Level 4: Summon Monster IV, Charm Monster, Confusion, Fear

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
            SetLocalInt(OBJECT_SELF,"WizardType",nRandNum);// * 0 - Typical Wizard
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
    if(HasSpell(SPELL_HASTE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_HASTE, OBJECT_SELF);
        SpeakString("*Haste*");
    }
    else
    if(HasSpell(SPELL_STONESKIN) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_STONESKIN, OBJECT_SELF);
        SpeakString("*Stoneskin*");
    }
    else
    if(HasSpell(SPELL_CLARITY) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CLARITY, OBJECT_SELF);
        SpeakString("*Clarity*");
    }
    else
    if ((oNearestTarget == (GetNearestCreature(CREATURE_TYPE_RACIAL_TYPE,RACIAL_TYPE_ELEMENTAL)))
    && (HasSpell(SPELL_PROTECTION_FROM_ELEMENTS) == TRUE))
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_PROTECTION_FROM_ELEMENTS, OBJECT_SELF);
        SpeakString("*Prot from Elements*");
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
    // * Check distance so not too close to fireball
    if((HasSpell(SPELL_FIREBALL) == TRUE) && (GetDistanceToObject(oNearestTarget) > 10.0))
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FIREBALL, oNearestTarget);
        SpeakString("*Fireball*");
    }
    else
    if(HasSpell(SPELL_FLAME_ARROW) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FLAME_ARROW, oNearestTarget);
        SpeakString("*Flame Arrow*");
    }
    else
    if(HasSpell(SPELL_MELFS_ACID_ARROW) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MELFS_ACID_ARROW, oNearestTarget);
        SpeakString("*Melf's Acid Arrow*");
    }
    else
    if(HasSpell(SPELL_MAGIC_MISSILE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGIC_MISSILE, oNearestTarget);
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
    if(HasSpell(SPELL_HASTE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_HASTE, OBJECT_SELF);
        SpeakString("*Haste*");
    }
    else
    if(HasSpell(SPELL_STONESKIN) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_STONESKIN, OBJECT_SELF);
        SpeakString("*Stoneskin*");
    }
    else
    if(HasSpell(SPELL_ELEMENTAL_SHIELD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF);
        SpeakString("*Elemental Shield*");
    }
    else
    if(HasSpell(SPELL_PROTECTION_FROM_ELEMENTS) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_PROTECTION_FROM_ELEMENTS, OBJECT_SELF);
        SpeakString("*Prot from Elements*");
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
    // * Check distance so not too close to fireball
    if((HasSpell(SPELL_FIREBALL) == TRUE) && (GetDistanceToObject(oNearestTarget) > 10.0))
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FIREBALL, oNearestTarget);
        SpeakString("*Fireball*");
    }
    else
    if(HasSpell(SPELL_FLAME_ARROW) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FLAME_ARROW, oNearestTarget);
        SpeakString("*Flame Arrow*");
    }
    else
    if(HasSpell(SPELL_MELFS_ACID_ARROW) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MELFS_ACID_ARROW, oNearestTarget);
        SpeakString("*Melf's Acid Arrow*");
    }
    else
    if(HasSpell(SPELL_MAGIC_MISSILE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGIC_MISSILE, oNearestTarget);
        SpeakString("*Magic Missile*");
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
    if(HasSpell(SPELL_HASTE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_HASTE, OBJECT_SELF);
        SpeakString("*Haste*");
    }
    else
    if(HasSpell(SPELL_STONESKIN) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_STONESKIN, OBJECT_SELF);
        SpeakString("*Stoneskin*");
    }
    else
    if(HasSpell(SPELL_CLARITY) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CLARITY, OBJECT_SELF);
        SpeakString("*Clarity*");
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
    if(HasSpell(SPELL_WEB) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_WEB, oNearestTarget);
        SpeakString("*Web*");
    }
    else
    if(HasSpell(SPELL_DOMINATE_PERSON) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_DOMINATE_PERSON, oNearestTarget);
        SpeakString("*Dominate*");
    }
    else
    if(HasSpell(SPELL_CHARM_PERSON) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CHARM_PERSON, oNearestTarget);
        SpeakString("*Charm Person*");
    }
    else
    if(HasSpell(SPELL_MAGIC_MISSILE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGIC_MISSILE, oNearestTarget);
        SpeakString("*Magic Missile*");
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
    if(HasSpell(SPELL_HASTE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_HASTE, OBJECT_SELF);
        SpeakString("*Haste*");
    }
    else
    if(HasSpell(SPELL_STONESKIN) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_STONESKIN, OBJECT_SELF);
        SpeakString("*Stoneskin*");
    }
    else
    if(HasSpell(SPELL_ELEMENTAL_SHIELD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF);
        SpeakString("*Elemental Shield*");
    }
    else
    if(HasSpell(SPELL_MINOR_GLOBE_OF_INVULNERABILITY) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MINOR_GLOBE_OF_INVULNERABILITY, OBJECT_SELF);
        SpeakString("*Minor Globe of Invul*");
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
    if(HasSpell(SPELL_FLAME_ARROW) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FLAME_ARROW, oNearestTarget);
        SpeakString("*Flame Arrow*");
    }
    else
    if(HasSpell(SPELL_SUMMON_CREATURE_IV) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_SUMMON_CREATURE_IV, oNearestTarget);
        SpeakString("*Summon IV*");
    }
    else
    if(HasSpell(SPELL_LIGHTNING_BOLT) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_LIGHTNING_BOLT, oNearestTarget);
        SpeakString("*Lightning Bolt*");
    }
    else
    if(HasSpell(SPELL_MAGIC_MISSILE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGIC_MISSILE, oNearestTarget);
        SpeakString("*Magic Missile*");
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
    if(HasSpell(SPELL_HASTE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_HASTE, OBJECT_SELF);
        SpeakString("*Haste*");
    }
    else
    if(HasSpell(SPELL_STONESKIN) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_STONESKIN, OBJECT_SELF);
        SpeakString("*Stoneskin*");
    }
    else
    if(HasSpell(SPELL_CLARITY) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CLARITY, OBJECT_SELF);
        SpeakString("*Clarity*");
    }
    else
    if(HasSpell(SPELL_STINKING_CLOUD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_STINKING_CLOUD, OBJECT_SELF);
        SpeakString("*Stinking Cloud*");
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
    if(HasSpell(SPELL_WALL_OF_FIRE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_WALL_OF_FIRE, OBJECT_SELF);
        SpeakString("*Wall of Fire*");
    }
    else
    if(HasSpell(SPELL_MELFS_ACID_ARROW) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MELFS_ACID_ARROW, OBJECT_SELF);
        SpeakString("*Melfs Acid Arrow*");
    }
    else
    if(HasSpell(SPELL_BLINDNESS_AND_DEAFNESS) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_BLINDNESS_AND_DEAFNESS, OBJECT_SELF);
        SpeakString("*Blind/Deaf*");
    }
    else
    if(HasSpell(SPELL_MAGIC_MISSILE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGIC_MISSILE, oNearestTarget);
        SpeakString("*Magic Missile*");
    }
    else
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
}
}
