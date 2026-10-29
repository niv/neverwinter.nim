/* OnHeartbeat Script for the wyrm that the Deck of Many Things
 * hatchling turns into. This causes the wyrm to vanish after
 * no more enemies are around.
 */

#include "X0_INC_HENAI"

void main()
{
    object oMaster = GetMaster();
    object oNearEnemy = GetNearestSeenEnemy();

    if (GetIsObjectValid(oNearEnemy) || GetIsInCombat()) {
        DetermineCombatRound(oNearEnemy);
        return;
    }

    // if we got here, no more enemies
    effect eVanish = EffectDisappear();
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        eVanish,
                        OBJECT_SELF,
                        3.0);

}


