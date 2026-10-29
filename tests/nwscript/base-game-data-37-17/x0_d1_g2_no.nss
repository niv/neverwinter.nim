/* GESTURE SCRIPT - NPC performs gesture and voicechat NO */

void main()
{
    object oSource = OBJECT_SELF;
    PlayVoiceChat(VOICE_CHAT_NO, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT));
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT));
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT));
}

