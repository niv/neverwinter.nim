//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Action Script: Set current selected part to
   Belt
*/
// created/updated 2003-06-24 Georg Zoeller, Bioware Corp
/////////////////////////////////////////////////////////

#include "x2_inc_craft"
void main()
{
   CISetCurrentModPart(GetPCSpeaker(),ITEM_APPR_ARMOR_MODEL_BELT,6745);
}
