/* GESTURE SCRIPT - NPC performs gesture and voicechat LAUGH */

void main()
{
    object oSource = OBJECT_SELF;
    PlayVoiceChat(VOICE_CHAT_LAUGH, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
}

