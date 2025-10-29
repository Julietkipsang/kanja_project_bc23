codeunit 50103 DocumentAttachment
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        SaccoApp: Record "Sacco Application";
        FloatManage: Record "Float Management";
        ChangeRequest: Record ChangeRequest;
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Sacco Application":
                begin
                    RecRef.Open(DATABASE::"Sacco Application");
                    if SaccoApp.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(SaccoApp);
                end;

            DATABASE::"Float Management":
                begin
                    RecRef.Open(DATABASE::"Float Management");
                    if FloatManage.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(FloatManage);
                end;
            DATABASE::ChangeRequest:
                begin
                    RecRef.Open(DATABASE::ChangeRequest);
                    if ChangeRequest.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(ChangeRequest);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option;
    begin
        case RecRef.Number of
            DATABASE::"Sacco Application":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);

                    //FieldRef := RecRef.Field(2);
                    //DocType := FieldRef.Value;
                    // DocumentAttachment.SetRange("Required Document", DocType);

                    FlowFieldsEditable := false;
                end;
            DATABASE::"Float Management":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);

                    //FieldRef := RecRef.Field(2);
                    //DocType := FieldRef.Value;
                    // DocumentAttachment.SetRange("Required Document", DocType);

                    FlowFieldsEditable := false;
                end;
            DATABASE::ChangeRequest:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);

                    //FieldRef := RecRef.Field(2);
                    //DocType := FieldRef.Value;
                    // DocumentAttachment.SetRange("Required Document", DocType);

                    FlowFieldsEditable := false;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option;
    begin
        case RecRef.Number of
            DATABASE::"Sacco Application":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);

                    //FieldRef := RecRef.Field(2);
                    //DocType := FieldRef.Value;
                    //DocumentAttachment.Validate("Required Document", DocType);
                end;
            DATABASE::"Float Management":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);

                    //FieldRef := RecRef.Field(2);
                    //DocType := FieldRef.Value;
                    //DocumentAttachment.Validate("Required Document", DocType);
                end;
            DATABASE::ChangeRequest:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);

                    //FieldRef := RecRef.Field(2);
                    //DocType := FieldRef.Value;
                    //DocumentAttachment.Validate("Required Document", DocType);
                end;
        end;
    end;

}