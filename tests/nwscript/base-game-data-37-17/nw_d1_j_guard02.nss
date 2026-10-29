#include "NW_I0_PLOT"

void main()
{
   SetPLocalInt(GetPCSpeaker(), "NW_L_ENTRANCEGRANTED"+GetTag(OBJECT_SELF),1);
   TakeGold(100,GetPCSpeaker());

}

