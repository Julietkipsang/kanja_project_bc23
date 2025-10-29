pageextension 50100 DocumentsattachmentSetups extends "Document Attachment Details"
{


    layout
    {
        addafter(Name)
        {
            field(DocumentTypes; Rec.DocumentTypes)
            {
                trigger
                OnValidate()
                var
                    TempBlob: Codeunit "Temp Blob";
                    FilePath: Text;
                    FileInStream: InStream;
                begin
                end;
            }
            field(Description; Rec.Description)
            {

            }

            field(EdmsPath; Rec.EdmsPath)
            {
                ApplicationArea = all;
                ExtendedDatatype = URL;
                Editable = false;
            }
            field(Type; Rec.Type)
            {
                // Editable = false;
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    // Allow the user to select a file




                end;
            }
        }
    }

    actions
    {
        addafter("UploadFile")

        {
            action("ViewDoc")
            {
                ApplicationArea = All;
                Image = View;
                trigger OnAction()
                var
                    DocAttach: Record "Document Attachment";
                begin

                end;
            }

        }
    }
    trigger
    OnDeleteRecord(): Boolean
    begin
        SaccoAppl.Reset();
        SaccoAppl.SetRange("No.", Rec."No.");
        if SaccoAppl.FindFirst() then begin
            SaccoAppl.TestField(Status, SaccoAppl.Status::New);
        end;

        ChangeRequest.Reset();
        ChangeRequest.SetRange("No.", Rec."No.");
        if ChangeRequest.FindFirst() then begin
            ChangeRequest.TestField(Status, ChangeRequest.Status::New);
        end;

        FloatMangemnet.Reset();
        FloatMangemnet.SetRange("Receipt No", Rec."No.");
        if FloatMangemnet.FindFirst() then begin
            FloatMangemnet.TestField(Status, FloatMangemnet.Status::Open);
        end;

    end;

    trigger
    OnNewRecord(BelowxRec: Boolean)
    begin
    end;

    var
        myInt: Integer;

        SaccoAppl: Record "Sacco Application";

        ChangeRequest: Record ChangeRequest;

        FloatMangemnet: Record "Float Management";

        FileName: Text;
        FileInStream: InStream;
        OutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FilePath: Text;
}