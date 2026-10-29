// the henchman casts their spell

#include "X0_INC_HENAI"

void DoBuff(int nBuffType, object oTarget);
void HandleSpell(int nSpell, int nSpellGroup = 0, int nSelfOnly = 0);

void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetLocalObject(OBJECT_SELF, "Henchman_Spell_Target");
    int nBuffType = GetLocalInt(OBJECT_SELF, "X2_BUFFING_TYPE");
    ClearAllActions();
    SetAssociateState(NW_ASC_IS_BUSY, TRUE);
    if(nBuffType != 0)
    {
        //SetLocalFloat(OBJECT_SELF, "X2_BUFFING_DELAY", 0.0);
        if(oTarget != OBJECT_INVALID)
            DoBuff(nBuffType, oTarget);
        else // target all party
        {
            int i = 1;
            DoBuff(nBuffType, OBJECT_SELF);
            DoBuff(nBuffType, oPC);
            object oHench = GetHenchman(oPC, i);
            while(oHench != OBJECT_INVALID)
            {
                if(oHench != OBJECT_SELF)
                    DoBuff(nBuffType, oHench);
                i++;
                oHench = GetHenchman(oPC, i);
            }
            object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
            object oAnimal = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
            if(oFamiliar != OBJECT_INVALID)
                DoBuff(nBuffType, oFamiliar);
            if(oAnimal != OBJECT_INVALID)
                DoBuff(nBuffType, oAnimal);

        }
        SetLocalInt(OBJECT_SELF, "X2_BUFFING_TYPE", 0);
        ActionDoCommand(SetAssociateState(NW_ASC_IS_BUSY, FALSE));
        return;
    }
    int nSpell = GetLocalInt(OBJECT_SELF, "Deekin_Spell_Cast");

    if ((nSpell > 0) && (GetIsObjectValid(oTarget)))
    {
        ClearAllActions();
        ActionCastSpellAtObject(nSpell, oTarget);
        ActionDoCommand(SetLocalInt(OBJECT_SELF, "Deekin_Spell_Cast", 0));
        ActionDoCommand(SetLocalObject(OBJECT_SELF, "Henchman_Spell_Target", OBJECT_INVALID));
    }
    else PlayVoiceChat(VOICE_CHAT_CUSS);
    ActionDoCommand(SetAssociateState(NW_ASC_IS_BUSY, FALSE));
}

void CheckAndCastSpell(int nSpell, int nSpellGroup, object oTarget)
{
    if(GetHasSpell(nSpell))
    {
        //float fDelay = GetLocalFloat(OBJECT_SELF, "X2_BUFFING_DELAY");
        if(nSpellGroup != 0)
        {
            string sGroup = "USED_SPELL_GROUP_" + IntToString(nSpellGroup);
            if(GetLocalInt(OBJECT_SELF, sGroup) == 0)
            {
                //DelayCommand(fDelay, ActionSpeakString("Casting " + GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpell))) + " On " + GetName(oTarget)));
                //DelayCommand(fDelay, ActionCastSpellAtObject(nSpell, oTarget));
                ActionCastSpellAtObject(nSpell, oTarget);
                SetLocalInt(OBJECT_SELF, sGroup, 1);
            }
        }
        else // no group, just cast the spell
        {
            //DelayCommand(fDelay, ActionSpeakString("Casting " + GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpell))) + " On " + GetName(oTarget)));
            //DelayCommand(fDelay, ActionCastSpellAtObject(nSpell, oTarget));
            ActionCastSpellAtObject(nSpell, oTarget);
        }
        //SetLocalFloat(OBJECT_SELF, "X2_BUFFING_DELAY", fDelay += 1.0);
    }
}

void HandleSpell(int nSpell, int nSpellGroup = 0, int nSelfOnly = 0)
{
    object oTarget = GetLocalObject(OBJECT_SELF, "Henchman_Spell_Target");
    if(nSelfOnly != 0 && oTarget != OBJECT_SELF)
        return;

    // need to put in ActionDoCommand() so GetHasSpell() would return correct values after casting spells
    ActionDoCommand(CheckAndCastSpell(nSpell, nSpellGroup, oTarget));

}

void InitGroups()
{
    // init spell groups
    int i = 1;
    string sName;
    for(i = 1; i <= 9; i++)
    {
        sName = "USED_SPELL_GROUP_" + IntToString(i);
        SetLocalInt(OBJECT_SELF, sName, 0);
    }
}

