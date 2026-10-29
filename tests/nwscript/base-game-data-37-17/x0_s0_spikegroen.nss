//::///////////////////////////////////////////////
//:: Spike Growth: On Enter
//:: x0_s0_spikegroEN.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 1d4 acid damage
    per round
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////

#include "x0_i0_spells"

#include "x2_inc_spellhook"

void main()
{




    DoSpikeGrowthEffect(GetEnteringObject());
}
