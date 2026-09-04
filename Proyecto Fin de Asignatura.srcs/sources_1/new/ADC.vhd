
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.06.2025 20:55:36
-- Design Name: 
-- Module Name: ADC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADC is
    Port (
        ADCclk       : in  std_logic;
        enable    : in  std_logic;
        I1        : in  std_logic;
        I2        : in  std_logic;
        I3        : in  std_logic;
        ADC_out   : in  std_logic;
        CS        : out std_logic;
        ADC_in    : out std_logic;
        done      : out std_logic;
        data_out  : out std_logic_vector(9 downto 0)
    );
end ADC;

architecture Behavioral of ADC is

    signal Pasos       : integer range 0 to 25 := 0;

    signal ADC_in_s  : std_logic := '0';
    signal done_s    : std_logic := '0';
    signal dummy    : std_logic := '0';
    signal data_out_s   : std_logic_vector(9 downto 0);
    
    signal cs_s: std_logic := '1';

begin

    ADC_in  <= ADC_in_s;
    done    <= done_s;
    CS <= cs_s;

   process(ADCclk)
    begin
        if rising_edge(ADCclk) then
            if enable='1' then
                case Pasos is
                
                when 0 =>
                cs_s <= '0';
                
                done_s   <= '0';   
                Pasos       <= 1;
                
                when 1 =>
                ADC_in_s <= '1';    -- start bit
                
                Pasos       <= 2;

                when 2 =>
                ADC_in_s <= '1';              -- SGL/DIF = single-ended
                
                Pasos       <= 3;

                when 3 =>
                ADC_in_s <= I3;               -- D2 = tu MSB de canal
                
                Pasos       <= 4;

                when 4 =>
                ADC_in_s <= I2;               -- D1
                
                Pasos       <= 5;

                when 5 =>
                ADC_in_s <= I1;               -- D0 = tu LSB de canal
                
                Pasos       <= 6;
                
                when 6 =>
                ADC_in_s <= '0';              -- bit "no importa"
                
                Pasos       <= 7;
                
                when 7 =>
                ADC_in_s <= '0';              -- bit "no importa"
               
                Pasos       <= 8;
                
                when 8 =>
                dummy <= ADC_out;--bit basura
                Pasos       <= 9;
                
                when 9 =>
                dummy <= ADC_out;--bit basura
                Pasos       <= 10;
                
                when 10 =>
                dummy <= ADC_out;--bit basura
                Pasos       <= 11;
                
                when 11 =>
                dummy <= ADC_out;--bit basura
                Pasos       <= 12;
                
                when 12 =>
                dummy <= ADC_out;--bit basura
                Pasos       <= 13;
                
                when 13 =>
                dummy <= ADC_out;--bit basura                
                Pasos       <= 14;
                
                when 14 =>
                data_out_s(9) <= ADC_out; 
                Pasos       <= 15;
                
                when 15 =>
                data_out_s(8) <= ADC_out; 
                Pasos       <= 16;
                
                when 16 =>
                data_out_s(7) <= ADC_out; 
                Pasos       <= 17;
                
                when 17 =>
                data_out_s(6) <= ADC_out; 
                Pasos       <= 18;
                
                when 18 =>
                data_out_s(5) <= ADC_out; 
                Pasos       <= 19;
                
                when 19 =>
                data_out_s(4) <= ADC_out; 
                Pasos       <= 20;
                
                when 20 =>
                data_out_s(3) <= ADC_out; 
                Pasos       <= 21;
                
                when 21 =>
                data_out_s(2) <= ADC_out; 
                Pasos       <= 22;
                
                when 22 =>
                data_out_s(1) <= ADC_out; 
                Pasos       <= 23;
                
                when 23 =>
                data_out_s(0) <= ADC_out;                 
                Pasos       <= 24;
                
                when 24 =>
                data_out <= data_out_s;                  
                Pasos       <= 25;
                
                when 25 =>
                done_s   <= '1';
                cs_s <= '1';           -- dato completo
                Pasos       <= 0;                

                end case;
        else
      -- reset de todo
      Pasos      <= 0;
      done_s  <= '0';
    end if;
  end if;
end process;
end Behavioral;

