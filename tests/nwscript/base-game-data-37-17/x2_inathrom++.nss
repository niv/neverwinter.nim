//::///////////////////////////////////////////////
//:: iNathyrraRom++
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Increases the level of the Nathyrra Romance Level variable
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////
#include "x0_i0_henchman"


void main()
{
    SetLocalInt(GetModule(),"iNathyrraRomLevel", GetLocalInt(GetModule(),"iNathyrraRomLevel")+1);
    // * 0 the interjections so she has nothing in her "what did you want to say" dialog dialog.
    SetHasInterjection(GetPCSpeaker(), TRUE, 0);
    // * Turn off the "interjection" variable
    SetHasInterjection(GetPCSpeaker(), FALSE, 0);
}

