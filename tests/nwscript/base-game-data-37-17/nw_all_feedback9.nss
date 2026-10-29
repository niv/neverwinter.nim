//::///////////////////////////////////////////////
//:: NW_ALL_FEEDBACK2.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Return true if player has activated a Word of
  Recall before.  CHAPTER 1 and CHAPTER1e
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult = FALSE;
    string sTag = GetTag(GetModule());
    if (sTag == "Chapter1" || sTag =="ENDMODULE1")
    {
        iResult = GetLocalInt(GetPCSpeaker(), "NW_L_USED_RECALL")>0;
    }
    return iResult;
}