void DoBuff(int nBuffType, object oTarget)
{
    // buff types:
    // 1 - short duration
    // 2 - long duration
    // 3 - all

    // buff groups:
    // buff groups are used to prevent a henchmen to cast spells that have the same effect,
    // for example: resist elements and protection from elements are similiar so the henchmen
    // would cast only the most powerful among these if he has them both.
    int nBuffType = GetLocalInt(OBJECT_SELF, "X2_BUFFING_TYPE");
    SetLocalObject(OBJECT_SELF, "Henchman_Spell_Target", oTarget);
    if(nBuffType == 1 || nBuffType == 3) // short or all buffs
    {
        HandleSpell(SPELL_GREATER_SPELL_MANTLE, 9, 1);
        HandleSpell(SPELL_SPELL_MANTLE, 9);
        HandleSpell(SPELL_GLOBE_OF_INVULNERABILITY, 7, 1);
        HandleSpell(SPELL_ETHEREAL_VISAGE, 8, 1);
        HandleSpell(SPELL_REGENERATE, 3);
        HandleSpell(SPELL_MONSTROUS_REGENERATION, 3);
        HandleSpell(SPELL_MASS_HASTE, 5, 1);
        HandleSpell(SPELL_LESSER_SPELL_MANTLE, 9, 1);
        HandleSpell(SPELL_MESTILS_ACID_SHEATH, 0, 1);
        HandleSpell(SPELL_MINOR_GLOBE_OF_INVULNERABILITY, 7, 1);
        HandleSpell(SPELL_ELEMENTAL_SHIELD, 0, 1);
        HandleSpell(SPELL_DIVINE_POWER, 0, 1);
        HandleSpell(SPELL_HASTE, 5);
        HandleSpell(SPELL_PRAYER, 0, 1);
        HandleSpell(SPELL_DEATH_ARMOR, 0, 1);
        HandleSpell(SPELL_CLARITY);
        HandleSpell(SPELL_DIVINE_FAVOR, 0, 1);
        HandleSpell(SPELL_RESISTANCE);
        HandleSpell(SPELL_SANCTUARY, 2);
        HandleSpell(SPELL_EXPEDITIOUS_RETREAT, 0, 1);

    }
    if(nBuffType == 2 || nBuffType == 3) // long or all buffs
    {
        HandleSpell(SPELL_PREMONITION, 8, 1);
        HandleSpell(SPELL_SHADOW_SHIELD, 0, 1);
        HandleSpell(SPELL_PROTECTION_FROM_SPELLS);
        HandleSpell(SPELL_GREATER_STONESKIN, 8, 1);
        HandleSpell(SPELL_ENERGY_BUFFER, 1, 1);
        HandleSpell(SPELL_STONESKIN, 8);
        HandleSpell(SPELL_GHOSTLY_VISAGE, 8, 1);
        HandleSpell(SPELL_SHIELD, 0, 1);
        HandleSpell(SPELL_TRUE_SEEING);
        HandleSpell(SPELL_SPELL_RESISTANCE);
        HandleSpell(SPELL_FREEDOM_OF_MOVEMENT);
        HandleSpell(SPELL_DEATH_WARD);
        HandleSpell(SPELL_PROTECTION_FROM_ELEMENTS, 1);
        HandleSpell(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, 4, 1);
        HandleSpell(SPELL_MAGIC_VESTMENT);
        HandleSpell(SPELL_INVISIBILITY_PURGE);
        HandleSpell(SPELL_RESIST_ELEMENTS, 1);
        HandleSpell(SPELL_OWLS_WISDOM);
        HandleSpell(SPELL_FOXS_CUNNING);
        HandleSpell(SPELL_BULLS_STRENGTH);
        HandleSpell(SPELL_CATS_GRACE);
        HandleSpell(SPELL_GREATER_EAGLE_SPLENDOR);
        HandleSpell(SPELL_ENDURANCE);
        HandleSpell(SPELL_AID);
        HandleSpell(SPELL_MAGE_ARMOR);
        HandleSpell(SPELL_SHIELD_OF_FAITH, 0, 1);
        HandleSpell(SPELL_PROTECTION_FROM_EVIL, 4);
        HandleSpell(SPELL_ENTROPIC_SHIELD, 0, 1);
        HandleSpell(SPELL_ENDURE_ELEMENTS, 1);
        HandleSpell(SPELL_BLESS);
        HandleSpell(SPELL_ETHEREALNESS, 2, 1);
        HandleSpell(SPELL_INVISIBILITY_SPHERE, 6, 1);
        HandleSpell(SPELL_IMPROVED_INVISIBILITY, 6);
        HandleSpell(SPELL_INVISIBILITY, 6);
    }

    ActionDoCommand(InitGroups());
}
