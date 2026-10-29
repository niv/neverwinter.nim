#include "NW_J_FETCH"

int StartingConditional()
{
    int iResult;
    // * return true if the item holder still has the item
    iResult = PlayerHasFetchItem(OBJECT_SELF);
    return iResult;
}
