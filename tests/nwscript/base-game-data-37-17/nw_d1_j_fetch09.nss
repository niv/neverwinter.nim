#include "NW_I0_Plot"
#include "NW_J_FETCH"

void main()
{
     SetLocalObject(Global(), "NW_J_FETCHPLOT_PC",GetPCSpeaker());
     SetLocalInt(Global(), "NW_J_FETCHPLOT", 50);
     GiveFetchItemToPC(GetPCSpeaker());

}
