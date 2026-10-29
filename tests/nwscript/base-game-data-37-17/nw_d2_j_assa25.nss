#include "NW_I0_GENERIC"

void main()
{
    object oFight = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    AdjustReputation(oFight, OBJECT_SELF, -100);

    DetermineCombatRound();

}
