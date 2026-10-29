void main()
{
    object oTarget = GetAttackTarget();
    object oAttacker = GetLastAttacker(OBJECT_SELF);
    if (GetIsObjectValid(oAttacker) &&
        (GetTotalDamageDealt() > (GetMaxHitPoints(OBJECT_SELF) / 4) ||
        GetHitDice(oAttacker) >= GetHitDice(oTarget) )  &&
        oTarget != oAttacker &&
        GetIsEnemy(oAttacker) )
    {
      ClearAllActions();
      ActionAttack(oAttacker);
    }
}
