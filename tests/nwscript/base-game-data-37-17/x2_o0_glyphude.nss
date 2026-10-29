//::///////////////////////////////////////////////
//:: Glyph of Warding OnuserDefined
//:: x2_o0_glyphhb
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script fires the glyph of warding
    effects.

    Check x2_o0_hhb.nss and the Glyph of Warding
    placeable object for details

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////

void main()
{
    if (GetUserDefinedEventNumber() == 2000 &&  GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_TRIGGERED") == 0 )
    {
        effect eVis = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,OBJECT_SELF);
        int nSpell  = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_SPELL");
        int nMetaMagic = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_METAMAGIC");
        object oTarget = GetLocalObject(OBJECT_SELF,"X2_GLYPH_LAST_ENTER");
        string sScript = GetLocalString(OBJECT_SELF,"X2_GLYPH_SPELLSCRIPT");

        if (sScript != "")
        {
            ActionCastFakeSpellAtObject(nSpell,oTarget,PROJECTILE_PATH_TYPE_DEFAULT);
            ExecuteScript(sScript,oTarget);
        }
        else
        {
            ActionCastSpellAtObject(nSpell,oTarget,nMetaMagic,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
        }

        int nCharges = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CHARGES");

        if(nCharges ==0)
        {
            SetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_TRIGGERED",TRUE);
            effect e1 = GetFirstEffect(OBJECT_SELF);
            while (GetIsEffectValid(e1))
            {
                if (GetEffectType(e1) == EFFECT_TYPE_VISUALEFFECT)
                {
                    if (GetEffectCreator(e1) == OBJECT_SELF)
                    {
                        RemoveEffect(OBJECT_SELF,e1);
                    }
                }
                e1 = GetNextEffect(OBJECT_SELF);
            }


            DestroyObject(OBJECT_SELF,1.0f);
        }
        else
        {
          if (nCharges >0)
          {
            nCharges --;
            SetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CHARGES",nCharges);
           }
        }

    }
}
