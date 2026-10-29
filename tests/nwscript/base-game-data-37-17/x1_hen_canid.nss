// returns TRUE if henchman lore skill is better than his master's

int StartingConditional()
{
    int nHenchmanLore = GetSkillRank(SKILL_LORE, OBJECT_SELF);
    int nMasterLore = GetSkillRank(SKILL_LORE, GetMaster(OBJECT_SELF));

    return (nHenchmanLore > nMasterLore);
}
