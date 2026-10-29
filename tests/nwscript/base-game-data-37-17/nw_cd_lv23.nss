//*  Cleric: Level 20
//*  Spell Level    0    1   2   3   4   5   6   7   8   9
//* --------------------------------------------------------
//*  Spell/Day
//*  Level 1        3   1+1  -   -   -   -   -   -   -   -
//*  Level 2        4   2+1  -   -   -   -   -   -   -   -

// * Protection Spells:  Level 0: Resistance, Virtue
// *                     Level 1: Bless, Endure Elements, Protection from C/E/G/L, Sanctuary
// * Offensive Spells:   Level 0: n/a
// *                     Level 1: Cause Fear, Doom, Magic Stone, Magic Weapon
// *                              Summon Monster I
// * Defensive Spells:   Level 0: Cure Minor Wounds, Light
// *                     Level 1: Cure Light Wounds, Remove Fear

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
    if((HasSpell(SPELL_CURE_LIGHT_WOUNDS) == TRUE) && (GetObjectNeedsHealing(oMostDamagedMember,15)))
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_CURE_LIGHT_WOUNDS, oMostDamagedMember);
        SpeakString("*Cure Light WOunds*");
    }

    else
    if(HasSpell(SPELL_DOOM) == TRUE)
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_DOOM, oNearestTarget);
        SpeakString("*Silence*");
    }
    else
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
}
}
