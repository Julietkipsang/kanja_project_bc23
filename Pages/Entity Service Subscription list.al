page 50029 "Entity Service Sub List"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Entity Service Subscription";
    Caption = 'Entity Service Subscription';

    layout
    {
        area(Content)
        {
            repeater("")
            {

                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Caption = 'Service Type';
                    trigger OnValidate()
                    var
                        ServiceType: Record "Services Type";
                    begin
                        if ServiceType.Get(Rec."Account Type") then
                            if ServiceType.Active = false then
                                Error('The service is Not active');
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {

                }
                field("End Date"; Rec."End Date")
                {

                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;
                }

                field("Maximum Daily"; Rec."Maximum Daily")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        EntityApplication: Record "Sacco Application";

    procedure SetEditable()
    begin
        if EntityApplication.Get(Rec."Application No.") then
            if EntityApplication.Status <> EntityApplication.Status::New then
                CurrPage.Editable(false);
    end;

    trigger OnOpenPage()
    begin
        SetEditable();
    end;
}
