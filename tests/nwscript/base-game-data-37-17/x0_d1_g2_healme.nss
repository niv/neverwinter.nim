/* GESTURE SCRIPT - NPC performs gesture and voicechat HEALME */

void main()
{
    object oSource = OBJECT_SELF;
    PlayVoiceChat(VOICE_CHAT_HEALME, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_TALK_PLEADING));
}

