library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.COMANDOS_LCD_REVC.ALL;

entity LIB_LCD_INTESC_REVC is


PORT(CLK: IN STD_LOGIC;

-------------------------------------------------------
-------------PUERTOS DE LA LCD (NO BORRAR)-------------
	  RS : OUT STD_LOGIC;									  --
	  RW : OUT STD_LOGIC;									  --
	  ENA : OUT STD_LOGIC;									  --
	  CORD : IN STD_LOGIC;									  --
	  CORI : IN STD_LOGIC;									  --
	  DATA_LCD: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);     --
	  BLCD :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0);        --
-------------------------------------------------------
	  
-----------------------------------------------------------
--------------ABAJO ESCRIBE TUS PUERTOS--------------------	

	LEDS: out STD_logic_vector(17 downto 0);
   ABC : in STD_logic_vector (2 downto 0);
	reset : in STD_logic
	);

end LIB_LCD_INTESC_REVC;

architecture Behavioral of LIB_LCD_INTESC_REVC is

-----------------------------------------------------------------
---------------SE�ALES DE LA LCD (NO BORRAR)---------------------
TYPE RAM IS ARRAY (0 TO  60) OF STD_LOGIC_VECTOR(8 DOWNTO 0);  --
																					--
SIGNAL INSTRUCCION : RAM;													--
																					--
COMPONENT PROCESADOR_LCD_REVC is											--
																					--
PORT(CLK : IN STD_LOGIC;													--
	  VECTOR_MEM : IN STD_LOGIC_VECTOR(8 DOWNTO 0);					--
	  INC_DIR : OUT INTEGER RANGE 0 TO 1024;							--
	  CORD : IN STD_LOGIC;													--
	  CORI : IN STD_LOGIC;													--
	  RS : OUT STD_LOGIC;													--
	  RW : OUT STD_LOGIC;													--
	  DELAY_COR : IN INTEGER RANGE 0 TO 1000;							--
	  BD_LCD : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);			         --
	  ENA  : OUT STD_LOGIC;													--
	  C1A,C2A,C3A,C4A : IN STD_LOGIC_VECTOR(39 DOWNTO 0);       --
	  C5A,C6A,C7A,C8A : IN STD_LOGIC_VECTOR(39 DOWNTO 0);       --
	  DATA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)							--
		);																			--
																					--
end  COMPONENT PROCESADOR_LCD_REVC;										--
																					--
COMPONENT CARACTERES_ESPECIALES_REVC is										--
																					--
PORT( C1,C2,C3,C4:OUT STD_LOGIC_VECTOR(39 DOWNTO 0);				--
		C5,C6,C7,C8:OUT STD_LOGIC_VECTOR(39 DOWNTO 0);				--
		CLK : IN STD_LOGIC													--
		);																			--
																					--
end COMPONENT CARACTERES_ESPECIALES_REVC;	

             								--

																					--
CONSTANT CHAR1 : INTEGER := 1;											--
CONSTANT CHAR2 : INTEGER := 2;											--
CONSTANT CHAR3 : INTEGER := 3;											--
CONSTANT CHAR4 : INTEGER := 4;											--
CONSTANT CHAR5 : INTEGER := 5;											--
CONSTANT CHAR6 : INTEGER := 6;											--
CONSTANT CHAR7 : INTEGER := 7;											--
CONSTANT CHAR8 : INTEGER := 8;											--
																					--
																					--
SIGNAL DIR : INTEGER RANGE 0 TO 1024 := 0;							--
SIGNAL VECTOR_MEM_S : STD_LOGIC_VECTOR(8 DOWNTO 0);				--
SIGNAL RS_S, RW_S, E_S : STD_LOGIC;										--
SIGNAL DATA_S : STD_LOGIC_VECTOR(7 DOWNTO 0);						--
SIGNAL DIR_S : INTEGER RANGE 0 TO 1024;								--
SIGNAL DELAY_COR : INTEGER RANGE 0 TO 1000;							--
SIGNAL C1S,C2S,C3S,C4S : STD_LOGIC_VECTOR(39 DOWNTO 0);	      --
SIGNAL C5S,C6S,C7S,C8S : STD_LOGIC_VECTOR(39 DOWNTO 0); 
SIGNAL lcd_data_out: STD_LOGIC_VECTOR(7 DOWNTO 0); 	   		--
----------------------------------------------------------------
-----------------------------------------------------------------
---------------------------------------------------------
--------------AGREGA TUS SE�ALES AQU�--------------------

