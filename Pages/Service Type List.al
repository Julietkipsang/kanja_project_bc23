page 50081 "Service Type List"
{
    // version TL2.0

    Caption = 'Service Types';
    CardPageID = "Service Type Card";
    PageType = List;
    SourceTable = "Services Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Minimum  Amount"; Rec."Minimum  Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Maximum Daily  Amount"; Rec."Maximum Daily  Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        if Rec."Maximum Daily  Amount" < rec."Maximum Amount" then
                            Error('Maximum Daily Cannot be Less than Maximum per transcation Amount');
                    end;
                }


                field("Maintenance Fee"; Rec."Maintenance Fee")
                {
                    ApplicationArea = All;
                }

                field(Active; Rec.Active)
                {
                    // Editable = false;
                    ApplicationArea = All;
                }




            }
        }
    }

    actions
    {
    }
}

