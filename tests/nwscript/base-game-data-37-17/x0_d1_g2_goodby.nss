/* GESTURE SCRIPT - NPC performs gesture and voicechat GOODBYE */

void main()
{
    object oSource = OBJECT_SELF;
    PlayVoiceChat(VOICE_CHAT_GOODBYE, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_SALUTE));
}

