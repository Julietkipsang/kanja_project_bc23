table 50024 "EntitySubscripted"
{
    Caption = 'Change Entity Service Subscripted';


    fields
    {
        field(1; "Application No."; Code[20])
        {
        }
        field(2; "Account Type"; Code[20])
        {
            TableRelation = "Services Type";
            //Editable = false;
            trigger OnValidate()
            var
                AccountType: Record "Services Type";
            begin
                if AccountType.Get("Account Type") then begin
                    Description := AccountType.Description;
                end;



            end;

        }
        field(3; Description; Text[50])
        {
            Editable = false;
        }
        field(4; Amount; Decimal)
        {
            trigger OnValidate()
            var
                AccountTypes: Record "Account Type";
            begin

            end;
        }
        field(5; Status; enum "Service Type Status")
        {

        }
        field(6; "Maximum Amount"; Decimal)
        {
            trigger OnValidate()
            var
                ServiceType: Record "Services Type";
            begin
                if ServiceType.Get("Account Type") then
                    if "Maximum Amount" > ServiceType."Maximum Amount" then
                        Error('Maximum Amount is greater than Service type maximum Amount');
            end;
        }
        field(7; "Minimum Amount"; Decimal)
        {
            trigger OnValidate()
            var
                ServiceType: Record "Services Type";
            begin
                if ServiceType.Get("Account Type") then
                    if "Minimum Amount" > ServiceType."Minimum  Amount" then
                        Error('Minimum Amount is greater than Service type Minimum Amount');
            end;
        }
        field(8; "Maximum Daily"; Decimal)
        {
            trigger OnValidate()
            var
                ServiceType: Record "Services Type";
            begin
                if ServiceType.Get("Account Type") then
                    if "Maximum Daily" > ServiceType."Maximum Daily  Amount" then
                        Error('Maximum Daily Amount is greater than Service type Maximum Daily Amount');

                if Rec."Maximum Daily" < rec."Maximum Amount" then
                    Error('Maximum Daily Cannot be Less than Maximum per transcation Amount');

            end;
        }
        field(9; EntityNo; code[10])
        {

        }
        field(10; EntityName; Text[100])
        {

        }
        field(11; oldEntityNo; Code[100])
        {

        }
        field(12; oldServiceCode; Code[100])
        {

        }
        field(13; oldStatus; enum "Service Type Status")
        {
            Editable = false;
        }
        field(14; Nos; Code[100])
        {
            trigger OnValidate()
            begin


            end;
        }
        field(15; oldMinimumAmount; Decimal)
        {
            Editable = false;

        }
        field(16; oldMaximumAmount; Decimal)
        {
            Editable = false;
        }
        field(17; oldMaximumDaily; Decimal)
        {
            Editable = false;

        }



    }

    keys
    {
        key(Key1; "Account Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger
    OnInsert()
    begin
        CBSSetup.Reset();
        CBSSetup.GET;
        IF Nos = '' THEN BEGIN
            NoSeriesManagement.GetNextNo(CBSSetup."MA Individual Nos.", Today, true);
        END;
        //Change.Reset();
        // Change.SetRange();

    end;


    var
        NoSeriesManagement: Codeunit "No. Series";
        CBSSetup: Record "CBS Setup";
        Entity: Record Organisation;
        Change: Record ChangeRequest;
}

