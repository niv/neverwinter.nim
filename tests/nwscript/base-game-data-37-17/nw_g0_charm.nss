#include "NW_I0_GENERIC"
#include "x0_inc_henai"

void main()
{   SendForHelp();
    SetCommandable(TRUE);

    DetermineCombatRound();

    SetCommandable(FALSE);
}
