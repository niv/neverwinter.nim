//*  Sorcerer: Level 20 (Offensive)
//*  Spell Level    0   1   2   3   4   5   6   7   8   9
//* -------------------------------------------------------
//*  Spell/Day
//*  Level 1        3   1   -   -   -   -   -   -   -   -
//*  Level 2        4   2   -   -   -   -   -   -   -   -
//*  Level 3        4   2   1   -   -   -   -   -   -   -
//*  Level 4        4   3   2   -   -   -   -   -   -   -
//*  Level 5        4   3   2   1   -   -   -   -   -   -
//*  Level 6        4   3   3   2   -   -   -   -   -   -
//*  Level 7        4   4   3   2   1   -   -   -   -   -
//*  Level 8        4   4   3   3   2   -   -   -   -   -
//*  Level 9        4   4   4   3   2   1   -   -   -   -
//*  Level 10       4   4   4   3   3   2   -   -   -   -
//*  Level 11       4   4   4   4   3   2   1   -   -   -
//*  Level 12       4   4   4   4   3   3   2   -   -   -
//*  Level 13       4   4   4   4   3   3   2   1   -   -
//*  Level 14       4   4   4   4   4   3   3   2   -   -
//*  Level 15       4   4   4   4   4   4   3   2   1   -
//*  Level 16       4   4   4   4   4   4   3   3   2   -
//*  Level 17       4   4   4   4   4   4   4   3   2   1
//*  Level 18       4   4   4   4   4   4   4   3   3   2
//*  Level 19       4   4   4   4   4   4   4   4   3   3
//*  Level 20       4   4   4   4   4   4   4   4   4   4

