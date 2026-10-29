/* GESTURE SCRIPT - NPC performs gesture and voicechat HELP */

void main()
{
    object oSource = OBJECT_SELF;
    PlayVoiceChat(VOICE_CHAT_HELP, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_TALK_PLEADING));
}

