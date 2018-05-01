library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;    -- needed for +/- operations


entity top is
    port (
        BTN0: in std_logic;     -- button 0
        BTN1: in std_logic;     -- button 1
        SW0: in std_logic;      -- switch 0
        CLK: in std_logic;      -- Clock
        LED: out std_logic_vector(3 downto 0) := "1111"  -- Led diodes
    );
end top;

architecture Behavioral of top is
    signal clk_25: std_logic := '0';
    signal tmp25:  std_logic_vector(11 downto 0) := x"000";
    signal row:    std_logic_vector(3 downto 0)  := "0000";      
    signal data:   bit_vector(11 downto 0) := "000000000000";
    signal help:   bit_vector(11 downto 0) := "000000000000";
    signal code:   bit_vector(11 downto 0) := "100100000000";   
    signal mask0:  bit_vector(11 downto 0) := "000000000000";
    signal mask1:  bit_vector(11 downto 0) := "000000000001";
    signal ledd:   bit_vector(3 downto 0)  := "0000";
    
begin

process (CLK)
    begin
        if rising_edge(CLK) then
            tmp25 <= tmp25 + 1;			-- èítaè
            if  tmp25 = x"C00" then
                   tmp25 <= x"000";
                   clk_25 <= not clk_25;
            end if;
        end if;
    end process;

process (clk_25)
    begin
        if rising_edge(clk_25) then
		     if SW0 = '0' then		-- reset
			  code <= "100100000000";   
			  LED <= "1111";
			  data <="000000000000";
			  help <="000000000000";
			  row <="0000";
        		
			else
                  if row /= "1000" then
                    if BTN0 = '0' then		-- zadávání 0
                      data <= data or mask0;
                      data <= data rol 1;
                      row <= row + 1;
                      LED(0) <= "0";
                      LED(1) <= "1";
                      LED(3) <= not LED(3);     
                    end if;
                    if BTN1 = '0' then		-- zadávání 1
                      data <= data or mask1;
                      data <= data rol 1;
                      row <= row + 1;
                      LED(0) <= "1";
                      LED(1) <= "0";
                      LED(3) <= not LED(3);
                    end if;
                  else
                    data <= data rol 4;  -- vytvoøení kódu CRC
                    help <= data;
                    if data >= "100000000000" then
                    help <= help xor code;
                    end if;
                    code <= code ror 1;
                    if data >= "010000000000" then
                    help <= help xor code;
                    end if;
                    code <= code ror 1;
                    if data >= "001000000000" then
                    help <= help xor code;
                    end if;
                    code <= code ror 1;
                    if data >= "000100000000" then
                    help <= help xor code;
                    end if;
                    code <= code ror 1;
                    if data >= "000010000000" then
                    help <= help xor code;
                    end if;
                    code <= code ror 1;
                    if data >= "000001000000" then
                    help <= help xor code;
                    end if;
                    code <= code ror 1;
                    if data >= "000000100000" then
                    help <= help xor code;
                    end if;
                    code <= code ror 1;
                    if data >= "000000010000" then
                    help <= help xor code;
                    end if;
                    code <= code ror 1;
                    if data >= "000000001000" then
                    help <= help xor code;
                    end if;
                  
                    ledd <= help(3 downto 0); -- Zjistìní kódu 
                    if ledd = "0000" then	  -- a poslanání	
                    LED <= "1111";		  -- na výstup LED
                    end if;
                    if ledd = "0001" then
                    LED <= "1110";
                    end if;
                    if ledd = "0010" then
                    LED <= "1101";
                    end if;
                    if ledd = "0011" then
                    LED <= "1100";
                    end if;
                    if ledd = "0100" then
                    LED <= "1011";
                    end if;
                    if ledd = "0101" then
                    LED <= "1010";
                    end if;
                    if ledd = "0110" then
                    LED <= "1001";
                    end if;
                    if ledd = "0111" then
                    LED <= "1000";
                    end if;
                    if ledd = "1000" then
                    LED <= "0111";
                    end if;
                    if ledd = "1001" then
                    LED <= "0110";
                    end if;
                    if ledd = "1010" then
                    LED <= "0101";
                    end if;
                    if ledd = "1011" then
                    LED <= "0100";
                    end if;
                    if ledd = "1100" then
                    LED <= "0011";
                    end if;
                    if ledd = "1101" then
                    LED <= "0010";
                    end if;
                    if ledd = "1110" then
                    LED <= "0001";
                    end if;
                    if ledd = "1111" then
                    LED <= "0000";
                    end if;
                  end if;
		     end if
        end if;       
    end process;
end Behavioral;