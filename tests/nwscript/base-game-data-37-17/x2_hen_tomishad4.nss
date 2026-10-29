// Tomi uses his Summon Shadow ability

void main()
{
    ClearAllActions();
//    ActionUseFeat(FEAT_SUMMON_SHADOW, OBJECT_SELF);
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_SUMMON_SHADOW);
    ActionCastSpellAtObject(SPELL_SUMMON_SHADOW, OBJECT_SELF, METAMAGIC_ANY, TRUE);
    
}
