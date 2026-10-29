/* GESTURE SCRIPT - PC performs gesture and voicechat SPELLFAILED */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_SPELLFAILED, oSource);
}