---------------------------------------------------------

																	  --ABC--
    signal KeyDigit1: STD_logic_vector(2 downto 0) := "011";
    signal KeyDigit2: STD_logic_vector(2 downto 0) := "110";
    signal KeyDigit3: STD_logic_vector(2 downto 0) := "101";
    signal KeyDigit4: STD_logic_vector(2 downto 0) := "011";
	 
	 signal InputDigit1: STD_logic_vector(2 downto 0);
	 signal InputDigit2: STD_logic_vector(2 downto 0);
	 signal InputDigit3: STD_logic_vector(2 downto 0);
	 signal InputDigit4: STD_logic_vector(2 downto 0);
	 signal Unlocked: std_logic := '0';
	 signal var1: std_logic := '0';
	 signal NewCLK: std_logic := '0';
	 signal N_Digit: integer := 0;
	 signal N_Attempts: integer := 1;
	 
BEGIN

-----------------------------------------------------------
------------COMPONENTES PARA LCD (NO BORRAR)---------------
U1 : PROCESADOR_LCD_REVC PORT MAP(CLK  => CLK,				--
									 VECTOR_MEM => VECTOR_MEM_S,	--
									 RS  => RS_S,						--
									 RW  => RW_S,						--
									 ENA => E_S,						--
									 INC_DIR => DIR_S,				--
									 DELAY_COR => DELAY_COR,		--
									 BD_LCD => BLCD,					--
									 CORD => CORD,						--
									 CORI => CORI,						--
									 C1A =>C1S,  					   --	
									 C2A =>C2S,							--
									 C3A =>C3S,							--
									 C4A =>C4S,							--
									 C5A =>C5S,							--
									 C6A =>C6S,							--
									 C7A =>C7S,							--
									 C8A =>C8S,							--
									 DATA  => DATA_S );				--
																			--
U2 : CARACTERES_ESPECIALES_REVC PORT MAP(C1 =>C1S,			--	
									C2 =>C2S,							--
									C3 =>C3S,							--
									C4 =>C4S,							--
									C5 =>C5S,							--
									C6 =>C6S,							--
									C7 =>C7S,						   --
									C8 =>C8S,							--
									CLK => CLK							--
									);										--
																			--
DIR <= DIR_S;															--
VECTOR_MEM_S <= INSTRUCCION(DIR);								--
																			--
RS <= RS_S;																--
RW <= RW_S;																--
ENA <= E_S;																--
DATA_LCD <= DATA_S;

																			--
													                  --
-----------------------------------------------------------


DELAY_COR <= 600; --Modificar esta variable para la velocidad del corrimiento.

-------------------------------------------------------------------
-----------------ABAJO ESCRIBE TU C�DIGO EN VHDL-------------------

Relojito: process (CLK, NewCLK)
variable Count: integer := 0;
begin
	if rising_edge(CLK) then
		Count := Count + 1;
			if (Count = 25000000 and NewCLK = '0') then
				NewCLK <= '1';
				Count := 0;
			elsif (Count = 25000000 and NewCLK = '1') then
				NewCLK <= '0';
				Count := 0;
			end if;
	end if;
end process Relojito;
	
CajaFuerte: process (KeyDigit1, KeyDigit2, KeyDigit3, KeyDigit4, InputDigit1, InputDigit2, InputDigit3, InputDigit4, N_Digit, N_Attempts, var1)
begin
	if ((N_Attempts >= 1) and (N_Attempts <= 5)) then
		if (ABC /= "111") and (var1 = '0') then
			var1 <= '1';
			N_Digit <= N_Digit + 1;
			case N_Digit is
				when 1 => InputDigit1 <= ABC;
				when 2 => InputDigit2 <= ABC;
				when 3 => InputDigit3 <= ABC;
				when 4 => InputDigit4 <= ABC;
				when others => null;
			end case;
		elsif (ABC = "111") then
			var1 <= '0';
		end if;
	end if;
	
	if N_Digit = 4 then 
		if (InputDigit1 = KeyDigit1) and (InputDigit2 = KeyDigit2) and (InputDigit3 = KeyDigit3) and (InputDigit4 = KeyDigit4) then
			Unlocked <= '1';
		else
			N_Digit <= 0;
			N_Attempts <= N_Attempts + 1;
		end if;
	end if;
	
	if reset = '0' then
		var1 <= '0';
		N_Attempts <= 1;
		N_Digit <= 0;
		Unlocked <= '0';
	end if;
