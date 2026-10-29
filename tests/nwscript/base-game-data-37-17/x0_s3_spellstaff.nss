//::///////////////////////////////////////////////
//:: x0_s3_spellstaff
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires the three spells stored on it.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    object oItem = GetItemPossessedBy(OBJECT_SELF, "x0_spellstaff");
    object oPC = OBJECT_SELF;
    string sTag = GetTag(oItem);
   // SetLocalInt(oItem, "X0_L_SPELL1", SPELL_PREMONITION);
   // SetLocalInt(oItem, "X0_L_SPELL2", SPELL_MAGE_ARMOR);
  //  SetLocalInt(oItem, "X0_L_SPELL3", SPELL_HASTE);

    int nSpell1 = GetCampaignInt("dbItems", "X0_L_spellstaff_SPELL1");
    int nSpell2 = GetCampaignInt("dbItems", "X0_L_spellstaff_SPELL2");
    int nSpell3 = GetCampaignInt("dbItems", "X0_L_spellstaff_SPELL3");
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionCastSpellAtObject(nSpell1, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
    AssignCommand(oPC, ActionCastSpellAtObject(nSpell2, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
    AssignCommand(oPC, ActionCastSpellAtObject(nSpell3, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE, oPC)));
    AssignCommand(oPC, SetCommandable(FALSE, oPC));


}
