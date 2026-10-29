/* GESTURE SCRIPT - NPC performs gesture and voicechat ATTACK */

void main()
{
    object oSource = OBJECT_SELF;
    PlayVoiceChat(VOICE_CHAT_ATTACK, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_TAUNT));
}

