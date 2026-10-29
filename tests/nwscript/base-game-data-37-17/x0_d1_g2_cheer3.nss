/* GESTURE SCRIPT - NPC performs gesture and voicechat CHEER */

void main()
{
    object oSource = OBJECT_SELF;
    PlayVoiceChat(VOICE_CHAT_CHEER, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_VICTORY3));
}

