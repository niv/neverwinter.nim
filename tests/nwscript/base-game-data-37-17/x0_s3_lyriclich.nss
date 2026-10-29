//::///////////////////////////////////////////////
//:: Name
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    These bard lyrics will 'use' your bard song.
    
    The Lich Song:
        - always a Horrid Wilting once per day.
    
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////


void main()
{
    if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
    {
        SpeakStringByStrRef(40063);
    }
    else
    {
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
        PlaySound("as_cv_flute2");
        ActionCastSpellAtObject(SPELL_HORRID_WILTING, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    }
}
