/* GESTURE SCRIPT - PC performs gesture and voicechat CANTDO */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_CANTDO, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT));
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT));
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT));
}

