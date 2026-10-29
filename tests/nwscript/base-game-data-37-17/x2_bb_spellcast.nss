//::///////////////////////////////////////////////
//:: Black Blade Of Disaster On Spell Cast AT
//:: x2_bb_spellcast
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The black blade of disaster is destroyed
    by mordenkainens disjunction
*/
//:://////////////////////////////////////////////
//:: Created By: GeorgZ
//:: Created On: Oct 11, 2003
//:://////////////////////////////////////////////

void main()
{
    if (GetLastSpell() ==  SPELL_MORDENKAINENS_DISJUNCTION)
    {
        SetPlotFlag(OBJECT_SELF,FALSE);
        DestroyObject(OBJECT_SELF);
    }
}

