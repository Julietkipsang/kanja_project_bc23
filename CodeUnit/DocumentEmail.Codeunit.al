codeunit 50104 "Document & Email Management"
{
    trigger OnRun()
    begin

    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;


    procedure CreateWithoutAttatchmentMessage(SenderName: Text; SenderAddress: Text; Recipients: Text; Subject: Text; Body: Text)
    var
        Mail: Codeunit "Email Message";
        Email: Codeunit Email;
    begin
        Mail.Create(Recipients, Subject, Body, true);
        Email.Send(Mail, Enum::"Email Scenario"::Default);
    end;

    procedure CreateMessage(SenderName: Text; SenderAddress: Text; Recipients: Text; Subject: Text; Body: Text; Attach: Boolean; AttachmentInStream: InStream; Attatchment: Text[40]; ContentType: Text[10])
    var
        Mail: Codeunit "Email Message";
        Email: Codeunit Email;
    begin
        if StrLen(Recipients) > 0 then begin
            Mail.Create(Recipients, Subject, Body, true);
            if Attach then begin
                Mail.AddAttachment(Attatchment, ContentType, AttachmentInStream);
            end;
            Email.Send(Mail, Enum::"Email Scenario"::Default);
        end;

    end;

    procedure CreateMessageManyAttatchement(SenderName: Text; SenderAddress: Text; Recipients: Text; Subject: Text; Body: Text; NoofAttach: Integer; AttachmentInStream: array[4] of InStream; Attatchment: array[4] of Text[40]; ContentType: Text[10])
    var
        Mail: Codeunit "Email Message";
        Email: Codeunit Email;
        i: Integer;
    begin
        //  Recipients := 'michael.ochieng@tangazoletu.com';
        if StrLen(Recipients) > 0 then begin
            Mail.Create(Recipients, Subject, Body, true);
            for i := 1 to NoofAttach do begin
                Mail.AddAttachment(Attatchment[i], ContentType, AttachmentInStream[i]);
            end;
            Email.Send(Mail, Enum::"Email Scenario"::Default);
        end;
    end;

    procedure UploadFile(DocumentNo: Code[50]; File_Type: Enum "File Handler")
    var
        TempBlob: Codeunit "Temp Blob";
        DocumentInStream: InStream;
        DocumentOutStream: OutStream;
        FileMgt: Codeunit "File Management";
        FileHandler: Record "File Handler";
        FileHandler2: Record "File Handler";
        Filename: Text;
        Dialogue: Label 'Select a file to Attach';
        Allfiles: Label 'All files (*.*)|*.*';
    begin
        if Confirm(StrSubstNo('Are you sure you want to Attach %1?', File_Type), false) then begin
            UploadIntoStream(Dialogue, '', Allfiles, Filename, DocumentInStream);
            FileHandler.Init();
            FileHandler.Validate("File ID", DocumentNo);
            FileHandler.Validate("Document Source", File_Type);
            FileHandler.Validate("File Extension", FileMgt.GetExtension(Filename));
            FileHandler.Validate("File Name", FileMgt.GetFileNameWithoutExtension(Filename));
            FileHandler.Content.CreateOutStream(DocumentOutStream);
            CopyStream(DocumentOutStream, DocumentInStream);
            FileHandler2.Reset();
            if FileHandler2.Get(DocumentNo, File_Type) then begin
                FileHandler2.TransferFields(FileHandler);
                if Confirm(StrSubstNo('The Document for: %1 has already beeen attatched,\ Do you want to Replace it?', File_Type), false) then begin
                    FileHandler2.Modify();
                end else begin
                    exit;
                end;
            end else begin
                FileHandler.Insert(true);
            end;
            Message('%1 Successfully Attatched!', File_Type);
        end;
    end;

    procedure DownloadFile(DocumentNo: Code[50]; File_Type: Enum "File Handler")
    var
        DocumentInStream: InStream;
        ExportFileName: Text;
        // FileMgt: Codeunit "File Management";
        FileHandler: Record "File Handler";
        Filename: Text;
        ToFolder: Text;
    begin
        FileHandler.Reset();
        if FileHandler.Get(DocumentNo, File_Type) then begin
            ExportFileName := FileHandler."File Name" + '.' + FileHandler."File Extension";
            FileHandler.CalcFields(Content);
            if FileHandler.Content.HasValue then begin
                FileHandler.Content.CreateInStream(DocumentInStream);
                DownloadFromStream(DocumentInStream, '', ToFolder, '', ExportFileName);
            end;
        end;
    end;










    local procedure ReadExcelFilePICS()
    var
        FileMgt: Codeunit "File Management";
        FromFile: Text[150];
        IStream: InStream;
        FileName: Text[150];
        SheetName: Text[150];
        UploadExcelMsg: Label 'Please Choose  Pictures to Upload.';
        NoFileFoundMsg: Label 'No Excel file found!';
        FromFilter: Label 'Excel Files (*.xlsx;*.xls)';
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if StrLen(FromFile) > 0 then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else begin
            Error(NoFileFoundMsg);
        end;
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
        // ImportExcelRAWData();
    end;



    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    procedure SetBlobValue(value: Text)
    var
        outStr: OutStream;
    begin
        // BlobField.CreateOutStream(outStr);
        outStr.WriteText(value);
    end;

}