end process CajaFuerte;
					
LEDScontrol: process (unlocked)
begin
	if reset = '0' then
		LEDS <= "000000000000000000";
	end if;
	if unlocked = '1' then
		if NewCLK = '1' then
			LEDS <= "101010101010101010";
		elsif NewCLK = '0' then
			LEDS <= "010101010101010101";
		end if;
	end if;
end process LEDScontrol;
					
-----------------------------------------------------------------------------------------
-------------------------ABAJO ESCRIBE TU C�DIGO PARA LA LCD-----------------------------

mostrar: process(InputDigit1, InputDigit2, InputDigit3, InputDigit4, N_Attempts)
begin
	INSTRUCCION(0) <= LCD_INI("00");
	INSTRUCCION(1) <= POS(1,1);
	INSTRUCCION(2) <= CHAR(MI);
	INSTRUCCION(3) <= CHAR(N);
	INSTRUCCION(4) <= CHAR(T);
	INSTRUCCION(5) <= CHAR(E);
	INSTRUCCION(6) <= CHAR(N);
	INSTRUCCION(7) <= CHAR(T);
	INSTRUCCION(8) <= CHAR(O);
	INSTRUCCION(9) <= CHAR_ASCII(x"20");
	INSTRUCCION(10) <= CHAR_ASCII(x"23");
	INSTRUCCION(11) <= BUCLE_INI(1);
	case Unlocked is
		when '0' =>
			case N_Attempts is
				when 1 to 5 =>	
					INSTRUCCION(12) <= POS(1,10);
					INSTRUCCION(13) <= INT_NUM(N_Attempts);
					INSTRUCCION(14) <= POS(2,4);
					INSTRUCCION(15) <= CHAR_ASCII(x"20");
					case InputDigit1 is
						when "011" =>	INSTRUCCION(16) <= CHAR(A);
						when "101" =>	INSTRUCCION(16) <= CHAR(B);
						when "110" =>	INSTRUCCION(16) <= CHAR(C);
						when others => null;
					end case;
					case InputDigit2 is
						when "011" =>	INSTRUCCION(17) <= CHAR(A);
						when "101" =>	INSTRUCCION(17) <= CHAR(B);
						when "110" =>	INSTRUCCION(17) <= CHAR(C);
						when others => null;
					end case;
					case InputDigit3 is
						when "011" =>	INSTRUCCION(18) <= CHAR(A);
						when "101" =>	INSTRUCCION(18) <= CHAR(B);
						when "110" =>	INSTRUCCION(18) <= CHAR(C);
						when others => null;
					end case;
					case InputDigit4 is
						when "011" =>	INSTRUCCION(19) <= CHAR(A);
						when "101" =>	INSTRUCCION(19) <= CHAR(B);
						when "110" =>	INSTRUCCION(19) <= CHAR(C);
						when others => null;
					end case;
					INSTRUCCION(20) <= CHAR_ASCII(x"20");
				when others => 
					INSTRUCCION(15) <= POS(2,4);
					INSTRUCCION(16) <= CHAR(ME);
					INSTRUCCION(17) <= CHAR(MR);
					INSTRUCCION(18) <= CHAR(MR);
					INSTRUCCION(19) <= CHAR(MO);
					INSTRUCCION(20) <= CHAR(MR);
			end case;
		when '1' =>
			INSTRUCCION(15) <= POS(2,4);
			INSTRUCCION(16) <= CHAR_ASCII(x"20");
			INSTRUCCION(17) <= CHAR_ASCII(x"20");
			INSTRUCCION(18) <= CHAR(MO);
			INSTRUCCION(19) <= CHAR(MK);
			INSTRUCCION(20) <= CHAR_ASCII(x"20");
	end case;
end process mostrar;
			
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

end Behavioral;