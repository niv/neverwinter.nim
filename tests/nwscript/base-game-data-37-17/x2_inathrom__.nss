//::///////////////////////////////////////////////
//:: iNathyrraRom__
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Decrases the level of the Nathyrra Romance Level variable
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////


void main()
{
    SetLocalInt(GetModule(),"iNathyrraRomLevel", GetLocalInt(GetModule(),"iNathyrraRomLevel")-1);
}
