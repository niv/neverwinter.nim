//*  Bard: Level 7 (Offensive)
//*  Spell Level    0   1   2   3   4   5   6   7
//* -----------------------------------------------
//*  Spell/Day
//*  Level 1        2   -   -   -   -   -   -   -
//*  Level 2        3   0   -   -   -   -   -   -

// * Protection Spells:  Level 1: Protection from Evil/Good/Law, Mage Armor, Resistance
// * Offensive Spells:   Level 1: Charm Person, Sleep, Summon Monster I
// * Defensive Spells:   Level 1: Cure Light Woulds

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
                }                 */
            SetLocalInt(OBJECT_SELF,"BardType",nRandNum);// * 0 - Typical Bard
                                                         // * 1 - ?
            SetLocalInt(OBJECT_SELF,"FindBardType",1);
        }
     //GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY);

switch (GetLocalInt(OBJECT_SELF,"BardType"))
{
case 0:
  {
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
    {
        ActionAttack(oNearestTarget);
    }
  }
  break;
}
}
