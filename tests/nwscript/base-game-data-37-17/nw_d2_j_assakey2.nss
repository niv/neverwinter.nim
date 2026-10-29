#include "NW_I0_PLOT"

void main()
{
    RewardGP(300,GetPCSpeaker(),FALSE);
    SetLocalInt(OBJECT_SELF,"Generic_Surrender",3);
    // EscapeArea(); Commented this out because this script fires
    // when you agree to the double cross
    // did not make sense for the victim to leave
}

