integer intRLV_RC =-1812221819; // RLV Relay channel. This will be intercepted by the RLV / OpenCollar
string strLOCK_STATUS = "open"; // This shows that at the startup, the door is unlocked so that it can be used
float floLOCK_TIME = 10; // This is for how long the door will remain lcoked. The default time is 10 minutes
integer intLISTEN_HANDLE; // This is used for the default listening channel, currently not used
// list colorChoices = ["-", "Red", "Green", "Yellow"];
list lisMENU_ONE = ["Key","Open/Close","three","four","five","six","seven","eight","nine","ten","eleven","twelve" ]; // The default menu commands
string strMENU_MSG = "\nPlease make a choice.";   // This is the menu header. The newline (\n) helps to visually separate this text from the dialog heading line 
integer intDIALOG_CHAN; // This is used to hold the value for the menu dialog
key keyKEYHOLDER;
string strKEYHOLDER = "no one"; // When we start up, this makes sure that there are no keys in use. 
key keyTOUCHER; // Used to hold the key og who has touched the menu
integer intCHAN_DIAG; // Used to hold the menu dialog channel, currently not used
 
default
{
    state_entry()
    {
        llSetText ("Door is " + strLOCK_STATUS + ".\nKey held by " + strKEYHOLDER +".", <1,1,1>, 1); // Set the float text to tell us of the status
        intDIALOG_CHAN = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) ); // Set the dialog channel
    }

    touch_start(integer num)
    {
        keyTOUCHER = llDetectedKey(0); // Get the key of who touched us
        llDialog(keyTOUCHER, strMENU_MSG, lisMENU_ONE, intDIALOG_CHAN); // Display the menu to whoever touched us using the menu and message and the dialog channel
        intLISTEN_HANDLE = llListen(intDIALOG_CHAN, "", llGetOwner(), ""); // Open the listening channel. This is used by the listen section
    }

    listen(integer intDIALOG_CHAN, string name, key id, string menu_message)
    {
        if ( menu_message == "Key" )
        {
            if ( strKEYHOLDER == "no one" )
            {
                keyKEYHOLDER = keyTOUCHER;
                // keyKEYHOLDER = "e2e41eb9-f281-4d62-86f8-a910104f709c"; // Used for testing, remove before full release
                strKEYHOLDER = llKey2Name(keyKEYHOLDER);
                // strKEYHOLDER = "Shaz Fhang"; // Used for testing, remove before full release
                llWhisper (0, strKEYHOLDER + " Takes the key from the hook and slips it into their pocket.");
                llSetText ("Door is " + strLOCK_STATUS + ".\nKey held by " + strKEYHOLDER +".", <1,1,1>, 1);
            }
            else if ( keyKEYHOLDER != keyTOUCHER )
            {
                llWhisper (0," Sorry, you do not seem to have a key for this, the last person I saw with it was " + strKEYHOLDER + ".");
            }
            else
            {
                
                llWhisper (0, strKEYHOLDER + " slips the Key from their pocket and puts it back on the hook");
                strKEYHOLDER = "no one";
                llSetText ("Door is " + strLOCK_STATUS + ".\nKey held by " + strKEYHOLDER +".", <1,1,1>, 1);
            }
        }
        if ( menu_message == "Open/Close" )
        {
            if ( strLOCK_STATUS == "open" )
            {
                keyKEYHOLDER = keyTOUCHER;
                // keyKEYHOLDER = "e2e41eb9-f281-4d62-86f8-a910104f709c"; // Used for testing, remove before full release
                string tmpKEYHOLDER = llKey2Name(keyTOUCHER);
                // strKEYHOLDER = "Shaz Fhang"; // Used for testing, remove before full release
                llSay (0, tmpKEYHOLDER + " closes the door");
                strLOCK_STATUS = "closed";
            }
            else if ( strLOCK_STATUS == "closed" )
            {
                string tmpKEYHOLDER = llKey2Name(keyTOUCHER);
                llSay (0, tmpKEYHOLDER + " opens the door");
                strLOCK_STATUS = "open";
            }
            llSetText ("Door is " + strLOCK_STATUS + ".\nKey held by " + strKEYHOLDER +".", <1,1,1>, 1);
        }
        llListenRemove(intLISTEN_HANDLE);
    }

}
