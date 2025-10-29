page 50028 "Entity Service Subscripted"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Entity Service Subscripted";
    DeleteAllowed = false;
    Editable = true;


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
        // area(Factboxes)
        // {

        // }
    }


    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }

}