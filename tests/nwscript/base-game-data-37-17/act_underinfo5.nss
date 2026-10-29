//::///////////////////////////////////////////////
//:: act_UnderInfo5
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Sets the state of the Undermountain_Info variable
   1 = Player knows Halaster has vanished
   2 = Durnan told Halaster has vanished
   3 = Player knows Halaster captured by Drow
   4 = Durnan told Halaster captured by Drow
   5 = Player knows of The Matron
   6 = Player told Halaster of The Matron
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: July 23, 2003
//:://////////////////////////////////////////////

void main()
{
  if (GetLocalInt(GetModule(),("Undermountain_Info"))<=5)
     {
     SetLocalInt(GetModule(),("Undermountain_Info"),5);
     }
}