// * Spell Suggestions
// * Protection Spells:  Level 1: Protection from Evil/Good/Law, Mage Armor
// *                     Level 2: Resist Elements, Invisibility, Mirror Image, Bull's Strength
// *                     Level 3: Magic Circle against Chaos/Evil/Good/Law, Protection from Elements,
// *                              Invisibility Sphere, Haste
// *                     Level 4: Minor Globe of Invulnerability, Stoneskin, Fire Shield,
// *                              Improved Invisibility
// *                     Level 5: N/A
// *                     Level 6: Globe of Invulnerability, True Seeing, Mislead, Mass Haste,
// *                              Tenser's Transformation
// *                     Level 7: Spell Turning, Mass Invisibility, Simulacrum
// *                     Level 8: Protection from Spells
// *                     Level 9: N/A
// * Offensive Spells:   Level 1: Charm Person, Color Spray, Sleep, Magic Missile,
// *                              Ray of Enfeeblement, Burning Hands, Summon Monster I
// *                     Level 2: Melfs Acid Arrow, Summon Monster II, Web,
// *                              Ghoul Touch, Blindness/Deafness
// *                     Level 3: Dispel Magic, Flame Arrow, Stinking Cloud, Summon Monster III,
// *                              Hold Person, Fireball, Lightning Bolt, Vampiric Touch, Slow
// *                     Level 4: Summon Monster IV, Charm Monster, Confusion, Fear
// *                     Level 5: Cloudkill, Summon Monster V, Dominate Person, Feeblemind,
// *                              Hold Monster, Cone of Cold, Animate Dead,
// *                     Level 6: Greater Dispelling, Acid Fog, Summon Monster VI, Chain Lightning,
// *                              Circle of Death
// *                     Level 7: Power Word: Stun, Summon Monster VII, Delayed Blast Fireball,
// *                              Mordenkainen's Sword, Prismatic Spray, Control Undead, Finger of Death,
// *                     Level 8: Incendiary Cloud, Power Word: Blind, Summon Monster VIII, Mass Charm,
// *                     Level 9: Mordenkainen's Disjunction, Gate, Power Word: Kill, Summon Monster IX,
// *                              Dominate Monster, Meteor Swarm, Weird, Energy Drain, Wail of the Banshee,
// *                              Time Stop

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
    if(HasSpell(SPELL_PREMONITION) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_PREMONITION, OBJECT_SELF);
        SpeakString("*Premonition*");
    }
    else
    if(HasSpell(SPELL_MIND_BLANK) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MIND_BLANK, OBJECT_SELF);
        SpeakString("*Mind Blank*");
    }
    else
    if(HasSpell(SPELL_MISLEAD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MISLEAD, OBJECT_SELF);
        SpeakString("*Mislead*");
    }
    else
    if(HasSpell(SPELL_SPELL_TURNING) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_SPELL_TURNING, OBJECT_SELF);
        SpeakString("*Spell Turning*");
    }
    else
    if((HasSpell(SPELL_PROTECTION_FROM_SPELLS) == TRUE)
       && ((oNearestTarget != (GetNearestCreature(CREATURE_TYPE_CLASS,CLASS_TYPE_BARBARIAN)))
       || (oNearestTarget != (GetNearestCreature(CREATURE_TYPE_CLASS,CLASS_TYPE_FIGHTER)))
       || (oNearestTarget != (GetNearestCreature(CREATURE_TYPE_CLASS,CLASS_TYPE_MONK)))
       || (oNearestTarget != (GetNearestCreature(CREATURE_TYPE_CLASS,CLASS_TYPE_ROGUE)))))
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_PROTECTION_FROM_SPELLS, OBJECT_SELF);
        SpeakString("*Protection From Spells*");
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
    if(HasSpell(SPELL_WAIL_OF_THE_BANSHEE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_WAIL_OF_THE_BANSHEE, oNearestTarget);
        SpeakString("*Wail of the Banshee*");
    }
    else
    if(HasSpell(SPELL_METEOR_SWARM) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_METEOR_SWARM, oNearestTarget);
        SpeakString("*Meteor Swarm*");
    }
    else
    if(HasSpell(SPELL_INCENDIARY_CLOUD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_INCENDIARY_CLOUD, oNearestTarget);
        SpeakString("*Incendiary Cloud*");
    }
    else
    if(HasSpell(SPELL_FINGER_OF_DEATH) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FINGER_OF_DEATH, oNearestTarget);
        SpeakString("*Finger of Death*");
    }
    else
    if(HasSpell(SPELL_PRISMATIC_SPRAY) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_PRISMATIC_SPRAY, oNearestTarget);
        SpeakString("*Prismatic Spray*");
    }
    else
    if(HasSpell(SPELL_CHAIN_LIGHTNING) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CHAIN_LIGHTNING, oNearestTarget);
        SpeakString("*Chain Lightning*");
    }
    else
    if(HasSpell(SPELL_CONE_OF_COLD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CONE_OF_COLD, OBJECT_SELF);
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
    if(HasSpell(SPELL_PREMONITION) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_PREMONITION, OBJECT_SELF);
        SpeakString("*Premonition*");
    }
    else
    if(HasSpell(SPELL_ELEMENTAL_SHIELD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF);
        SpeakString("*Elemental Shield*");
    }
    else
    if(HasSpell(SPELL_MISLEAD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MISLEAD, OBJECT_SELF);
        SpeakString("*Mislead*");
    }
    else
    if(HasSpell(SPELL_SPELL_TURNING) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_SPELL_TURNING, OBJECT_SELF);
        SpeakString("*Spell Turning*");
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
    if(HasSpell(SPELL_TIME_STOP) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_TIME_STOP, oNearestTarget);
        SpeakString("*Time Stop");
    }
    else
    if(HasSpell(SPELL_METEOR_SWARM) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_METEOR_SWARM, oNearestTarget);
        SpeakString("*Meteor Swarm*");
    }
    else
    if(HasSpell(SPELL_INCENDIARY_CLOUD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_INCENDIARY_CLOUD, oNearestTarget);
        SpeakString("*Incendiary Cloud*");
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
    if(HasSpell(SPELL_PREMONITION) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_PREMONITION, OBJECT_SELF);
        SpeakString("*Premonition*");
    }
    else
    if(HasSpell(SPELL_MIND_BLANK) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MIND_BLANK, OBJECT_SELF);
        SpeakString("*Mind Blank*");
    }
    else
    if(HasSpell(SPELL_FEAR) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FEAR, OBJECT_SELF);
        SpeakString("*Mislead*");
    }
    else
    if(HasSpell(SPELL_SPELL_TURNING) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_SPELL_TURNING, OBJECT_SELF);
        SpeakString("*Spell Turning*");
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
    if(HasSpell(SPELL_TIME_STOP) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_TIME_STOP, oNearestTarget);
        SpeakString("*Time Stop");
    }
    else
    if(HasSpell(SPELL_POWER_WORD_STUN) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_POWER_WORD_STUN, oNearestTarget);
        SpeakString("*Power Word Stun*");
    }
    else
    if(HasSpell(SPELL_MASS_CHARM) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MASS_CHARM, oNearestTarget);
        SpeakString("*Mass Charm*");
    }
    else
    if(HasSpell(SPELL_MASS_DOMINATION) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MASS_DOMINATION, oNearestTarget);
        SpeakString("*Mass Domination*");
    }
    else
    if(HasSpell(SPELL_WAIL_OF_THE_BANSHEE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_WAIL_OF_THE_BANSHEE, oNearestTarget);
        SpeakString("*Wail of the Banshee*");
    }
    else
    if(HasSpell(SPELL_FEEBLEMIND) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FEEBLEMIND, oNearestTarget);
        SpeakString("*Feeblemind*");
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
    if(HasSpell(SPELL_PREMONITION) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_PREMONITION, OBJECT_SELF);
        SpeakString("*Premonition*");
    }
    else
    if(HasSpell(SPELL_ELEMENTAL_SHIELD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF);
        SpeakString("*Elemental Shield*");
    }
    else
    if(HasSpell(SPELL_SPELL_TURNING) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_SPELL_TURNING, OBJECT_SELF);
        SpeakString("*Spell Turning*");
    }
    else
    if(HasSpell(SPELL_PROTECTION_FROM_EVIL) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_PROTECTION_FROM_EVIL, OBJECT_SELF);
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
    if(HasSpell(SPELL_TIME_STOP) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_TIME_STOP, oNearestTarget);
        SpeakString("*Time Stop");
    }
    else
    if(HasSpell(SPELL_GATE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_GATE, oNearestTarget);
        SpeakString("*Gate*");
    }
    else
    if(HasSpell(SPELL_POWER_WORD_STUN) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_POWER_WORD_STUN, oNearestTarget);
        SpeakString("*Power Word Stun*");
    }
    else
    if(HasSpell(SPELL_MORDENKAINENS_SWORD) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MORDENKAINENS_SWORD, oNearestTarget);
        SpeakString("*Mordenkainen's Sword*");
    }
    else
    if(HasSpell(SPELL_WEB) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_WEB, oNearestTarget);
        SpeakString("*Web*");
    }
    else
    if(HasSpell(SPELL_SUMMON_CREATURE_VII) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_SUMMON_CREATURE_VII, oNearestTarget);
        SpeakString("*Summon VII*");
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
    if(HasSpell(SPELL_PREMONITION) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_PREMONITION, OBJECT_SELF);
        SpeakString("*Premonition*");
    }
    else
    if(HasSpell(SPELL_MIND_BLANK) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MIND_BLANK, OBJECT_SELF);
        SpeakString("*Mind Blank*");
    }
    else
    if(HasSpell(SPELL_WAIL_OF_THE_BANSHEE) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_WAIL_OF_THE_BANSHEE, oNearestTarget);
        SpeakString("*Wail of the Banshee*");
    }
    else
    if(HasSpell(SPELL_SPELL_TURNING) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_SPELL_TURNING, OBJECT_SELF);
        SpeakString("*Spell Turning*");
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
    if(HasSpell(SPELL_TIME_STOP) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_TIME_STOP, oNearestTarget);
        SpeakString("*Time Stop");
    }
    else
    if(HasSpell(SPELL_POWER_WORD_KILL) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_POWER_WORD_KILL, oNearestTarget);
        SpeakString("*Power Word Kill*");
    }
    else
    if(HasSpell(SPELL_FINGER_OF_DEATH) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FINGER_OF_DEATH, oNearestTarget);
        SpeakString("*Finger of Death*");
    }
    else
    if(HasSpell(SPELL_ENERGY_DRAIN) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_ENERGY_DRAIN, oNearestTarget);
        SpeakString("*Energy Drain*");
    }
    else
    if(HasSpell(SPELL_CLOUDKILL) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CLOUDKILL, oNearestTarget);
        SpeakString("*Cloudkill*");
    }
    else
    if(HasSpell(SPELL_CHAIN_LIGHTNING) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CHAIN_LIGHTNING, oNearestTarget);
        SpeakString("*Chain Lightning*");
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
