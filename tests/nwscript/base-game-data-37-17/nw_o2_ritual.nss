//::///////////////////////////////////////////////
//:: Ritual SpellCast
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   This event fires when a spell is cast on the
   brazier.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December
//:://////////////////////////////////////////////

void main()
{
    // * if ritual happened once, don't let it happen again
    if (GetLocalInt(OBJECT_SELF,"NW_J_SETUPRITUAL") == 10)
    {
        return;
    }


    if (GetLocalInt(OBJECT_SELF,"NW_J_SETUPRITUAL") == 0)
    {
       ExecuteScript(GetTag(OBJECT_SELF) + "_SETUP", OBJECT_SELF);
       SetLocalInt(OBJECT_SELF,"NW_J_SETUPRITUAL",1);
    }


    // * now test to see if the spell was succesful
    if ((GetLastSpell() == GetLocalInt(OBJECT_SELF, "NW_J_SPELLID"))
       &&
       (GetTag(GetFirstItemInInventory()) == GetLocalString(OBJECT_SELF,"NW_J_REAGENT")))
    {
        // * modules stores and then demon stores object ID of person who summoned him.
        SetLocalObject(OBJECT_SELF, "NW_L_DEMON_SUMMONER", GetLastSpellCaster());
        // * should only be able to happen once
        ExecuteScript(GetTag(OBJECT_SELF) + "_USE", OBJECT_SELF);
        DestroyObject(GetFirstItemInInventory());
        SetLocalInt(OBJECT_SELF,"NW_J_SETUPRITUAL",10);
    }
    else
    // * fireball explosion
    {
        location loc = GetLocation(GetNearestObjectByTag(GetLocalString(OBJECT_SELF, "NW_J_CREATURELOC")));
        ActionCastSpellAtLocation(SPELL_FIREBALL, loc, METAMAGIC_ANY, TRUE);
    }
}



