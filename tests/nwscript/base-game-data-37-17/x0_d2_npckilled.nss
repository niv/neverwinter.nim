/* TRUE if this PC or a party member killed the NPC */

#include "x0_i0_npckilled"

int StartingConditional()
{
    return GetNPCKilled(GetPCSpeaker(), GetTag(OBJECT_SELF));
}
