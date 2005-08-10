package body Schema.Validators.UR_Type is

   UR_Type_Element   : array (Process_Contents_Type) of XML_Element :=
     (others => No_Element);

   type UR_Type_Validator is new XML_Validator_Record with record
      Process_Contents : Process_Contents_Type := Process_Strict;
   end record;
   type UR_Type_Access is access all UR_Type_Validator'Class;

   procedure Validate_End_Element
     (Validator      : access UR_Type_Validator;
      Local_Name     : Unicode.CES.Byte_Sequence;
      Data           : Validator_Data);
   procedure Validate_Attributes
     (Validator         : access UR_Type_Validator;
      Atts              : Sax.Attributes.Attributes'Class;
      Id_Table          : in out Id_Htable_Access;
      Nillable          : Boolean;
      Is_Nil            : out Boolean;
      Grammar           : in out XML_Grammar);
   procedure Validate_Start_Element
     (Validator         : access UR_Type_Validator;
      Local_Name        : Unicode.CES.Byte_Sequence;
      Namespace_URI     : Unicode.CES.Byte_Sequence;
      NS                : XML_Grammar_NS;
      Data              : Validator_Data;
      Schema_Target_NS  : XML_Grammar_NS;
      Element_Validator : out XML_Element);
   procedure Validate_Characters
     (Validator      : access UR_Type_Validator;
      Ch             : Unicode.CES.Byte_Sequence;
      Empty_Element  : Boolean);
   --  See doc for inherited subprograms

   -------------------------
   -- Validate_Characters --
   -------------------------

   procedure Validate_Characters
     (Validator      : access UR_Type_Validator;
      Ch             : Unicode.CES.Byte_Sequence;
      Empty_Element  : Boolean)
   is
   begin
      Debug_Output
        ("Validate_Characters for UR_Type Process_Contents="
         & Validator.Process_Contents'Img & ' ' & Ch
         & ' ' & Empty_Element'Img);
   end Validate_Characters;

   ----------------------------
   -- Validate_Start_Element --
   ----------------------------

   procedure Validate_Start_Element
     (Validator              : access UR_Type_Validator;
      Local_Name             : Unicode.CES.Byte_Sequence;
      Namespace_URI          : Unicode.CES.Byte_Sequence;
      NS                     : XML_Grammar_NS;
      Data                   : Validator_Data;
      Schema_Target_NS       : XML_Grammar_NS;
      Element_Validator      : out XML_Element)
   is
      pragma Unreferenced (Data);
   begin
      Debug_Output
        ("Validate_Start_Element UR_Type Process_Contents="
         & Validator.Process_Contents'Img);

      --  ur-Type and anyType accept anything

      case Validator.Process_Contents is
         when Process_Strict =>
            Element_Validator := Lookup_Element
              (NS, Local_Name, Create_If_Needed => False);
            if Element_Validator = No_Element then
               Validation_Error
                 ("No definition provided for """ & Local_Name & """");
            else
               Check_Qualification
                 (Schema_Target_NS, Element_Validator, Namespace_URI);
            end if;

         when Process_Lax =>
            Element_Validator := Lookup_Element
              (NS, Local_Name, Create_If_Needed => False);
            if Element_Validator = No_Element then
               Debug_Output ("Definition not found for " & Local_Name);
               Element_Validator :=
                 Get_UR_Type_Element (Validator.Process_Contents);
            else
               Debug_Output ("Definition found for " & Local_Name);
            end if;

         when Process_Skip =>
            Element_Validator :=
              Get_UR_Type_Element (Validator.Process_Contents);
      end case;

   end Validate_Start_Element;

   -------------------------
   -- Validate_Attributes --
   -------------------------

   procedure Validate_Attributes
     (Validator         : access UR_Type_Validator;
      Atts              : Sax.Attributes.Attributes'Class;
      Id_Table          : in out Id_Htable_Access;
      Nillable          : Boolean;
      Is_Nil            : out Boolean;
      Grammar           : in out XML_Grammar)
   is
      pragma Unreferenced (Validator, Atts, Id_Table, Nillable, Grammar);
   begin
      Is_Nil := False;
   end Validate_Attributes;

   --------------------------
   -- Validate_End_Element --
   --------------------------

   procedure Validate_End_Element
     (Validator      : access UR_Type_Validator;
      Local_Name     : Unicode.CES.Byte_Sequence;
      Data           : Validator_Data)
   is
      pragma Unreferenced (Validator, Local_Name, Data);
   begin
      null;
   end Validate_End_Element;

   -------------------------
   -- Get_UR_Type_Element --
   -------------------------

   function Get_UR_Type_Element
     (Process_Contents : Process_Contents_Type) return XML_Element is
   begin
      return UR_Type_Element (Process_Contents);
   end Get_UR_Type_Element;

   -----------------------------
   -- Create_UR_Type_Elements --
   -----------------------------

   procedure Create_UR_Type_Elements
     (Schema_NS : Schema.Validators.XML_Grammar_NS)
   is
      Validator : UR_Type_Access;
   begin
      if UR_Type_Element (UR_Type_Element'First) = No_Element then
         for P in Process_Contents_Type loop
            Validator := new UR_Type_Validator;
            Validator.Process_Contents := P;
            UR_Type_Element (P)  := Create_Local_Element
              ("", Schema_NS, Create_Local_Type (Validator), Qualified);
         end loop;
      end if;
   end Create_UR_Type_Elements;

end Schema.Validators.UR_Type;
