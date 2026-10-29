/* GESTURE SCRIPT - NPC performs gesture and voicechat YES */

void main()
{
    object oSource = OBJECT_SELF;
    PlayVoiceChat(VOICE_CHAT_YES, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_LISTEN));
}

