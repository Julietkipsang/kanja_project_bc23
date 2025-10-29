tableextension 50001 DocumentAttachmentExt extends "Document Attachment"
{
    fields
    {
        field(50100; "DocumentTypes"; Enum "Document Types")
        {
            // OptionCaption = ' ,Kra Pin,Sasra, BusinessPermits,Kanja Contracts,Other Compliance, Any other Doc,';
            // OptionMembers = " ","Kra Pin","Sasra","BusinessPermits","Kanja Contracts","Other Compliance","Any other Doc";
            //TableRelation = DocumentTypes.DocumentDescription;

        }
        field(50101; EdmsPath; Text[100])
        {


        }
        field(50102; Type; Code[100])
        {

        }
        field(50103; NewPath; text[100])
        {

        }
        field(50104;"Description"; Code[100])
        {
            
        }

    }
    keys
    {
        key(keyExt1; Type)
        {
            Enabled = true;
        }
    }

}