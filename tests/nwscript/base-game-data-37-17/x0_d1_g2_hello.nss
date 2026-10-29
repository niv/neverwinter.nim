/* GESTURE SCRIPT - NPC performs gesture and voicechat HELLO */

void main()
{
    object oSource = OBJECT_SELF;
    PlayVoiceChat(VOICE_CHAT_HELLO, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_GREETING));
}

