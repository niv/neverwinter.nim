void main()
{
   int nSpell = GetLastSpell();
    // Dispel magic always
    if (nSpell ==    SPELL_DISPEL_MAGIC || nSpell == SPELL_GREATER_DISPELLING || nSpell == SPELL_LESSER_DISPEL || nSpell ==  SPELL_MORDENKAINENS_DISJUNCTION)
    {
        DestroyObject(OBJECT_SELF);
    }

}
